# app.py - Main Flask Application for Gaming Tournament Management System
from flask import Flask, render_template, request, redirect, url_for, session, flash, jsonify
from config import Config
import sys
sys.path.append('database')
from db_connection import get_db_connection, execute_query, execute_procedure, call_function
import pymysql
from functools import wraps

app = Flask(__name__)
app.config.from_object(Config)

# ============================================
# UTILITY FUNCTIONS
# ============================================

def login_required(f):
    """Decorator to require admin login"""
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if 'admin_logged_in' not in session:
            flash('Please login to access this page', 'error')
            return redirect(url_for('admin_login'))
        return f(*args, **kwargs)
    return decorated_function

# ============================================
# PUBLIC ROUTES (No login required)
# ============================================

@app.route('/')
def home():
    """Home page"""
    try:
        # Get top 5 teams
        top_teams = execute_query("""
            SELECT t.TEAM_NAME, g.GAME_NAME, s.POINTS, s.RANKING
            FROM team t
            JOIN stats s ON t.TEAM_ID = s.TEAM_ID
            JOIN games g ON t.GAME_ID = g.GAME_ID
            ORDER BY s.POINTS DESC LIMIT 5
        """)

        # Get UPCOMING tournaments ONLY (Fixed)
        tournaments = execute_query("""
            SELECT TK_ID, TOURNAMENT_NAME, LOCATION, PRIZE_POOL, DURATION
            FROM tournaments
            WHERE STATUS = 'UPCOMING'
            ORDER BY TK_ID DESC
            LIMIT 3
        """)

        # Get stats
        stats = {
            'total_teams': execute_query("SELECT COUNT(*) as count FROM team")[0]['count'],
            'total_tournaments': execute_query("SELECT COUNT(*) as count FROM tournaments")[0]['count'],
            'total_games': execute_query("SELECT COUNT(*) as count FROM games")[0]['count']
        }

        return render_template('public/home.html', top_teams=top_teams or [], tournaments=tournaments or [], stats=stats)

    except Exception as e:
        print(f"Error: {e}")
        return render_template('public/home.html', top_teams=[], tournaments=[], stats={'total_teams':0,'total_tournaments':0,'total_games':0})


@app.route('/dashboard')
def dashboard():
    """Rankings dashboard"""
    try:
        teams = execute_query("""
            SELECT t.TEAM_ID, t.TEAM_NAME, g.GAME_NAME, t.REGION,
                   s.WINS, s.LOSSES, s.POINTS, s.RANKING, s.MATCH_PLAYED
            FROM team t
            JOIN stats s ON t.TEAM_ID = s.TEAM_ID
            JOIN games g ON t.GAME_ID = g.GAME_ID
            ORDER BY s.POINTS DESC
        """)
        return render_template('public/dashboard.html', teams=teams or [])
    except Exception as e:
        print(f"Error: {e}")
        return render_template('public/dashboard.html', teams=[])

@app.route('/teams')
def teams():
    """Teams listing with win percentage calculated and region filter"""
    try:
        # Get region filter from query parameters
        region_filter = request.args.get('region', '')
        
        if region_filter:
            # Use stored procedure for filtered results
            conn = get_db_connection()
            cursor = conn.cursor(pymysql.cursors.DictCursor)
            cursor.callproc('get_teams_by_region', [region_filter])
            teams_list = cursor.fetchall()
            cursor.nextset()
            
            # Normalize column names to match template expectations
            for team in teams_list:
                if 'win_percentage' in team:
                    team['WIN_PERCENTAGE'] = team['win_percentage']
            
            cursor.close()
            conn.close()
        else:
            # Get all teams (existing query)
            teams_list = execute_query("""
                SELECT
                    t.TEAM_ID,
                    t.TEAM_NAME,
                    g.GAME_NAME,
                    t.REGION,
                    s.WINS,
                    s.LOSSES,
                    s.POINTS,
                    s.RANKING,
                    ROUND(calculate_win_percentage(t.TEAM_ID), 2) as WIN_PERCENTAGE
                FROM team t
                JOIN games g ON t.GAME_ID = g.GAME_ID
                LEFT JOIN stats s ON t.TEAM_ID = s.TEAM_ID
                ORDER BY s.POINTS DESC
            """)
        
        # Get distinct regions for filter dropdown
        regions = execute_query("SELECT DISTINCT REGION FROM team ORDER BY REGION")
        
        return render_template('public/teams.html', 
                             teams=teams_list or [], 
                             regions=regions or [],
                             selected_region=region_filter)
    except Exception as e:
        print(f"Error: {e}")
        return render_template('public/teams.html', teams=[], regions=[], selected_region='')



@app.route('/games')
def games():
    """Public games page showing all games with team counts"""
    try:
        games_list = execute_query("""
            SELECT 
                g.GAME_ID,
                g.GAME_NAME,
                g.GENRE,
                g.DEVELOPER,
                g.RELEASE_DATE,
                count_teams_in_game(g.GAME_ID) as team_count
            FROM games g
            ORDER BY g.GAME_NAME
        """)
        
        return render_template('public/games.html', games=games_list)  # ← Changed path
    except Exception as e:
        print(f"Error in games: {e}")
        flash('Error loading games', 'error')
        return redirect(url_for('home'))


@app.route('/games/<int:game_id>/teams')
def game_teams(game_id):
    """Show teams for a specific game"""
    try:
        # Get game details
        game_info = execute_query("""
            SELECT GAME_ID, GAME_NAME, GENRE, DEVELOPER, RELEASE_DATE
            FROM games 
            WHERE GAME_ID = %s
        """, (game_id,))
        
        if not game_info:
            flash('Game not found', 'error')
            return redirect(url_for('games'))
        
        game = game_info[0]
        
        # Get teams for this game
        teams_list = execute_query("""
            SELECT 
                t.TEAM_ID, 
                t.TEAM_NAME, 
                t.REGION, 
                t.COACH,
                ROUND(calculate_win_percentage(t.TEAM_ID), 2) as WIN_PERCENTAGE
            FROM team t
            WHERE t.GAME_ID = %s
            ORDER BY t.TEAM_NAME
        """, (game_id,))
        
        return render_template('public/game_teams.html', game=game, teams=teams_list)  # ← Changed path
    except Exception as e:
        print(f"Error in game_teams: {e}")
        flash('Error loading teams', 'error')
        return redirect(url_for('games'))




# FIXED: Route definition was incomplete
@app.route('/teams/<int:team_id>')
def team_detail(team_id):
    """Team details page"""
    try:
        team = execute_query("""
            SELECT t.*, g.GAME_NAME, s.*
            FROM team t
            JOIN games g ON t.GAME_ID = g.GAME_ID
            LEFT JOIN stats s ON t.TEAM_ID = s.TEAM_ID
            WHERE t.TEAM_ID = %s
        """, (team_id,))

        sponsorships = execute_query("""
            SELECT ID, NAME, INDUSTRY, AMOUNT 
            FROM sponsorship 
            WHERE TEAM_ID = %s
        """, (team_id,))

        return render_template('public/team_detail.html', team=team[0] if team else None, sponsorships=sponsorships or [])
    except Exception as e:
        print(f"Error: {e}")
        return redirect(url_for('teams'))

# ============================================
# PUBLIC ROUTES - TOURNAMENTS
# ============================================

@app.route('/tournaments')
def tournaments():
    """Public tournaments listing with status filter - uses stored procedure"""
    try:
        status = request.args.get('status', 'ALL')
        
        # Instead of: execute_procedure('get_tournaments_filtered', (status,))
        # Use this simpler approach:
        
        if status in ('UPCOMING', 'ONGOING', 'COMPLETED'):
            tournaments_list = execute_query(
                "CALL get_tournaments_filtered(%s)", 
                (status,)
            )
        else:
            tournaments_list = execute_query(
                "CALL get_tournaments_filtered('ALL')"
            )
        
        statuses = ['ALL', 'UPCOMING', 'ONGOING', 'COMPLETED']
        selected_status = status if status in statuses else 'ALL'
        
        return render_template('public/tournaments.html',
                             tournaments=tournaments_list or [],
                             statuses=statuses,
                             selected=selected_status)
    
    except Exception as e:
        print(f"Error in tournaments route: {e}")
        import traceback
        traceback.print_exc()
        return render_template('public/tournaments.html',
                             tournaments=[],
                             statuses=['ALL', 'UPCOMING', 'ONGOING', 'COMPLETED'],
                             selected='ALL')



@app.route('/tournaments/<int:tournament_id>')
def tournament_detail(tournament_id):
    """Tournament details with standings, streams, and winner"""
    try:
        # Use stored procedure to get tournament details and participating teams
        conn = get_db_connection()
        cursor = conn.cursor(pymysql.cursors.DictCursor)
        cursor.callproc('get_tournament_details', [tournament_id])

        # First result set: tournament info
        tournament_info = cursor.fetchall()
        cursor.nextset()

        # Second result set: participating teams with rankings
        teams = cursor.fetchall()
        cursor.close()

        if not tournament_info:
            flash('Tournament not found', 'error')
            conn.close()
            return redirect(url_for('tournaments'))

        tournament = tournament_info[0]  # Main tournament dict

        # Get additional data: game name (not in procedure)
        game_info = execute_query("""
            SELECT g.GAME_NAME
            FROM tournaments t
            JOIN games g ON t.GAME_ID = g.GAME_ID
            WHERE t.TK_ID = %s
        """, (tournament_id,))
        if game_info:
            tournament['GAME_NAME'] = game_info[0]['GAME_NAME']

        # Get winner name using the winner view (prefer this for reliability)
        winner_info = execute_query("""
            SELECT TEAM_NAME FROM v_tournament_winners WHERE TK_ID = %s
        """, (tournament_id,))
        if winner_info and winner_info[0]['TEAM_NAME']:
            tournament['WINNER_NAME'] = winner_info[0]['TEAM_NAME']
        else:
            tournament['WINNER_NAME'] = None  # Or 'TBD'

        # Get tournament status if not present (assuming it's needed for the template)
        if 'STATUS' not in tournament:
            status_info = execute_query("""
                SELECT STATUS FROM tournaments WHERE TK_ID = %s
            """, (tournament_id,))
            if status_info:
                tournament['STATUS'] = status_info[0]['STATUS']

        # Get streams (not in procedure)
        streams = execute_query("""
            SELECT PLATFORM, URL, LANGUAGE 
            FROM stream 
            WHERE TK_ID = %s
        """, (tournament_id,))
        conn.close()

        return render_template(
            'public/tournament_detail.html',
            tournament=tournament,
            tournament_standings=teams or [],
            streams=streams or []
        )
    except Exception as e:
        print(f"Error in tournament_detail: {e}")
        import traceback
        traceback.print_exc()
        flash('Error loading tournament details', 'error')
        return redirect(url_for('tournaments'))





import json

@app.route('/analytics')
def analytics():
    """Analytics dashboard"""
    try:
        # Call procedures
        top_teams = execute_query("CALL get_top_teams_analytics(10)")
        teams_by_region = execute_query("CALL get_teams_count_by_region()")
        
        # Convert to JSON for JavaScript (fixes linter errors)
        top_teams_json = json.dumps([t['TEAM_NAME'] for t in (top_teams or [])])
        top_teams_points = json.dumps([t['POINTS'] for t in (top_teams or [])])
        
        region_labels = json.dumps([r['REGION'] for r in (teams_by_region or [])])
        region_counts = json.dumps([r['count'] for r in (teams_by_region or [])])
        
        return render_template('public/analytics.html',
                             top_teams=top_teams or [],
                             teams_by_region=teams_by_region or [],
                             top_teams_json=top_teams_json,
                             top_teams_points=top_teams_points,
                             region_labels=region_labels,
                             region_counts=region_counts)
    
    except Exception as e:
        print(f"Error: {e}")
        import traceback
        traceback.print_exc()
        return render_template('public/analytics.html',
                             top_teams=[],
                             teams_by_region=[],
                             top_teams_json='[]',
                             top_teams_points='[]',
                             region_labels='[]',
                             region_counts='[]')

# ============================================
# ADMIN ROUTES
# ============================================

@app.route('/admin/login', methods=['GET', 'POST'])
def admin_login():
    """Admin login page"""
    if request.method == 'POST':
        username = request.form.get('username')
        password = request.form.get('password')

        user = execute_query("SELECT * FROM ADMIN_USERS WHERE USERNAME = %s AND PASSWORD = %s", 
                           (username, password))

        if user:
            session['admin_logged_in'] = True
            session['admin_username'] = username
            flash('Login successful!', 'success')
            return redirect(url_for('admin_dashboard'))
        else:
            flash('Invalid credentials', 'error')

    return render_template('admin/login.html')

@app.route('/admin/logout')
def admin_logout():
    """Admin logout"""
    session.pop('admin_logged_in', None)
    session.pop('admin_username', None)
    flash('Logged out successfully', 'success')
    return redirect(url_for('home'))

@app.route('/admin/dashboard')
@login_required
def admin_dashboard():
    """Admin dashboard"""
    try:
        stats = {
            'total_teams': execute_query("SELECT COUNT(*) as count FROM team")[0]['count'],
            'total_tournaments': execute_query("SELECT COUNT(*) as count FROM tournaments")[0]['count'],
            'total_games': execute_query("SELECT COUNT(*) as count FROM games")[0]['count'],
            'total_sponsorships': execute_query("SELECT SUM(AMOUNT) as total FROM sponsorship")[0]['total'] or 0
        }
        return render_template('admin/admin_dashboard.html', stats=stats)
    except Exception as e:
        print(f"Error: {e}")
        return render_template('admin/admin_dashboard.html', stats={})

# GAMES MANAGEMENT
@app.route('/admin/games')
@login_required
def admin_games():
    """Games management"""
    try:
        games = execute_query("SELECT * FROM games")
        return render_template('admin/games.html', games=games or [])
    except Exception as e:
        print(f"Error: {e}")
        return render_template('admin/games.html', games=[])

@app.route('/admin/games/add', methods=['POST'])
@login_required
def add_game():
    """Add new game"""
    try:
        name = request.form.get('game_name')
        genre = request.form.get('genre')
        developer = request.form.get('developer')
        release_date = request.form.get('release_date')
        max_players = request.form.get('max_players')

        execute_query("""
            INSERT INTO games (GAME_NAME, GENRE, DEVELOPER, RELEASE_DATE, MAX_PLAYERS)
            VALUES (%s, %s, %s, %s, %s)
        """, (name, genre, developer, release_date, max_players), fetch=False)

        flash('Game added successfully!', 'success')
    except Exception as e:
        flash(f'Error adding game: {str(e)}', 'error')

    return redirect(url_for('admin_games'))

@app.route('/admin/games/delete/<int:game_id>')
@login_required
def delete_game(game_id):
    """Delete game"""
    try:
        execute_query("DELETE FROM games WHERE GAME_ID = %s", (game_id,), fetch=False)
        flash('Game deleted successfully!', 'success')
    except Exception as e:
        flash(f'Error deleting game: {str(e)}', 'error')

    return redirect(url_for('admin_games'))

# TEAMS MANAGEMENT
@app.route('/admin/teams/add', methods=['POST'])
@login_required
def add_team():
    """Add new team"""
    try:
        team_name = request.form.get('team_name', '').strip()
        region = request.form.get('region', '').strip()
        coach = request.form.get('coach', '').strip()
        game_id = request.form.get('game_id', '').strip()
        
        # Validate inputs
        if not team_name or not region or not coach or not game_id:
            flash('Please fill in all fields', 'error')
            return redirect(url_for('admin_teams'))
        
        # Verify game exists
        game = execute_query("SELECT GAME_ID FROM games WHERE GAME_ID = %s", (game_id,))
        if not game:
            flash('Game not found', 'error')
            return redirect(url_for('admin_teams'))
        
        # Insert team (NO FOUNDED_YEAR - removed it)
        result = execute_query("""
            INSERT INTO team (TEAM_NAME, REGION, COACH, GAME_ID)
            VALUES (%s, %s, %s, %s)
        """, (team_name, region, coach, game_id), fetch=False)
        
        flash(f'Team "{team_name}" added successfully!', 'success')
        print(f"DEBUG: Team '{team_name}' inserted successfully")
    except Exception as e:
        print(f"Error adding team: {e}")
        import traceback
        traceback.print_exc()
        flash(f'Error: {str(e)}', 'error')
    
    return redirect(url_for('admin_teams'))


@app.route('/admin/teams')
@login_required
def admin_teams():
    """Admin teams page"""
    try:
        teams = execute_query("""
            SELECT 
                t.TEAM_ID,
                t.TEAM_NAME,
                t.REGION,
                t.COACH,
                t.GAME_ID,
                g.GAME_NAME
            FROM team t
            JOIN games g ON t.GAME_ID = g.GAME_ID
            ORDER BY t.TEAM_ID DESC
        """)
        
        games = execute_query("SELECT GAME_ID, GAME_NAME FROM games ORDER BY GAME_NAME")
        
        print(f"DEBUG: Found {len(teams) if teams else 0} teams")
        
        return render_template('admin/teams.html',
                             teams=teams or [],
                             games=games or [])
    except Exception as e:
        print(f"Error in admin_teams: {e}")
        import traceback
        traceback.print_exc()
        flash('Error loading teams', 'error')
        return render_template('admin/teams.html',
                             teams=[],
                             games=[])


@app.route('/admin/teams/delete/<int:team_id>', methods=['POST'])
@login_required
def delete_team(team_id):
    """Delete team"""
    try:
        execute_query("DELETE FROM team WHERE TEAM_ID = %s", (team_id,), fetch=False)
        flash('Team deleted successfully!', 'success')
    except Exception as e:
        print(f"Error deleting team: {e}")
        flash(f'Error: {str(e)}', 'error')
    
    return redirect(url_for('admin_teams'))



# ============================================
# ADMIN - TOURNAMENTS MANAGEMENT
# ============================================

@app.route('/admin/tournaments')
@login_required
def admin_tournaments():
    """Admin tournaments page with full CRUD"""
    try:
        tournaments = execute_query("""
            SELECT 
                t.TK_ID,
                t.TOURNAMENT_NAME,
                t.LOCATION,
                t.PRIZE_POOL,
                t.DURATION,
                t.GAME_ID,
                t.STATUS,
                t.WINNER_TEAM_ID,
                g.GAME_NAME,
                winner.TEAM_NAME AS WINNER_NAME,
                count_participating_teams(t.TK_ID) as team_count
            FROM tournaments t
            JOIN games g ON t.GAME_ID = g.GAME_ID
            LEFT JOIN team winner ON winner.TEAM_ID = t.WINNER_TEAM_ID
            ORDER BY t.TK_ID DESC
        """)
        
        games = execute_query("SELECT GAME_ID, GAME_NAME FROM games ORDER BY GAME_NAME")
        teams = execute_query("SELECT TEAM_ID, TEAM_NAME, GAME_ID FROM team ORDER BY TEAM_NAME")
        
        return render_template('admin/tournaments.html',
                             tournaments=tournaments or [],
                             games=games or [],
                             teams=teams or [],
                             statuses=['UPCOMING', 'ONGOING', 'COMPLETED'])
    except Exception as e:
        print(f"Error in admin_tournaments: {e}")
        flash('Error loading tournaments', 'error')
        return render_template('admin/tournaments.html',
                             tournaments=[], games=[], teams=[],
                             statuses=['UPCOMING', 'ONGOING', 'COMPLETED'])


@app.route('/admin/tournaments/add', methods=['POST'])
@login_required
def add_tournament():
    """Create new tournament with teams - FIXED"""
    from db_connection import execute_query_with_connection
    
    try:
        name = request.form.get('tournament_name')
        location = request.form.get('location')
        prize_pool = request.form.get('prize_pool')
        duration = request.form.get('duration')
        game_id = request.form.get('game_id')
        status = request.form.get('status', 'UPCOMING')
        team_ids = request.form.getlist('team_ids')

        # Convert types
        try:
            prize_pool = float(prize_pool)
        except:
            prize_pool = 0
        
        try:
            game_id = int(game_id)
        except:
            game_id = None

        # Execute INSERT and SELECT LAST_INSERT_ID on SAME connection
        results = execute_query_with_connection([
            ("""INSERT INTO tournaments
                (TOURNAMENT_NAME, LOCATION, PRIZE_POOL, DURATION, GAME_ID, STATUS)
                VALUES (%s, %s, %s, %s, %s, %s)""",
             (name, location, prize_pool, duration, game_id, status),
             False),
            
            ("SELECT LAST_INSERT_ID() as TK_ID", None, True)
        ])

        tk_id = results[1][0]['TK_ID'] if results[1] else 0
        print(f"✓ Tournament created with ID: {tk_id}")
        
        if tk_id == 0:
            flash(' Tournament creation failed', 'error')
            return redirect(url_for('admin_tournaments'))

        # Add teams
        if team_ids:
            for team_id in team_ids:
                execute_query("""
                    INSERT INTO participate (TEAM_ID, TK_ID) VALUES (%s, %s)
                """, (team_id, tk_id), fetch=False)

                execute_query("""
                    INSERT IGNORE INTO tournament_stats (TK_ID, TEAM_ID, WINS, LOSSES, POINTS)
                    VALUES (%s, %s, 0, 0, 0)
                """, (tk_id, team_id), fetch=False)

        flash(f' Tournament "{name}" created successfully with {len(team_ids)} teams!', 'success')
        return redirect(url_for('admin_tournaments'))

    except pymysql.Error as db_error:
        error_msg = str(db_error)
        print(f" DATABASE ERROR: {error_msg}")
        flash(f' {error_msg}', 'error')
        return redirect(url_for('admin_tournaments'))
    
    except Exception as e:
        print(f" ERROR: {e}")
        import traceback
        traceback.print_exc()
        flash(f' Error: {str(e)}', 'error')
        return redirect(url_for('admin_tournaments'))





@app.route('/admin/tournaments/update/<int:tk_id>', methods=['POST'])
@login_required
def update_tournament(tk_id):
    """Update tournament details"""
    try:
        name = request.form.get('tournament_name')
        location = request.form.get('location')
        prize_pool = request.form.get('prize_pool')
        duration = request.form.get('duration')
        game_id = request.form.get('game_id')
        status = request.form.get('status')
        
        execute_query("""
            UPDATE tournaments
            SET TOURNAMENT_NAME=%s, LOCATION=%s, PRIZE_POOL=%s,
                DURATION=%s, GAME_ID=%s, STATUS=%s
            WHERE TK_ID=%s
        """, (name, location, prize_pool, duration, game_id, status, tk_id), fetch=False)
        
        flash('Tournament updated successfully!', 'success')
    except Exception as e:
        print(f"Error updating tournament: {e}")
        flash(f'Error: {str(e)}', 'error')
    
    return redirect(url_for('admin_tournaments'))


@app.route('/admin/tournaments/manage-teams/<int:tk_id>', methods=['GET', 'POST'])
@login_required
def manage_teams(tk_id):
    """Add or remove teams from a tournament"""
    try:
        tournament = execute_query("SELECT * FROM tournaments WHERE TK_ID = %s", (tk_id,))
        if not tournament:
            flash('Tournament not found', 'error')
            return redirect(url_for('admin_tournaments'))
        
        if request.method == 'POST':
            # Get current teams in tournament
            current_teams = execute_query(
                "SELECT TEAM_ID FROM participate WHERE TK_ID = %s", (tk_id,)
            )
            current_team_ids = [t['TEAM_ID'] for t in current_teams]
            
            # Get selected teams from form
            selected_teams = request.form.getlist('team_ids')
            selected_team_ids = [int(t) for t in selected_teams]
            
            # Teams to add (new ones)
            teams_to_add = set(selected_team_ids) - set(current_team_ids)
            for team_id in teams_to_add:
                execute_query(
                    "INSERT INTO participate (TEAM_ID, TK_ID) VALUES (%s, %s)",
                    (team_id, tk_id), fetch=False
                )
                execute_query(
                    "INSERT IGNORE INTO tournament_stats (TK_ID, TEAM_ID, WINS, LOSSES, POINTS) VALUES (%s, %s, 0, 0, 0)",
                    (tk_id, team_id), fetch=False
                )
            
            # Teams to remove (deselected ones)
            teams_to_remove = set(current_team_ids) - set(selected_team_ids)
            for team_id in teams_to_remove:
                execute_query(
                    "DELETE FROM participate WHERE TEAM_ID = %s AND TK_ID = %s",
                    (team_id, tk_id), fetch=False
                )
                execute_query(
                    "DELETE FROM tournament_stats WHERE TEAM_ID = %s AND TK_ID = %s",
                    (team_id, tk_id), fetch=False
                )
            
            flash('Tournament teams updated successfully!', 'success')
            return redirect(url_for('admin_tournaments'))
        
        # GET request - show manage teams page
        current_teams = execute_query(
            "SELECT TEAM_ID FROM participate WHERE TK_ID = %s", (tk_id,)
        )
        current_team_ids = [t['TEAM_ID'] for t in current_teams]
        
        # Get all teams for the game
        game_teams = execute_query(
            "SELECT TEAM_ID, TEAM_NAME FROM team WHERE GAME_ID = %s ORDER BY TEAM_NAME",
            (tournament[0]['GAME_ID'],)
        )
        
        return render_template('admin/manage_teams.html',
                             tournament=tournament[0],
                             teams=game_teams or [],
                             current_team_ids=current_team_ids)
    except Exception as e:
        print(f"Error managing teams: {e}")
        flash(f'Error: {str(e)}', 'error')
        return redirect(url_for('admin_tournaments'))


@app.route('/admin/tournaments/delete/<int:tk_id>', methods=['POST'])
@login_required
def delete_tournament(tk_id):
    """Delete tournament"""
    try:
        execute_query("DELETE FROM tournaments WHERE TK_ID = %s", (tk_id,), fetch=False)
        flash('Tournament deleted successfully!', 'success')
    except Exception as e:
        print(f"Error deleting tournament: {e}")
        flash(f'Error: {str(e)}', 'error')
    
    return redirect(url_for('admin_tournaments'))


@app.route('/admin/tournaments/change-status/<int:tk_id>/<status>', methods=['POST'])
@login_required
def change_tournament_status(tk_id, status):
    """Quick status change"""
    try:
        if status not in ['UPCOMING', 'ONGOING', 'COMPLETED']:
            flash('Invalid status', 'error')
            return redirect(url_for('admin_tournaments'))
        
        execute_query("UPDATE tournaments SET STATUS=%s WHERE TK_ID=%s", 
                     (status, tk_id), fetch=False)
        
        # If completing, stamp winner
        if status == 'COMPLETED':
            winner = execute_query("""
                SELECT TEAM_ID FROM v_tournament_winners WHERE TK_ID=%s
            """, (tk_id,))
            if winner:
                execute_query("""
                    UPDATE tournaments SET WINNER_TEAM_ID=%s WHERE TK_ID=%s
                """, (winner[0]['TEAM_ID'], tk_id), fetch=False)
        
        flash(f'Tournament status changed to {status}!', 'success')
    except Exception as e:
        print(f"Error changing status: {e}")
        flash(f'Error: {str(e)}', 'error')
    
    return redirect(url_for('admin_tournaments'))



# ============================================
# ADMIN - STATISTICS (Match Recording)
# ============================================

@app.route('/admin/statistics')
@login_required
def admin_statistics():
    """Statistics management - record matches for ONGOING tournaments with 2+ teams"""
    try:
        # Get ONGOING tournaments that have 2 or more teams
        tournaments = execute_query("""
            SELECT 
                t.TK_ID,
                t.TOURNAMENT_NAME,
                t.GAME_ID,
                COUNT(p.TEAM_ID) as team_count
            FROM tournaments t
            JOIN participate p ON p.TK_ID = t.TK_ID
            WHERE t.STATUS = 'ONGOING'
            GROUP BY t.TK_ID, t.TOURNAMENT_NAME, t.GAME_ID
            HAVING COUNT(p.TEAM_ID) >= 2
            ORDER BY t.TOURNAMENT_NAME
        """)
        
        # Get current standings for ONGOING tournaments only
        standings = execute_query("""
            SELECT 
                s.TK_ID,
                t.TOURNAMENT_NAME,
                s.RANKING,
                s.TEAM_NAME,
                s.WINS,
                s.LOSSES,
                s.POINTS
            FROM v_tournament_standings s
            JOIN tournaments t ON t.TK_ID = s.TK_ID
            WHERE t.STATUS = 'ONGOING'
            ORDER BY t.TOURNAMENT_NAME, s.RANKING
        """)
        
        return render_template('admin/statistics.html',
                             tournaments=tournaments or [],
                             standings=standings or [])
    except Exception as e:
        print(f"Error in admin_statistics: {e}")
        flash('Error loading statistics page', 'error')
        return render_template('admin/statistics.html',
                             tournaments=[], standings=[])



@app.route('/admin/statistics/get-teams/<int:tk_id>')
@login_required
def get_tournament_teams(tk_id):
    """API endpoint: Get teams for a tournament"""
    try:
        teams = execute_query("""
            SELECT t.TEAM_ID, t.TEAM_NAME
            FROM team t
            JOIN participate p ON p.TEAM_ID = t.TEAM_ID
            WHERE p.TK_ID = %s
            ORDER BY t.TEAM_NAME
        """, (tk_id,))
        
        return {'teams': teams or []}
    except Exception as e:
        print(f"Error getting teams: {e}")
        return {'teams': []}, 500


@app.route('/admin/statistics/record-match', methods=['POST'])
@login_required
def record_match():
    """Record match result - direct inserts, no procedure"""
    try:
        tk_id = int(request.form.get('tournament_id'))
        winner_id = int(request.form.get('winner_id'))
        loser_id = int(request.form.get('loser_id'))
        points = int(request.form.get('points', 3))
        
        # Validation
        if winner_id == loser_id:
            flash('Winner and loser cannot be the same team!', 'error')
            return redirect(url_for('admin_statistics'))
        
        print(f"\n{'='*60}")
        print(f"Recording match: Tournament {tk_id}, Winner {winner_id}, Loser {loser_id}, Points {points}")
        print(f"{'='*60}\n")
        
        # Ensure both teams exist in tournament_stats (only 5 columns)
        execute_query("""
            INSERT IGNORE INTO tournament_stats (TK_ID, TEAM_ID, WINS, LOSSES, POINTS)
            VALUES (%s, %s, 0, 0, 0)
        """, (tk_id, winner_id), fetch=False)
        
        execute_query("""
            INSERT IGNORE INTO tournament_stats (TK_ID, TEAM_ID, WINS, LOSSES, POINTS)
            VALUES (%s, %s, 0, 0, 0)
        """, (tk_id, loser_id), fetch=False)
        
        print(f"✓ Stats entries ensured")
        
        # Update winner stats
        execute_query("""
            UPDATE tournament_stats
            SET WINS = WINS + 1,
                POINTS = POINTS + %s
            WHERE TK_ID = %s AND TEAM_ID = %s
        """, (points, tk_id, winner_id), fetch=False)
        
        print(f"✓ Winner stats updated")
        
        # Update loser stats
        execute_query("""
            UPDATE tournament_stats
            SET LOSSES = LOSSES + 1
            WHERE TK_ID = %s AND TEAM_ID = %s
        """, (tk_id, loser_id), fetch=False)
        
        print(f"✓ Loser stats updated")
        
        # Get team names
        winner_name = execute_query("SELECT TEAM_NAME FROM team WHERE TEAM_ID=%s", (winner_id,))
        loser_name = execute_query("SELECT TEAM_NAME FROM team WHERE TEAM_ID=%s", (loser_id,))
        
        if winner_name and loser_name:
            flash(f'✓ Match recorded! {winner_name[0]["TEAM_NAME"]} defeated {loser_name[0]["TEAM_NAME"]} (+{points} pts)!', 'success')
        
        print(f"{'='*60}\n✓ MATCH RECORDED SUCCESSFULLY\n{'='*60}\n")
        
    except Exception as e:
        print(f"\n❌ ERROR RECORDING MATCH:\n{e}\n")
        import traceback
        traceback.print_exc()
        flash(f'Error recording match: {str(e)}', 'error')
    
    return redirect(url_for('admin_statistics'))



# SPONSORSHIPS
@app.route('/admin/sponsorships')
@login_required
def admin_sponsorships():
    """Sponsorships management"""
    try:
        sponsorships = execute_query("""
            SELECT s.*, 
                   t.TEAM_NAME,
                   get_total_sponsorship_for_team(s.TEAM_ID) as TEAM_TOTAL_SPONSOR
            FROM sponsorship s
            JOIN team t ON s.TEAM_ID = t.TEAM_ID
        """)

        teams = execute_query("SELECT TEAM_ID, TEAM_NAME FROM team")
        return render_template('admin/sponsorships.html', sponsorships=sponsorships or [], teams=teams or [])
    except Exception as e:
        return render_template('admin/sponsorships.html', sponsorships=[], teams=[])

@app.route('/admin/sponsorships/add', methods=['POST'])
@login_required
def add_sponsorship():
    """Add sponsorship"""
    try:
        company = request.form.get('company')
        industry = request.form.get('industry')
        amount = request.form.get('amount')
        team_id = request.form.get('team_id')

        # Insert sponsorship with team directly
        execute_query("""
            INSERT INTO sponsorship (NAME, INDUSTRY, AMOUNT, TEAM_ID)
            VALUES (%s, %s, %s, %s)
        """, (company, industry, amount, team_id), fetch=False)

        flash('Sponsorship added successfully!', 'success')
    except Exception as e:
        flash(f'Error: {str(e)}', 'error')

    return redirect(url_for('admin_sponsorships'))

@app.route('/admin/sponsorships/update/<int:sponsorship_id>', methods=['POST'])
@login_required
def update_sponsorship(sponsorship_id):
    """Update sponsorship"""
    try:
        company = request.form.get('company')
        industry = request.form.get('industry')
        amount = request.form.get('amount')
        team_id = request.form.get('team_id')
        
        execute_query("""
            UPDATE sponsorship 
            SET NAME=%s, INDUSTRY=%s, AMOUNT=%s, TEAM_ID=%s
            WHERE ID=%s
        """, (company, industry, amount, team_id, sponsorship_id), fetch=False)
        
        flash('Sponsorship updated successfully!', 'success')
    except Exception as e:
        flash(f'Error: {str(e)}', 'error')
    
    return redirect(url_for('admin_sponsorships'))

@app.route('/admin/sponsorships/delete/<int:sponsorship_id>', methods=['POST'])
@login_required
def delete_sponsorship(sponsorship_id):
    """Delete sponsorship"""
    try:
        execute_query("DELETE FROM sponsorship WHERE ID = %s", (sponsorship_id,), fetch=False)
        flash('Sponsorship deleted successfully!', 'success')
    except Exception as e:
        flash(f'Error: {str(e)}', 'error')
    
    return redirect(url_for('admin_sponsorships'))

# ============================================
# ADMIN - STREAM MANAGEMENT
# ============================================

@app.route('/admin/streams')
@login_required
def admin_streams():
    """Admin streams page"""
    try:
        # Get all streams with tournament details (using correct column name: URL)
        stream_list = execute_query("""
            SELECT 
                s.STREAM_ID,
                s.TK_ID,
                s.PLATFORM,
                s.URL,
                s.LANGUAGE,
                t.TOURNAMENT_NAME
            FROM stream s
            JOIN tournaments t ON s.TK_ID = t.TK_ID
            ORDER BY s.STREAM_ID DESC
        """)
        
        # Get all tournaments
        tournaments = execute_query("""
            SELECT DISTINCT TK_ID, TOURNAMENT_NAME 
            FROM tournaments 
            ORDER BY TOURNAMENT_NAME
        """)
        
        platforms = ['Twitch', 'YouTube', 'Facebook Live', 'Custom']
        languages = ['English', 'Spanish', 'French', 'German', 'Hindi', 'Other']
        
        print(f"DEBUG: Found {len(tournaments) if tournaments else 0} tournaments")
        print(f"DEBUG: Found {len(stream_list) if stream_list else 0} streams")
        
        return render_template('admin/streams.html',
                             streams=stream_list or [],
                             tournaments=tournaments or [],
                             platforms=platforms,
                             languages=languages)
    except Exception as e:
        print(f"Error in admin_streams: {e}")
        import traceback
        traceback.print_exc()
        flash('Error loading streams', 'error')
        return render_template('admin/streams.html',
                             streams=[], 
                             tournaments=[],
                             platforms=['Twitch', 'YouTube', 'Facebook Live', 'Custom'],
                             languages=['English', 'Spanish', 'French', 'German', 'Hindi', 'Other'])


@app.route('/admin/streams/add', methods=['POST'])
@login_required
def add_stream():
    """Add new stream"""
    try:
        tk_id = request.form.get('tournament_id', '').strip()
        platform = request.form.get('platform', '').strip()
        stream_url = request.form.get('stream_url', '').strip()
        language = request.form.get('language', '').strip()
        
        # Validate inputs
        if not tk_id or not platform or not stream_url or not language:
            flash('Please fill in all fields', 'error')
            return redirect(url_for('admin_streams'))
        
        # Convert tk_id to integer and verify tournament exists
        try:
            tk_id_int = int(tk_id)
        except ValueError:
            flash('Invalid tournament ID', 'error')
            return redirect(url_for('admin_streams'))
        
        tournament = execute_query("SELECT TK_ID, TOURNAMENT_NAME FROM tournaments WHERE TK_ID = %s", (tk_id_int,))
        if not tournament:
            flash('Tournament not found', 'error')
            return redirect(url_for('admin_streams'))
        
        # Insert into stream table (column is URL, not STREAM_URL)
        execute_query("""
            INSERT INTO stream (TK_ID, PLATFORM, URL, LANGUAGE)
            VALUES (%s, %s, %s, %s)
        """, (tk_id_int, platform, stream_url, language), fetch=False)
        
        tournament_name = tournament[0]['TOURNAMENT_NAME']
        flash(f'Stream added successfully for tournament "{tournament_name}"!', 'success')
        print(f"DEBUG: Stream inserted into stream table")
    except Exception as e:
        print(f"Error adding stream: {e}")
        import traceback
        traceback.print_exc()
        flash(f'Error: {str(e)}', 'error')
    
    return redirect(url_for('admin_streams'))


@app.route('/admin/streams/delete/<int:stream_id>', methods=['POST'])
@login_required
def delete_stream(stream_id):
    """Delete stream"""
    try:
        execute_query("DELETE FROM stream WHERE STREAM_ID = %s", (stream_id,), fetch=False)
        flash('Stream deleted successfully!', 'success')
        print(f"DEBUG: Stream deleted from stream table")
    except Exception as e:
        print(f"Error deleting stream: {e}")
        import traceback
        traceback.print_exc()
        flash(f'Error: {str(e)}', 'error')
    
    return redirect(url_for('admin_streams'))


if __name__ == '__main__':
    app.run(debug=True, port=5000)

mysql> -- ============================================
mysql> -- NEW FUNCTION: Calculate Team Ranking
mysql> -- ============================================
mysql> DELIMITER $$
mysql> CREATE FUNCTION IF NOT EXISTS CalculateTournamentRanking(
    ->     p_tournament_id INT,
    ->     p_team_id INT
    -> )
    -> RETURNS INT
    -> READS SQL DATA
    -> BEGIN
    ->     DECLARE v_ranking INT;
    ->
    ->     SELECT COUNT(*) + 1 INTO v_ranking
    ->     FROM tournament_stats ts
    ->     WHERE ts.TK_ID = p_tournament_id
    ->     AND (ts.POINTS > (SELECT POINTS FROM tournament_stats WHERE TK_ID = p_tournament_id AND TEAM_ID = p_team_id)
    ->          OR (ts.POINTS = (SELECT POINTS FROM tournament_stats WHERE TK_ID = p_tournament_id AND TEAM_ID = p_team_id)
    ->              AND ts.WINS > (SELECT WINS FROM tournament_stats WHERE TK_ID = p_tournament_id AND TEAM_ID = p_team_id)));
    ->
    ->     RETURN COALESCE(v_ranking, 1);
    -> END$$
Query OK, 0 rows affected (0.01 sec)

mysql> DELIMITER ;
mysql>
mysql> -- ============================================
mysql> -- NEW PROCEDURE: Record Match 
mysql> -- ============================================
mysql> DELIMITER $$
mysql> CREATE PROCEDURE IF NOT EXISTS RecordMatchAndUpdateStandings(
    ->     IN p_tournament_id INT,
    ->     IN p_winner_team_id INT,
    ->     IN p_loser_team_id INT,
    ->     IN p_points_awarded INT
    -> )
    -> BEGIN
    ->     DECLARE EXIT HANDLER FOR SQLEXCEPTION
    ->     BEGIN
    ->         ROLLBACK;
    ->         SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error recording match result';
    ->     END;
    ->
    ->     START TRANSACTION;
    ->
    ->     -- Ensure both teams exist in tournament_stats
    ->     INSERT IGNORE INTO tournament_stats (TK_ID, TEAM_ID, WINS, LOSSES, POINTS, MATCH_PLAYED)
    ->     VALUES (p_tournament_id, p_winner_team_id, 0, 0, 0, 0);
    ->
    ->     INSERT IGNORE INTO tournament_stats (TK_ID, TEAM_ID, WINS, LOSSES, POINTS, MATCH_PLAYED)
    ->     VALUES (p_tournament_id, p_loser_team_id, 0, 0, 0, 0);
    ->
    ->     -- Update winner stats
    ->     UPDATE tournament_stats
    ->     SET WINS = WINS + 1,
    ->         POINTS = POINTS + p_points_awarded,
    ->         MATCH_PLAYED = MATCH_PLAYED + 1
    ->     WHERE TK_ID = p_tournament_id AND TEAM_ID = p_winner_team_id;
    ->
    ->     -- Update loser stats
    ->     UPDATE tournament_stats
    ->     SET LOSSES = LOSSES + 1,
    ->         MATCH_PLAYED = MATCH_PLAYED + 1
    ->     WHERE TK_ID = p_tournament_id AND TEAM_ID = p_loser_team_id;
    ->
    ->     -- Update rankings for all teams in tournament
    ->     UPDATE tournament_stats ts
    ->     SET ts.RANKING = CalculateTournamentRanking(p_tournament_id, ts.TEAM_ID)
    ->     WHERE ts.TK_ID = p_tournament_id;
    ->
    ->     COMMIT;
    -> END$$
Query OK, 0 rows affected (0.00 sec)

mysql> DELIMITER ;
mysql>
mysql> -- ============================================
mysql> -- NEW TRIGGER: Auto-Update Tournament Standings
mysql> -- ============================================
mysql> DELIMITER $$
mysql> CREATE TRIGGER IF NOT EXISTS trg_update_tournament_standings_on_stats_change
    -> AFTER UPDATE ON tournament_stats
    -> FOR EACH ROW
    -> BEGIN
    ->     DECLARE v_tournament_id INT;
    ->     SET v_tournament_id = NEW.TK_ID;
    ->
    ->     -- Recalculate all rankings in this tournament
    ->     UPDATE tournament_stats ts
    ->     SET ts.RANKING = (
    ->         SELECT COUNT(*) + 1
    ->         FROM tournament_stats ts2
    ->         WHERE ts2.TK_ID = v_tournament_id
    ->         AND (ts2.POINTS > NEW.POINTS
    ->              OR (ts2.POINTS = NEW.POINTS AND ts2.WINS > NEW.WINS))
    ->     )
    ->     WHERE ts.TK_ID = v_tournament_id;
    ->
    ->     -- Update tournament winner if someone has 10+ wins
    ->     IF NEW.WINS >= 10 THEN
    ->         UPDATE tournaments t
    ->         SET t.STATUS = 'COMPLETED',
    ->             t.WINNER_TEAM_ID = NEW.TEAM_ID
    ->         WHERE t.TK_ID = v_tournament_id AND t.STATUS = 'ONGOING';
    ->     END IF;
    -> END$$
Query OK, 0 rows affected (0.01 sec)

mysql> DELIMITER ;
mysql>










DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS get_tournaments_filtered(IN p_status VARCHAR(20))
BEGIN
    IF p_status IN ('UPCOMING', 'ONGOING', 'COMPLETED') THEN
        SELECT
            t.TK_ID,
            t.TOURNAMENT_NAME,
            t.LOCATION,
            t.PRIZE_POOL,
            t.DURATION,
            t.GAME_ID,
            t.STATUS,
            t.WINNER_TEAM_ID,
            team.TEAM_NAME AS WINNER_NAME
        FROM tournaments t
        LEFT JOIN team ON team.TEAM_ID = t.WINNER_TEAM_ID
        WHERE t.STATUS = p_status
        ORDER BY FIELD(t.STATUS, 'ONGOING', 'UPCOMING', 'COMPLETED'), t.TK_ID DESC;
    ELSE
        -- If 'ALL' or invalid, return all tournaments
        SELECT
            t.TK_ID,
            t.TOURNAMENT_NAME,
            t.LOCATION,
            t.PRIZE_POOL,
            t.DURATION,
            t.GAME_ID,
            t.STATUS,
            t.WINNER_TEAM_ID,
            team.TEAM_NAME AS WINNER_NAME
        FROM tournaments t
        LEFT JOIN team ON team.TEAM_ID = t.WINNER_TEAM_ID
        ORDER BY FIELD(t.STATUS, 'ONGOING', 'UPCOMING', 'COMPLETED'), t.TK_ID DESC;
    END IF;
END$$
DELIMITER ;




-Analytics
DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS get_top_teams_analytics(IN p_limit INT)
BEGIN
    SELECT 
        t.TEAM_NAME,
        s.POINTS,
        s.RANKING,
        s.WINS,
        s.LOSSES
    FROM team t
    JOIN stats s ON t.TEAM_ID = s.TEAM_ID
    ORDER BY s.POINTS DESC
    LIMIT p_limit;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS get_teams_count_by_region()
BEGIN
    SELECT 
        REGION,
        COUNT(*) as count
    FROM team
    GROUP BY REGION
    ORDER BY count DESC;
END$$
DELIMITER ;





--Functions
-- Function 1: Get tournament winner name
DELIMITER $$
CREATE FUNCTION IF NOT EXISTS get_tournament_winner_name(p_tk_id INT)
RETURNS VARCHAR(100)
READS SQL DATA
BEGIN
    DECLARE v_winner VARCHAR(100);
    SELECT t.TEAM_NAME INTO v_winner
    FROM tournaments trn
    LEFT JOIN team t ON t.TEAM_ID = trn.WINNER_TEAM_ID
    WHERE trn.TK_ID = p_tk_id
    LIMIT 1;
    RETURN COALESCE(v_winner, 'TBD');
END$$
DELIMITER ;

-- Function 2: Get total sponsorship for team
DELIMITER $$
CREATE FUNCTION IF NOT EXISTS get_total_sponsorship_for_team(p_team_id INT)
RETURNS DECIMAL(15,2)
READS SQL DATA
BEGIN
    DECLARE v_total DECIMAL(15,2);
    SELECT COALESCE(SUM(AMOUNT), 0) INTO v_total
    FROM sponsorship
    WHERE TEAM_ID = p_team_id;
    RETURN v_total;
END$$
DELIMITER ;

-- Function 3: Count participating teams in tournament
DELIMITER $$
CREATE FUNCTION IF NOT EXISTS count_participating_teams(p_tk_id INT)
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE v_count INT;
    SELECT COUNT(*) INTO v_count
    FROM participate
    WHERE TK_ID = p_tk_id;
    RETURN COALESCE(v_count, 0);
END$$
DELIMITER ;










DROP TRIGGER IF EXISTS validate_tournament_before_insert;

DELIMITER $$
CREATE TRIGGER validate_tournament_before_insert
BEFORE INSERT ON tournaments
FOR EACH ROW
BEGIN
    -- Validate PRIZE_POOL is not negative
    IF NEW.PRIZE_POOL < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Prize pool cannot be negative';
    END IF;
    
    -- Validate DURATION is not empty (it's VARCHAR now)
    IF NEW.DURATION IS NULL OR TRIM(NEW.DURATION) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Duration cannot be empty';
    END IF;
    
    -- Validate TOURNAMENT_NAME is not empty
    IF NEW.TOURNAMENT_NAME IS NULL OR TRIM(NEW.TOURNAMENT_NAME) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tournament name cannot be empty';
    END IF;
    
    -- Validate STATUS is valid
    IF NEW.STATUS NOT IN ('UPCOMING', 'ONGOING', 'COMPLETED') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid tournament status';
    END IF;
END$$
DELIMITER ;

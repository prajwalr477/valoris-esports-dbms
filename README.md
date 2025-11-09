# Valoris — Gaming Tournament Management System

Valoris is a Flask + MySQL web app for end‑to‑end esports tournament operations—create tournaments, register teams, schedule matches, record results, and auto‑update rankings in real time.

---

## Table of Contents
- Overview
- Features
- Prerequisites
- Setup (Step‑by‑Step)
- Configuration
- Database Setup
- Run & Access
- Project Structure
- Usage
- License

---

## Overview
A database‑backed web application that centralizes tournament management with a clean admin interface and public-facing dashboard for teams, sponsors, and viewers.

---

## Features
- Tournament and team management
- Game scheduling and match tracking
- Automatic rankings and standings updates
- Admin panel for managing tournaments, teams, games, and streams
- Public dashboard for viewing rankings and team details
- Stream link management
- Team sponsorship tracking
- Analytics and statistics

---

## Prerequisites
- Python 3.8+
- MySQL Server
- Git

---

## Setup (Step‑by‑Step)

1) Clone the repository

```bash
git clone https://github.com/prajwalr477/valoris-esports-dbms.git
cd valoris-esports-dbms
```

2) Create and activate a virtual environment

```bash
python -m venv venv
# macOS/Linux
source venv/bin/activate
# Windows (PowerShell)
venv\Scripts\Activate.ps1
```

3) Install Python dependencies

```bash
pip install -r requirements.txt
```

Included in requirements.txt:
- Flask==3.0.0
- Flask-MySQLdb==2.0.0
- PyMySQL==1.1.0
- python-dotenv==1.0.0
- Werkzeug==3.0.1

---

## Configuration

Default config (config.py):

```python
MYSQL_USER = 'root'
MYSQL_PASSWORD = 'root'
MYSQL_DB = 'gaming_tournament_db'
```

---

## Database Setup

The database/ folder contains SQL files. Apply them in order (ensure MySQL is running):

1) Create tables and schema
```bash
mysql -u root -p < database/Create_database.sql
```

## Run & Access

Start the app:

```bash
python app.py
```

Expected output:

```
 * Running on http://127.0.0.1:5000
 * Debug mode: on
```

Open in your browser:
- Home: http://localhost:5000
- Dashboard (Rankings): http://localhost:5000/dashboard
- Admin Panel: http://localhost:5000/admin/login

---

## Project Structure

```
valoris-esports-dbms/
├── .gitignore
├── LICENSE
├── README.md
├── app.py                          # Main Flask application
├── config.py                       # Configuration settings
├── requirements.txt                # Python dependencies
├── database/
│   ├── db_connection.py            # Database connection module
│   ├── Create_database.sql         # Create the database with valuees
├── static/
│   ├── css/
│   │   ├── admin.css               # Admin panel styles
│   │   └── style.css               # Main application styles
│   └── js/
│       ├── admin.js                # Admin panel functionality
│       └── main.js                 # Main application scripts
└── docs/
│   └── Final_report.pdf
└── templates/
    ├── base.html                   # Base template for all pages
    ├── admin/                      # Admin panel templates
    │   ├── admin_base.html         # Admin base layout
    │   ├── admin_dashboard.html    # Admin dashboard
    │   ├── games.html              # Games management
    │   ├── login.html              # Admin login
    │   ├── manage_teams.html       # Team management
    │   ├── sponsorships.html       # Sponsorship management
    │   ├── statistics.html         # Statistics view
    │   ├── streams.html            # Stream link management
    │   ├── teams.html              # Teams listing
    │   └── tournaments.html        # Tournament management
    └── public/                     # Public-facing templates
        ├── analytics.html          # Analytics page
        ├── dashboard.html          # Public rankings dashboard
        ├── game_teams.html         # Teams in a game
        ├── games.html              # Games listing
        ├── home.html               # Home page
        ├── team_detail.html        # Team details page
        ├── teams.html              # Teams listing
        ├── tournament_detail.html  # Tournament details page
        └── tournaments.html        # Tournaments listing
```

---

## Usage

1. **Admin Access:** Login to admin panel (http://localhost:5000/admin/login)
2. **Create Tournament:** Add tournaments with name, dates, and settings
3. **Add Teams:** Register teams and manage team information
4. **Add Games:** Schedule games/matches with participating teams
5. **Add Sponsorships:** Manage team sponsorships
6. **Manage Streams:** Add and manage stream links for tournaments
7. **Update Results:** Record match results; standings auto-update
8. **View Public Dashboard:** Check live rankings and statistics

---

## Documentation & Deliverables

The docs/ folder (to be created) will contain:
- Final project report
- ER diagram
- Relational schema
- Screenshots and usage guide
- Database design documentation

---

## License

MIT License

DELIMITER $$

-- Procedure: Get all teams by region with stats and win percentage
CREATE PROCEDURE `get_teams_by_region`(
    IN p_region VARCHAR(50)
)
BEGIN
    SELECT
        t.TEAM_ID,
        t.TEAM_NAME,
        t.REGION,
        t.COACH,
        g.GAME_NAME,
        s.POINTS,
        s.RANKING,
        ROUND((s.WINS / s.MATCH_PLAYED * 100), 2) as win_percentage
    FROM team t
    JOIN stats s ON t.TEAM_ID = s.TEAM_ID
    JOIN games g ON t.GAME_ID = g.GAME_ID
    WHERE t.REGION = p_region
    ORDER BY s.POINTS DESC;
END $$


-- Procedure: Get count of teams by region for analytics
CREATE PROCEDURE `get_teams_count_by_region`()
BEGIN
    SELECT
        REGION,
        COUNT(*) as count
    FROM team
    GROUP BY REGION
    ORDER BY count DESC;
END $$


-- Procedure: Get top teams by points, limited by parameter
CREATE PROCEDURE `get_top_teams_analytics`(IN p_limit INT)
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
END $$


-- Procedure: Get tournaments filtered by status or all if invalid
CREATE PROCEDURE `get_tournaments_filtered`(IN p_status VARCHAR(20))
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
END $$


-- Procedure: Get tournament details and standings for a given tournament ID
CREATE PROCEDURE `get_tournament_details`(
    IN p_tournament_id INT
)
BEGIN
    SELECT
        TK_ID,
        TOURNAMENT_NAME,
        PRIZE_POOL,
        DURATION,
        LOCATION,
        GAME_ID
    FROM tournaments
    WHERE TK_ID = p_tournament_id;

    SELECT
        tm.TEAM_ID,
        vts.TEAM_NAME,
        tm.REGION,
        vts.POINTS,
        vts.RANKING,
        vts.WINS,
        vts.LOSSES
    FROM participate p
    JOIN team tm ON p.TEAM_ID = tm.TEAM_ID
    JOIN v_tournament_standings vts ON vts.TEAM_NAME = tm.TEAM_NAME AND vts.TK_ID = p_tournament_id
    WHERE p.TK_ID = p_tournament_id
    ORDER BY vts.RANKING ASC;
END $$

DELIMITER ;






















DELIMITER $$

-- Function: Calculate win percentage for a given team
CREATE FUNCTION `calculate_win_percentage`(p_team_id INT) RETURNS decimal(5,2)
    DETERMINISTIC
BEGIN
    DECLARE win_pct DECIMAL(5,2);
    SELECT (WINS / MATCH_PLAYED * 100) INTO win_pct
    FROM stats
    WHERE TEAM_ID = p_team_id
    LIMIT 1;
    RETURN IFNULL(win_pct, 0);
END $$


-- Function: Count number of teams participating in a tournament
CREATE FUNCTION `count_participating_teams`(p_tk_id INT) RETURNS int
    READS SQL DATA
BEGIN
    DECLARE v_count INT;
    SELECT COUNT(*) INTO v_count
    FROM participate
    WHERE TK_ID = p_tk_id;
    RETURN COALESCE(v_count, 0);
END $$


-- Function: Count number of teams playing a specific game
CREATE FUNCTION `count_teams_in_game`(p_game_id INT) RETURNS int
    DETERMINISTIC
BEGIN
    DECLARE team_count INT;
    SELECT COUNT(*) INTO team_count
    FROM team
    WHERE GAME_ID = p_game_id;
    RETURN IFNULL(team_count, 0);
END $$


-- Function: Get total sponsorship amount for a team
CREATE FUNCTION `get_total_sponsorship_for_team`(p_team_id INT) RETURNS decimal(15,2)
    READS SQL DATA
BEGIN
    DECLARE v_total DECIMAL(15,2);
    SELECT COALESCE(SUM(AMOUNT), 0) INTO v_total
    FROM sponsorship
    WHERE TEAM_ID = p_team_id;
    RETURN v_total;
END $$


-- Function: Get tournament winner's team name or TBD if none
CREATE FUNCTION `get_tournament_winner_name`(p_tk_id INT) RETURNS varchar(100) CHARSET utf8mb4
    READS SQL DATA
BEGIN
    DECLARE v_winner VARCHAR(100);
    SELECT t.TEAM_NAME INTO v_winner
    FROM tournaments trn
    LEFT JOIN team t ON t.TEAM_ID = trn.WINNER_TEAM_ID
    WHERE trn.TK_ID = p_tk_id
    LIMIT 1;
    RETURN COALESCE(v_winner, 'TBD');
END $$

DELIMITER ;














DELIMITER $$

-- Trigger: After inserting a participation, seed tournament_stats for that team and tournament
CREATE TRIGGER trg_participate_seed AFTER INSERT ON participate
FOR EACH ROW
BEGIN
    INSERT INTO tournament_stats (TK_ID, TEAM_ID)
    VALUES (NEW.TK_ID, NEW.TEAM_ID)
    ON DUPLICATE KEY UPDATE TEAM_ID = TEAM_ID;
END $$


-- Trigger: Validate sponsorship data before insert
CREATE TRIGGER validate_sponsorship_before_insert BEFORE INSERT ON sponsorship
FOR EACH ROW
BEGIN
    IF NEW.AMOUNT <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Sponsorship amount must be greater than 0';
    END IF;

    IF NEW.AMOUNT > 10000000.00 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Sponsorship amount cannot exceed 10,000,000';
    END IF;

    IF NEW.TEAM_ID NOT IN (SELECT TEAM_ID FROM team) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Team does not exist';
    END IF;

    IF NEW.NAME IS NULL OR TRIM(NEW.NAME) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Sponsor name cannot be empty';
    END IF;

    IF NEW.INDUSTRY IS NULL OR TRIM(NEW.INDUSTRY) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Industry cannot be empty';
    END IF;

    IF (SELECT COUNT(*) FROM sponsorship WHERE NAME = NEW.NAME AND TEAM_ID = NEW.TEAM_ID) > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'This company already sponsors this team';
    END IF;
END $$


-- Trigger: Validate stats before insert
CREATE TRIGGER validate_stats_before_insert BEFORE INSERT ON stats
FOR EACH ROW
BEGIN
    IF NEW.WINS < 0 OR NEW.LOSSES < 0 OR NEW.MATCH_PLAYED < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Stats values cannot be negative';
    END IF;

    IF NEW.WINS + NEW.LOSSES > NEW.MATCH_PLAYED THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Wins + Losses cannot exceed Matches Played';
    END IF;

    IF NEW.POINTS < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Points cannot be negative';
    END IF;
END $$


-- Trigger: Validate stats before update
CREATE TRIGGER validate_stats_before_update BEFORE UPDATE ON stats
FOR EACH ROW
BEGIN
    IF NEW.WINS < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'WINS cannot be negative';
    END IF;

    IF NEW.LOSSES < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'LOSSES cannot be negative';
    END IF;

    IF NEW.MATCH_PLAYED < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'MATCH_PLAYED cannot be negative';
    END IF;

    IF NEW.POINTS < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'POINTS cannot be negative';
    END IF;

    IF NEW.RANKING < 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'RANKING must be at least 1';
    END IF;

    IF NEW.WINS + NEW.LOSSES != NEW.MATCH_PLAYED THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'WINS + LOSSES must equal MATCH_PLAYED exactly';
    END IF;

    IF NEW.WINS > NEW.MATCH_PLAYED THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'WINS cannot exceed MATCH_PLAYED';
    END IF;

    IF NEW.LOSSES > NEW.MATCH_PLAYED THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'LOSSES cannot exceed MATCH_PLAYED';
    END IF;

    IF NEW.MATCH_PLAYED < OLD.MATCH_PLAYED THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'MATCH_PLAYED cannot decrease. Teams cannot "unplay" matches';
    END IF;

    IF NEW.WINS < OLD.WINS THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'WINS cannot decrease. Match history cannot be changed';
    END IF;

    IF NEW.LOSSES < OLD.LOSSES THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'LOSSES cannot decrease. Match history cannot be changed';
    END IF;

    IF NEW.POINTS < 0 OR NEW.POINTS > (NEW.MATCH_PLAYED * 10) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'POINTS must be between 0 and MATCH_PLAYED * 10';
    END IF;

    IF NEW.TEAM_ID NOT IN (SELECT TEAM_ID FROM team) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Team does not exist';
    END IF;

    IF NEW.RANKING < 1 OR NEW.RANKING > 100 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'RANKING must be between 1 and 100';
    END IF;
END $$


-- Trigger: After update on tournament_stats, update tournament status and winner if a team hits 10 wins
CREATE TRIGGER trg_update_tournament_standings_on_stats_change AFTER UPDATE ON tournament_stats
FOR EACH ROW
BEGIN
    IF NEW.WINS >= 10 THEN
        UPDATE tournaments t
        SET t.STATUS = 'COMPLETED',
            t.WINNER_TEAM_ID = NEW.TEAM_ID
        WHERE t.TK_ID = NEW.TK_ID AND t.STATUS = 'ONGOING';
    END IF;
END $$


-- Trigger: Validate tournament data before insert
CREATE TRIGGER validate_tournament_before_insert BEFORE INSERT ON tournaments
FOR EACH ROW
BEGIN
    IF NEW.PRIZE_POOL < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Prize pool cannot be negative';
    END IF;

    IF NEW.DURATION IS NULL OR TRIM(NEW.DURATION) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Duration cannot be empty';
    END IF;

    IF NEW.TOURNAMENT_NAME IS NULL OR TRIM(NEW.TOURNAMENT_NAME) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Tournament name cannot be empty';
    END IF;

    IF NEW.STATUS NOT IN ('UPCOMING', 'ONGOING', 'COMPLETED') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid tournament status';
    END IF;
END $$

DELIMITER ;




















-- View: Tournament standings with ranking
CREATE OR REPLACE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `v_tournament_standings` AS
SELECT 
    ts.TK_ID AS TK_ID,
    ts.TEAM_ID AS TEAM_ID,
    t.TEAM_NAME AS TEAM_NAME,
    ts.POINTS AS POINTS,
    ts.WINS AS WINS,
    ts.LOSSES AS LOSSES,
    DENSE_RANK() OVER (
        PARTITION BY ts.TK_ID 
        ORDER BY ts.POINTS DESC, ts.WINS DESC, t.TEAM_NAME
    ) AS RANKING
FROM tournament_stats ts
JOIN team t ON t.TEAM_ID = ts.TEAM_ID;

-- View: Tournament winners, top ranked team per tournament
CREATE OR REPLACE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `v_tournament_winners` AS
SELECT x.TK_ID AS TK_ID,
       x.TEAM_ID AS TEAM_ID,
       x.TEAM_NAME AS TEAM_NAME
FROM (
    SELECT s.TK_ID AS TK_ID,
           s.TEAM_ID AS TEAM_ID,
           s.TEAM_NAME AS TEAM_NAME,
           s.POINTS AS POINTS,
           s.WINS AS WINS,
           s.LOSSES AS LOSSES,
           s.RANKING AS RANKING,
           ROW_NUMBER() OVER (
               PARTITION BY s.TK_ID 
               ORDER BY s.POINTS DESC, s.WINS DESC, s.TEAM_NAME
           ) AS rn
    FROM v_tournament_standings s
) x
WHERE x.rn = 1;


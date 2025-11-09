-- Get count of all objects at once
SELECT 
    (SELECT COUNT(*) FROM information_schema.VIEWS WHERE TABLE_SCHEMA = 'gaming_tournament_db') as Views,
    (SELECT COUNT(*) FROM information_schema.ROUTINES WHERE ROUTINE_SCHEMA = 'gaming_tournament_db' AND ROUTINE_TYPE = 'PROCEDURE') as Procedures,
    (SELECT COUNT(*) FROM information_schema.ROUTINES WHERE ROUTINE_SCHEMA = 'gaming_tournament_db' AND ROUTINE_TYPE = 'FUNCTION') as Functions,
    (SELECT COUNT(*) FROM information_schema.TRIGGERS WHERE TRIGGER_SCHEMA = 'gaming_tournament_db') as Triggers;

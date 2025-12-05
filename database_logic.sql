USE f1_project;

SET SQL_SAFE_UPDATES = 0;
DELETE FROM circuits;
INSERT INTO circuits (circuitId, circuitRef, name, location, country, url) VALUES 
(1, 'albert_park', 'Albert Park Grand Prix Circuit', 'Melbourne', 'Australia', 'http://en.wikipedia.org/wiki/Melbourne'),
(2, 'sepang', 'Sepang International Circuit', 'Kuala Lumpur', 'Malaysia', 'http://en.wikipedia.org/wiki/Sepang'),
(3, 'bahrain', 'Bahrain International Circuit', 'Sakhir', 'Bahrain', 'http://en.wikipedia.org/wiki/Bahrain'),
(4, 'catalunya', 'Circuit de Barcelona-Catalunya', 'Montmeló', 'Spain', 'http://en.wikipedia.org/wiki/Catalunya'),
(5, 'istanbul', 'Istanbul Park', 'Istanbul', 'Turkey', 'http://en.wikipedia.org/wiki/Istanbul');
SET SQL_SAFE_UPDATES = 1;

ALTER TABLE results
ADD CONSTRAINT fk_results_races
FOREIGN KEY (raceId) REFERENCES races(raceId);

ALTER TABLE results
ADD CONSTRAINT fk_results_drivers
FOREIGN KEY (driverId) REFERENCES drivers(driverId);

ALTER TABLE results
ADD CONSTRAINT fk_results_constructors
FOREIGN KEY (constructorId) REFERENCES constructors(constructorId);

ALTER TABLE races
ADD CONSTRAINT fk_races_circuits
FOREIGN KEY (circuitId) REFERENCES circuits(circuitId);

CREATE OR REPLACE VIEW vw_race_details AS
SELECT 
    r.year AS season,
    r.name AS race_name,
    r.date AS race_date,
    c.name AS circuit_name,
    d.forename AS driver_name,
    d.surname AS driver_surname,
    d.code AS driver_code,
    con.name AS team_name,
    res.grid AS start_pos,
    res.positionOrder AS finish_pos,
    res.points,
    res.laps,
    res.fastestLapTime
FROM results res
JOIN races r ON res.raceId = r.raceId
JOIN drivers d ON res.driverId = d.driverId
JOIN constructors con ON res.constructorId = con.constructorId
JOIN circuits c ON r.circuitId = c.circuitId;

CREATE OR REPLACE VIEW vw_team_stats AS
SELECT 
    r.year,
    con.name AS team,
    COUNT(*) AS total_races,
    SUM(res.points) AS total_points,
    SUM(CASE WHEN res.positionOrder = 1 THEN 1 ELSE 0 END) AS wins
FROM results res
JOIN races r ON res.raceId = r.raceId
JOIN constructors con ON res.constructorId = con.constructorId
GROUP BY r.year, con.name;

CREATE OR REPLACE VIEW vw_grid_analysis AS
SELECT 
    r.year,
    r.name AS race_name,
    d.surname AS driver_surname,
    res.grid AS start_pos,
    res.positionOrder AS finish_pos
FROM results res
JOIN races r ON res.raceId = r.raceId
JOIN drivers d ON res.driverId = d.driverId;
JOIN results res ON ps.raceId = res.raceId AND ps.driverId = res.driverId
JOIN races r ON ps.raceId = r.raceId
JOIN drivers d ON ps.driverId = d.driverId;

*/

USE [ProFootballReference]
GO
/****** Object:  StoredProcedure [dbo].[ssp_ImportGameData]    Script Date: 8/28/2023 6:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ssp_ImportGameData] 
AS
BEGIN TRY
	IF OBJECT_ID('tempdb..#ImportStaging', 'U') IS NOT NULL
		DROP TABLE #ImportStaging

	CREATE TABLE #ImportStaging (
		 DataCount INT NULL,
		 HomeTeam VARCHAR(100) NULL,
		 AwayTeam VARCHAR(100) NULL,
		 Week VARCHAR(100) NULL,
		 Day VARCHAR(100) NULL,
		 Time VARCHAR(100) NULL,
		 [Date] VARCHAR(100) NULL,
		 Season VARCHAR(100) NULL,
		 HomeResult VARCHAR(100) NULL,
		 AwayResult VARCHAR(100) NULL, 
		 HomeRecord VARCHAR(100) NULL, 
		 AwayRecord VARCHAR(100) NULL,
		 HomeScore INT NULL, 
		 AwayScore INT NULL,
		 HomeOff1stD INT NULL,
		 HomeOffTotYd INT NULL,
		 HomeOffPassYd INT NULL,
		 HomeOffRushYd INT NULL,
		 HomeOffTO INT NULL,
		 HomeDef1stD INT NULL,
		 HomeDefTotYd INT NULL,
		 HomeDefPassYd INT NULL,
		 HomeDefRushYd INT NULL,
		 HomeDefTO INT NULL,
		 HomeExPointsOff DECIMAL(5,2) NULL,
		 HomeExPointsDef DECIMAL(5,2) NULL,
		 HomeExPointsSpecial DECIMAL(5,2) NULL,
		 AwayOff1stD INT NULL,
		 AwayOffTotYd INT NULL,
		 AwayOffPassYd INT NULL,
		 AwayOffRushYd INT NULL,
		 AwayOffTO INT NULL,
		 AwayDef1stD INT NULL,
		 AwayDefTotYd INT NULL,
		 AwayDefPassYd INT NULL,
		 AwayDefRushYd INT NULL,
		 AwayDefTO INT NULL,
		 AwayExPointsOff DECIMAL(5,2) NULL,
		 AwayExPointsDef DECIMAL(5,2) NULL,
		 AwayExPointsSpecial DECIMAL(5,2) NULL
	)

	/*Pre-Insert ETL*/
	PRINT('Begin ETL Operations')
	UPDATE g
	SET g.VisitorFlag = '@'
	FROM GameDataImport g
	JOIN (
		SELECT gamedataid, team, Record, opponent, season
		FROM GameDataImport
		WHERE Week = 'SuperBowl'
		) AS g2 ON g2.Team = g.Opponent
		AND g.Team = g2.Opponent
	WHERE Week = 'SuperBowl'
		AND (
			TRY_CAST(SUBSTRING(g2.Record, 0, 2) AS INT) > TRY_CAST(SUBSTRING(g.Record, 0, 2) AS INT)
			OR g2.GameDataId > g.GameDataId
			)

	UPDATE g
	SET g.VisitorFlag = '@'
	FROM GameDataImport g
	WHERE NOT EXISTS (Select * FROM GameDataImport g2 WHERE g2.Team = g.Opponent AND g2.Date = g.Date AND g2.Season = g.Season)
	AND g.Opponent <> 'Bye Week' AND g.Opponent <> '0'

	UPDATE GameDataImport SET Team = 'Tampa Bay Buccaneers' WHERE Team = 'Tampa Bay Bucanneers'
	UPDATE GameDataImport SET Team = 'Washington Commanders' WHERE Team LIKE 'Washington%'
	UPDATE GameDataImport SET Team = 'Las Vegas Raiders' WHERE Team LIKE '%Raiders'
	UPDATE GameDataImport SET Team = 'Los Angeles Chargers' WHERE Team LIKE '%Chargers'
	UPDATE GameDataImport SET Team = 'Los Angeles Rams' WHERE Team LIKE '%Rams'
	PRINT('End ETL Operations')
	/*End Pre-Insert ETL*/

	INSERT INTO #ImportStaging
	(
		 HomeTeam,
		 AwayTeam,
		 Week,
		 Day,
		 Time,
		 [Date],
		 Season,
		 HomeResult,
		 AwayResult, 
		 HomeRecord, 
		 AwayRecord,
		 HomeScore, 
		 AwayScore,
		 HomeOff1stD,
		 HomeOffTotYd,
		 HomeOffPassYd,
		 HomeOffRushYd,
		 HomeOffTO,
		 HomeDef1stD,
		 HomeDefTotYd,
		 HomeDefPassYd,
		 HomeDefRushYd,
		 HomeDefTO,
		 HomeExPointsOff,
		 HomeExPointsDef,
		 HomeExPointsSpecial,
		 AwayOff1stD,
		 AwayOffTotYd,
		 AwayOffPassYd,
		 AwayOffRushYd,
		 AwayOffTO,
		 AwayDef1stD,
		 AwayDefTotYd,
		 AwayDefPassYd,
		 AwayDefRushYd,
		 AwayDefTO,
		 AwayExPointsOff,
		 AwayExPointsDef,
		 AwayExPointsSpecial
	)
	SELECT DISTINCT 
	CASE WHEN g.VisitorFlag = '@'
		 THEN g.Opponent
		 ELSE g.Team
		 END AS HomeTeam, 
	CASE WHEN g.VisitorFlag = '@'
		 THEN g.Team
		 ELSE g.Opponent
		 END AS AwayTeam,
	g.Week,
	g.Day,
	g.Time,
	g.[Date],
	g.Season,
	CASE WHEN g.VisitorFlag = '@'
		 THEN g2.Result
		 ELSE g.Result
		 END AS HomeResult, 
	CASE WHEN g.VisitorFlag = '@'
		 THEN g.Result
		 ELSE g2.Result
		 END AS AwayResult, 
	CASE WHEN g.VisitorFlag = '@'
		 THEN g2.Record
		 ELSE g.Record
		 END AS HomeRecord, 
	CASE WHEN g.VisitorFlag = '@'
		 THEN g.Record
		 ELSE g2.Record
		 END AS AwayRecord, 
	CASE WHEN g.VisitorFlag = '@'
		 THEN g.OpponentScore
		 ELSE g.TeamScore
		 END AS HomeScore, 
	CASE WHEN g.VisitorFlag = '@'
		 THEN g.TeamScore
		 ELSE g.OpponentScore
		 END AS AwayScore,
	CASE WHEN g.VisitorFlag = '@'
		 THEN g2.Off1stD
		 ELSE g.Off1stD
		 END AS HomeOff1stD,
	CASE WHEN g.VisitorFlag = '@'
		 THEN g2.OffTotYd
		 ELSE g.OffTotYd
		 END AS HomeOffTotYd,
	CASE WHEN g.VisitorFlag = '@'
		 THEN g2.OffPassYd
		 ELSE g.OffPassYd
		 END AS HomeOffPassYd,
	CASE WHEN g.VisitorFlag = '@'
		 THEN g2.OffRushYd
		 ELSE g.OffRushYd
		 END AS HomeOffRushYd,
	CASE WHEN g.VisitorFlag = '@'
		 THEN g2.OffTO
		 ELSE g.OffTO
		 END AS HomeOffTO,
	CASE WHEN g.VisitorFlag = '@'
		 THEN g2.Def1stD
		 ELSE g.Def1stD
		 END AS HomeDef1stD,
	CASE WHEN g.VisitorFlag = '@'
		 THEN g2.DefTotYd
		 ELSE g.DefTotYd
		 END AS HomeDefTotYd,
	CASE WHEN g.VisitorFlag = '@'
		 THEN g2.DefPassYd
		 ELSE g.DefPassYd
		 END AS HomeDefPassYd,
	CASE WHEN g.VisitorFlag = '@'
		 THEN g2.DefRushYd
		 ELSE g.DefRushYd
		 END AS HomeDefRushYd,
	CASE WHEN g.VisitorFlag = '@'
		 THEN g2.DefTO
		 ELSE g.DefTO
		 END AS HomeDefTO,
	CASE WHEN g.VisitorFlag = '@'
		 THEN g2.ExPointsOff
		 ELSE g.ExPointsOff
		 END AS HomeExPointsOff,
	CASE WHEN g.VisitorFlag = '@'
		 THEN g2.ExPointsDef
		 ELSE g.ExPointsDef
		 END AS HomeExPointsDef,
	CASE WHEN g.VisitorFlag = '@'
		 THEN g2.ExPointsSpecial
		 ELSE g.ExPointsSpecial
		 END AS HomeExPointsSpecial,
	CASE WHEN g.VisitorFlag = '@'
		 THEN g.Off1stD
		 ELSE g2.Off1stD
		 END AS AwayOff1stD,
	CASE WHEN g.VisitorFlag = '@'
		 THEN g.OffTotYd
		 ELSE g2.OffTotYd
		 END AS AwayOffTotYd,
	CASE WHEN g.VisitorFlag = '@'
		 THEN g.OffPassYd
		 ELSE g2.OffPassYd
		 END AS AwayOffPassYd,
	CASE WHEN g.VisitorFlag = '@'
		 THEN g.OffRushYd
		 ELSE g2.OffRushYd
		 END AS AwayOffRushYd,
	CASE WHEN g.VisitorFlag = '@'
		 THEN g.OffTO
		 ELSE g2.OffTO
		 END AS AwayOffTO,
	CASE WHEN g.VisitorFlag = '@'
		 THEN g.Def1stD
		 ELSE g2.Def1stD
		 END AS AwayDef1stD,
	CASE WHEN g.VisitorFlag = '@'
		 THEN g.DefTotYd
		 ELSE g2.DefTotYd
		 END AS AwayDefTotYd,
	CASE WHEN g.VisitorFlag = '@'
		 THEN g.DefPassYd
		 ELSE g2.DefPassYd
		 END AS AwayDefPassYd,
	CASE WHEN g.VisitorFlag = '@'
		 THEN g.DefRushYd
		 ELSE g2.DefRushYd
		 END AS AwayDefRushYd,
	CASE WHEN g.VisitorFlag = '@'
		 THEN g.DefTO
		 ELSE g2.DefTO
		 END AS AwayDefTO,
	CASE WHEN g.VisitorFlag = '@'
		 THEN g.ExPointsOff
		 ELSE g2.ExPointsOff
		 END AS AwayExPointsOff,
	CASE WHEN g.VisitorFlag = '@'
		 THEN g.ExPointsDef
		 ELSE g2.ExPointsDef
		 END AS AwayExPointsDef,
	CASE WHEN g.VisitorFlag = '@'
		 THEN g.ExPointsSpecial
		 ELSE g2.ExPointsSpecial
		 END AS AwayExPointsSpecial
	FROM GameDataImport g
	INNER JOIN (SELECT DISTINCT 
				 g.Team
				,g.Opponent
				,g.Week
				,g.Day
				,g.Time
				,g.[Date]
				,g.Season
				,g.Result
				,g.OT
				,g.Record
				,g.VisitorFlag
				,g.TeamScore
				,g.OpponentScore
				,g.Off1stD
				,g.OffTotYd
				,g.OffPassYd
				,g.OffRushYd
				,g.OffTO
				,g.Def1stD
				,g.DefTotYd
				,g.DefPassYd
				,g.DefRushYd
				,g.DefTO
				,g.ExPointsOff
				,g.ExPointsDef
				,g.ExPointsSpecial
				FROM GameDataImport g
				WHERE g.Off1stD <> 'Canceled'
				) as g2 ON g.Team = g2.Opponent AND g2.Team = g.Opponent AND g2.Week = g.Week AND g2.Season = g.Season
	WHERE g.Off1stD <> 'Canceled'
	UNION ALL
	SELECT DISTINCT 
	CASE WHEN g.VisitorFlag = '@'
		 THEN g.Opponent
		 ELSE g.Team
		 END AS HomeTeam, 
	CASE WHEN g.VisitorFlag = '@'
		 THEN g.Team
		 ELSE g.Opponent
		 END AS AwayTeam,
	g.Week,
	g.Day,
	g.Time,
	g.[Date],
	g.Season,
	CASE WHEN g.VisitorFlag = '@'
		 THEN NULL
		 ELSE g.Result
		 END AS HomeResult, 
	CASE WHEN g.VisitorFlag = '@'
		 THEN g.Result
		 ELSE NULL
		 END AS AwayResult, 
	CASE WHEN g.VisitorFlag = '@'
		 THEN NULL
		 ELSE g.Record
		 END AS HomeRecord, 
	CASE WHEN g.VisitorFlag = '@'
		 THEN g.Record
		 ELSE NULL
		 END AS AwayRecord, 
	CASE WHEN g.VisitorFlag = '@'
		 THEN g.OpponentScore
		 ELSE g.TeamScore
		 END AS HomeScore, 
	CASE WHEN g.VisitorFlag = '@'
		 THEN g.TeamScore
		 ELSE g.OpponentScore
		 END AS AwayScore,
	CASE WHEN g.VisitorFlag = '@'
		 THEN NULL
		 ELSE g.Off1stD
		 END AS HomeOff1stD,
	CASE WHEN g.VisitorFlag = '@'
		 THEN NULL
		 ELSE g.OffTotYd
		 END AS HomeOffTotYd,
	CASE WHEN g.VisitorFlag = '@'
		 THEN NULL
		 ELSE g.OffPassYd
		 END AS HomeOffPassYd,
	CASE WHEN g.VisitorFlag = '@'
		 THEN NULL
		 ELSE g.OffRushYd
		 END AS HomeOffRushYd,
	CASE WHEN g.VisitorFlag = '@'
		 THEN NULL
		 ELSE g.OffTO
		 END AS HomeOffTO,
	CASE WHEN g.VisitorFlag = '@'
		 THEN NULL
		 ELSE g.Def1stD
		 END AS HomeDef1stD,
	CASE WHEN g.VisitorFlag = '@'
		 THEN NULL
		 ELSE g.DefTotYd
		 END AS HomeDefTotYd,
	CASE WHEN g.VisitorFlag = '@'
		 THEN NULL
		 ELSE g.DefPassYd
		 END AS HomeDefPassYd,
	CASE WHEN g.VisitorFlag = '@'
		 THEN NULL
		 ELSE g.DefRushYd
		 END AS HomeDefRushYd,
	CASE WHEN g.VisitorFlag = '@'
		 THEN NULL
		 ELSE g.DefTO
		 END AS HomeDefTO,
	CASE WHEN g.VisitorFlag = '@'
		 THEN NULL
		 ELSE g.ExPointsOff
		 END AS HomeExPointsOff,
	CASE WHEN g.VisitorFlag = '@'
		 THEN NULL
		 ELSE g.ExPointsDef
		 END AS HomeExPointsDef,
	CASE WHEN g.VisitorFlag = '@'
		 THEN NULL
		 ELSE g.ExPointsSpecial
		 END AS HomeExPointsSpecial,
	CASE WHEN g.VisitorFlag = '@'
		 THEN g.Off1stD
		 ELSE NULL
		 END AS AwayOff1stD,
	CASE WHEN g.VisitorFlag = '@'
		 THEN g.OffTotYd
		 ELSE NULL
		 END AS AwayOffTotYd,
	CASE WHEN g.VisitorFlag = '@'
		 THEN g.OffPassYd
		 ELSE NULL
		 END AS AwayOffPassYd,
	CASE WHEN g.VisitorFlag = '@'
		 THEN g.OffRushYd
		 ELSE NULL
		 END AS AwayOffRushYd,
	CASE WHEN g.VisitorFlag = '@'
		 THEN g.OffTO
		 ELSE NULL
		 END AS AwayOffTO,
	CASE WHEN g.VisitorFlag = '@'
		 THEN g.Def1stD
		 ELSE NULL
		 END AS AwayDef1stD,
	CASE WHEN g.VisitorFlag = '@'
		 THEN g.DefTotYd
		 ELSE NULL
		 END AS AwayDefTotYd,
	CASE WHEN g.VisitorFlag = '@'
		 THEN g.DefPassYd
		 ELSE NULL
		 END AS AwayDefPassYd,
	CASE WHEN g.VisitorFlag = '@'
		 THEN g.DefRushYd
		 ELSE NULL
		 END AS AwayDefRushYd,
	CASE WHEN g.VisitorFlag = '@'
		 THEN g.DefTO
		 ELSE NULL
		 END AS AwayDefTO,
	CASE WHEN g.VisitorFlag = '@'
		 THEN g.ExPointsOff
		 ELSE NULL
		 END AS AwayExPointsOff,
	CASE WHEN g.VisitorFlag = '@'
		 THEN g.ExPointsDef
		 ELSE NULL
		 END AS AwayExPointsDef,
	CASE WHEN g.VisitorFlag = '@'
		 THEN g.ExPointsSpecial
		 ELSE NULL
		 END AS AwayExPointsSpecial
	FROM GameDataImport g
	WHERE NOT EXISTS (Select * FROM #ImportStaging g2 WHERE ((g2.AwayTeam = g.Team AND g2.HomeTeam = g.Opponent) OR (g2.HomeTeam = g.Team AND g2.AwayTeam = g.Opponent)) AND g2.Date = g.Date AND g2.Season = g.Season)
	AND g.Opponent <> 'Bye Week' AND g.Opponent <> '0' AND g.Off1stD <> 'Canceled'
	ORDER BY g.Season ASC,Week ASC, Date ASC, HomeTeam, AwayTeam

	/*Beginning data completeness calculations*/
	UPDATE #ImportStaging SET DataCount = 0 WHERE 1=1
	UPDATE #ImportStaging SET DataCount = DataCount + 1 WHERE HomeTeam IS NOT NULL
	UPDATE #ImportStaging SET DataCount = DataCount + 1 WHERE AwayTeam IS NOT NULL
	UPDATE #ImportStaging SET DataCount = DataCount + 1 WHERE Week IS NOT NULL
	UPDATE #ImportStaging SET DataCount = DataCount + 1 WHERE Day IS NOT NULL
	UPDATE #ImportStaging SET DataCount = DataCount + 1 WHERE Time IS NOT NULL
	UPDATE #ImportStaging SET DataCount = DataCount + 1 WHERE Date IS NOT NULL
	UPDATE #ImportStaging SET DataCount = DataCount + 1 WHERE Season IS NOT NULL
	UPDATE #ImportStaging SET DataCount = DataCount + 1 WHERE HomeResult IS NOT NULL
	UPDATE #ImportStaging SET DataCount = DataCount + 1 WHERE AwayResult IS NOT NULL
	UPDATE #ImportStaging SET DataCount = DataCount + 1 WHERE HomeRecord IS NOT NULL
	UPDATE #ImportStaging SET DataCount = DataCount + 1 WHERE AwayRecord IS NOT NULL
	UPDATE #ImportStaging SET DataCount = DataCount + 1 WHERE HomeOff1stD IS NOT NULL
	UPDATE #ImportStaging SET DataCount = DataCount + 1 WHERE HomeOffTotYd IS NOT NULL
	UPDATE #ImportStaging SET DataCount = DataCount + 1 WHERE HomeOffPassYd IS NOT NULL
	UPDATE #ImportStaging SET DataCount = DataCount + 1 WHERE HomeOffRushYd IS NOT NULL
	UPDATE #ImportStaging SET DataCount = DataCount + 1 WHERE HomeOffTO IS NOT NULL
	UPDATE #ImportStaging SET DataCount = DataCount + 1 WHERE HomeDef1stD IS NOT NULL
	UPDATE #ImportStaging SET DataCount = DataCount + 1 WHERE HomeDefTotYd IS NOT NULL
	UPDATE #ImportStaging SET DataCount = DataCount + 1 WHERE HomeDefPassYd IS NOT NULL
	UPDATE #ImportStaging SET DataCount = DataCount + 1 WHERE HomeDefRushYd IS NOT NULL
	UPDATE #ImportStaging SET DataCount = DataCount + 1 WHERE HomeDefTO IS NOT NULL
	UPDATE #ImportStaging SET DataCount = DataCount + 1 WHERE HomeExPointsOff IS NOT NULL
	UPDATE #ImportStaging SET DataCount = DataCount + 1 WHERE HomeExPointsDef IS NOT NULL
	UPDATE #ImportStaging SET DataCount = DataCount + 1 WHERE HomeExPointsSpecial IS NOT NULL
	UPDATE #ImportStaging SET DataCount = DataCount + 1 WHERE AwayOff1stD IS NOT NULL
	UPDATE #ImportStaging SET DataCount = DataCount + 1 WHERE AwayOffTotYd IS NOT NULL
	UPDATE #ImportStaging SET DataCount = DataCount + 1 WHERE AwayOffPassYd IS NOT NULL
	UPDATE #ImportStaging SET DataCount = DataCount + 1 WHERE AwayOffRushYd IS NOT NULL
	UPDATE #ImportStaging SET DataCount = DataCount + 1 WHERE AwayOffTO IS NOT NULL
	UPDATE #ImportStaging SET DataCount = DataCount + 1 WHERE AwayDef1stD IS NOT NULL
	UPDATE #ImportStaging SET DataCount = DataCount + 1 WHERE AwayDefTotYd IS NOT NULL
	UPDATE #ImportStaging SET DataCount = DataCount + 1 WHERE AwayDefPassYd IS NOT NULL
	UPDATE #ImportStaging SET DataCount = DataCount + 1 WHERE AwayDefRushYd IS NOT NULL
	UPDATE #ImportStaging SET DataCount = DataCount + 1 WHERE AwayDefTO IS NOT NULL
	UPDATE #ImportStaging SET DataCount = DataCount + 1 WHERE AwayExPointsOff IS NOT NULL
	UPDATE #ImportStaging SET DataCount = DataCount + 1 WHERE AwayExPointsDef IS NOT NULL
	UPDATE #ImportStaging SET DataCount = DataCount + 1 WHERE AwayExPointsSpecial IS NOT NULL

	/*Date Updates and Parsing*/
	UPDATE #ImportStaging SET Date = REPLACE(Date,'January','01/')
	UPDATE #ImportStaging SET Date = REPLACE(Date,'February','02/')
	UPDATE #ImportStaging SET Date = REPLACE(Date,'March','03/')
	UPDATE #ImportStaging SET Date = REPLACE(Date,'April','04/')
	UPDATE #ImportStaging SET Date = REPLACE(Date,'May','05/')
	UPDATE #ImportStaging SET Date = REPLACE(Date,'June','06/')
	UPDATE #ImportStaging SET Date = REPLACE(Date,'July','07/')
	UPDATE #ImportStaging SET Date = REPLACE(Date,'August','08/')
	UPDATE #ImportStaging SET Date = REPLACE(Date,'September','09/')
	UPDATE #ImportStaging SET Date = REPLACE(Date,'October','10/')
	UPDATE #ImportStaging SET Date = REPLACE(Date,'November','11/')
	UPDATE #ImportStaging SET Date = REPLACE(Date,'December','12/')

	UPDATE #ImportStaging SET Date = CONCAT(Date,'/',Season+1)
	WHERE SUBSTRING(Date,1,2) < 4 AND SUBSTRING(Date,1,3) NOT IN ('10/','11/','12/') --First 3 months

	UPDATE #ImportStaging SET Date = CONCAT(Date,'/',Season)
	WHERE TRY_CAST(SUBSTRING(Date,1,2) as INT) > 4 --First 3 months

	UPDATE #ImportStaging SET Date = REPLACE(Date,' ','')

	/*Clean up any missing stats as best we can*/
	UPDATE #ImportStaging SET HomeResult = 'W' WHERE AwayResult = 'L' and HomeResult IS NULL AND AwayResult IS NOT NULL
	UPDATE #ImportStaging SET HomeOff1stD = AwayDef1stD WHERE HomeOff1stD IS NULL AND AwayDef1stD IS NOT NULL
	UPDATE #ImportStaging SET HomeOffTotYd = AwayDefTotYd WHERE HomeOffTotYd IS NULL AND AwayDefTotYd IS NOT NULL
	UPDATE #ImportStaging SET HomeOffPassYd = AwayDefPassYd WHERE HomeOffPassYd IS NULL AND AwayDefPassYd IS NOT NULL
	UPDATE #ImportStaging SET HomeOffRushYd = AwayDefRushYd WHERE HomeOffRushYd IS NULL AND AwayDefRushYd IS NOT NULL
	UPDATE #ImportStaging SET HomeOffTo = AwayDefTO WHERE HomeOffTO IS NULL AND AwayDefTO IS NOT NULL
	UPDATE #ImportStaging SET HomeOffTo = AwayDefTO WHERE HomeOffTO IS NULL AND AwayDefTO IS NOT NULL
	UPDATE #ImportStaging SET HomeDef1stD = AwayOff1stD WHERE HomeDef1stD IS NULL AND AwayOff1stD IS NOT NULL
	UPDATE #ImportStaging SET HomeDefTotYd = AwayOffTotYd WHERE HomeDefTotYd IS NULL AND AwayOffTotYd IS NOT NULL
	UPDATE #ImportStaging SET HomeDefPassYd = AwayOffPassYd WHERE HomeDefPassYd IS NULL AND AwayOffPassYd IS NOT NULL
	UPDATE #ImportStaging SET HomeDefRushYd = AwayOffRushYd WHERE HomeDefRushYd IS NULL AND AwayOffRushYd IS NOT NULL
	UPDATE #ImportStaging SET HomeDefTO = AwayOffTO WHERE HomeDefTO IS NULL AND AwayOffTO IS NOT NULL
	UPDATE #ImportStaging SET HomeExPointsOff = AwayExPointsDef*-1 WHERE HomeExPointsOff IS NULL AND AwayExPointsDef IS NOT NULL
	UPDATE #ImportStaging SET HomeExPointsDef = AwayExPointsOff*-1 WHERE HomeExPointsDef IS NULL AND AwayExPointsOff IS NOT NULL
	UPDATE #ImportStaging SET HomeExPointsSpecial = AwayExPointsSpecial*-1 WHERE HomeExPointsSpecial IS NULL AND AwayExPointsSpecial IS NOT NULL
	UPDATE #ImportStaging SET AwayResult = 'W' WHERE HomeResult = 'L' and HomeResult IS NULL AND AwayResult IS NOT NULL
	UPDATE #ImportStaging SET AwayOff1stD = HomeDef1stD WHERE AwayOff1stD IS NULL AND HomeDef1stD IS NOT NULL
	UPDATE #ImportStaging SET AwayOffTotYd = HomeDefTotYd WHERE AwayOffTotYd IS NULL AND HomeDefTotYd IS NOT NULL
	UPDATE #ImportStaging SET AwayOffPassYd = HomeDefPassYd WHERE AwayOffPassYd IS NULL AND HomeDefPassYd IS NOT NULL
	UPDATE #ImportStaging SET AwayOffRushYd = HomeDefRushYd WHERE AwayOffRushYd IS NULL AND HomeDefRushYd IS NOT NULL
	UPDATE #ImportStaging SET AwayOffTo = HomeDefTO WHERE AwayOffTO IS NULL AND HomeDefTO IS NOT NULL
	UPDATE #ImportStaging SET AwayOffTo = HomeDefTO WHERE AwayOffTO IS NULL AND HomeDefTO IS NOT NULL
	UPDATE #ImportStaging SET AwayDef1stD = HomeOff1stD WHERE AwayDef1stD IS NULL AND HomeOff1stD IS NOT NULL
	UPDATE #ImportStaging SET AwayDefTotYd = HomeOffTotYd WHERE AwayDefTotYd IS NULL AND HomeOffTotYd IS NOT NULL
	UPDATE #ImportStaging SET AwayDefPassYd = HomeOffPassYd WHERE AwayDefPassYd IS NULL AND HomeOffPassYd IS NOT NULL
	UPDATE #ImportStaging SET AwayDefRushYd = HomeOffRushYd WHERE AwayDefRushYd IS NULL AND HomeOffRushYd IS NOT NULL
	UPDATE #ImportStaging SET AwayDefTO = HomeOffTO WHERE AwayDefTO IS NULL AND HomeOffTO IS NOT NULL
	UPDATE #ImportStaging SET AwayExPointsOff = HomeExPointsDef*-1 WHERE AwayExPointsOff IS NULL AND HomeExPointsDef IS NOT NULL
	UPDATE #ImportStaging SET AwayExPointsDef = HomeExPointsOff*-1 WHERE AwayExPointsDef IS NULL AND HomeExPointsOff IS NOT NULL
	UPDATE #ImportStaging SET AwayExPointsSpecial = HomeExPointsSpecial*-1 WHERE AwayExPointsSpecial IS NULL AND HomeExPointsSpecial IS NOT NULL

	/*Data completeness calculations*/
	UPDATE #ImportStaging SET DataCount = 0 WHERE 1=1
	UPDATE #ImportStaging SET DataCount = DataCount + 1 WHERE HomeTeam IS NOT NULL
	UPDATE #ImportStaging SET DataCount = DataCount + 1 WHERE AwayTeam IS NOT NULL
	UPDATE #ImportStaging SET DataCount = DataCount + 1 WHERE Week IS NOT NULL
	UPDATE #ImportStaging SET DataCount = DataCount + 1 WHERE Day IS NOT NULL
	UPDATE #ImportStaging SET DataCount = DataCount + 1 WHERE Time IS NOT NULL
	UPDATE #ImportStaging SET DataCount = DataCount + 1 WHERE Date IS NOT NULL
	UPDATE #ImportStaging SET DataCount = DataCount + 1 WHERE Season IS NOT NULL
	UPDATE #ImportStaging SET DataCount = DataCount + 1 WHERE HomeResult IS NOT NULL
	UPDATE #ImportStaging SET DataCount = DataCount + 1 WHERE AwayResult IS NOT NULL
	UPDATE #ImportStaging SET DataCount = DataCount + 1 WHERE HomeRecord IS NOT NULL
	UPDATE #ImportStaging SET DataCount = DataCount + 1 WHERE AwayRecord IS NOT NULL
	UPDATE #ImportStaging SET DataCount = DataCount + 1 WHERE HomeOff1stD IS NOT NULL
	UPDATE #ImportStaging SET DataCount = DataCount + 1 WHERE HomeOffTotYd IS NOT NULL
	UPDATE #ImportStaging SET DataCount = DataCount + 1 WHERE HomeOffPassYd IS NOT NULL
	UPDATE #ImportStaging SET DataCount = DataCount + 1 WHERE HomeOffRushYd IS NOT NULL
	UPDATE #ImportStaging SET DataCount = DataCount + 1 WHERE HomeOffTO IS NOT NULL
	UPDATE #ImportStaging SET DataCount = DataCount + 1 WHERE HomeDef1stD IS NOT NULL
	UPDATE #ImportStaging SET DataCount = DataCount + 1 WHERE HomeDefTotYd IS NOT NULL
	UPDATE #ImportStaging SET DataCount = DataCount + 1 WHERE HomeDefPassYd IS NOT NULL
	UPDATE #ImportStaging SET DataCount = DataCount + 1 WHERE HomeDefRushYd IS NOT NULL
	UPDATE #ImportStaging SET DataCount = DataCount + 1 WHERE HomeDefTO IS NOT NULL
	UPDATE #ImportStaging SET DataCount = DataCount + 1 WHERE HomeExPointsOff IS NOT NULL
	UPDATE #ImportStaging SET DataCount = DataCount + 1 WHERE HomeExPointsDef IS NOT NULL
	UPDATE #ImportStaging SET DataCount = DataCount + 1 WHERE HomeExPointsSpecial IS NOT NULL
	UPDATE #ImportStaging SET DataCount = DataCount + 1 WHERE AwayOff1stD IS NOT NULL
	UPDATE #ImportStaging SET DataCount = DataCount + 1 WHERE AwayOffTotYd IS NOT NULL
	UPDATE #ImportStaging SET DataCount = DataCount + 1 WHERE AwayOffPassYd IS NOT NULL
	UPDATE #ImportStaging SET DataCount = DataCount + 1 WHERE AwayOffRushYd IS NOT NULL
	UPDATE #ImportStaging SET DataCount = DataCount + 1 WHERE AwayOffTO IS NOT NULL
	UPDATE #ImportStaging SET DataCount = DataCount + 1 WHERE AwayDef1stD IS NOT NULL
	UPDATE #ImportStaging SET DataCount = DataCount + 1 WHERE AwayDefTotYd IS NOT NULL
	UPDATE #ImportStaging SET DataCount = DataCount + 1 WHERE AwayDefPassYd IS NOT NULL
	UPDATE #ImportStaging SET DataCount = DataCount + 1 WHERE AwayDefRushYd IS NOT NULL
	UPDATE #ImportStaging SET DataCount = DataCount + 1 WHERE AwayDefTO IS NOT NULL
	UPDATE #ImportStaging SET DataCount = DataCount + 1 WHERE AwayExPointsOff IS NOT NULL
	UPDATE #ImportStaging SET DataCount = DataCount + 1 WHERE AwayExPointsDef IS NOT NULL
	UPDATE #ImportStaging SET DataCount = DataCount + 1 WHERE AwayExPointsSpecial IS NOT NULL


	INSERT INTO [dbo].[GameData]
           ([HomeTeam]
           ,[AwayTeam]
           ,[Week]
           ,[Day]
           ,[Time]
           ,[Date]
           ,[Season]
           ,[HomeResult]
           ,[AwayResult]
           ,[HomeRecord]
           ,[AwayRecord]
           ,[HomeScore]
           ,[AwayScore]
           ,[HomeOff1stD]
           ,[HomeOffTotYd]
           ,[HomeOffPassYd]
           ,[HomeOffRushYd]
           ,[HomeOffTO]
           ,[HomeDef1stD]
           ,[HomeDefTotYd]
           ,[HomeDefPassYd]
           ,[HomeDefRushYd]
           ,[HomeDefTO]
           ,[HomeExPointsOff]
           ,[HomeExPointsDef]
           ,[HomeExPointsSpecial]
           ,[AwayOff1stD]
           ,[AwayOffTotYd]
           ,[AwayOffPassYd]
           ,[AwayOffRushYd]
           ,[AwayOffTO]
           ,[AwayDef1stD]
           ,[AwayDefTotYd]
           ,[AwayDefPassYd]
           ,[AwayDefRushYd]
           ,[AwayDefTO]
           ,[AwayExPointsOff]
           ,[AwayExPointsDef]
           ,[AwayExPointsSpecial])
	SELECT
			ist.[HomeTeam]
           ,ist.[AwayTeam]
           ,ist.[Week]
           ,ist.[Day]
           ,ist.[Time]
           ,TRY_CAST(ist.[Date] AS DATE)
           ,ist.[Season]
           ,ist.[HomeResult]
           ,ist.[AwayResult]
           ,ist.[HomeRecord]
           ,ist.[AwayRecord]
           ,ist.[HomeScore]
           ,ist.[AwayScore]
           ,ist.[HomeOff1stD]
           ,ist.[HomeOffTotYd]
           ,ist.[HomeOffPassYd]
           ,ist.[HomeOffRushYd]
           ,ist.[HomeOffTO]
           ,ist.[HomeDef1stD]
           ,ist.[HomeDefTotYd]
           ,ist.[HomeDefPassYd]
           ,ist.[HomeDefRushYd]
           ,ist.[HomeDefTO]
           ,ist.[HomeExPointsOff]
           ,ist.[HomeExPointsDef]
           ,ist.[HomeExPointsSpecial]
           ,ist.[AwayOff1stD]
           ,ist.[AwayOffTotYd]
           ,ist.[AwayOffPassYd]
           ,ist.[AwayOffRushYd]
           ,ist.[AwayOffTO]
           ,ist.[AwayDef1stD]
           ,ist.[AwayDefTotYd]
           ,ist.[AwayDefPassYd]
           ,ist.[AwayDefRushYd]
           ,ist.[AwayDefTO]
           ,ist.[AwayExPointsOff]
           ,ist.[AwayExPointsDef]
           ,ist.[AwayExPointsSpecial]
	FROM #ImportStaging AS ist
	LEFT JOIN (  SELECT
			MAX(ISNULL([DataCount],0)) as DataCountMax
		   ,[HomeTeam]
           ,[AwayTeam]
           ,[Week]
           ,[Season]
		   FROM #ImportStaging
		   GROUP BY
		   [HomeTeam]
           ,[AwayTeam]
           ,[Week]
           ,[Season]) is2 ON (is2.HomeTeam = ist.AwayTeam OR ist.HomeTeam = is2.AwayTeam) AND ist.Week = is2.Week AND ist.Season = is2.Season
   UNION ALL
   SELECT
			ist.[HomeTeam]
           ,ist.[AwayTeam]
           ,ist.[Week]
           ,ist.[Day]
           ,ist.[Time]
           ,TRY_CAST(ist.[Date] AS DATE)
           ,ist.[Season]
           ,ist.[HomeResult]
           ,ist.[AwayResult]
           ,ist.[HomeRecord]
           ,ist.[AwayRecord]
           ,ist.[HomeScore]
           ,ist.[AwayScore]
           ,ist.[HomeOff1stD]
           ,ist.[HomeOffTotYd]
           ,ist.[HomeOffPassYd]
           ,ist.[HomeOffRushYd]
           ,ist.[HomeOffTO]
           ,ist.[HomeDef1stD]
           ,ist.[HomeDefTotYd]
           ,ist.[HomeDefPassYd]
           ,ist.[HomeDefRushYd]
           ,ist.[HomeDefTO]
           ,ist.[HomeExPointsOff]
           ,ist.[HomeExPointsDef]
           ,ist.[HomeExPointsSpecial]
           ,ist.[AwayOff1stD]
           ,ist.[AwayOffTotYd]
           ,ist.[AwayOffPassYd]
           ,ist.[AwayOffRushYd]
           ,ist.[AwayOffTO]
           ,ist.[AwayDef1stD]
           ,ist.[AwayDefTotYd]
           ,ist.[AwayDefPassYd]
           ,ist.[AwayDefRushYd]
           ,ist.[AwayDefTO]
           ,ist.[AwayExPointsOff]
           ,ist.[AwayExPointsDef]
           ,ist.[AwayExPointsSpecial]
	FROM #ImportStaging AS ist
    WHERE NOT EXISTS (Select 1 FROM #ImportStaging is2 
					  WHERE ist.HomeTeam = is2.HomeTeam 
					  AND ist.AwayTeam = is2.AwayTeam 
					  AND ist.Date = is2.Date 
					  AND ist.Season = is2.Season) --all rows that don't have a complement
	TRUNCATE TABLE #ImportStaging

	DROP TABLE #ImportStaging
	
END TRY
BEGIN CATCH
	SELECT ERROR_LINE(), ERROR_MESSAGE(), ERROR_NUMBER(), ERROR_PROCEDURE(), ERROR_SEVERITY(), ERROR_STATE()
END CATCH

GO

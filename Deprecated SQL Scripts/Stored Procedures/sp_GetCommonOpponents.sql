IF OBJECT_ID('ssp_GetCommonOpponents','P') IS NOT NULL
	DROP PROCEDURE ssp_GetCommonOpponents
	GO

CREATE PROCEDURE ssp_GetCommonOpponents @Team VARCHAR(25), @Opponent VARCHAR(25), @Season VARCHAR(4)
AS
BEGIN TRY
	IF @Season IS NULL
		SET @Season = 2023

	IF @Team IS NULL
		PRINT 'Away Team Parameter is null'

	IF @Opponent IS NULL
		PRINT 'Home Team Parameter is null'

	IF OBJECT_ID('tempdb..#TeamMatchups', 'U') IS NOT NULL
		DROP TABLE #TeamMatchups

	CREATE TABLE #TeamMatchups (HomeTeam VARCHAR(35), AwayTeam VARCHAR(35), [Date] Date, HomeResult VARCHAR(1), AwayResult VARCHAR(1), HomeScore INT, AwayScore INT)

	IF OBJECT_ID('tempdb..#OppMatchups', 'U') IS NOT NULL
		DROP TABLE #OppMatchups

	CREATE TABLE #OppMatchups (HomeTeam VARCHAR(35), AwayTeam VARCHAR(35), [Date] Date, HomeResult VARCHAR(1), AwayResult VARCHAR(1), HomeScore INT, AwayScore INT)

	INSERT INTO #TeamMatchups (HomeTeam, AwayTeam, [Date], HomeResult, AwayResult, HomeScore, AwayScore)
	SELECT DISTINCT 
	 HomeTeam 
	,AwayTeam
	,[Date]
	,HomeResult
	,AwayResult
	,gd.AwayScore
	,gd.HomeScore
	FROM GameData gd
	WHERE (gd.HomeTeam = @Team or gd.AwayTeam = @Team)
	AND gd.season = @Season
	AND (gd.HomeScore IS NOT NULL AND gd.AwayScore IS NOT NULL)
	AND (gd.HomeResult IS NOT NULL AND gd.AwayResult IS NOT NULL)
	ORDER BY [Date]

	INSERT INTO #OppMatchups (HomeTeam, AwayTeam, [Date], HomeResult, AwayResult, HomeScore, AwayScore)
	SELECT DISTINCT 
	 HomeTeam 
	,AwayTeam
	,[Date]
	,HomeResult
	,AwayResult
	,gd.AwayScore
	,gd.HomeScore
	FROM GameData gd
	WHERE (gd.HomeTeam = @Opponent or gd.AwayTeam = @Opponent)
	AND gd.season = @Season
	AND (gd.HomeScore IS NOT NULL AND gd.AwayScore IS NOT NULL)
	AND (gd.HomeResult IS NOT NULL AND gd.AwayResult IS NOT NULL)
	ORDER BY [Date]


	UPDATE #OppMatchups SET AwayResult = 'L' WHERE HomeResult = 'W' AND AwayResult IS NULL
	UPDATE #OppMatchups SET HomeResult = 'L' WHERE AwayResult = 'W' AND HomeResult IS NULL
	UPDATE #OppMatchups SET AwayResult = 'W' WHERE HomeResult = 'L' AND AwayResult IS NULL
	UPDATE #OppMatchups SET HomeResult = 'W' WHERE AwayResult = 'L' AND HomeResult IS NULL

	UPDATE #TeamMatchups SET AwayResult = 'L' WHERE HomeResult = 'W' AND AwayResult IS NULL
	UPDATE #TeamMatchups SET HomeResult = 'L' WHERE AwayResult = 'W' AND HomeResult IS NULL
	UPDATE #TeamMatchups SET AwayResult = 'W' WHERE HomeResult = 'L' AND AwayResult IS NULL
	UPDATE #TeamMatchups SET HomeResult = 'W' WHERE AwayResult = 'L' AND HomeResult IS NULL

	--select * from #OppMatchups
	--ORDER BY Date ASC

	--select * from #TeamMatchups
	--ORDER BY Date ASC
	--WARNING! ERRORS ENCOUNTERED DURING SQL PARSING!
SELECT *
FROM #OppMatchups o
WHERE 
		((o.AwayTeam <> @Opponent
		AND (
			o.AwayTeam IN (
				SELECT HomeTeam
				FROM #TeamMatchups
				WHERE HomeTeam <> @Opponent
				)
			OR o.AwayTeam IN (
				SELECT AwayTeam
				FROM #TeamMatchups
				WHERE AwayTeam <> @Opponent
				)
			))
	OR (
		o.HomeTeam <> @Opponent
		AND (
			o.HomeTeam IN (
				SELECT HomeTeam
				FROM #TeamMatchups
				WHERE HomeTeam <> @Opponent
				)
			OR o.HomeTeam IN (
				SELECT AwayTeam
				FROM #TeamMatchups
				WHERE AwayTeam <> @Opponent
				)
			)
			))
	AND (
			(
			o.HomeTeam <> @Team
			)
		AND (
			o.AwayTeam <> @Team
			)
		)
	



	--SELECT DISTINCT *
	--FROM #TeamMatchups t
	--WHERE EXISTS (Select 1 FROM #OppMatchups o where ((CASE WHEN t.AwayTeam = @Team  THEN t.HomeTeam 
	--													  WHEN t.HomeTeam = @Team THEN t.AwayTeam END = o.HomeTeam)
	--											OR (CASE WHEN t.AwayTeam = @Team  THEN t.HomeTeam 
	--													  WHEN t.HomeTeam = @Team THEN t.AwayTeam END = o.AwayTeam)))
	--AND t.HomeScore IS NOT NULL AND t.AwayScore IS NOT NULL
	--ORDER BY t.Date ASC

END TRY
BEGIN CATCH

END CATCH
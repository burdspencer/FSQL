IF OBJECT_ID('ssp_GetCommonOpponents','P') IS NOT NULL
	DROP PROCEDURE ssp_GetCommonOpponents
	GO

CREATE PROCEDURE ssp_GetCommonOpponents @Team VARCHAR(25), @Opponent VARCHAR(25), @Season VARCHAR(4) = NULL, @Date Date = NULL

AS
BEGIN TRY
	IF @Season IS NULL
		SET @Season = 2023

	IF @Team IS NULL
		PRINT 'Team Parameter is null'

	IF @Opponent IS NULL
		PRINT 'Opponent Parameter is null'

	IF OBJECT_ID('tempdb..#TeamMatchups', 'U') IS NOT NULL
		DROP TABLE #TeamMatchups

	CREATE TABLE #TeamMatchups (HomeTeam VARCHAR(35), AwayTeam VARCHAR(35), [Date] Date, HomeResult VARCHAR(1), AwayResult VARCHAR(1), HomeScore INT, AwayScore INT)

	IF OBJECT_ID('tempdb..#OppMatchups', 'U') IS NOT NULL
		DROP TABLE #OppMatchups

	CREATE TABLE #OppMatchups (
	[HomeTeam] [varchar](35), 
	[AwayTeam] [varchar](35), 
	[Date] [date], 
	[HomeResult] [varchar](1), 
	[AwayResult] [varchar](1),
	[HomeRecord] [varchar](100) NULL,
	[AwayRecord] [varchar](100) NULL,
	[HomeScore] [int] NOT NULL,
	[AwayScore] [int] NOT NULL,
	[HomeOff1stD] [int] NULL,
	[HomeOffTotYd] [int] NULL,
	[HomeOffPassYd] [int] NULL,
	[HomeOffRushYd] [int] NULL,
	[HomeOffTO] [int] NULL,
	[HomeDef1stD] [int] NULL,
	[HomeDefTotYd] [int] NULL,
	[HomeDefPassYd] [int] NULL,
	[HomeDefRushYd] [int] NULL,
	[HomeDefTO] [int] NULL,
	[HomeExPointsOff] [decimal](5, 2) NULL,
	[HomeExPointsDef] [decimal](5, 2) NULL,
	[HomeExPointsSpecial] [decimal](5, 2) NULL,
	[AwayOff1stD] [int] NULL,
	[AwayOffTotYd] [int] NULL,
	[AwayOffPassYd] [int] NULL,
	[AwayOffRushYd] [int] NULL,
	[AwayOffTO] [int] NULL,
	[AwayDef1stD] [int] NULL,
	[AwayDefTotYd] [int] NULL,
	[AwayDefPassYd] [int] NULL,
	[AwayDefRushYd] [int] NULL,
	[AwayDefTO] [int] NULL,
	[AwayExPointsOff] [decimal](5, 2) NULL,
	[AwayExPointsDef] [decimal](5, 2) NULL,
	[AwayExPointsSpecial] [decimal](5, 2) NULL)

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
	AND (gd.season = @Season OR @Season is NULL)
	AND (gd.HomeScore IS NOT NULL AND gd.AwayScore IS NOT NULL)
	AND (gd.HomeResult IS NOT NULL AND gd.AwayResult IS NOT NULL)
	AND (gd.Date <= @Date OR @Date IS NULL)
	ORDER BY [Date]
	 
	INSERT INTO #OppMatchups ([HomeTeam],[AwayTeam],[Date],[HomeResult],[AwayResult],[HomeScore],[AwayScore],[HomeOff1stD],[HomeOffTotYd],
	[HomeOffPassYd],[HomeOffRushYd],[HomeOffTO],[HomeDef1stD],[HomeDefTotYd],[HomeDefPassYd],[HomeDefRushYd],[HomeDefTO],[HomeExPointsOff],[HomeExPointsDef],[HomeExPointsSpecial],
	[AwayOff1stD],[AwayOffTotYd],[AwayOffPassYd],[AwayOffRushYd],[AwayOffTO],[AwayDef1stD],[AwayDefTotYd],[AwayDefPassYd],[AwayDefRushYd],[AwayDefTO],[AwayExPointsOff],[AwayExPointsDef],
	[AwayExPointsSpecial])
	SELECT DISTINCT 
	 gd.HomeTeam 
	,gd.AwayTeam
	,gd.[Date]
	,gd.HomeResult
	,gd.AwayResult
	,gd.AwayScore
	,gd.HomeScore
	,gd.HomeOff1stD
	,gd.HomeOffTotYd
	,gd.HomeOffPassYd
	,gd.HomeOffRushYd
	,gd.HomeOffTO
	,gd.HomeDef1stD
	,gd.HomeDefTotYd
	,gd.HomeDefPassYd
	,gd.HomeDefRushYd
	,gd.HomeDefTO
	,gd.HomeExPointsOff
	,gd.HomeExPointsDef
	,gd.HomeExPointsSpecial
	,gd.AwayOff1stD
	,gd.AwayOffTotYd
	,gd.AwayOffPassYd
	,gd.AwayOffRushYd
	,gd.AwayOffTO
	,gd.AwayDef1stD
	,gd.AwayDefTotYd
	,gd.AwayDefPassYd
	,gd.AwayDefRushYd
	,gd.AwayDefTO
	,gd.AwayExPointsOff
	,gd.AwayExPointsDef
	,gd.AwayExPointsSpecial
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

SELECT HomeTeam
	 , AwayTeam
	 , [Date]
	 , CASE WHEN HomeTeam = @Opponent THEN AwayResult WHEN AwayTeam = @Opponent THEN HomeResult END AS Result
	 , CASE WHEN HomeTeam = @Opponent THEN HomeScore		   ELSE AwayScore			END AS ParamOpponentScore
	 , CASE WHEN HomeTeam = @Opponent THEN AwayScore		   ELSE HomeScore			END AS OppScore
	 , CASE WHEN HomeTeam = @Opponent THEN HomeOff1stD		   ELSE AwayOff1stD			END AS TeamOff1stD
	 , CASE WHEN HomeTeam = @Opponent THEN HomeOffTotYd		   ELSE AwayOffTotYd		END AS TeamOffTotYd
	 , CASE WHEN HomeTeam = @Opponent THEN HomeOffPassYd	   ELSE AwayOffPassYd		END as TeamOffPassYd
	 , CASE WHEN HomeTeam = @Opponent THEN HomeOffRushYd	   ELSE AwayOffRushYd		END AS TeamOffRushYd
	 , CASE WHEN HomeTeam = @Opponent THEN HomeOffTO		   ELSE AwayOffTO			END AS TeamOffTO
	 , CASE WHEN HomeTeam = @Opponent THEN HomeDef1stD		   ELSE AwayDef1stD			END AS TeamDef1stD
	 , CASE WHEN HomeTeam = @Opponent THEN HomeDefTotYd		   ELSE AwayDefTotYd		END AS TeamDefTotYd
	 , CASE WHEN HomeTeam = @Opponent THEN HomeDefPassYd	   ELSE AwayDefPassYd		END AS TeamDefPassYd
	 , CASE WHEN HomeTeam = @Opponent THEN HomeDefRushYd	   ELSE AwayDefRushYd		END AS TeamDefRushYd
	 , CASE WHEN HomeTeam = @Opponent THEN HomeDefTO		   ELSE AwayDefTO			END AS TeamDefTO
	 , CASE WHEN HomeTeam = @Opponent THEN HomeExPointsOff	   ELSE AwayExPointsOff		END AS TeamExPointsOff
	 , CASE WHEN HomeTeam = @Opponent THEN HomeExPointsDef	   ELSE AwayExPointsDef		END AS TeamExPointsDef
	 , CASE WHEN HomeTeam = @Opponent THEN HomeExPointsSpecial ELSE AwayExPointsSpecial END AS TeamExPointsSpecial
	 , CASE WHEN HomeTeam = @Opponent THEN AwayOff1stD		   ELSE HomeOff1stD			END AS OppOff1stD
	 , CASE WHEN HomeTeam = @Opponent THEN AwayOffTotYd		   ELSE HomeOffTotYd		END AS OppOffTotYd
	 , CASE WHEN HomeTeam = @Opponent THEN AwayOffPassYd	   ELSE HomeOffPassYd		END as OppOffPassYd
	 , CASE WHEN HomeTeam = @Opponent THEN AwayOffRushYd	   ELSE HomeOffRushYd		END AS OppOffRushYd
	 , CASE WHEN HomeTeam = @Opponent THEN AwayOffTO		   ELSE HomeOffTO			END AS OppOffTO
	 , CASE WHEN HomeTeam = @Opponent THEN AwayDef1stD		   ELSE HomeDef1stD			END AS OppDef1stD
	 , CASE WHEN HomeTeam = @Opponent THEN AwayDefTotYd		   ELSE HomeDefTotYd		END AS OppDefTotYd
	 , CASE WHEN HomeTeam = @Opponent THEN AwayDefPassYd	   ELSE HomeDefPassYd		END AS OppDefPassYd
	 , CASE WHEN HomeTeam = @Opponent THEN AwayDefRushYd	   ELSE HomeDefRushYd		END AS OppDefRushYd
	 , CASE WHEN HomeTeam = @Opponent THEN AwayDefTO		   ELSE HomeDefTO			END AS OppDefTO
	 , CASE WHEN HomeTeam = @Opponent THEN AwayExPointsOff	   ELSE HomeExPointsOff		END AS OppExPointsOff
	 , CASE WHEN HomeTeam = @Opponent THEN AwayExPointsDef	   ELSE HomeExPointsDef		END AS OppExPointsDef
	 , CASE WHEN HomeTeam = @Opponent THEN AwayExPointsSpecial ELSE HomeExPointsSpecial END AS OppExPointsSpecial
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
	AND ( --Don't include matchups against @Team -- This may be a future feature
			(
			o.HomeTeam <> @Team
			)
		AND (
			o.AwayTeam <> @Team
			)
		)
ORDER BY Date ASC
END TRY
BEGIN CATCH
	SELECT ERROR_MESSAGE(), ERROR_LINE(), ERROR_PROCEDURE()
END CATCH
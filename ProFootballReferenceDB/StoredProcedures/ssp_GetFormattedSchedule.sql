IF OBJECT_ID('ssp_GetFormattedSchedule','P') IS NOT NULL
	DROP PROCEDURE ssp_GetFormattedSchedule
	GO

CREATE PROCEDURE ssp_GetFormattedSchedule @Team VARCHAR(25), @Season VARCHAR(4)
AS
BEGIN TRY
	IF @Season IS NULL
		SET @Season = 2023

	IF @Team IS NULL
		PRINT 'Team Parameter is null'

	IF OBJECT_ID('tempdb..#TeamMatchups', 'U') IS NOT NULL
		DROP TABLE #TeamMatchups

	CREATE TABLE #TeamMatchups (HomeTeam VARCHAR(35), AwayTeam VARCHAR(35), [Date] Date, HomeResult VARCHAR(1), AwayResult VARCHAR(1), HomeScore INT, AwayScore INT)

	IF OBJECT_ID('tempdb..#OppMatchups', 'U') IS NOT NULL
		DROP TABLE #OppMatchups

	CREATE TABLE #OppMatchups (
	[Team] [varchar](35), 
	[Opponent] [varchar](35), 
	[Date] [date], 
	[TeamResult] [varchar](1), 
	[OppResult] [varchar](1),
	[TeamRecord] [varchar](100) NULL,
	[OppRecord] [varchar](100) NULL,
	[TeamScore] [int] NOT NULL,
	[OppScore] [int] NOT NULL,
	[TeamOff1stD] [int] NULL,
	[TeamOffTotYd] [int] NULL,
	[TeamOffPassYd] [int] NULL,
	[TeamOffRushYd] [int] NULL,
	[TeamOffTO] [int] NULL,
	[TeamDef1stD] [int] NULL,
	[TeamDefTotYd] [int] NULL,
	[TeamDefPassYd] [int] NULL,
	[TeamDefRushYd] [int] NULL,
	[TeamDefTO] [int] NULL,
	[TeamExPointsOff] [decimal](5, 2) NULL,
	[TeamExPointsDef] [decimal](5, 2) NULL,
	[TeamExPointsSpecial] [decimal](5, 2) NULL,
	[OppOff1stD] [int] NULL,
	[OppOffTotYd] [int] NULL,
	[OppOffPassYd] [int] NULL,
	[OppOffRushYd] [int] NULL,
	[OppOffTO] [int] NULL,
	[OppDef1stD] [int] NULL,
	[OppDefTotYd] [int] NULL,
	[OppDefPassYd] [int] NULL,
	[OppDefRushYd] [int] NULL,
	[OppDefTO] [int] NULL,
	[OppExPointsOff] [decimal](5, 2) NULL,
	[OppExPointsDef] [decimal](5, 2) NULL,
	[OppExPointsSpecial] [decimal](5, 2) NULL)

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


	UPDATE #TeamMatchups SET AwayResult = 'L' WHERE HomeResult = 'W' AND AwayResult IS NULL
	UPDATE #TeamMatchups SET HomeResult = 'L' WHERE AwayResult = 'W' AND HomeResult IS NULL
	UPDATE #TeamMatchups SET AwayResult = 'W' WHERE HomeResult = 'L' AND AwayResult IS NULL
	UPDATE #TeamMatchups SET HomeResult = 'W' WHERE AwayResult = 'L' AND HomeResult IS NULL

SELECT HomeTeam
	 , AwayTeam
	 , [Date]
	 , CASE WHEN HomeTeam <> @Team THEN AwayResult ELSE HomeResult END AS Result
	 , CASE WHEN HomeTeam =  @Team THEN HomeScore		   ELSE AwayScore			END AS Team
	 , CASE WHEN HomeTeam =  @Team THEN AwayScore		   ELSE HomeScore			END AS OppScore
	 , CASE WHEN HomeTeam =  @Team THEN HomeOff1stD		   ELSE AwayOff1stD			END AS TeamOff1stD
	 , CASE WHEN HomeTeam =  @Team THEN HomeOffTotYd	   ELSE AwayOffTotYd		END AS TeamOffTotYd
	 , CASE WHEN HomeTeam =  @Team THEN HomeOffPassYd	   ELSE AwayOffPassYd		END as TeamOffPassYd
	 , CASE WHEN HomeTeam =  @Team THEN HomeOffRushYd	   ELSE AwayOffRushYd		END AS TeamOffRushYd
	 , CASE WHEN HomeTeam =  @Team THEN HomeOffTO		   ELSE AwayOffTO			END AS TeamOffTO
	 , CASE WHEN HomeTeam =  @Team THEN HomeDef1stD		   ELSE AwayDef1stD			END AS TeamDef1stD
	 , CASE WHEN HomeTeam =  @Team THEN HomeDefTotYd	   ELSE AwayDefTotYd		END AS TeamDefTotYd
	 , CASE WHEN HomeTeam =  @Team THEN HomeDefPassYd	   ELSE AwayDefPassYd		END AS TeamDefPassYd
	 , CASE WHEN HomeTeam =  @Team THEN HomeDefRushYd	   ELSE AwayDefRushYd		END AS TeamDefRushYd
	 , CASE WHEN HomeTeam =  @Team THEN HomeDefTO		   ELSE AwayDefTO			END AS TeamDefTO
	 , CASE WHEN HomeTeam =  @Team THEN HomeExPointsOff	   ELSE AwayExPointsOff		END AS TeamExPointsOff
	 , CASE WHEN HomeTeam =  @Team THEN HomeExPointsDef	   ELSE AwayExPointsDef		END AS TeamExPointsDef
	 , CASE WHEN HomeTeam =  @Team THEN HomeExPointsSpecial ELSE AwayExPointsSpecial END AS TeamExPointsSpecial
	 , CASE WHEN HomeTeam =  @Team THEN AwayOff1stD		   ELSE HomeOff1stD			END AS OppOff1stD
	 , CASE WHEN HomeTeam =  @Team THEN AwayOffTotYd	   ELSE HomeOffTotYd		END AS OppOffTotYd
	 , CASE WHEN HomeTeam =  @Team THEN AwayOffPassYd	   ELSE HomeOffPassYd		END as OppOffPassYd
	 , CASE WHEN HomeTeam =  @Team THEN AwayOffRushYd	   ELSE HomeOffRushYd		END AS OppOffRushYd
	 , CASE WHEN HomeTeam =  @Team THEN AwayOffTO		   ELSE HomeOffTO			END AS OppOffTO
	 , CASE WHEN HomeTeam =  @Team THEN AwayDef1stD		   ELSE HomeDef1stD			END AS OppDef1stD
	 , CASE WHEN HomeTeam =  @Team THEN AwayDefTotYd	   ELSE HomeDefTotYd		END AS OppDefTotYd
	 , CASE WHEN HomeTeam =  @Team THEN AwayDefPassYd	   ELSE HomeDefPassYd		END AS OppDefPassYd
	 , CASE WHEN HomeTeam =  @Team THEN AwayDefRushYd	   ELSE HomeDefRushYd		END AS OppDefRushYd
	 , CASE WHEN HomeTeam =  @Team THEN AwayDefTO		   ELSE HomeDefTO			END AS OppDefTO
	 , CASE WHEN HomeTeam =  @Team THEN AwayExPointsOff	   ELSE HomeExPointsOff		END AS OppExPointsOff
	 , CASE WHEN HomeTeam =  @Team THEN AwayExPointsDef	   ELSE HomeExPointsDef		END AS OppExPointsDef
	 , CASE WHEN HomeTeam =  @Team THEN AwayExPointsSpecial ELSE HomeExPointsSpecial END AS OppExPointsSpecial
FROM GameData gd
WHERE (gd.HomeTeam = @Team or gd.AwayTeam = @Team)
	AND gd.season = @Season
	AND (gd.HomeScore IS NOT NULL AND gd.AwayScore IS NOT NULL)
	AND (gd.HomeResult IS NOT NULL AND gd.AwayResult IS NOT NULL)
ORDER BY Date ASC

END TRY
BEGIN CATCH
	SELECT ERROR_MESSAGE(), ERROR_LINE(), ERROR_PROCEDURE()
END CATCH
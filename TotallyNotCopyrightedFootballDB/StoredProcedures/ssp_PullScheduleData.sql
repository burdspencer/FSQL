IF OBJECT_ID('ssp_PullScheduleData','P') IS NOT NULL
	DROP PROCEDURE ssp_PullScheduleData
	GO

CREATE PROCEDURE ssp_PullScheduleData @Season VARCHAR(4) = NULL, @Week VARCHAR(25) = NULL
AS
BEGIN TRY
	SET ANSI_WARNINGS OFF;
	SET NOCOUNT ON;

	DECLARE @Team VARCHAR(50) = NULL

	IF @Week IS NULL
		SET @Week = 101 --Full Season = 101
	If @Season IS NULL
		SET @Season = 2022
	IF OBJECT_ID('tempdb..##tempGameData','U') IS NOT NULL
		DROP TABLE ##tempGameData

	CREATE TABLE ##tempGameData (
	HomeTeam					varchar(100),
	AwayTeam					varchar(100),
	Week						varchar(20),
	Season						int,
	HomeScore					int,
	AwayScore					int,
	Result						varchar(100),
	AvgPointsFor				int,
	AvgPointsAgainst			int,
	AvgOff1stD					int,
	AvgOffTotYd					int,
	AvgOffPassYd				int,
	AvgOffRushYd				int,
	AvgOffTO					int,
	AvgDef1stD					int,
	AvgDefTotYd					int,
	AvgDefPassYd				int,
	AvgDefRushYd				int,
	AvgDefTO					int,
	AvgExPointsOff				decimal(5,2),
	AvgExPointsDef				decimal(5,2),
	AvgExPointsSpecial			decimal(5,2),
	LastPointsFor				int,
	LastPointsAgainst			int,
	LastOff1stD					int,
	LastOffTotYd				int,
	LastOffPassYd				int,
	LastOffRushYd				int,
	LastOffTO					int,
	LastDef1stD					int,
	LastDefTotYd				int,
	LastDefPassYd				int,
	LastDefRushYd				int,
	LastDefTO					int,
	LastExPointsOff				decimal(5,2),
	LastExPointsDef				decimal(5,2),
	LastExPointsSpecial			decimal(5,2),
	HomeOddsOpen				decimal(5,2),
	HomeOddsMin					decimal(5,2),
	HomeOddsMax					decimal(5,2),
	HomeOddsClose				decimal(5,2),
	AwayOddsOpen				decimal(5,2),
	AwayOddsMin					decimal(5,2),
	AwayOddsMax					decimal(5,2),
	AwayOddsClose				decimal(5,2),
	HomeLineOpen				decimal(5,2),
	HomeLineMin					decimal(5,2),
	HomeLineMax					decimal(5,2),
	HomeLineClose				decimal(5,2),
	AwayLineOpen				decimal(5,2),
	AwayLineMin					decimal(5,2),
	AwayLineMax					decimal(5,2),
	AwayLineClose				decimal(5,2),
	HomeLineOddsOpen			decimal(5,2),
	HomeLineOddsMin				decimal(5,2),
	HomeLineOddsMax				decimal(5,2),
	HomeLineOddsClose			decimal(5,2),
	AwayLineOddsOpen			decimal(5,2),
	AwayLineOddsMin				decimal(5,2),
	AwayLineOddsMax				decimal(5,2),
	AwayLineOddsClose			decimal(5,2),
	TotalScoreOpen				decimal(5,2),
	TotalScoreMin				decimal(5,2),
	TotalScoreMax				decimal(5,2),
	TotalScoreClose				decimal(5,2),
	TotalScoreOverOpen			decimal(5,2),
	TotalScoreOverMin			decimal(5,2),
	TotalScoreOverMax			decimal(5,2),
	TotalScoreOverClose			decimal(5,2),
	TotalScoreUnderOpen			decimal(5,2),
	TotalScoreUnderMin			decimal(5,2),
	TotalScoreUnderMax			decimal(5,2),
	TotalScoreUnderClose		decimal(5,2)
	);


	DECLARE team_cursor CURSOR
    FOR 
	SELECT DISTINCT HomeTeam
	FROM GameData ;

	OPEN team_cursor
	FETCH NEXT FROM team_cursor into @Team

	WHILE @@FETCH_STATUS = 0
		BEGIN
			INSERT INTO ##tempGameData (
			 HomeTeam
			,AwayTeam
			,Week
			,Season
			,HomeScore
			,AwayScore
			,Result
			,AvgPointsFor
			,AvgPointsAgainst
			,AvgOff1stD
			,AvgOffTotYd
			,AvgOffPassYd
			,AvgOffRushYd	
			,AvgOffTO			
			,AvgDef1stD			
			,AvgDefTotYd		
			,AvgDefPassYd		
			,AvgDefRushYd		
			,AvgDefTO			
			,AvgExPointsOff		
			,AvgExPointsDef		
			,AvgExPointsSpecial
			,LastPointsFor
			,LastPointsAgainst
			,LastOff1stD
			,LastOffTotYd
			,LastOffPassYd
			,LastOffRushYd	
			,LastOffTO			
			,LastDef1stD			
			,LastDefTotYd		
			,LastDefPassYd		
			,LastDefRushYd		
			,LastDefTO			
			,LastExPointsOff		
			,LastExPointsDef		
			,LastExPointsSpecial
			,HomeOddsOpen
			,HomeOddsMin
			,HomeOddsMax
			,HomeOddsClose
			,AwayOddsOpen
			,AwayOddsMin
			,AwayOddsMax
			,AwayOddsClose
			,HomeLineOpen
			,HomeLineMin
			,HomeLineMax
			,HomeLineClose
			,AwayLineOpen
			,AwayLineMin
			,AwayLineMax
			,AwayLineClose
			,HomeLineOddsOpen
			,HomeLineOddsMin
			,HomeLineOddsMax
			,HomeLineOddsClose
			,AwayLineOddsOpen
			,AwayLineOddsMin
			,AwayLineOddsMax
			,AwayLineOddsClose
			,TotalScoreOpen
			,TotalScoreMin
			,TotalScoreMax
			,TotalScoreClose
			,TotalScoreOverOpen
			,TotalScoreOverMin
			,TotalScoreOverMax
			,TotalScoreOverClose
			,TotalScoreUnderOpen
			,TotalScoreUnderMin
			,TotalScoreUnderMax
			,TotalScoreUnderClose
			)
			SELECT DISTINCT gd.HomeTeam
				 , gd.AwayTeam
				 , gd.Week
				 , gd.Season
				 , gd.HomeScore
				 , gd.AwayScore
				 , CASE WHEN HomeResult = 'W' THEN 'Home' WHEN AwayResult = 'W' THEN 'Away' ELSE 'Tie' END as Result
				 , AVG(ssf.AvgPointsFor) as AvgPointsFor
				 , AVG(ssf.AvgPointsAgainst) as AvgPointsAgainst
				 , AVG(ssf.AvgOff1stD) as AvgOff1stD
				 , AVG(ssf.AvgOffTotYd) as AvgOffTotYd
				 , AVG(ssf.AvgOffPassYd) as AvgOffPassYd
				 , AVG(ssf.AvgOffRushYd) as AvgOffRushYd
				 , AVG(ssf.AvgOffTO) as AvgOffTO
				 , AVG(ssf.AvgDef1stD) as AvgDef1stD
				 , AVG(ssf.AvgDefTotYd) as AvgDefTotYd
				 , AVG(ssf.AvgDefPassYd) as AvgDefPassYd
				 , AVG(ssf.AvgDefRushYd) as AvgDefRushYd
				 , AVG(ssf.AvgDefTO) as AvgDefTO
				 , AVG(ssf.AvgExPointsOff) as AvgExPointsOff
				 , AVG(ssf.AvgExPointsDef) as AvgExPointsDef
				 , AVG(ssf.AvgExPointsSpecial) as AvgExPointsSpecial
				 , SUM(ssf2.PointsFor) as LastPointsFor
				 , SUM(ssf2.PointsAgainst) as LastPointsAgainst
				 , SUM(ssf2.Off1stD) as LastOff1stD
				 , SUM(ssf2.OffTotYd) as LastOffTotYd
				 , SUM(ssf2.OffPassYd) as LastOffPassYd
				 , SUM(ssf2.OffRushYd) as LastOffRushYd
				 , SUM(ssf2.OffTO) as LastOffTO
				 , SUM(ssf2.Def1stD) as LastDef1stD
				 , SUM(ssf2.DefTotYd) as LastDefTotYd
				 , SUM(ssf2.DefPassYd) as LastDefPassYd
				 , SUM(ssf2.DefRushYd) as LastDefRushYd
				 , SUM(ssf2.DefTO) as LastDefTO
				 , SUM(ssf2.ExPointsOff) as LastExPointsOff
				 , SUM(ssf2.ExPointsDef) as LastExPointsDef
				 , SUM(ssf2.ExPointsSpecial) as LastExPointsSepcial
				 , gd.HomeOddsOpen
				 , gd.HomeOddsMin
				 , gd.HomeOddsMax
				 , gd.HomeOddsClose
				 , gd.AwayOddsOpen
				 , gd.AwayOddsMin
				 , gd.AwayOddsMax
				 , gd.AwayOddsClose
				 , gd.HomeLineOpen
				 , gd.HomeLineMin
				 , gd.HomeLineMax
				 , gd.HomeLineClose
				 , gd.AwayLineOpen
				 , gd.AwayLineMin
				 , gd.AwayLineMax
				 , gd.AwayLineClose
				 , gd.HomeLineOddsOpen
				 , gd.HomeLineOddsMin
				 , gd.HomeLineOddsMax
				 , gd.HomeLineOddsClose
				 , gd.AwayLineOddsOpen
				 , gd.AwayLineOddsMin
				 , gd.AwayLineOddsMax
				 , gd.AwayLineOddsClose
				 , gd.TotalScoreOpen
				 , gd.TotalScoreMin
				 , gd.TotalScoreMax
				 , gd.TotalScoreClose
				 , gd.TotalScoreOverOpen
				 , gd.TotalScoreOverMin
				 , gd.TotalScoreOverMax
				 , gd.TotalScoreOverClose
				 , gd.TotalScoreUnderOpen
				 , gd.TotalScoreUnderMin
				 , gd.TotalScoreUnderMax
				 , gd.TotalScoreUnderClose
			FROM GameData gd
			OUTER APPLY ssf_AggSeasonStatsUpTo(@Team, gd.Season, gd.Week) ssf
			OUTER APPLY ssf_LastGameStats(@Team, gd.Season, gd.Week) ssf2
			WHERE (gd.HomeTeam = @Team or gd.AwayTeam = @Team)
			AND	  (gd.Season = @Season)
			AND   (gd.Week < @Week)
			AND NOT EXISTS (SELECT 1 FROM ##tempGameData tgd WHERE tgd.HomeTeam = gd.HomeTeam AND tgd.AwayTeam = gd.AwayTeam and tgd.Week = gd.Week AND tgd.Season = gd.Season)
			GROUP BY gd.HomeTeam
				 , gd.AwayTeam
				 , gd.Week
				 , gd.Season
				 , gd.HomeScore
				 , gd.AwayScore
				 , CASE WHEN HomeResult = 'W' THEN 'Home' WHEN AwayResult = 'W' THEN 'Away' ELSE 'Tie' END
				 , gd.HomeOddsOpen
				 , gd.HomeOddsMin
				 , gd.HomeOddsMax
				 , gd.HomeOddsClose
				 , gd.AwayOddsOpen
				 , gd.AwayOddsMin
				 , gd.AwayOddsMax
				 , gd.AwayOddsClose
				 , gd.HomeLineOpen
				 , gd.HomeLineMin
				 , gd.HomeLineMax
				 , gd.HomeLineClose
				 , gd.AwayLineOpen
				 , gd.AwayLineMin
				 , gd.AwayLineMax
				 , gd.AwayLineClose
				 , gd.HomeLineOddsOpen
				 , gd.HomeLineOddsMin
				 , gd.HomeLineOddsMax
				 , gd.HomeLineOddsClose
				 , gd.AwayLineOddsOpen
				 , gd.AwayLineOddsMin
				 , gd.AwayLineOddsMax
				 , gd.AwayLineOddsClose
				 , gd.TotalScoreOpen
				 , gd.TotalScoreMin
				 , gd.TotalScoreMax
				 , gd.TotalScoreClose
				 , gd.TotalScoreOverOpen
				 , gd.TotalScoreOverMin
				 , gd.TotalScoreOverMax
				 , gd.TotalScoreOverClose
				 , gd.TotalScoreUnderOpen
				 , gd.TotalScoreUnderMin
				 , gd.TotalScoreUnderMax
				 , gd.TotalScoreUnderClose
			ORDER BY Week ASC, Season ASC
		FETCH NEXT FROM team_cursor INTO @Team;
	END
	
	CLOSE team_cursor;
	DEALLOCATE team_cursor;
	print('PSD - 311')
	SELECT * FROM ##tempGameData
	print('PSD - 313')
END TRY
BEGIN CATCH
	IF CURSOR_STATUS('global','team_cursor') <> -3
	BEGIN
		IF CURSOR_STATUS('global','team_cursor') <> -1
			CLOSE team_cursor;
		DEALLOCATE team_cursor;
	END
	SELECT ERROR_MESSAGE(), ERROR_LINE(), ERROR_PROCEDURE()
END CATCH
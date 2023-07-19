IF OBJECT_ID('ssp_ScheduleDataReport_Dev','P') IS NOT NULL
	DROP PROCEDURE ssp_ScheduleDataReport_Dev
	GO

CREATE PROCEDURE ssp_ScheduleDataReport_Dev
				 @ReportType CHAR(1) = 'N'
			,	 @OneUnitThreshold	DECIMAL(5,2) NULL
			,	 @FiveUnitThreshold DECIMAL(5,2) NULL
			,	 @TenUnitThreshold	DECIMAL(5,2) NULL
AS
BEGIN TRY
	SET NOCOUNT ON;
	DECLARE @Season INT
	DECLARE @TestCode INT = 0 --use 0 for no debug, 1 for basic debug, 2 for verbose debug (higher value = longer process time)

	DECLARE @tempGameDataFull GameDataTable

	IF OBJECT_ID('tempdb..#Years','U') IS NOT NULL
		DROP TABLE #Years

	CREATE TABLE #Years (
	Season			int
	);

	INSERT INTO #Years (Season) 
	VALUES
	 (2000)
	,(2001)
	,(2002)
	,(2003)
	,(2004)
	,(2005)
	,(2006)
	,(2007)
	,(2008)
	,(2009)
	,(2010)
	,(2011)
	,(2012)
	,(2013)
	,(2014)
	,(2015)
	,(2016)
	,(2017)
	,(2018)
	,(2019)
	,(2020)
	,(2021)
	,(2022)
	,(2023)


	DECLARE year_cur CURSOR
	FOR
	SELECT Season
	From #Years

	OPEN year_cur
	FETCH NEXT FROM year_cur into @Season

	WHILE @@FETCH_STATUS = 0
	BEGIN
	DECLARE @Team VARCHAR(50) = NULL
	DECLARE @Week INT = 101

	IF OBJECT_ID('tempdb..#tempGameData','U') IS NOT NULL
		DROP TABLE #tempGameData

	CREATE TABLE #tempGameData (
	HomeTeam					varchar(100),
	AwayTeam					varchar(100),
	Week						varchar(20),
	Season						int,
	HomeScore					int,
	AwayScore					int,
	Result						varchar(100),
	HomeAvgPointsFor			int,
	HomeAvgPointsAgainst		int,
	HomeAvgOff1stD				int,
	HomeAvgOffTotYd				int,
	HomeAvgOffPassYd			int,
	HomeAvgOffRushYd			int,
	HomeAvgOffTO				int,
	HomeAvgDef1stD				int,
	HomeAvgDefTotYd				int,
	HomeAvgDefPassYd			int,
	HomeAvgDefRushYd			int,
	HomeAvgDefTO				int,
	HomeAvgExPointsOff			decimal(5,2),
	HomeAvgExPointsDef			decimal(5,2),
	HomeAvgExPointsSpecial		decimal(5,2),
	HomeLastPointsFor			int,
	HomeLastPointsAgainst		int,
	HomeLastOff1stD				int,
	HomeLastOffTotYd			int,
	HomeLastOffPassYd			int,
	HomeLastOffRushYd			int,
	HomeLastOffTO				int,
	HomeLastDef1stD				int,
	HomeLastDefTotYd			int,
	HomeLastDefPassYd			int,
	HomeLastDefRushYd			int,
	HomeLastDefTO				int,
	HomeLastExPointsOff			decimal(5,2),
	HomeLastExPointsDef			decimal(5,2),
	HomeLastExPointsSpecial		decimal(5,2),
	AwayAvgPointsFor	   		int,
	AwayAvgPointsAgainst   		int,
	AwayAvgOff1stD		   		int,
	AwayAvgOffTotYd		   		int,
	AwayAvgOffPassYd	   		int,
	AwayAvgOffRushYd	   		int,
	AwayAvgOffTO		   		int,
	AwayAvgDef1stD		   		int,
	AwayAvgDefTotYd		   		int,
	AwayAvgDefPassYd	   		int,
	AwayAvgDefRushYd	   		int,
	AwayAvgDefTO		   		int,
	AwayAvgExPointsOff	   		decimal(5,2),
	AwayAvgExPointsDef	   		decimal(5,2),
	AwayAvgExPointsSpecial 		decimal(5,2),
	AwayLastPointsFor	   		int,
	AwayLastPointsAgainst  		int,
	AwayLastOff1stD		   		int,
	AwayLastOffTotYd	   		int,
	AwayLastOffPassYd	   		int,
	AwayLastOffRushYd	   		int,
	AwayLastOffTO		   		int,
	AwayLastDef1stD		   		int,
	AwayLastDefTotYd	   		int,
	AwayLastDefPassYd	   		int,
	AwayLastDefRushYd	   		int,
	AwayLastDefTO		   		int,
	AwayLastExPointsOff	   		decimal(5,2),
	AwayLastExPointsDef	   		decimal(5,2),
	AwayLastExPointsSpecial		decimal(5,2),
	HomeOddsOpen				decimal(5,2),
	HomeOddsMin					decimal(5,2),
	HomeOddsMax					decimal(5,2),
	HomeOddsClose   			decimal(5,2),
	AwayOddsOpen				decimal(5,2),
	AwayOddsMin					decimal(5,2),
	AwayOddsMax					decimal(5,2),
	AwayOddsClose   			decimal(5,2),
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
			INSERT INTO #tempGameData (
			 HomeTeam
			,AwayTeam
			,Week
			,Season
			,HomeScore
			,AwayScore
			,Result
			,HomeAvgPointsFor
			,HomeAvgPointsAgainst
			,HomeAvgOff1stD
			,HomeAvgOffTotYd
			,HomeAvgOffPassYd
			,HomeAvgOffRushYd	
			,HomeAvgOffTO			
			,HomeAvgDef1stD			
			,HomeAvgDefTotYd		
			,HomeAvgDefPassYd		
			,HomeAvgDefRushYd		
			,HomeAvgDefTO			
			,HomeAvgExPointsOff		
			,HomeAvgExPointsDef		
			,HomeAvgExPointsSpecial
			,HomeLastPointsFor
			,HomeLastPointsAgainst
			,HomeLastOff1stD
			,HomeLastOffTotYd
			,HomeLastOffPassYd
			,HomeLastOffRushYd	
			,HomeLastOffTO			
			,HomeLastDef1stD			
			,HomeLastDefTotYd		
			,HomeLastDefPassYd		
			,HomeLastDefRushYd		
			,HomeLastDefTO			
			,HomeLastExPointsOff		
			,HomeLastExPointsDef		
			,HomeLastExPointsSpecial
			,AwayAvgPointsFor
			,AwayAvgPointsAgainst
			,AwayAvgOff1stD
			,AwayAvgOffTotYd
			,AwayAvgOffPassYd
			,AwayAvgOffRushYd	
			,AwayAvgOffTO			
			,AwayAvgDef1stD			
			,AwayAvgDefTotYd		
			,AwayAvgDefPassYd		
			,AwayAvgDefRushYd		
			,AwayAvgDefTO			
			,AwayAvgExPointsOff		
			,AwayAvgExPointsDef		
			,AwayAvgExPointsSpecial
			,AwayLastPointsFor
			,AwayLastPointsAgainst
			,AwayLastOff1stD
			,AwayLastOffTotYd
			,AwayLastOffPassYd
			,AwayLastOffRushYd	
			,AwayLastOffTO			
			,AwayLastDef1stD			
			,AwayLastDefTotYd		
			,AwayLastDefPassYd		
			,AwayLastDefRushYd		
			,AwayLastDefTO			
			,AwayLastExPointsOff		
			,AwayLastExPointsDef		
			,AwayLastExPointsSpecial
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
				 , AVG(COALESCE(ssfHome.AvgPointsFor,0))		as HomeAvgPointsFor
				 , AVG(COALESCE(ssfHome.AvgPointsAgainst,0))	as HomeAvgPointsAgainst
				 , AVG(COALESCE(ssfHome.AvgOff1stD,0))			as HomeAvgOff1stD
				 , AVG(COALESCE(ssfHome.AvgOffTotYd,0))			as HomeAvgOffTotYd
				 , AVG(COALESCE(ssfHome.AvgOffPassYd,0))		as HomeAvgOffPassYd
				 , AVG(COALESCE(ssfHome.AvgOffRushYd,0))		as HomeAvgOffRushYd
				 , AVG(COALESCE(ssfHome.AvgOffTO,0))			as HomeAvgOffTO
				 , AVG(COALESCE(ssfHome.AvgDef1stD,0))			as HomeAvgDef1stD
				 , AVG(COALESCE(ssfHome.AvgDefTotYd,0))			as HomeAvgDefTotYd
				 , AVG(COALESCE(ssfHome.AvgDefPassYd,0))		as HomeAvgDefPassYd
				 , AVG(COALESCE(ssfHome.AvgDefRushYd,0))		as HomeAvgDefRushYd
				 , AVG(COALESCE(ssfHome.AvgDefTO,0))			as HomeAvgDefTO
				 , AVG(COALESCE(ssfHome.AvgExPointsOff,0))		as HomeAvgExPointsOff
				 , AVG(COALESCE(ssfHome.AvgExPointsDef,0))		as HomeAvgExPointsDef
				 , AVG(COALESCE(ssfHome.AvgExPointsSpecial,0))	as HomeAvgExPointsSpecial
				 , SUM(COALESCE(ssf2Home.PointsFor,0))			as HomeLastPointsFor
				 , SUM(COALESCE(ssf2Home.PointsAgainst,0))		as HomeLastPointsAgainst
				 , SUM(COALESCE(ssf2Home.Off1stD,0))			as HomeLastOff1stD
				 , SUM(COALESCE(ssf2Home.OffTotYd,0))			as HomeLastOffTotYd
				 , SUM(COALESCE(ssf2Home.OffPassYd,0))			as HomeLastOffPassYd
				 , SUM(COALESCE(ssf2Home.OffRushYd,0))			as HomeLastOffRushYd
				 , SUM(COALESCE(ssf2Home.OffTO,0))				as HomeLastOffTO
				 , SUM(COALESCE(ssf2Home.Def1stD,0))			as HomeLastDef1stD
				 , SUM(COALESCE(ssf2Home.DefTotYd,0))			as HomeLastDefTotYd
				 , SUM(COALESCE(ssf2Home.DefPassYd,0))			as HomeLastDefPassYd
				 , SUM(COALESCE(ssf2Home.DefRushYd,0))			as HomeLastDefRushYd
				 , SUM(COALESCE(ssf2Home.DefTO,0))				as HomeLastDefTO
				 , SUM(COALESCE(ssf2Home.ExPointsOff,0))		as HomeLastExPointsOff
				 , SUM(COALESCE(ssf2Home.ExPointsDef,0))		as HomeLastExPointsDef
				 , SUM(COALESCE(ssf2Home.ExPointsSpecial,0))	as HomeLastExPointsSepcial
				 , AVG(COALESCE(ssfAway.AvgPointsFor,0))		as AwayAvgPointsFor
				 , AVG(COALESCE(ssfAway.AvgPointsAgainst,0))	as AwayAvgPointsAgainst
				 , AVG(COALESCE(ssfAway.AvgOff1stD,0))			as AwayAvgOff1stD
				 , AVG(COALESCE(ssfAway.AvgOffTotYd,0))			as AwayAvgOffTotYd
				 , AVG(COALESCE(ssfAway.AvgOffPassYd,0))		as AwayAvgOffPassYd
				 , AVG(COALESCE(ssfAway.AvgOffRushYd,0))		as AwayAvgOffRushYd
				 , AVG(COALESCE(ssfAway.AvgOffTO,0))			as AwayAvgOffTO
				 , AVG(COALESCE(ssfAway.AvgDef1stD,0))			as AwayAvgDef1stD
				 , AVG(COALESCE(ssfAway.AvgDefTotYd,0))			as AwayAvgDefTotYd
				 , AVG(COALESCE(ssfAway.AvgDefPassYd,0))		as AwayAvgDefPassYd
				 , AVG(COALESCE(ssfAway.AvgDefRushYd,0))		as AwayAvgDefRushYd
				 , AVG(COALESCE(ssfAway.AvgDefTO,0))			as AwayAvgDefTO
				 , AVG(COALESCE(ssfAway.AvgExPointsOff,0))		as AwayAvgExPointsOff
				 , AVG(COALESCE(ssfAway.AvgExPointsDef,0))		as AwayAvgExPointsDef
				 , AVG(COALESCE(ssfAway.AvgExPointsSpecial,0))	as AwayAvgExPointsSpecial
				 , SUM(COALESCE(ssf2Away.PointsFor,0))			as AwayLastPointsFor
				 , SUM(COALESCE(ssf2Away.PointsAgainst,0))		as AwayLastPointsAgainst
				 , SUM(COALESCE(ssf2Away.Off1stD,0))			as AwayLastOff1stD
				 , SUM(COALESCE(ssf2Away.OffTotYd,0))			as AwayLastOffTotYd
				 , SUM(COALESCE(ssf2Away.OffPassYd,0))			as AwayLastOffPassYd
				 , SUM(COALESCE(ssf2Away.OffRushYd,0))			as AwayLastOffRushYd
				 , SUM(COALESCE(ssf2Away.OffTO,0))				as AwayLastOffTO
				 , SUM(COALESCE(ssf2Away.Def1stD,0))			as AwayLastDef1stD
				 , SUM(COALESCE(ssf2Away.DefTotYd,0))			as AwayLastDefTotYd
				 , SUM(COALESCE(ssf2Away.DefPassYd,0))			as AwayLastDefPassYd
				 , SUM(COALESCE(ssf2Away.DefRushYd,0))			as AwayLastDefRushYd
				 , SUM(COALESCE(ssf2Away.DefTO,0))				as AwayLastDefTO
				 , SUM(COALESCE(ssf2Away.ExPointsOff,0))		as AwayLastExPointsOff
				 , SUM(COALESCE(ssf2Away.ExPointsDef,0))		as AwayLastExPointsDef
				 , SUM(COALESCE(ssf2Away.ExPointsSpecial,0))	as AwayLastExPointsSepcial
				 , gd.HomeOddsOpen
				 , gd.HomeOddsMin
				 , gd.HomeOddsMax
				 , COALESCE(gd.HomeOddsClose,gd.HomeOddsMax,gd.HomeOddsOpen)
				 , gd.AwayOddsOpen
				 , gd.AwayOddsMin
				 , gd.AwayOddsMax
				 , COALESCE(gd.AwayOddsClose,gd.AwayOddsMax,gd.AwayOddsOpen)
				 , gd.HomeLineOpen
				 , gd.HomeLineMin
				 , gd.HomeLineMax
				 , COALESCE(gd.HomeLineClose,gd.HomeLineMax,gd.HomeLineOpen)
				 , gd.AwayLineOpen
				 , gd.AwayLineMin
				 , gd.AwayLineMax
				 , COALESCE(gd.AwayLineClose,gd.AwayLineMax,gd.AwayLineOpen)
				 , gd.HomeLineOddsOpen
				 , gd.HomeLineOddsMin
				 , gd.HomeLineOddsMax
				 , COALESCE(gd.HomeLineOddsClose,gd.HomeLineOddsMax,gd.HomeLineOddsOpen)
				 , gd.AwayLineOddsOpen
				 , gd.AwayLineOddsMin
				 , gd.AwayLineOddsMax
				 , COALESCE(gd.AwayLineOddsClose,gd.AwayLineOddsMax,gd.AwayLineOddsOpen)
				 , gd.TotalScoreOpen
				 , gd.TotalScoreMin
				 , gd.TotalScoreMax
				 , COALESCE(gd.TotalScoreClose,gd.TotalScoreMax,gd.TotalScoreOpen)
				 , gd.TotalScoreOverOpen
				 , gd.TotalScoreOverMin
				 , gd.TotalScoreOverMax
				 , gd.TotalScoreOverClose
				 , gd.TotalScoreUnderOpen
				 , gd.TotalScoreUnderMin
				 , gd.TotalScoreUnderMax
				 , gd.TotalScoreUnderClose
			FROM GameData gd
			OUTER APPLY ssf_AggSeasonStatsUpTo(HomeTeam, gd.Season, gd.Week) ssfHome
			OUTER APPLY ssf_LastGameStats(HomeTeam, gd.Season, gd.Week) ssf2Home
			OUTER APPLY ssf_AggSeasonStatsUpTo(AwayTeam, gd.Season, gd.Week) ssfAway
			OUTER APPLY ssf_LastGameStats(AwayTeam, gd.Season, gd.Week) ssf2Away
			WHERE (gd.HomeTeam = @Team or gd.AwayTeam = @Team)
			AND	  (gd.Season = @Season)
			AND   (gd.Week < @Week)
			AND NOT EXISTS (SELECT 1 FROM #tempGameData tgd WHERE tgd.HomeTeam = gd.HomeTeam AND tgd.AwayTeam = gd.AwayTeam and tgd.Week = gd.Week AND tgd.Season = gd.Season)
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
				 , COALESCE(gd.HomeOddsClose,gd.HomeOddsMax,gd.HomeOddsOpen)
				 , gd.AwayOddsOpen
				 , gd.AwayOddsMin
				 , gd.AwayOddsMax
				 , COALESCE(gd.AwayOddsClose,gd.AwayOddsMax,gd.AwayOddsOpen)
				 , gd.HomeLineOpen
				 , gd.HomeLineMin
				 , gd.HomeLineMax
				 , COALESCE(gd.HomeLineClose,gd.HomeLineMax,gd.HomeLineOpen)
				 , gd.AwayLineOpen
				 , gd.AwayLineMin
				 , gd.AwayLineMax
				 , COALESCE(gd.AwayLineClose,gd.AwayLineMax,gd.AwayLineOpen)
				 , gd.HomeLineOddsOpen
				 , gd.HomeLineOddsMin
				 , gd.HomeLineOddsMax
				 , COALESCE(gd.HomeLineOddsClose,gd.HomeLineOddsMax,gd.HomeLineOddsOpen)
				 , gd.AwayLineOddsOpen
				 , gd.AwayLineOddsMin
				 , gd.AwayLineOddsMax
				 , COALESCE(gd.AwayLineOddsClose,gd.AwayLineOddsMax,gd.AwayLineOddsOpen)
				 , gd.TotalScoreOpen
				 , gd.TotalScoreMin
				 , gd.TotalScoreMax
				 , COALESCE(gd.TotalScoreClose,gd.TotalScoreMax,gd.TotalScoreOpen)
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

		INSERT INTO @tempGameDataFull (
			 HomeTeam
			,AwayTeam
			,Week
			,Season
			,HomeScore
			,AwayScore
			,Result
			,HomeAvgPointsFor
			,HomeAvgPointsAgainst
			,HomeAvgOff1stD
			,HomeAvgOffTotYd
			,HomeAvgOffPassYd
			,HomeAvgOffRushYd	
			,HomeAvgOffTO			
			,HomeAvgDef1stD			
			,HomeAvgDefTotYd		
			,HomeAvgDefPassYd		
			,HomeAvgDefRushYd		
			,HomeAvgDefTO			
			,HomeAvgExPointsOff		
			,HomeAvgExPointsDef		
			,HomeAvgExPointsSpecial
			,HomeLastPointsFor
			,HomeLastPointsAgainst
			,HomeLastOff1stD
			,HomeLastOffTotYd
			,HomeLastOffPassYd
			,HomeLastOffRushYd	
			,HomeLastOffTO			
			,HomeLastDef1stD			
			,HomeLastDefTotYd		
			,HomeLastDefPassYd		
			,HomeLastDefRushYd		
			,HomeLastDefTO			
			,HomeLastExPointsOff		
			,HomeLastExPointsDef		
			,HomeLastExPointsSpecial
			,AwayAvgPointsFor
			,AwayAvgPointsAgainst
			,AwayAvgOff1stD
			,AwayAvgOffTotYd
			,AwayAvgOffPassYd
			,AwayAvgOffRushYd	
			,AwayAvgOffTO			
			,AwayAvgDef1stD			
			,AwayAvgDefTotYd		
			,AwayAvgDefPassYd		
			,AwayAvgDefRushYd		
			,AwayAvgDefTO			
			,AwayAvgExPointsOff		
			,AwayAvgExPointsDef		
			,AwayAvgExPointsSpecial
			,AwayLastPointsFor
			,AwayLastPointsAgainst
			,AwayLastOff1stD
			,AwayLastOffTotYd
			,AwayLastOffPassYd
			,AwayLastOffRushYd	
			,AwayLastOffTO			
			,AwayLastDef1stD			
			,AwayLastDefTotYd		
			,AwayLastDefPassYd		
			,AwayLastDefRushYd		
			,AwayLastDefTO			
			,AwayLastExPointsOff		
			,AwayLastExPointsDef		
			,AwayLastExPointsSpecial
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
			,OneUnitThreshold
			,FiveUnitThreshold
			,TenUnitThreshold
			)
		SELECT HomeTeam
			,AwayTeam
			,Week
			,Season
			,HomeScore
			,AwayScore
			,Result
			,HomeAvgPointsFor
			,HomeAvgPointsAgainst
			,HomeAvgOff1stD
			,HomeAvgOffTotYd
			,HomeAvgOffPassYd
			,HomeAvgOffRushYd	
			,HomeAvgOffTO			
			,HomeAvgDef1stD			
			,HomeAvgDefTotYd		
			,HomeAvgDefPassYd		
			,HomeAvgDefRushYd		
			,HomeAvgDefTO			
			,HomeAvgExPointsOff		
			,HomeAvgExPointsDef		
			,HomeAvgExPointsSpecial
			,HomeLastPointsFor
			,HomeLastPointsAgainst
			,HomeLastOff1stD
			,HomeLastOffTotYd
			,HomeLastOffPassYd
			,HomeLastOffRushYd	
			,HomeLastOffTO			
			,HomeLastDef1stD			
			,HomeLastDefTotYd		
			,HomeLastDefPassYd		
			,HomeLastDefRushYd		
			,HomeLastDefTO			
			,HomeLastExPointsOff		
			,HomeLastExPointsDef		
			,HomeLastExPointsSpecial
			,AwayAvgPointsFor
			,AwayAvgPointsAgainst
			,AwayAvgOff1stD
			,AwayAvgOffTotYd
			,AwayAvgOffPassYd
			,AwayAvgOffRushYd	
			,AwayAvgOffTO			
			,AwayAvgDef1stD			
			,AwayAvgDefTotYd		
			,AwayAvgDefPassYd		
			,AwayAvgDefRushYd		
			,AwayAvgDefTO			
			,AwayAvgExPointsOff		
			,AwayAvgExPointsDef		
			,AwayAvgExPointsSpecial
			,AwayLastPointsFor
			,AwayLastPointsAgainst
			,AwayLastOff1stD
			,AwayLastOffTotYd
			,AwayLastOffPassYd
			,AwayLastOffRushYd	
			,AwayLastOffTO			
			,AwayLastDef1stD			
			,AwayLastDefTotYd		
			,AwayLastDefPassYd		
			,AwayLastDefRushYd		
			,AwayLastDefTO			
			,AwayLastExPointsOff		
			,AwayLastExPointsDef		
			,AwayLastExPointsSpecial
			,HomeOddsOpen
			,HomeOddsMin
			,HomeOddsMax
			,COALESCE(HomeOddsClose,HomeOddsMax,HomeOddsOpen)
			,AwayOddsOpen
			,AwayOddsMin
			,AwayOddsMax
			,COALESCE(AwayOddsClose,AwayOddsMax,AwayOddsOpen)
			,HomeLineOpen
			,HomeLineMin
			,HomeLineMax
			,COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen)
			,AwayLineOpen
			,AwayLineMin
			,AwayLineMax
			,COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen)
			,HomeLineOddsOpen
			,HomeLineOddsMin
			,HomeLineOddsMax
			,COALESCE(HomeLineOddsClose,HomeLineOddsMax,HomeLineOddsOpen)
			,AwayLineOddsOpen
			,AwayLineOddsMin
			,AwayLineOddsMax
			,COALESCE(AwayLineOddsClose,AwayLineOddsMax,AwayLineOddsOpen)
			,TotalScoreOpen
			,TotalScoreMin
			,TotalScoreMax
			,COALESCE(TotalScoreClose,TotalScoreMax,TotalScoreOpen)
			,TotalScoreOverOpen
			,TotalScoreOverMin
			,TotalScoreOverMax
			,TotalScoreOverClose
			,TotalScoreUnderOpen
			,TotalScoreUnderMin
			,TotalScoreUnderMax
			,TotalScoreUnderClose
			,@OneUnitThreshold
			,@FiveUnitThreshold
			,@TenUnitThreshold
		FROM #tempGameData

	FETCH NEXT FROM year_cur INTO @Season
	END
	IF @ReportType = 'G'
	BEGIN
		SELECT	HomeTeam
			,	AwayTeam
			,	[Week]
			,	Season
			,	Result
			,	HomeAvgPointsFor
			,	HomeAvgPointsAgainst
			,	HomeAvgOff1stD
			,	HomeAvgOffTotYd
			,	HomeAvgOffPassYd
			,	HomeAvgOffRushYd	
			,	HomeAvgOffTO			
			,	HomeAvgDef1stD			
			,	HomeAvgDefTotYd		
			,	HomeAvgDefPassYd		
			,	HomeAvgDefRushYd		
			,	HomeAvgDefTO			
			,	HomeAvgExPointsOff		
			,	HomeAvgExPointsDef		
			,	HomeAvgExPointsSpecial
			,	HomeLastPointsFor
			,	HomeLastPointsAgainst
			,	HomeLastOff1stD
			,	HomeLastOffTotYd
			,	HomeLastOffPassYd
			,	HomeLastOffRushYd	
			,	HomeLastOffTO			
			,	HomeLastDef1stD			
			,	HomeLastDefTotYd		
			,	HomeLastDefPassYd		
			,	HomeLastDefRushYd		
			,	HomeLastDefTO			
			,	HomeLastExPointsOff		
			,	HomeLastExPointsDef		
			,	HomeLastExPointsSpecial
			,	AwayAvgPointsFor
			,	AwayAvgPointsAgainst
			,	AwayAvgOff1stD
			,	AwayAvgOffTotYd
			,	AwayAvgOffPassYd
			,	AwayAvgOffRushYd	
			,	AwayAvgOffTO			
			,	AwayAvgDef1stD			
			,	AwayAvgDefTotYd		
			,	AwayAvgDefPassYd		
			,	AwayAvgDefRushYd		
			,	AwayAvgDefTO			
			,	AwayAvgExPointsOff		
			,	AwayAvgExPointsDef		
			,	AwayAvgExPointsSpecial
			,	AwayLastPointsFor
			,	AwayLastPointsAgainst
			,	AwayLastOff1stD
			,	AwayLastOffTotYd
			,	AwayLastOffPassYd
			,	AwayLastOffRushYd	
			,	AwayLastOffTO			
			,	AwayLastDef1stD			
			,	AwayLastDefTotYd		
			,	AwayLastDefPassYd		
			,	AwayLastDefRushYd		
			,	AwayLastDefTO			
			,	AwayLastExPointsOff		
			,	AwayLastExPointsDef		
			,	AwayLastExPointsSpecial
			,	HomeOddsOpen
			,	HomeOddsMin
			,	HomeOddsMax
			,	AwayOddsOpen
			,	AwayOddsMin
			,	AwayOddsMax
			,	HomeLineOpen
			,	HomeLineMin
			,	HomeLineMax
			,	COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen)
			,	AwayLineOpen
			,	AwayLineMin
			,	AwayLineMax
			,	COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen)
			,	HomeLineOddsOpen
			,	HomeLineOddsMin
			,	HomeLineOddsMax
			,	COALESCE(HomeLineOddsClose,HomeLineOddsMax,HomeLineOddsOpen)
			,	AwayLineOddsOpen
			,	AwayLineOddsMin
			,	AwayLineOddsMax
			,	COALESCE(AwayLineOddsClose,AwayLineOddsMax,AwayLineOddsOpen)
			,	TotalScoreOpen
			,	TotalScoreMin
			,	TotalScoreMax
			,	COALESCE(TotalScoreClose,TotalScoreMax,TotalScoreOpen)
			,	TotalScoreOverOpen
			,	TotalScoreOverMin
			,	TotalScoreOverMax
			,	TotalScoreOverClose
			,	TotalScoreUnderOpen
			,	TotalScoreUnderMin
			,	TotalScoreUnderMax
			,	TotalScoreUnderClose
			,	COALESCE(HomeLineOddsClose,HomeLineOddsMax,HomeLineOddsOpen) as HomeMLClose
			,	COALESCE(AwayLineOddsClose,AwayLineOddsMax,AwayLineOddsOpen) as AwayMLClose
			,	CONCAT(COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen), ' @ ', COALESCE(HomeLineOddsClose,HomeLineOddsMax,HomeLineOddsOpen)) as HomeSpreadClose
			,	CONCAT(COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen), ' @ ', COALESCE(AwayLineOddsClose,AwayLineOddsMax,AwayLineOddsOpen)) as AwaySpreadClose
			,	CONCAT(COALESCE(TotalScoreClose,TotalScoreMax,TotalScoreOpen), ' @ ', COALESCE(TotalScoreUnderClose,TotalScoreUnderMax,TotalScoreUnderOpen), ' / ', COALESCE(TotalScoreOverClose,TotalScoreOverMax,TotalScoreOverOpen)) as AwaySpreadClose
			,	ISNULL(COALESCE(HomeLineOddsClose,HomeLineOddsMax,HomeLineOddsOpen),0) - ISNULL(HomeOddsOpen,0) as HomeLineMovement	
			,	ISNULL(COALESCE(AwayLineOddsClose,AwayLineOddsMax,AwayLineOddsOpen),0) - ISNULL(AwayOddsOpen,0) as AwayLineMovement	
			,	ISNULL(COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen),0) - ISNULL(COALESCE(HomeLineOpen,HomeLineMin,HomeLineClose),0) as HomeLineMovement
			,	ISNULL(COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen),0) - ISNULL(COALESCE(AwayLineOpen,AwayLineMin,AwayLineClose),0) as AwayLineMovement		
			,	ISNULL(COALESCE(HomeLineOddsClose,HomeLineOddsMax,HomeLineOddsOpen),0) - ISNULL(COALESCE(HomeLineOddsOpen,HomeLineOddsMin,HomeLineOddsClose),0) as HomeLineOddsMovement	
			,	ISNULL(COALESCE(AwayLineOddsClose,AwayLineOddsMax,AwayLineOddsOpen),0) - ISNULL(COALESCE(AwayLineOddsOpen,AwayLineOddsMin,AwayLineOddsClose),0) as AwayLineOddsMovement	
			,	ISNULL(COALESCE(TotalScoreClose,TotalScoreOpen),0) - ISNULL(TotalScoreOpen,0) as TotalScoreMovement		
			,	ISNULL(TotalScoreOverClose,0) - ISNULL(TotalScoreOverClose,0) as TotalScoreOverMovement	
			,	ISNULL(TotalScoreUnderClose,0) - ISNULL(TotalScoreUnderOpen,0) as TotalScoreUnderMovement
	FROM @tempGameDataFull
	ORDER BY Season ASC, Week ASC

	GOTO Finish

	END
	
	CLOSE year_cur;
	DEALLOCATE year_cur;
	
	IF @ReportType = 'B'
	BEGIN
		EXEC ssp_CalculateSeasonData

		IF OBJECT_ID('tempdb..#SeasonData','U') IS NOT NULL
		DROP TABLE #SeasonData

		CREATE TABLE #SeasonData (
					 Season							INT
					,SeasonTotalUnderRate			DECIMAL(5,2)
					,SeasonTotalPushRate			DECIMAL(5,2)
					,SeasonTotalOverRate			DECIMAL(5,2)
					,HomeUnderdogSpreadCoverRate	DECIMAL(5,2)
					,HomeFavoriteSpreadCoverRate	DECIMAL(5,2)
					,AwayUnderdogSpreadCoverRate	DECIMAL(5,2)
					,AwayFavoriteSpreadCoverRate	DECIMAL(5,2)
					,HomeSpreadCoverRate			DECIMAL(5,2)
					,AwaySpreadCoverRate			DECIMAL(5,2)
					,FavoriteSpreadCoverRate		DECIMAL(5,2)
					,DogSpreadCoverRate				DECIMAL(5,2)
					,HomeUnderdogOutrightRate		DECIMAL(5,2)
					,HomeFavoriteOutrightRate		DECIMAL(5,2)
					,AwayUnderdogOutrightRate		DECIMAL(5,2)
					,AwayFavoriteOutrightRate		DECIMAL(5,2)
					,HomeOutrightRate				DECIMAL(5,2)
					,AwayOutrightRate				DECIMAL(5,2)
					,FavoriteOutrightRate			DECIMAL(5,2)
					,DogOutrightRate				DECIMAL(5,2)
					/*Number Correct*/
					,ImpliedProbabilityOutrightHANumCorrect DECIMAL(5,2)
					,ImpliedProbabilityOutrightFDNumCorrect DECIMAL(5,2)
					,ImpliedProbabilityOutrightPickNumCorrect DECIMAL(5,2)
					,ImpliedProbabilitySpreadHANumCorrect DECIMAL(5,2)
					,ImpliedProbabilitySpreadFDNumCorrect DECIMAL(5,2)
					,ImpliedProbabilitySpreadPickNumCorrect DECIMAL(5,2)
					,ImpliedProbabilityTotalNumCorrect DECIMAL(5,2)
					/*Total Applicable*/
					,ImpliedProbabilityOutrightHATotApplicable DECIMAL(5,2)
					,ImpliedProbabilityOutrightFDTotApplicable DECIMAL(5,2)
					,ImpliedProbabilityOutrightPickTotApplicable DECIMAL(5,2)
					,ImpliedProbabilitySpreadHATotApplicable DECIMAL(5,2)
					,ImpliedProbabilitySpreadFDTotApplicable DECIMAL(5,2)
					,ImpliedProbabilitySpreadPickTotApplicable DECIMAL(5,2)
					,ImpliedProbabilityTotalTotApplicable DECIMAL(5,2)
					/*Accuracy Columns*/
					,ImpliedProbabilityOutrightHAAccuracy DECIMAL(5,2)
					,ImpliedProbabilityOutrightFDAccuracy DECIMAL(5,2)
					,ImpliedProbabilityOutrightPickAccuracy DECIMAL(5,2)
					,ImpliedProbabilitySpreadHAAccuracy DECIMAL(5,2)
					,ImpliedProbabilitySpreadFDAccuracy DECIMAL(5,2)
					,ImpliedProbabilitySpreadPickAccuracy DECIMAL(5,2)
					,ImpliedProbabilityTotalAccuracy DECIMAL(5,2)
					/*Average Odds Columns*/
					,ImpliedProbabilityOutrightHAAvgOdds DECIMAL(5,2)
					,ImpliedProbabilityOutrightFDAvgOdds DECIMAL(5,2)
					,ImpliedProbabilityOutrightPickAvgOdds DECIMAL(5,2)
					,ImpliedProbabilitySpreadHAAvgOdds DECIMAL(5,2)
					,ImpliedProbabilitySpreadFDAvgOdds DECIMAL(5,2)
					,ImpliedProbabilitySpreadPickAvgOdds DECIMAL(5,2)
					,ImpliedProbabilityTotalAvgOdds DECIMAL(5,2)
					/*Profit Columns*/
					,ImpliedProbabilityOutrightHAProfit DECIMAL(5,2)
					,ImpliedProbabilityOutrightFDProfit DECIMAL(5,2)
					,ImpliedProbabilityOutrightPickProfit DECIMAL(5,2)
					,ImpliedProbabilitySpreadHAProfit DECIMAL(5,2)
					,ImpliedProbabilitySpreadFDProfit DECIMAL(5,2)
					,ImpliedProbabilitySpreadPickProfit DECIMAL(5,2)
					,ImpliedProbabilityTotalProfit DECIMAL(5,2)
					)
		DECLARE
		@ImpliedProbabilityOutrightPickHomeOddsThreshold			Decimal(5,2),
		@ImpliedProbabilityOutrightPickAwayOddsThreshold			Decimal(5,2),
		@ImpliedProbabilityOutrightPickFavoriteOddsThreshold		Decimal(5,2),
		@ImpliedProbabilityOutrightPickDogOddsThreshold				Decimal(5,2),
		@ImpliedProbabilitySpreadPickHomeOddsThreshold				Decimal(5,2),
		@ImpliedProbabilitySpreadPickAwayOddsThreshold				Decimal(5,2),
		@ImpliedProbabilitySpreadPickFavoriteOddsThreshold			Decimal(5,2),
		@ImpliedProbabilitySpreadPickDogOddsThreshold				Decimal(5,2),
		@ImpliedProbabilityTotalPickOverOddsThreshold				Decimal(5,2),
		@ImpliedProbabilityTotalPickUnderOddsThreshold				Decimal(5,2),
		@Year														INT

		EXEC ssp_CalculateSeasonData

		INSERT INTO #SeasonData (Season,SeasonTotalUnderRate,SeasonTotalPushRate,SeasonTotalOverRate,HomeUnderdogSpreadCoverRate,HomeFavoriteSpreadCoverRate,AwayUnderdogSpreadCoverRate
,AwayFavoriteSpreadCoverRate,HomeSpreadCoverRate,AwaySpreadCoverRate,FavoriteSpreadCoverRate,DogSpreadCoverRate,HomeUnderdogOutrightRate,HomeFavoriteOutrightRate,AwayUnderdogOutrightRate
,AwayFavoriteOutrightRate,HomeOutrightRate,AwayOutrightRate,FavoriteOutrightRate,DogOutrightRate)
		SELECT	Season
			,	SeasonTotalUnderRate
			,	SeasonTotalPushRate
			,	SeasonTotalOverRate
			,	HomeUnderdogSpreadCoverRate
			,	HomeFavoriteSpreadCoverRate
			,	AwayUnderdogSpreadCoverRate
			,	AwayFavoriteSpreadCoverRate
			,	HomeSpreadCoverRate
			,	AwaySpreadCoverRate
			,	FavoriteSpreadCoverRate
			,	DogSpreadCoverRate
			,	HomeUnderdogOutrightRate
			,	HomeFavoriteOutrightRate
			,	AwayUnderdogOutrightRate
			,	AwayFavoriteOutrightRate
			,	HomeOutrightRate
			,	AwayOutrightRate
			,	FavoriteOutrightRate
			,	DogOutrightRate
		From Seasons
		ORDER BY Season ASC

		
		if @TestCode = 1 SELECT 'line 908 - ',* FROM @tempGameDataFull


		/*Data Cleanup*/
		UPDATE @tempGameDataFull SET AwayLineClose = HomeLineClose * -1
		WHERE AwayLineClose IS NULL AND HomeLineClose IS NOT NULL

		UPDATE @tempGameDataFull SET HomeLineClose = AwayLineClose * -1
		WHERE AwayLineClose IS NOT NULL AND HomeLineClose IS NULL

		DECLARE year_cur CURSOR
		FOR
		SELECT Season
		From #Years

		OPEN year_cur
		FETCH NEXT FROM year_cur into @Season

		WHILE @@FETCH_STATUS = 0
		BEGIN

		SET @Year = @Season --Store season from cursor so we avoid overwriting it



		


		/*Set implied probability odds thresholds based on previous years' data*/
		SET @ImpliedProbabilityOutrightPickHomeOddsThreshold	= 1/(SELECT AVG(CAST(HomeOutrightRate as Decimal(5,2)))			FROM Seasons WHERE Season = @Year - 1)
		SET @ImpliedProbabilityOutrightPickAwayOddsThreshold	= 1/(SELECT AVG(CAST(AwayOutrightRate as Decimal(5,2)))			FROM Seasons WHERE Season = @Year - 1)
		SET @ImpliedProbabilityOutrightPickFavoriteOddsThreshold= 1/(SELECT AVG(CAST(FavoriteOutrightRate as Decimal(5,2)))		FROM Seasons WHERE Season = @Year - 1)
		SET @ImpliedProbabilityOutrightPickDogOddsThreshold		= 1/(SELECT AVG(CAST(DogOutrightRate as Decimal(5,2)))			FROM Seasons WHERE Season = @Year - 1)
		SET @ImpliedProbabilitySpreadPickHomeOddsThreshold		= 1/(SELECT AVG(CAST(HomeSpreadCoverRate as Decimal(5,2)))		FROM Seasons WHERE Season = @Year - 1)
		SET @ImpliedProbabilitySpreadPickAwayOddsThreshold		= 1/(SELECT AVG(CAST(AwaySpreadCoverRate as Decimal(5,2)))		FROM Seasons WHERE Season = @Year - 1)
		SET @ImpliedProbabilitySpreadPickFavoriteOddsThreshold	= 1/(SELECT AVG(CAST(FavoriteSpreadCoverRate as Decimal(5,2)))	FROM Seasons WHERE Season = @Year - 1)
		SET @ImpliedProbabilitySpreadPickDogOddsThreshold		= 1/(SELECT AVG(CAST(DogSpreadCoverRate as Decimal(5,2)))		FROM Seasons WHERE Season = @Year - 1)
		SET @ImpliedProbabilityTotalPickOverOddsThreshold		= 1/(SELECT AVG(CAST(SeasonTotalOverRate as Decimal(5,2)))		FROM Seasons WHERE Season = @Year - 1)
		SET @ImpliedProbabilityTotalPickUnderOddsThreshold		= 1/(SELECT AVG(CAST(SeasonTotalUnderRate as Decimal(5,2)))		FROM Seasons WHERE Season = @Year - 1)

		UPDATE @tempGameDataFull SET ImpliedProbabilityOutrightPickHomeOddsThreshold = @ImpliedProbabilityOutrightPickHomeOddsThreshold WHERE Season = @Year
		UPDATE @tempGameDataFull SET ImpliedProbabilityOutrightPickAwayOddsThreshold = @ImpliedProbabilityOutrightPickAwayOddsThreshold WHERE Season = @Year
		UPDATE @tempGameDataFull SET ImpliedProbabilityOutrightPickFavoriteOddsThreshold = @ImpliedProbabilityOutrightPickFavoriteOddsThreshold WHERE Season = @Year
		UPDATE @tempGameDataFull SET ImpliedProbabilityOutrightPickDogOddsThreshold = @ImpliedProbabilityOutrightPickDogOddsThreshold WHERE Season = @Year
		UPDATE @tempGameDataFull SET ImpliedProbabilitySpreadPickHomeOddsThreshold = @ImpliedProbabilitySpreadPickHomeOddsThreshold WHERE Season = @Year
		UPDATE @tempGameDataFull SET ImpliedProbabilitySpreadPickAwayOddsThreshold = @ImpliedProbabilitySpreadPickAwayOddsThreshold WHERE Season = @Year
		UPDATE @tempGameDataFull SET ImpliedProbabilitySpreadPickFavoriteOddsThreshold = @ImpliedProbabilitySpreadPickFavoriteOddsThreshold WHERE Season = @Year
		UPDATE @tempGameDataFull SET ImpliedProbabilitySpreadPickDogOddsThreshold = @ImpliedProbabilitySpreadPickDogOddsThreshold WHERE Season = @Year
		UPDATE @tempGameDataFull SET ImpliedProbabilityTotalPickOverOddsThreshold = @ImpliedProbabilityTotalPickOverOddsThreshold WHERE Season = @Year
		UPDATE @tempGameDataFull SET ImpliedProbabilityTotalPickUnderOddsThreshold = @ImpliedProbabilityTotalPickUnderOddsThreshold WHERE Season = @Year

		--Debug Rates from Seasons table
		--IF @TestCode = 2
		--SELECT  AVG(CAST(HomeOutrightRate as Decimal(5,2)))			as AvgHomeOutrightRate		
		--	   ,AVG(CAST(AwayOutrightRate as Decimal(5,2)))			as AvgAwayOutrightRate		
		--	   ,AVG(CAST(FavoriteOutrightRate as Decimal(5,2)))		as AvgFavOutrightRate
		--	   ,AVG(CAST(DogOutrightRate as Decimal(5,2)))			as AvgDogOutrightRate
		--	   ,AVG(CAST(HomeSpreadCoverRate as Decimal(5,2)))		as AvgHomeSpreadRate
		--	   ,AVG(CAST(AwaySpreadCoverRate as Decimal(5,2)))		as AvgAwaySpreadRate
		--	   ,AVG(CAST(FavoriteSpreadCoverRate as Decimal(5,2)))	as AvgFavSpreadRate
		--	   ,AVG(CAST(DogSpreadCoverRate as Decimal(5,2)))		as AvgDogSpreadRate
		--	   ,AVG(CAST(SeasonTotalOverRate as Decimal(5,2)))		as AvgTotalOverRate
		--	   ,AVG(CAST(SeasonTotalUnderRate as Decimal(5,2)))		as AvgTotalUnderRate
		--	   FROM Seasons where Season <= @Year - 1

		--Debug Thresholds
		IF @TestCode = 2
			BEGIN
				SELECT  @Season,
						@ImpliedProbabilityOutrightPickHomeOddsThreshold	 as OutrightHomeThreshold
					   ,@ImpliedProbabilityOutrightPickAwayOddsThreshold	 as OutrightAwayThreshold
					   ,@ImpliedProbabilityOutrightPickFavoriteOddsThreshold as OutrightFavThreshold
					   ,@ImpliedProbabilityOutrightPickDogOddsThreshold		 as OutrightDogThreshold
					   ,@ImpliedProbabilitySpreadPickHomeOddsThreshold		 as SpreadHomeThreshold
					   ,@ImpliedProbabilitySpreadPickAwayOddsThreshold		 as SpreadAwayThreshold
					   ,@ImpliedProbabilitySpreadPickFavoriteOddsThreshold	 as SpreadFavThreshold
					   ,@ImpliedProbabilitySpreadPickDogOddsThreshold		 as SpreadDogThreshold
					   ,@ImpliedProbabilityTotalPickOverOddsThreshold		 as TotalOverThreshold
					   ,@ImpliedProbabilityTotalPickUnderOddsThreshold		 as TotalUnderThreshold
				SELECT 'line 983 -', * FROM @tempGameDataFull
			END

		UPDATE tgd SET
			tgd.HomeTeam = smp.HomeTeam	,
			tgd.AwayTeam = smp.AwayTeam	,
			tgd.Week = smp.Week	,
			tgd.Season = smp.Season	,
			tgd.HomeScore = smp.HomeScore	,
			tgd.AwayScore = smp.AwayScore	,
			tgd.Result = smp.Result	,
			tgd.HomeAvgPointsFor = smp.HomeAvgPointsFor	,
			tgd.HomeAvgPointsAgainst = smp.HomeAvgPointsAgainst	,
			tgd.HomeAvgOff1stD = smp.HomeAvgOff1stD	,
			tgd.HomeAvgOffTotYd = smp.HomeAvgOffTotYd	,
			tgd.HomeAvgOffPassYd = smp.HomeAvgOffPassYd	,
			tgd.HomeAvgOffRushYd = smp.HomeAvgOffRushYd	,
			tgd.HomeAvgOffTO = smp.HomeAvgOffTO	,
			tgd.HomeAvgDef1stD = smp.HomeAvgDef1stD	,
			tgd.HomeAvgDefTotYd = smp.HomeAvgDefTotYd	,
			tgd.HomeAvgDefPassYd = smp.HomeAvgDefPassYd	,
			tgd.HomeAvgDefRushYd = smp.HomeAvgDefRushYd	,
			tgd.HomeAvgDefTO = smp.HomeAvgDefTO	,
			tgd.HomeAvgExPointsOff = smp.HomeAvgExPointsOff	,
			tgd.HomeAvgExPointsDef = smp.HomeAvgExPointsDef	,
			tgd.HomeAvgExPointsSpecial = smp.HomeAvgExPointsSpecial	,
			tgd.HomeLastPointsFor = smp.HomeLastPointsFor	,
			tgd.HomeLastPointsAgainst = smp.HomeLastPointsAgainst	,
			tgd.HomeLastOff1stD = smp.HomeLastOff1stD	,
			tgd.HomeLastOffTotYd = smp.HomeLastOffTotYd	,
			tgd.HomeLastOffPassYd = smp.HomeLastOffPassYd	,
			tgd.HomeLastOffRushYd = smp.HomeLastOffRushYd	,
			tgd.HomeLastOffTO = smp.HomeLastOffTO	,
			tgd.HomeLastDef1stD = smp.HomeLastDef1stD	,
			tgd.HomeLastDefTotYd = smp.HomeLastDefTotYd	,
			tgd.HomeLastDefPassYd = smp.HomeLastDefPassYd	,
			tgd.HomeLastDefRushYd = smp.HomeLastDefRushYd	,
			tgd.HomeLastDefTO = smp.HomeLastDefTO	,
			tgd.HomeLastExPointsOff = smp.HomeLastExPointsOff	,
			tgd.HomeLastExPointsDef = smp.HomeLastExPointsDef	,
			tgd.HomeLastExPointsSpecial = smp.HomeLastExPointsSpecial	,
			tgd.AwayAvgPointsFor = smp.AwayAvgPointsFor	,
			tgd.AwayAvgPointsAgainst = smp.AwayAvgPointsAgainst	,
			tgd.AwayAvgOff1stD = smp.AwayAvgOff1stD	,
			tgd.AwayAvgOffTotYd = smp.AwayAvgOffTotYd	,
			tgd.AwayAvgOffPassYd = smp.AwayAvgOffPassYd	,
			tgd.AwayAvgOffRushYd = smp.AwayAvgOffRushYd	,
			tgd.AwayAvgOffTO = smp.AwayAvgOffTO	,
			tgd.AwayAvgDef1stD = smp.AwayAvgDef1stD	,
			tgd.AwayAvgDefTotYd = smp.AwayAvgDefTotYd	,
			tgd.AwayAvgDefPassYd = smp.AwayAvgDefPassYd	,
			tgd.AwayAvgDefRushYd = smp.AwayAvgDefRushYd	,
			tgd.AwayAvgDefTO = smp.AwayAvgDefTO	,
			tgd.AwayAvgExPointsOff = smp.AwayAvgExPointsOff	,
			tgd.AwayAvgExPointsDef = smp.AwayAvgExPointsDef	,
			tgd.AwayAvgExPointsSpecial = smp.AwayAvgExPointsSpecial	,
			tgd.AwayLastPointsFor = smp.AwayLastPointsFor	,
			tgd.AwayLastPointsAgainst = smp.AwayLastPointsAgainst	,
			tgd.AwayLastOff1stD = smp.AwayLastOff1stD	,
			tgd.AwayLastOffTotYd = smp.AwayLastOffTotYd	,
			tgd.AwayLastOffPassYd = smp.AwayLastOffPassYd	,
			tgd.AwayLastOffRushYd = smp.AwayLastOffRushYd	,
			tgd.AwayLastOffTO = smp.AwayLastOffTO	,
			tgd.AwayLastDef1stD = smp.AwayLastDef1stD	,
			tgd.AwayLastDefTotYd = smp.AwayLastDefTotYd	,
			tgd.AwayLastDefPassYd = smp.AwayLastDefPassYd	,
			tgd.AwayLastDefRushYd = smp.AwayLastDefRushYd	,
			tgd.AwayLastDefTO = smp.AwayLastDefTO	,
			tgd.AwayLastExPointsOff = smp.AwayLastExPointsOff	,
			tgd.AwayLastExPointsDef = smp.AwayLastExPointsDef	,
			tgd.AwayLastExPointsSpecial = smp.AwayLastExPointsSpecial	,
			tgd.HomeOddsOpen = smp.HomeOddsOpen	,
			tgd.HomeOddsMin = smp.HomeOddsMin	,
			tgd.HomeOddsMax = smp.HomeOddsMax	,
			tgd.HomeOddsClose = smp.HomeOddsClose	,
			tgd.HomeOddsCloseIP = smp.HomeOddsCloseIP	,
			tgd.HomeOddsCloseDevig = smp.HomeOddsCloseDevig	,
			tgd.AwayOddsOpen = smp.AwayOddsOpen	,
			tgd.AwayOddsMin = smp.AwayOddsMin	,
			tgd.AwayOddsMax = smp.AwayOddsMax	,
			tgd.AwayOddsClose = smp.AwayOddsClose	,
			tgd.AwayOddsCloseIP = smp.AwayOddsCloseIP	,
			tgd.AwayOddsCloseDevig = smp.AwayOddsCloseDevig	,
			tgd.HomeLineOpen = smp.HomeLineOpen	,
			tgd.HomeLineMin = smp.HomeLineMin	,
			tgd.HomeLineMax = smp.HomeLineMax	,
			tgd.HomeLineClose = smp.HomeLineClose	,
			tgd.AwayLineOpen = smp.AwayLineOpen	,
			tgd.AwayLineMin = smp.AwayLineMin	,
			tgd.AwayLineMax = smp.AwayLineMax	,
			tgd.AwayLineClose = smp.AwayLineClose	,
			tgd.HomeLineOddsOpen = smp.HomeLineOddsOpen	,
			tgd.HomeLineOddsMin = smp.HomeLineOddsMin	,
			tgd.HomeLineOddsMax = smp.HomeLineOddsMax	,
			tgd.HomeLineOddsClose = smp.HomeLineOddsClose	,
			tgd.HomeLineOddsCloseIP = smp.HomeLineOddsCloseIP	,
			tgd.HomeLineOddsCloseDevig = smp.HomeLineOddsCloseDevig	,
			tgd.AwayLineOddsOpen = smp.AwayLineOddsOpen	,
			tgd.AwayLineOddsMin = smp.AwayLineOddsMin	,
			tgd.AwayLineOddsMax = smp.AwayLineOddsMax	,
			tgd.AwayLineOddsClose = smp.AwayLineOddsClose	,
			tgd.AwayLineOddsCloseIP = smp.AwayLineOddsCloseIP	,
			tgd.AwayLineOddsCloseDevig = smp.AwayLineOddsCloseDevig	,
			tgd.TotalScoreOpen = smp.TotalScoreOpen	,
			tgd.TotalScoreMin = smp.TotalScoreMin	,
			tgd.TotalScoreMax = smp.TotalScoreMax	,
			tgd.TotalScoreClose = smp.TotalScoreClose	,
			tgd.TotalScoreOverOpen = smp.TotalScoreOverOpen	,
			tgd.TotalScoreOverMin = smp.TotalScoreOverMin	,
			tgd.TotalScoreOverMax = smp.TotalScoreOverMax	,
			tgd.TotalScoreOverClose = smp.TotalScoreOverClose	,
			tgd.TotalScoreOverCloseIP = smp.TotalScoreOverCloseIP	,
			tgd.TotalScoreOverCloseDevig = smp.TotalScoreOverCloseDevig	,
			tgd.TotalScoreUnderOpen = smp.TotalScoreUnderOpen	,
			tgd.TotalScoreUnderMin = smp.TotalScoreUnderMin	,
			tgd.TotalScoreUnderMax = smp.TotalScoreUnderMax	,
			tgd.TotalScoreUnderClose = smp.TotalScoreUnderClose	,
			tgd.TotalScoreUnderCloseIP = smp.TotalScoreUnderCloseIP	,
			tgd.TotalScoreUnderCloseDevig = smp.TotalScoreUnderCloseDevig	,
			tgd.HomeLineMovement = smp.HomeLineMovement	,
			tgd.HomeLineOddsMovement = smp.HomeLineOddsMovement	,
			tgd.AwayLineMovement = smp.AwayLineMovement	,
			tgd.AwayLineOddsMovement = smp.AwayLineOddsMovement	,
			tgd.TotalScoreMovement = smp.TotalScoreMovement	,
			tgd.TotalScoreOverMovement = smp.TotalScoreOverMovement	,
			tgd.TotalScoreUnderMovement = smp.TotalScoreUnderMovement	,
			tgd.ImpliedProbabilityOutrightPick = smp.ImpliedProbabilityOutrightPick	,
			tgd.ImpliedProbabilityOutrightPickHomeAway = smp.ImpliedProbabilityOutrightPickHomeAway	,
			tgd.ImpliedProbabilityOutrightPickFavDog = smp.ImpliedProbabilityOutrightPickFavDog	,
			tgd.ImpliedProbabilityOutrightPickCorrect = smp.ImpliedProbabilityOutrightPickCorrect	, --Outright Best Pick Correct
			tgd.ImpliedProbabilityOutrightPickHACorrect = smp.ImpliedProbabilityOutrightPickHACorrect	, --Home/Away Pick Correct
			tgd.ImpliedProbabilityOutrightPickFDCorrect = smp.ImpliedProbabilityOutrightPickFDCorrect	, --Fav/Dog Pick Correct
			tgd.ImpliedProbabilitySpreadPick = smp.ImpliedProbabilitySpreadPick	,
			tgd.ImpliedProbabilitySpreadPickHomeAway = smp.ImpliedProbabilitySpreadPickHomeAway	,
			tgd.ImpliedProbabilitySpreadPickFavDog = smp.ImpliedProbabilitySpreadPickFavDog	,
			tgd.ImpliedProbabilitySpreadPickHACorrect = smp.ImpliedProbabilitySpreadPickHACorrect	,
			tgd.ImpliedProbabilitySpreadPickFDCorrect = smp.ImpliedProbabilitySpreadPickFDCorrect	,
			tgd.ImpliedProbabilitySpreadPickCorrect = smp.ImpliedProbabilitySpreadPickCorrect	,
			tgd.ImpliedProbabilityTotalPick = smp.ImpliedProbabilityTotalPick	,
			tgd.ImpliedProbabilityTotalPickCorrect = smp.ImpliedProbabilityTotalPickCorrect	,
			tgd.ImpliedProbabilityOutrightPickWager = smp.ImpliedProbabilityOutrightPickWager	,
			tgd.ImpliedProbabilityOutrightPickHomeAwayWager = smp.ImpliedProbabilityOutrightPickHomeAwayWager	,
			tgd.ImpliedProbabilityOutrightPickFavDogWager = smp.ImpliedProbabilityOutrightPickFavDogWager	,
			tgd.ImpliedProbabilitySpreadPickWager = smp.ImpliedProbabilitySpreadPickWager	,
			tgd.ImpliedProbabilitySpreadPickHomeAwayWager = smp.ImpliedProbabilitySpreadPickHomeAwayWager	,
			tgd.ImpliedProbabilitySpreadPickFavDogWager = smp.ImpliedProbabilitySpreadPickFavDogWager	,
			tgd.ImpliedProbabilityTotalPickWager = smp.ImpliedProbabilityTotalPickWager	,
			tgd.ImpliedProbabilityOutrightPickWagerProfit = smp.ImpliedProbabilityOutrightPickWagerProfit	,
			tgd.ImpliedProbabilityOutrightPickHomeAwayWagerProfit = smp.ImpliedProbabilityOutrightPickHomeAwayWagerProfit	,
			tgd.ImpliedProbabilityOutrightPickFavDogWagerProfit = smp.ImpliedProbabilityOutrightPickFavDogWagerProfit	,
			tgd.ImpliedProbabilitySpreadPickWagerProfit = smp.ImpliedProbabilitySpreadPickWagerProfit	,
			tgd.ImpliedProbabilitySpreadPickHomeAwayWagerProfit = smp.ImpliedProbabilitySpreadPickHomeAwayWagerProfit	,
			tgd.ImpliedProbabilitySpreadPickFavDogWagerProfit = smp.ImpliedProbabilitySpreadPickFavDogWagerProfit	,
			tgd.ImpliedProbabilityTotalPickWagerProfit = smp.ImpliedProbabilityTotalPickWagerProfit	,
			tgd.OneUnitThreshold = smp.OneUnitThreshold	,
			tgd.FiveUnitThreshold = smp.FiveUnitThreshold	,
			tgd.TenUnitThreshold = smp.TenUnitThreshold
		FROM @tempGameDataFull tgd
		CROSS APPLY ssf_ScheduleMakePicks (@tempGameDataFull) smp
		WHERE tgd.Season = @Year
		AND tgd.HomeTeam = smp.HomeTeam
		AND tgd.AwayTeam = smp.AwayTeam
		AND tgd.Season = smp.Season
		AND tgd.Week = smp.Week

		if @TestCode = 2
			BEGIN
				SELECT 'post-update variable table -', * FROM @tempGameDataFull
				select 'post-update function output -',* FROM ssf_ScheduleMakePicks (@tempGameDataFull) smp WHERE smp.Season = @Year
			END
		--Season Accuracy Calculation									    
		--Total Applicable
		/*Calculate floating point accuracy*/
		UPDATE #SeasonData SET ImpliedProbabilityOutrightFDTotApplicable = CAST((SELECT COUNT(*) FROM @tempGameDataFull WHERE ImpliedProbabilityOutrightPickFDCorrect IS NOT NULL AND Season = @Year) as DECIMAL(5,2))
		WHERE Season = @Year
		
		UPDATE #SeasonData SET ImpliedProbabilityOutrightHATotApplicable = CAST((SELECT COUNT(*) FROM @tempGameDataFull WHERE ImpliedProbabilityOutrightPickHACorrect IS NOT NULL AND Season = @Year) as DECIMAL(5,2))
		WHERE Season = @Year

		UPDATE #SeasonData SET ImpliedProbabilityOutrightPickTotApplicable = CAST((SELECT COUNT(*) FROM @tempGameDataFull WHERE ImpliedProbabilityOutrightPickCorrect IS NOT NULL AND Season = @Year) as DECIMAL(5,2))
		WHERE Season = @Year

		UPDATE #SeasonData SET ImpliedProbabilitySpreadFDTotApplicable = CAST((SELECT COUNT(*) FROM @tempGameDataFull WHERE ImpliedProbabilitySpreadPickFDCorrect IS NOT NULL AND Season = @Year) as DECIMAL(5,2))
		WHERE Season = @Year

		UPDATE #SeasonData SET ImpliedProbabilitySpreadHATotApplicable = CAST((SELECT COUNT(*) FROM @tempGameDataFull WHERE ImpliedProbabilitySpreadPickHACorrect IS NOT NULL AND Season = @Year) as DECIMAL(5,2))
		WHERE Season = @Year
		
		UPDATE #SeasonData SET ImpliedProbabilitySpreadPickTotApplicable = CAST((SELECT COUNT(*) FROM @tempGameDataFull WHERE ImpliedProbabilitySpreadPickCorrect IS NOT NULL AND Season = @Year) as DECIMAL(5,2))
		WHERE Season = @Year
		
		UPDATE #SeasonData SET ImpliedProbabilityTotalTotApplicable = CAST((SELECT COUNT(*) FROM @tempGameDataFull WHERE ImpliedProbabilityTotalPickCorrect IS NOT NULL AND Season = @Year) as DECIMAL(5,2))
		WHERE Season = @Year

		--Set Number Correct
		UPDATE #SeasonData SET ImpliedProbabilityOutrightFDNumCorrect = CAST((SELECT COUNT(*) FROM @tempGameDataFull WHERE ImpliedProbabilityOutrightPickFDCorrect = 'Y' AND Season = @Year) as DECIMAL(5,2))
		WHERE (SELECT COUNT(*) FROM @tempGameDataFull WHERE ImpliedProbabilityOutrightPickFDCorrect IS NOT NULL AND Season = @Year) <> 0
		AND Season = @Year
		
		UPDATE #SeasonData SET ImpliedProbabilityOutrightHANumCorrect = CAST((SELECT COUNT(*) FROM @tempGameDataFull WHERE ImpliedProbabilityOutrightPickHACorrect = 'Y' AND Season = @Year) as DECIMAL(5,2))
		WHERE (SELECT COUNT(*) FROM @tempGameDataFull WHERE ImpliedProbabilityOutrightPickHACorrect IS NOT NULL AND Season = @Year) <> 0
		AND Season = @Year

		UPDATE #SeasonData SET ImpliedProbabilityOutrightPickNumCorrect = CAST((SELECT COUNT(*) FROM @tempGameDataFull WHERE ImpliedProbabilityOutrightPickCorrect = 'Y' AND Season = @Year) as DECIMAL(5,2))
		WHERE (SELECT COUNT(*) FROM @tempGameDataFull WHERE ImpliedProbabilityOutrightPickCorrect IS NOT NULL AND Season = @Year) <> 0
		AND Season = @Year

		UPDATE #SeasonData SET ImpliedProbabilitySpreadFDNumCorrect = CAST((SELECT COUNT(*) FROM @tempGameDataFull WHERE ImpliedProbabilitySpreadPickFDCorrect = 'Y' AND Season = @Year) as DECIMAL(5,2))
		WHERE (SELECT COUNT(*) FROM @tempGameDataFull WHERE ImpliedProbabilitySpreadPickFDCorrect IS NOT NULL AND Season = @Year) <> 0
		AND Season = @Year

		UPDATE #SeasonData SET ImpliedProbabilitySpreadHANumCorrect = CAST((SELECT COUNT(*) FROM @tempGameDataFull WHERE ImpliedProbabilitySpreadPickHACorrect = 'Y' AND Season = @Year) as DECIMAL(5,2))
		WHERE (SELECT COUNT(*) FROM @tempGameDataFull WHERE ImpliedProbabilitySpreadPickHACorrect IS NOT NULL AND Season = @Year) <> 0
		AND Season = @Year
		
		UPDATE #SeasonData SET ImpliedProbabilitySpreadPickNumCorrect = CAST((SELECT COUNT(*) FROM @tempGameDataFull WHERE ImpliedProbabilitySpreadPickCorrect = 'Y' AND Season = @Year) as DECIMAL(5,2))
		WHERE (SELECT COUNT(*) FROM @tempGameDataFull WHERE ImpliedProbabilitySpreadPickCorrect IS NOT NULL AND Season = @Year) <> 0
		AND Season = @Year
		
		UPDATE #SeasonData SET ImpliedProbabilityTotalNumCorrect = CAST((SELECT COUNT(*) FROM @tempGameDataFull WHERE ImpliedProbabilityTotalPickCorrect = 'Y' AND Season = @Year) as DECIMAL(5,2))
		WHERE (SELECT COUNT(*) FROM @tempGameDataFull WHERE ImpliedProbabilityTotalPickCorrect IS NOT NULL AND Season = @Year) <> 0
		AND Season = @Year


		--Calculate floating point accuracy
		UPDATE #SeasonData SET ImpliedProbabilityOutrightFDAccuracy = ISNULL(ImpliedProbabilityOutrightFDNumCorrect,0)/ISNULL(NULLIF(ImpliedProbabilityOutrightFDTotApplicable,0),1)
		WHERE Season = @Year
		
		UPDATE #SeasonData SET ImpliedProbabilityOutrightHAAccuracy = ISNULL(ImpliedProbabilityOutrightHANumCorrect,0)/ISNULL(NULLIF(ImpliedProbabilityOutrightHATotApplicable,0),1)
		WHERE Season = @Year

		UPDATE #SeasonData SET ImpliedProbabilityOutrightPickAccuracy = ISNULL(ImpliedProbabilityOutrightPickNumCorrect,0)/ISNULL(NULLIF(ImpliedProbabilityOutrightPickTotApplicable,0),1)
		WHERE Season = @Year

		UPDATE #SeasonData SET ImpliedProbabilitySpreadFDAccuracy = ISNULL(ImpliedProbabilitySpreadFDNumCorrect,0)/ISNULL(NULLIF(ImpliedProbabilitySpreadFDTotApplicable,0),1)
		WHERE Season = @Year

		UPDATE #SeasonData SET ImpliedProbabilitySpreadHAAccuracy = ISNULL(ImpliedProbabilitySpreadHANumCorrect,0)/ISNULL(NULLIF(ImpliedProbabilitySpreadHATotApplicable,0),1)
		WHERE Season = @Year

		UPDATE #SeasonData SET ImpliedProbabilitySpreadPickAccuracy = ISNULL(ImpliedProbabilitySpreadPickNumCorrect,0)/ISNULL(NULLIF(ImpliedProbabilitySpreadPickTotApplicable,0),1)
		WHERE Season = @Year

		UPDATE #SeasonData SET ImpliedProbabilityTotalAccuracy = ISNULL(ImpliedProbabilityTotalNumCorrect,0)/ISNULL(NULLIF(ImpliedProbabilityTotalTotApplicable,0),1)
		WHERE Season = @Year
		


		FETCH NEXT FROM year_cur INTO @Season
		END
			
			IF @TestCode = 1 OR @TestCode = 2
			BEGIN
				select 'HomeOddsCloseIP Error',* from @tempGameDataFull
				WHERE (HomeOddsCloseIP IS NULL AND (HomeOddsClose IS NOT NULL OR HomeOddsMax IS NOT NULL OR HomeOddsMin IS NOT NULL OR HomeOddsOpen IS NOT NULL))
				UNION ALL
				select 'AwayOddsCloseIP Error',* from @tempGameDataFull
				WHERE (AwayOddsCloseIP IS NULL AND (AwayOddsClose IS NOT NULL OR AwayOddsMax IS NOT NULL OR AwayOddsMin IS NOT NULL OR AwayOddsOpen IS NOT NULL))
				UNION ALL
				select 'HomeLineOddsCloseIP Error',* from @tempGameDataFull
				WHERE (HomeLineOddsCloseIP IS NULL AND (HomeLineOddsClose IS NOT NULL OR HomeLineOddsMax IS NOT NULL OR HomeLineOddsMin IS NOT NULL OR HomeLineOddsOpen IS NOT NULL))
				UNION ALL
				select 'AwayLineOddsCloseIP Error',* from @tempGameDataFull
				WHERE (AwayLineOddsCloseIP IS NULL AND (AwayLineOddsClose IS NOT NULL OR AwayLineOddsMax IS NOT NULL OR AwayLineOddsMin IS NOT NULL OR AwayLineOddsOpen IS NOT NULL))
				UNION ALL
				select 'TotalScoreOverCloseIP Error',* from @tempGameDataFull
				WHERE (TotalScoreOverCloseIP IS NULL AND (TotalScoreOverClose IS NOT NULL OR TotalScoreOverMax IS NOT NULL OR TotalScoreOverMin IS NOT NULL OR TotalScoreOverOpen IS NOT NULL))
				UNION ALL
				select 'TotalScoreUnderCloseIP Error',* from @tempGameDataFull
				WHERE (TotalScoreUnderCloseIP IS NULL AND (TotalScoreUnderClose IS NOT NULL OR TotalScoreUnderMax IS NOT NULL OR TotalScoreUnderMin IS NOT NULL OR TotalScoreUnderOpen IS NOT NULL))
				UNION ALL
				select 'HomeOddsCloseDevig Error',* from @tempGameDataFull
				WHERE (HomeOddsCloseDevig IS NULL AND (HomeOddsClose IS NOT NULL OR HomeOddsMax IS NOT NULL OR HomeOddsMin IS NOT NULL OR HomeOddsOpen IS NOT NULL))
				UNION ALL
				select 'AwayOddsCloseDevig Error',* from @tempGameDataFull
				WHERE (AwayOddsCloseDevig IS NULL AND (AwayOddsClose IS NOT NULL OR AwayOddsMax IS NOT NULL OR AwayOddsMin IS NOT NULL OR AwayOddsOpen IS NOT NULL))
				UNION ALL
				select 'HomeLineOddsCloseDevig Error',* from @tempGameDataFull
				WHERE (HomeLineOddsCloseDevig IS NULL AND (HomeLineOddsClose IS NOT NULL OR HomeLineOddsMax IS NOT NULL OR HomeLineOddsMin IS NOT NULL OR HomeLineOddsOpen IS NOT NULL))
				UNION ALL
				select 'AwayLineOddsCloseDevig Error',* from @tempGameDataFull
				WHERE (AwayLineOddsCloseDevig IS NULL AND (AwayLineOddsClose IS NOT NULL OR AwayLineOddsMax IS NOT NULL OR AwayLineOddsMin IS NOT NULL OR AwayLineOddsOpen IS NOT NULL))
				UNION ALL
				select 'TotalScoreOverCloseDevig Error',* from @tempGameDataFull
				WHERE (TotalScoreOverCloseDevig IS NULL AND (TotalScoreOverClose IS NOT NULL OR TotalScoreOverMax IS NOT NULL OR TotalScoreOverMin IS NOT NULL OR TotalScoreOverOpen IS NOT NULL))
				UNION ALL
				select 'TotalScoreUnderCloseDevig Error',* from @tempGameDataFull
				WHERE (TotalScoreUnderCloseDevig IS NULL AND (TotalScoreUnderClose IS NOT NULL OR TotalScoreUnderMax IS NOT NULL OR TotalScoreUnderMin IS NOT NULL OR TotalScoreUnderOpen IS NOT NULL))
				UNION ALL
				select 'Outright Pick Error',* from @tempGameDataFull
				WHERE (ImpliedProbabilityOutrightPickCorrect IS NULL AND ImpliedProbabilityOutrightPick IS NOT NULL)
				UNION ALL
				select 'Outright FD Pick Error',* from @tempGameDataFull
				WHERE (ImpliedProbabilityOutrightPickFavDog IS NULL AND ImpliedProbabilityOutrightPickFDCorrect IS NOT NULL)
				UNION ALL
				select 'Outright HA Pick Error',* from @tempGameDataFull
				WHERE (ImpliedProbabilityOutrightPickHomeAway IS NULL AND ImpliedProbabilityOutrightPickHACorrect IS NOT NULL)
				UNION ALL
				select 'Spread Pick Error',* from @tempGameDataFull
				WHERE (ImpliedProbabilitySpreadPick IS NULL AND ImpliedProbabilitySpreadPickCorrect IS NOT NULL)
				UNION ALL
				select 'Spread Pick FD Error',* from @tempGameDataFull
				WHERE (ImpliedProbabilitySpreadPickFavDog IS NULL AND ImpliedProbabilitySpreadPickFDCorrect IS NOT NULL)
				UNION ALL
				select 'Spread Pick HA Error',* from @tempGameDataFull
				WHERE (ImpliedProbabilitySpreadPickHomeAway IS NULL AND ImpliedProbabilitySpreadPickHACorrect IS NOT NULL)
				UNION ALL
				select 'Total Pick Error',* from @tempGameDataFull
				WHERE (ImpliedProbabilityTotalPick IS NULL AND ImpliedProbabilityTotalPickCorrect IS NOT NULL)

				UNION ALL

				select 'Outright Pick Wager Error',* from @tempGameDataFull
				WHERE (ImpliedProbabilityOutrightPickWager IS NULL AND ImpliedProbabilityOutrightPickWagerProfit IS NOT NULL) OR (ImpliedProbabilityOutrightPickWager IS NOT NULL AND ImpliedProbabilityOutrightPickWagerProfit IS NULL)
				UNION ALL
				select 'Outright FD Pick Wager Error',* from @tempGameDataFull
				WHERE (ImpliedProbabilityOutrightPickFavDogWager IS NULL AND ImpliedProbabilityOutrightPickFavDogWagerProfit IS NOT NULL) OR (ImpliedProbabilityOutrightPickFavDogWager IS NOT NULL AND ImpliedProbabilityOutrightPickFavDogWagerProfit IS NULL)
				UNION ALL
				select 'Outright HA Pick Wager Error',* from @tempGameDataFull
				WHERE (ImpliedProbabilityOutrightPickHomeAwayWager IS NULL AND ImpliedProbabilityOutrightPickHomeAwayWagerProfit IS NOT NULL) OR (ImpliedProbabilityOutrightPickHomeAwayWager IS NOT NULL AND ImpliedProbabilityOutrightPickHomeAwayWagerProfit IS NULL)
				UNION ALL
				select 'Spread Pick Wager Error',* from @tempGameDataFull
				WHERE (ImpliedProbabilitySpreadPickWager IS NULL AND ImpliedProbabilitySpreadPickWagerProfit IS NOT NULL) OR (ImpliedProbabilitySpreadPickWager IS NOT NULL AND ImpliedProbabilitySpreadPickWagerProfit IS NULL)
				UNION ALL
				select 'Spread Pick FD Wager Error',* from @tempGameDataFull
				WHERE (ImpliedProbabilitySpreadPickFavDogWager IS NULL AND ImpliedProbabilitySpreadPickFavDogWagerProfit IS NOT NULL) OR (ImpliedProbabilitySpreadPickFavDogWager IS NOT NULL AND ImpliedProbabilitySpreadPickFavDogWagerProfit IS NULL)
				UNION ALL
				select 'Spread Pick HA Wager Error',* from @tempGameDataFull
				WHERE (ImpliedProbabilitySpreadPickHomeAwayWager IS NULL AND ImpliedProbabilitySpreadPickHomeAwayWagerProfit IS NOT NULL) OR (ImpliedProbabilitySpreadPickHomeAwayWager IS NOT NULL AND ImpliedProbabilitySpreadPickHomeAwayWagerProfit IS NULL)
				UNION ALL
				select 'Total Pick Wager Error',* from @tempGameDataFull
				WHERE (ImpliedProbabilityTotalPickWager IS NULL AND ImpliedProbabilityTotalPickWagerProfit IS NOT NULL) OR (ImpliedProbabilityTotalPickWager IS NOT NULL AND ImpliedProbabilityTotalPickWagerProfit IS NULL)



			END
			--IF @TestCode = 2
			--select * from @tempGameDataFull

			--IF @TestCode = 2
			--select   sd.Season				
			--		/*Summary Data*/
			--		,gd.SeasonWager
			--		,gd.SeasonProfit
			--		,@OneUnitThreshold
			--		,@FiveUnitThreshold
			--		,@TenUnitThreshold
			--		,gd.SeasonProfit / ISNULL(NULLIF(gd.SeasonWager,0),1) as SeasonROI
			--		/*Regular Columns*/
			--		,SeasonTotalUnderRate			
			--		,SeasonTotalPushRate			
			--		,SeasonTotalOverRate			
			--		,HomeUnderdogSpreadCoverRate	
			--		,HomeFavoriteSpreadCoverRate	
			--		,AwayUnderdogSpreadCoverRate	
			--		,AwayFavoriteSpreadCoverRate	
			--		,HomeSpreadCoverRate			
			--		,AwaySpreadCoverRate			
			--		,FavoriteSpreadCoverRate		
			--		,DogSpreadCoverRate				
			--		,HomeUnderdogOutrightRate		
			--		,HomeFavoriteOutrightRate		
			--		,AwayUnderdogOutrightRate		
			--		,AwayFavoriteOutrightRate		
			--		,HomeOutrightRate				
			--		,AwayOutrightRate				
			--		,FavoriteOutrightRate			
			--		,DogOutrightRate			
			--		--Outright Home/Away
			--		,ImpliedProbabilityOutrightHANumCorrect 
			--		,ImpliedProbabilityOutrightHATotApplicable
			--		,ImpliedProbabilityOutrightHAAccuracy 
			--		,gd.ImpliedProbabilityOutrightPickHomeAwayProfit
			--		--Outright Favorite/Underdog
			--		,ImpliedProbabilityOutrightFDNumCorrect 
			--		,ImpliedProbabilityOutrightFDTotApplicable 
			--		,ImpliedProbabilityOutrightFDAccuracy 
			--		,gd.ImpliedProbabilityOutrightFavDogProfit
			--		--Outright Pick
			--		,ImpliedProbabilityOutrightPickNumCorrect 
			--		,ImpliedProbabilityOutrightPickTotApplicable 
			--		,ImpliedProbabilityOutrightPickAccuracy 
			--		,gd.ImpliedProbabilityOutrightPickProfit
			--		--Spread Home/Away
			--		,ImpliedProbabilitySpreadHANumCorrect 
			--		,ImpliedProbabilitySpreadHATotApplicable 
			--		,ImpliedProbabilitySpreadHAAccuracy 
			--		,gd.ImpliedProbabilitySpreadPickHomeAwayProfit
			--		--Spread Favorite/Underdog
			--		,ImpliedProbabilitySpreadFDNumCorrect 
			--		,ImpliedProbabilitySpreadFDTotApplicable
			--		,ImpliedProbabilitySpreadFDAccuracy
			--		,gd.ImpliedProbabilitySpreadPickFavDogProfit
			--		--Spread Pick
			--		,ImpliedProbabilitySpreadPickNumCorrect 
			--		,ImpliedProbabilitySpreadPickTotApplicable 
			--		,ImpliedProbabilitySpreadPickAccuracy 
			--		,gd.ImpliedProbabilitySpreadPickProfit
			--		--Total O/U
			--		,ImpliedProbabilityTotalNumCorrect 
			--		,ImpliedProbabilityTotalTotApplicable 
			--		,ImpliedProbabilityTotalAccuracy 
			--		,gd.ImpliedProbabilityTotalPickProfit
			--	from #SeasonData sd
			--	JOIN (Select Season
			--				,SUM(COALESCE(ImpliedProbabilitySpreadPickFavDogWager,0)) as ImpliedProbabilitySpreadPickFavDogWager
			--				,SUM(COALESCE(ImpliedProbabilitySpreadPickWager,0)) as ImpliedProbabilitySpreadPickWager
			--				,SUM(COALESCE(ImpliedProbabilityTotalPickWager,0))as ImpliedProbabilityTotalPickWager
			--				,SUM(COALESCE(ImpliedProbabilitySpreadPickHomeAwayWager,0)) as ImpliedProbabilitySpreadPickHomeAwayWager
			--				,SUM(COALESCE(ImpliedProbabilityOutrightPickWager,0)) as ImpliedProbabilityOutrightPickWager
			--				,SUM(COALESCE(ImpliedProbabilityOutrightPickFavDogWager,0)) as ImpliedProbabilityOutrightFavDogWager
			--				,SUM(COALESCE(ImpliedProbabilityOutrightPickHomeAwayWager,0)) as ImpliedProbabilityOutrightPickHomeAwayWager
			--				,SUM(COALESCE(ImpliedProbabilitySpreadPickFavDogWagerProfit,0)) as ImpliedProbabilitySpreadPickFavDogProfit
			--				,SUM(COALESCE(ImpliedProbabilitySpreadPickWagerProfit,0)) as ImpliedProbabilitySpreadPickProfit
			--				,SUM(COALESCE(ImpliedProbabilityTotalPickWagerProfit,0))as ImpliedProbabilityTotalPickProfit
			--				,SUM(COALESCE(ImpliedProbabilitySpreadPickHomeAwayWagerProfit,0)) as ImpliedProbabilitySpreadPickHomeAwayProfit
			--				,SUM(COALESCE(ImpliedProbabilityOutrightPickWagerProfit,0)) as ImpliedProbabilityOutrightPickProfit
			--				,SUM(COALESCE(ImpliedProbabilityOutrightPickFavDogWagerProfit,0)) as ImpliedProbabilityOutrightFavDogProfit
			--				,SUM(COALESCE(ImpliedProbabilityOutrightPickHomeAwayWagerProfit,0)) as ImpliedProbabilityOutrightPickHomeAwayProfit
			--				,SUM(COALESCE(ImpliedProbabilityOutrightPickWager,0)) + SUM(COALESCE(ImpliedProbabilitySpreadPickWager,0)) + SUM(COALESCE(ImpliedProbabilityTotalPickWager,0)) as SeasonWager
			--				,SUM(COALESCE(ImpliedProbabilityOutrightPickWagerProfit,0)) + SUM(COALESCE(ImpliedProbabilitySpreadPickWagerProfit,0)) + SUM(COALESCE(ImpliedProbabilityTotalPickWagerProfit,0)) as SeasonProfit
			--		 FROM @tempGameDataFull GROUP BY Season) gd ON gd.Season = sd.Season
			--	ORDER BY sd.Season ASC

				select   sd.Season				
					/*Summary Data*/
					,@OneUnitThreshold
					,@FiveUnitThreshold
					,@TenUnitThreshold
					,gd.SeasonProfit / ISNULL(NULLIF(gd.SeasonWager,0),1) as SeasonROI
					,gd.SeasonProfit as SeasonProfit
					,gd.SeasonWager  as SeasonWager
				from #SeasonData sd
				JOIN (Select Season
							--,SUM(COALESCE(ImpliedProbabilitySpreadPickFavDogWager,0.00)) as ImpliedProbabilitySpreadPickFavDogWager
							--,SUM(COALESCE(ImpliedProbabilitySpreadPickWager,0.00)) as ImpliedProbabilitySpreadPickWager
							--,SUM(COALESCE(ImpliedProbabilityTotalPickWager,0.00))as ImpliedProbabilityTotalPickWager
							--,SUM(COALESCE(ImpliedProbabilitySpreadPickHomeAwayWager,0.00)) as ImpliedProbabilitySpreadPickHomeAwayWager
							--,SUM(COALESCE(ImpliedProbabilityOutrightPickWager,0.00)) as ImpliedProbabilityOutrightPickWager
							--,SUM(COALESCE(ImpliedProbabilityOutrightPickFavDogWager,0.00)) as ImpliedProbabilityOutrightFavDogWager
							--,SUM(COALESCE(ImpliedProbabilityOutrightPickHomeAwayWager,0.00)) as ImpliedProbabilityOutrightPickHomeAwayWager
							--,SUM(COALESCE(ImpliedProbabilitySpreadPickFavDogWagerProfit,0.00)) as ImpliedProbabilitySpreadPickFavDogProfit
							--,SUM(COALESCE(ImpliedProbabilitySpreadPickWagerProfit,0.00)) as ImpliedProbabilitySpreadPickProfit
							--,SUM(COALESCE(ImpliedProbabilityTotalPickWagerProfit,0.00))as ImpliedProbabilityTotalPickProfit
							--,SUM(COALESCE(ImpliedProbabilitySpreadPickHomeAwayWagerProfit,0.00)) as ImpliedProbabilitySpreadPickHomeAwayProfit
							--,SUM(COALESCE(ImpliedProbabilityOutrightPickWagerProfit,0.00)) as ImpliedProbabilityOutrightPickProfit
							--,SUM(COALESCE(ImpliedProbabilityOutrightPickFavDogWagerProfit,0.00)) as ImpliedProbabilityOutrightFavDogProfit
							--,SUM(COALESCE(ImpliedProbabilityOutrightPickHomeAwayWagerProfit,0.00)) as ImpliedProbabilityOutrightPickHomeAwayProfit
							,SUM(COALESCE(ImpliedProbabilityOutrightPickWager,0.00)) + SUM(COALESCE(ImpliedProbabilitySpreadPickWager,0.00)) + SUM(COALESCE(ImpliedProbabilityTotalPickWager,0.00)) as SeasonWager
							,SUM(COALESCE(ImpliedProbabilityOutrightPickWagerProfit,0.00)) + SUM(COALESCE(ImpliedProbabilitySpreadPickWagerProfit,0.00)) + SUM(COALESCE(ImpliedProbabilityTotalPickWagerProfit,0.00)) as SeasonProfit
					 FROM @tempGameDataFull GROUP BY Season) gd ON gd.Season = sd.Season
				ORDER BY sd.Season ASC

			--Cache results for PowerBI usage
			UPDATE s SET  			
					/*Summary Data*/
					s.SeasonImpliedProbabilityWager = gd.SeasonWager
					,s.SeasonImpliedProbabilityProfit = gd.SeasonProfit
					,SeasonImpliedProbabilityROI = ISNULL(gd.SeasonProfit,0) / ISNULL(NULLIF(gd.SeasonWager,0),1)
					/*Regular Columns*/
					,s.SeasonTotalUnderRate = sd.SeasonTotalUnderRate			
					,s.SeasonTotalPushRate	= sd.SeasonTotalPushRate			
					,s.SeasonTotalOverRate = sd.SeasonTotalOverRate			
					,s.HomeUnderdogSpreadCoverRate	= sd.HomeUnderdogSpreadCoverRate	
					,s.HomeFavoriteSpreadCoverRate	= sd.HomeFavoriteSpreadCoverRate	
					,s.AwayUnderdogSpreadCoverRate	= sd.AwayUnderdogSpreadCoverRate	
					,s.AwayFavoriteSpreadCoverRate	= sd.AwayFavoriteSpreadCoverRate	
					,s.HomeSpreadCoverRate = sd.HomeSpreadCoverRate			
					,s.AwaySpreadCoverRate = sd.AwaySpreadCoverRate			
					,s.FavoriteSpreadCoverRate = sd.FavoriteSpreadCoverRate
					,s.DogSpreadCoverRate = sd.DogSpreadCoverRate				
					,s.HomeUnderdogOutrightRate = sd.HomeUnderdogOutrightRate
					,s.HomeFavoriteOutrightRate = sd.HomeFavoriteOutrightRate
					,s.AwayUnderdogOutrightRate	= sd.AwayUnderdogOutrightRate	
					,s.AwayFavoriteOutrightRate	= sd.AwayFavoriteOutrightRate	
					,s.HomeOutrightRate = sd.HomeOutrightRate	
					,s.AwayOutrightRate	= sd.AwayOutrightRate				
					,s.FavoriteOutrightRate	= sd.FavoriteOutrightRate	
					,s.DogOutrightRate = sd.DogOutrightRate		
					--Outright Home/Away
					,s.ImpliedProbabilityOutrightHANumCorrect = sd.ImpliedProbabilityOutrightHANumCorrect 
					,s.ImpliedProbabilityOutrightHATotApplicable = sd.ImpliedProbabilityOutrightHATotApplicable
					,s.ImpliedProbabilityOutrightHAAccuracy = TRY_CAST(sd.ImpliedProbabilityOutrightHAAccuracy as DECIMAL(5,2))
					,s.ImpliedProbabilityOutrightHAProfit = TRY_CAST(sd.ImpliedProbabilityOutrightHAProfit as DECIMAL(5,2))
					--Outright Favorite/Underdog
					,s.ImpliedProbabilityOutrightFDNumCorrect = sd.ImpliedProbabilityOutrightFDNumCorrect 
					,s.ImpliedProbabilityOutrightFDTotApplicable = sd.ImpliedProbabilityOutrightFDTotApplicable 
					,s.ImpliedProbabilityOutrightFDAccuracy = TRY_CAST(sd.ImpliedProbabilityOutrightFDAccuracy as DECIMAL(5,2))
					,s.ImpliedProbabilityOutrightFDProfit = TRY_CAST(gd.ImpliedProbabilityOutrightFavDogProfit as DECIMAL(5,2))
					--Outright Pick
					,s.ImpliedProbabilityOutrightPickNumCorrect = sd.ImpliedProbabilityOutrightPickNumCorrect 
					,s.ImpliedProbabilityOutrightPickTotApplicable  = sd.ImpliedProbabilityOutrightPickTotApplicable 
					,s.ImpliedProbabilityOutrightPickAccuracy  = TRY_CAST(sd.ImpliedProbabilityOutrightPickAccuracy as DECIMAL(5,2))
					,s.ImpliedProbabilityOutrightPickProfit = TRY_CAST(gd.ImpliedProbabilityOutrightPickProfit as DECIMAL(5,2))
					--Spread Home/Away
					,s.ImpliedProbabilitySpreadHANumCorrect = sd.ImpliedProbabilitySpreadHANumCorrect 
					,s.ImpliedProbabilitySpreadHATotApplicable  = sd.ImpliedProbabilitySpreadHATotApplicable 
					,s.ImpliedProbabilitySpreadHAAccuracy = TRY_CAST(sd.ImpliedProbabilitySpreadHAAccuracy  as DECIMAL(5,2))
					,s.ImpliedProbabilitySpreadHAProfit = TRY_CAST(gd.ImpliedProbabilitySpreadPickHomeAwayProfit as DECIMAL(5,2))
					--Spread Favorite/Underdog
					,s.ImpliedProbabilitySpreadFDNumCorrect = sd.ImpliedProbabilitySpreadFDNumCorrect 
					,s.ImpliedProbabilitySpreadFDTotApplicable = sd.ImpliedProbabilitySpreadFDTotApplicable
					,s.ImpliedProbabilitySpreadFDAccuracy = TRY_CAST(sd.ImpliedProbabilitySpreadFDAccuracy as DECIMAL(5,2))
					,s.ImpliedProbabilitySpreadFDProfit = TRY_CAST(gd.ImpliedProbabilitySpreadPickFavDogProfit as DECIMAL(5,2))
					--Spread Pick
					,s.ImpliedProbabilitySpreadPickNumCorrect = sd.ImpliedProbabilitySpreadPickNumCorrect 
					,s.ImpliedProbabilitySpreadPickTotApplicable = sd.ImpliedProbabilitySpreadPickTotApplicable 
					,s.ImpliedProbabilitySpreadPickAccuracy = TRY_CAST(sd.ImpliedProbabilitySpreadPickAccuracy as DECIMAL(5,2)) 
					,s.ImpliedProbabilitySpreadPickProfit = TRY_CAST(gd.ImpliedProbabilitySpreadPickProfit as DECIMAL(5,2))
					--Total O/U
					,s.ImpliedProbabilityTotalNumCorrect = sd.ImpliedProbabilityTotalNumCorrect 
					,s.ImpliedProbabilityTotalTotApplicable = sd.ImpliedProbabilityTotalTotApplicable 
					,s.ImpliedProbabilityTotalAccuracy = TRY_CAST(sd.ImpliedProbabilityTotalAccuracy as DECIMAL(5,2))
					,s.ImpliedProbabilityTotalProfit = TRY_CAST(gd.ImpliedProbabilityTotalPickProfit as DECIMAL(5,2))
				from Seasons s
				JOIN #SeasonData sd ON s.Season = sd.Season
				JOIN (Select Season
							,SUM(COALESCE(ImpliedProbabilitySpreadPickFavDogWager,0)) as ImpliedProbabilitySpreadPickFavDogWager
							,SUM(COALESCE(ImpliedProbabilitySpreadPickWager,0)) as ImpliedProbabilitySpreadPickWager
							,SUM(COALESCE(ImpliedProbabilityTotalPickWager,0))as ImpliedProbabilityTotalPickWager
							,SUM(COALESCE(ImpliedProbabilitySpreadPickHomeAwayWager,0)) as ImpliedProbabilitySpreadPickHomeAwayWager
							,SUM(COALESCE(ImpliedProbabilityOutrightPickWager,0)) as ImpliedProbabilityOutrightPickWager
							,SUM(COALESCE(ImpliedProbabilityOutrightPickFavDogWager,0)) as ImpliedProbabilityOutrightFavDogWager
							,SUM(COALESCE(ImpliedProbabilityOutrightPickHomeAwayWager,0)) as ImpliedProbabilityOutrightPickHomeAwayWager
							,SUM(COALESCE(ImpliedProbabilitySpreadPickFavDogWagerProfit,0)) as ImpliedProbabilitySpreadPickFavDogProfit
							,SUM(COALESCE(ImpliedProbabilitySpreadPickWagerProfit,0)) as ImpliedProbabilitySpreadPickProfit
							,SUM(COALESCE(ImpliedProbabilityTotalPickWagerProfit,0))as ImpliedProbabilityTotalPickProfit
							,SUM(COALESCE(ImpliedProbabilitySpreadPickHomeAwayWagerProfit,0)) as ImpliedProbabilitySpreadPickHomeAwayProfit
							,SUM(COALESCE(ImpliedProbabilityOutrightPickWagerProfit,0)) as ImpliedProbabilityOutrightPickProfit
							,SUM(COALESCE(ImpliedProbabilityOutrightPickFavDogWagerProfit,0)) as ImpliedProbabilityOutrightFavDogProfit
							,SUM(COALESCE(ImpliedProbabilityOutrightPickHomeAwayWagerProfit,0)) as ImpliedProbabilityOutrightPickHomeAwayProfit
							,SUM(COALESCE(ImpliedProbabilityOutrightPickWager,0)) + SUM(COALESCE(ImpliedProbabilitySpreadPickWager,0)) + SUM(COALESCE(ImpliedProbabilityTotalPickWager,0)) as SeasonWager
							,SUM(COALESCE(ImpliedProbabilityOutrightPickWagerProfit,0)) + SUM(COALESCE(ImpliedProbabilitySpreadPickWagerProfit,0)) + SUM(COALESCE(ImpliedProbabilityTotalPickWagerProfit,0)) as SeasonProfit
					 FROM @tempGameDataFull GROUP BY Season) gd ON gd.Season = sd.Season
				
			UPDATE gd SET 
				HomeOddsClose = COALESCE(tgd.HomeOddsClose,tgd.HomeOddsMax,tgd.HomeOddsOpen)				
			,	AwayOddsClose = COALESCE(tgd.AwayOddsClose,tgd.AwayOddsMax,tgd.AwayOddsOpen)				
			,	HomeLineClose = COALESCE(tgd.HomeLineClose,tgd.HomeLineMax,tgd.HomeLineOpen)					
			,	AwayLineClose = COALESCE(tgd.AwayLineClose,tgd.AwayLineMax,tgd.AwayLineOpen)					
			,	HomeLineOddsClose = COALESCE(tgd.HomeLineOddsClose,tgd.HomeLineOddsMax,tgd.HomeLineOddsOpen)				
			,	AwayLineOddsClose = COALESCE(tgd.AwayLineOddsClose,tgd.AwayLineOddsMax,tgd.AwayLineOddsOpen)				
			,	TotalScoreClose = COALESCE(tgd.TotalScoreClose,tgd.TotalScoreMax,tgd.TotalScoreOpen)				
			,	gd.TotalScoreOverClose = tgd.TotalScoreOverClose				
			,	gd.TotalScoreUnderClose = tgd.TotalScoreUnderClose			
				/*Betting Report Only*/
			,	gd.ImpliedProbabilityOutrightPick = tgd.ImpliedProbabilityOutrightPick		
			,	gd.ImpliedProbabilityOutrightPickCorrect = tgd.ImpliedProbabilityOutrightPickCorrect
			,	gd.ImpliedProbabilityOutrightPickWager = tgd.ImpliedProbabilityOutrightPickWager	
			,	gd.ImpliedProbabilityOutrightPickWagerProfit = tgd.ImpliedProbabilityOutrightPickWagerProfit	
			,	gd.ImpliedProbabilityOutrightPickHomeAway = tgd.ImpliedProbabilityOutrightPickHomeAway	
			,	gd.ImpliedProbabilityOutrightPickHACorrect = tgd.ImpliedProbabilityOutrightPickHACorrect	
			,	gd.ImpliedProbabilityOutrightPickHomeAwayWager = tgd.ImpliedProbabilityOutrightPickHomeAwayWager	
			,	gd.ImpliedProbabilityOutrightPickHomeAwayWagerProfit = tgd.ImpliedProbabilityOutrightPickHomeAwayWagerProfit	
			,	gd.ImpliedProbabilityOutrightPickFavDog = tgd.ImpliedProbabilityOutrightPickFavDog	
			,	gd.ImpliedProbabilityOutrightPickFDCorrect = tgd.ImpliedProbabilityOutrightPickFDCorrect	
			,	gd.ImpliedProbabilityOutrightPickFavDogWager = tgd.ImpliedProbabilityOutrightPickFavDogWager
			,	gd.ImpliedProbabilitySpreadPick = tgd.ImpliedProbabilitySpreadPick	
			,	gd.ImpliedProbabilitySpreadPickCorrect = tgd.ImpliedProbabilitySpreadPickCorrect	
			,	gd.ImpliedProbabilitySpreadPickWager = tgd.ImpliedProbabilitySpreadPickWager	
			,	gd.ImpliedProbabilitySpreadPickWagerProfit = tgd.ImpliedProbabilitySpreadPickWagerProfit	
			,	gd.ImpliedProbabilitySpreadPickHomeAway = tgd.ImpliedProbabilitySpreadPickHomeAway	
			,	gd.ImpliedProbabilitySpreadPickHACorrect = tgd.ImpliedProbabilitySpreadPickHACorrect
			,	gd.ImpliedProbabilitySpreadPickHomeAwayWager = tgd.ImpliedProbabilitySpreadPickHomeAwayWager	
			,	gd.ImpliedProbabilitySpreadPickHomeAwayWagerProfit = tgd.ImpliedProbabilitySpreadPickHomeAwayWagerProfit	
			,	gd.ImpliedProbabilitySpreadPickFavDog = tgd.ImpliedProbabilitySpreadPickFavDog		
			,	gd.ImpliedProbabilitySpreadPickFDCorrect = tgd.ImpliedProbabilitySpreadPickFDCorrect	
			,	gd.ImpliedProbabilitySpreadPickFavDogWager = tgd.ImpliedProbabilitySpreadPickFavDogWager		
			,	gd.ImpliedProbabilityOutrightPickFavDogWagerProfit = tgd.ImpliedProbabilityOutrightPickFavDogWagerProfit	
			,	gd.ImpliedProbabilityTotalPick = tgd.ImpliedProbabilityTotalPick				
			,	gd.ImpliedProbabilityTotalPickCorrect = tgd.ImpliedProbabilityTotalPickCorrect		
			,	gd.ImpliedProbabilityTotalPickWager = tgd.ImpliedProbabilityTotalPickWager					
			,	gd.ImpliedProbabilityTotalPickWagerProfit = tgd.ImpliedProbabilityTotalPickWagerProfit		
			from GameData gd
			JOIN @tempGameDataFull tgd ON tgd.Season = gd.Season AND tgd.HomeTeam = gd.HomeTeam AND tgd.AwayTeam = gd.AwayTeam AND tgd.Week = gd.Week
			
			
			
			INSERT INTO SeasonDataAggregateCache (Season, SeasonWager, SeasonProfit, OneUnitThreshold, FiveUnitThreshold, TenUnitThreshold)
			SELECT sd.Season, gd.SeasonWager, gd.SeasonProfit, @OneUnitThreshold, @FiveUnitThreshold, @TenUnitThreshold
			FROM #SeasonData sd
			JOIN (Select Season
							,SUM(COALESCE(ImpliedProbabilitySpreadPickFavDogWager,0)) as ImpliedProbabilitySpreadPickFavDogWager
							,SUM(COALESCE(ImpliedProbabilitySpreadPickWager,0)) as ImpliedProbabilitySpreadPickWager
							,SUM(COALESCE(ImpliedProbabilityTotalPickWager,0))as ImpliedProbabilityTotalPickWager
							,SUM(COALESCE(ImpliedProbabilitySpreadPickHomeAwayWager,0)) as ImpliedProbabilitySpreadPickHomeAwayWager
							,SUM(COALESCE(ImpliedProbabilityOutrightPickWager,0)) as ImpliedProbabilityOutrightPickWager
							,SUM(COALESCE(ImpliedProbabilityOutrightPickFavDogWager,0)) as ImpliedProbabilityOutrightFavDogWager
							,SUM(COALESCE(ImpliedProbabilityOutrightPickHomeAwayWager,0)) as ImpliedProbabilityOutrightPickHomeAwayWager
							,SUM(COALESCE(ImpliedProbabilitySpreadPickFavDogWagerProfit,0)) as ImpliedProbabilitySpreadPickFavDogProfit
							,SUM(COALESCE(ImpliedProbabilitySpreadPickWagerProfit,0)) as ImpliedProbabilitySpreadPickProfit
							,SUM(COALESCE(ImpliedProbabilityTotalPickWagerProfit,0))as ImpliedProbabilityTotalPickProfit
							,SUM(COALESCE(ImpliedProbabilitySpreadPickHomeAwayWagerProfit,0)) as ImpliedProbabilitySpreadPickHomeAwayProfit
							,SUM(COALESCE(ImpliedProbabilityOutrightPickWagerProfit,0)) as ImpliedProbabilityOutrightPickProfit
							,SUM(COALESCE(ImpliedProbabilityOutrightPickFavDogWagerProfit,0)) as ImpliedProbabilityOutrightFavDogProfit
							,SUM(COALESCE(ImpliedProbabilityOutrightPickHomeAwayWagerProfit,0)) as ImpliedProbabilityOutrightPickHomeAwayProfit
							,SUM(COALESCE(ImpliedProbabilityOutrightPickWager,0)) + SUM(COALESCE(ImpliedProbabilitySpreadPickWager,0)) + SUM(COALESCE(ImpliedProbabilityTotalPickWager,0)) as SeasonWager
							,SUM(COALESCE(ImpliedProbabilityOutrightPickWagerProfit,0)) + SUM(COALESCE(ImpliedProbabilitySpreadPickWagerProfit,0)) + SUM(COALESCE(ImpliedProbabilityTotalPickWagerProfit,0)) as SeasonProfit
					 FROM @tempGameDataFull GROUP BY Season) gd ON gd.Season = sd.Season
			SELECT * FROM @tempGameDataFull ORDER BY Season ASC, Week ASC

		Finish:
			IF CURSOR_STATUS('global','year_cur') <> -3
		BEGIN
			IF CURSOR_STATUS('global','year_cur') <> -1
				CLOSE year_cur;
			DEALLOCATE year_cur;
		END

	END


END TRY
BEGIN CATCH
		IF CURSOR_STATUS('global','year_cur') <> -3
	BEGIN
		IF CURSOR_STATUS('global','year_cur') <> -1
			CLOSE year_cur;
		DEALLOCATE year_cur;
	END
	SELECT ERROR_MESSAGE(), ERROR_LINE(), ERROR_PROCEDURE()
END CATCH
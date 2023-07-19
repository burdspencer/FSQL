IF OBJECT_ID('ssp_ScheduleDataReport','P') IS NOT NULL
	DROP PROCEDURE ssp_ScheduleDataReport
	GO

CREATE PROCEDURE ssp_ScheduleDataReport
				 @ReportType CHAR(1) = 'N'
			,	 @OneUnitThreshold	DECIMAL(5,2) NULL
			,	 @FiveUnitThreshold DECIMAL(5,2) NULL
			,	 @TenUnitThreshold	DECIMAL(5,2) NULL
AS
BEGIN TRY
	SET NOCOUNT ON;
	DECLARE @Season INT
	DECLARE @TestCode INT = 0 --use 1 if testing/debugging 

	IF OBJECT_ID('tempdb..#tempGameDataFull','U') IS NOT NULL
		DROP TABLE #tempGameDataFull

	CREATE TABLE #tempGameDataFull (
	HomeTeam					varchar(100),
	AwayTeam					varchar(100),
	Week						varchar(20),
	Season						int,
	HomeScore					int,
	AwayScore					int,
	Result						varchar(100),
	HomeAvgPointsFor			decimal(5,2),
	HomeAvgPointsAgainst		decimal(5,2),
	HomeAvgOff1stD				decimal(5,2),
	HomeAvgOffTotYd				decimal(5,2),
	HomeAvgOffPassYd			decimal(5,2),
	HomeAvgOffRushYd			decimal(5,2),
	HomeAvgOffTO				decimal(5,2),
	HomeAvgDef1stD				decimal(5,2),
	HomeAvgDefTotYd				decimal(5,2),
	HomeAvgDefPassYd			decimal(5,2),
	HomeAvgDefRushYd			decimal(5,2),
	HomeAvgDefTO				decimal(5,2),
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
	AwayAvgPointsFor			decimal(5,2),
	AwayAvgPointsAgainst		decimal(5,2),
	AwayAvgOff1stD				decimal(5,2),
	AwayAvgOffTotYd				decimal(5,2),
	AwayAvgOffPassYd			decimal(5,2),
	AwayAvgOffRushYd			decimal(5,2),
	AwayAvgOffTO				decimal(5,2),
	AwayAvgDef1stD				decimal(5,2),
	AwayAvgDefTotYd				decimal(5,2),
	AwayAvgDefPassYd			decimal(5,2),
	AwayAvgDefRushYd			decimal(5,2),
	AwayAvgDefTO				decimal(5,2),
	AwayAvgExPointsOff			decimal(5,2),
	AwayAvgExPointsDef			decimal(5,2),
	AwayAvgExPointsSpecial		decimal(5,2),
	AwayLastPointsFor			int,
	AwayLastPointsAgainst		int,
	AwayLastOff1stD				int,
	AwayLastOffTotYd			int,
	AwayLastOffPassYd			int,
	AwayLastOffRushYd			int,
	AwayLastOffTO				int,
	AwayLastDef1stD				int,
	AwayLastDefTotYd			int,
	AwayLastDefPassYd			int,
	AwayLastDefRushYd			int,
	AwayLastDefTO				int,
	AwayLastExPointsOff			decimal(5,2),
	AwayLastExPointsDef			decimal(5,2),
	AwayLastExPointsSpecial		decimal(5,2),
	/*Odds Data*/
	HomeOddsOpen				decimal(5,2),
	HomeOddsMin					decimal(5,2),
	HomeOddsMax					decimal(5,2),
	HomeOddsClose				decimal(5,2),
	HomeOddsCloseIP				decimal(5,2),
	HomeOddsCloseDevig			decimal(5,2),
	AwayOddsOpen				decimal(5,2),
	AwayOddsMin					decimal(5,2),
	AwayOddsMax					decimal(5,2),
	AwayOddsClose				decimal(5,2),
	AwayOddsCloseIP				decimal(5,2),
	AwayOddsCloseDevig			decimal(5,2),
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
	HomeLineOddsCloseIP			decimal(5,2),
	HomeLineOddsCloseDevig		decimal(5,2),
	AwayLineOddsOpen			decimal(5,2),
	AwayLineOddsMin				decimal(5,2),
	AwayLineOddsMax				decimal(5,2),
	AwayLineOddsClose			decimal(5,2),
	AwayLineOddsCloseIP			decimal(5,2),
	AwayLineOddsCloseDevig		decimal(5,2),
	TotalScoreOpen				decimal(5,2),
	TotalScoreMin				decimal(5,2),
	TotalScoreMax				decimal(5,2),
	TotalScoreClose				decimal(5,2),
	TotalScoreOverOpen			decimal(5,2),
	TotalScoreOverMin			decimal(5,2),
	TotalScoreOverMax			decimal(5,2),
	TotalScoreOverClose			decimal(5,2),
	TotalScoreOverCloseIP		decimal(5,2),
	TotalScoreOverCloseDevig	decimal(5,2),
	TotalScoreUnderOpen			decimal(5,2),
	TotalScoreUnderMin			decimal(5,2),
	TotalScoreUnderMax			decimal(5,2),
	TotalScoreUnderClose		decimal(5,2),
	TotalScoreUnderCloseIP		decimal(5,2),
	TotalScoreUnderCloseDevig	decimal(5,2),
	/*Odds Movement*/
	HomeLineMovement			decimal(5,2),
	HomeLineOddsMovement	decimal(5,2),
	AwayLineMovement			decimal(5,2),
	AwayLineOddsMovement		decimal(5,2),
	TotalScoreMovement			decimal(5,2),
	TotalScoreOverMovement		decimal(5,2),
	TotalScoreUnderMovement		decimal(5,2),
	/*Betting Report Only*/
	ImpliedProbabilityOutrightPick					VARCHAR(10),
	ImpliedProbabilityOutrightPickHomeAway			VARCHAR(10),
	ImpliedProbabilityOutrightPickFavDog			VARCHAR(10),
	ImpliedProbabilityOutrightPickCorrect			VARCHAR(1), --Outright Best Pick Correct
	ImpliedProbabilityOutrightPickHACorrect			VARCHAR(1), --Home/Away Pick Correct
	ImpliedProbabilityOutrightPickFDCorrect			VARCHAR(1), --Fav/Dog Pick Correct
	ImpliedProbabilitySpreadPick					VARCHAR(10),
	ImpliedProbabilitySpreadPickHomeAway			VARCHAR(10),
	ImpliedProbabilitySpreadPickFavDog				VARCHAR(10),
	ImpliedProbabilitySpreadPickHACorrect			VARCHAR(1),
	ImpliedProbabilitySpreadPickFDCorrect			VARCHAR(1),
	ImpliedProbabilitySpreadPickCorrect				VARCHAR(1),
	ImpliedProbabilityTotalPick						VARCHAR(10),
	ImpliedProbabilityTotalPickCorrect				VARCHAR(1),
	/*Betting Profit Calc Columns*/
	ImpliedProbabilityOutrightPickWager						DECIMAL(7,2),
	ImpliedProbabilityOutrightPickHomeAwayWager				DECIMAL(7,2),
	ImpliedProbabilityOutrightPickFavDogWager				DECIMAL(7,2),
	ImpliedProbabilitySpreadPickWager						DECIMAL(7,2),
	ImpliedProbabilitySpreadPickHomeAwayWager				DECIMAL(7,2),
	ImpliedProbabilitySpreadPickFavDogWager					DECIMAL(7,2),
	ImpliedProbabilityTotalPickWager						DECIMAL(7,2),
	ImpliedProbabilityOutrightPickWagerProfit				DECIMAL(11,2),
	ImpliedProbabilityOutrightPickHomeAwayWagerProfit		DECIMAL(11,2),
	ImpliedProbabilityOutrightPickFavDogWagerProfit			DECIMAL(11,2),
	ImpliedProbabilitySpreadPickWagerProfit					DECIMAL(11,2),
	ImpliedProbabilitySpreadPickHomeAwayWagerProfit			DECIMAL(11,2),
	ImpliedProbabilitySpreadPickFavDogWagerProfit			DECIMAL(11,2),
	ImpliedProbabilityTotalPickWagerProfit					DECIMAL(11,2)
	);
	

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
	DECLARE @Week INT = NULL

	IF @Week IS NULL
		SET @Week = 101 --Full Season = 101
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

		INSERT INTO #tempGameDataFull (
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
	FROM #tempGameDataFull

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

		DECLARE year_cur CURSOR
		FOR
		SELECT Season
		From #Years

		OPEN year_cur
		FETCH NEXT FROM year_cur into @Season

		WHILE @@FETCH_STATUS = 0
		BEGIN

		SET @Year = @Season --Store season from cursor so we avoid overwriting it



		/*Data Cleanup*/
		UPDATE #tempGameDataFull SET AwayLineClose = HomeLineClose * -1
		WHERE AwayLineClose IS NULL AND HomeLineClose IS NOT NULL

		UPDATE #tempGameDataFull SET HomeLineClose = AwayLineClose * -1
		WHERE AwayLineClose IS NOT NULL AND HomeLineClose IS NULL


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


		--Debug Rates from Seasons table
		IF @TestCode = 1
		SELECT  AVG(CAST(HomeOutrightRate as Decimal(5,2)))			as AvgHomeOutrightRate		
			   ,AVG(CAST(AwayOutrightRate as Decimal(5,2)))			as AvgAwayOutrightRate		
			   ,AVG(CAST(FavoriteOutrightRate as Decimal(5,2)))		as AvgFavOutrightRate
			   ,AVG(CAST(DogOutrightRate as Decimal(5,2)))			as AvgDogOutrightRate
			   ,AVG(CAST(HomeSpreadCoverRate as Decimal(5,2)))		as AvgHomeSpreadRate
			   ,AVG(CAST(AwaySpreadCoverRate as Decimal(5,2)))		as AvgAwaySpreadRate
			   ,AVG(CAST(FavoriteSpreadCoverRate as Decimal(5,2)))	as AvgFavSpreadRate
			   ,AVG(CAST(DogSpreadCoverRate as Decimal(5,2)))		as AvgDogSpreadRate
			   ,AVG(CAST(SeasonTotalOverRate as Decimal(5,2)))		as AvgTotalOverRate
			   ,AVG(CAST(SeasonTotalUnderRate as Decimal(5,2)))		as AvgTotalUnderRate
			   FROM Seasons where Season <= @Year - 1

		--Debug Thresholds
		IF @TestCode = 1
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


		/*Devig Logic*/
		--Team A IP / (Team A IP + Team B IP) where IP = Implied Probability
		--Get implied probability
		UPDATE #tempGameDataFull SET HomeOddsCloseIP = (1/COALESCE(HomeOddsClose,HomeOddsMax,HomeOddsOpen,HomeOddsMin))*100 
			WHERE COALESCE(HomeOddsClose,HomeOddsMax,HomeOddsOpen,HomeOddsMin) IS NOT NULL

		UPDATE #tempGameDataFull SET AwayOddsCloseIP = (1/COALESCE(AwayOddsClose,AwayOddsMax,AwayOddsOpen,AwayOddsMin))*100 
			WHERE COALESCE(AwayOddsClose,AwayOddsMax,AwayOddsOpen,AwayOddsMin) IS NOT NULL

		UPDATE #tempGameDataFull SET HomeLineOddsCloseIP = (1/COALESCE(HomeLineOddsClose,HomeLineOddsMax,HomeLineOddsOpen,HomeLineOddsMin))*100 
			WHERE COALESCE(HomeLineOddsClose,HomeLineOddsMax,HomeLineOddsOpen,HomeLineOddsMin) IS NOT NULL

		UPDATE #tempGameDataFull SET AwayLineOddsCloseIP = (1/COALESCE(AwayLineOddsClose,AwayLineOddsMax,AwayLineOddsOpen, AwayLineOddsMin))*100 
			WHERE COALESCE(AwayLineOddsClose,AwayLineOddsMax,AwayLineOddsOpen,AwayLineOddsMin) IS NOT NULL

		UPDATE #tempGameDataFull SET TotalScoreOverCloseIP = (1/COALESCE(TotalScoreOverClose,TotalScoreOverMax,TotalScoreOverOpen,TotalScoreOverMin))*100 
			WHERE COALESCE(TotalScoreOverClose,TotalScoreOverMax,TotalScoreOverOpen,TotalScoreOverMin) IS NOT NULL
	
		UPDATE #tempGameDataFull SET TotalScoreUnderCloseIP = (1/COALESCE(TotalScoreUnderClose,TotalScoreUnderMax,TotalScoreUnderOpen,TotalScoreUnderMin))*100 
			WHERE COALESCE(TotalScoreUnderClose,TotalScoreUnderMax,TotalScoreUnderOpen,TotalScoreUnderMin) IS NOT NULL

		--Convert back to decimal
		UPDATE #tempGameDataFull SET HomeOddsCloseDevig = 1/(HomeOddsCloseIP / ISNULL(HomeOddsCloseIP + AwayOddsCloseIP,1))
			WHERE HomeOddsCloseIP IS NOT NULL AND AwayOddsCloseIP IS NOT NULL

		UPDATE #tempGameDataFull SET AwayOddsCloseDevig = 1/(AwayOddsCloseIP / ISNULL(AwayOddsCloseIP + HomeOddsCloseIP,1))
			WHERE HomeOddsCloseIP IS NOT NULL AND AwayOddsCloseIP IS NOT NULL

		UPDATE #tempGameDataFull SET HomeLineOddsCloseDevig = 1/(HomeLineOddsCloseIP / ISNULL(AwayLineOddsCloseIP + HomeLineOddsCloseIP,1))
			WHERE HomeLineOddsCloseIP IS NOT NULL AND AwayLineOddsCloseIP IS NOT NULL

		UPDATE #tempGameDataFull SET AwayLineOddsCloseDevig = 1/(AwayLineOddsCloseIP / ISNULL(AwayLineOddsCloseIP + HomeLineOddsCloseIP,1))
			WHERE HomeLineOddsCloseIP IS NOT NULL AND AwayLineOddsCloseIP IS NOT NULL

		UPDATE #tempGameDataFull SET TotalScoreOverCloseDevig = 1/(TotalScoreOverCloseIP / ISNULL(TotalScoreUnderCloseIP + TotalScoreOverCloseIP,1))
			WHERE TotalScoreUnderCloseIP IS NOT NULL AND TotalScoreOverCloseIP IS NOT NULL
		
		UPDATE #tempGameDataFull SET TotalScoreUnderCloseDevig = 1/(TotalScoreUnderCloseIP / ISNULL(TotalScoreUnderCloseIP + TotalScoreOverCloseIP,1))
			WHERE TotalScoreUnderCloseIP IS NOT NULL AND TotalScoreOverCloseIP IS NOT NULL

		/*Make picks*/
		UPDATE #tempGameDataFull SET ImpliedProbabilityOutrightPickHomeAway = 'Home'
		WHERE  HomeOddsCloseDevig > @ImpliedProbabilityOutrightPickHomeOddsThreshold			   
			   AND AwayOddsCloseDevig < @ImpliedProbabilityOutrightPickAwayOddsThreshold
			   AND Season = @Year

		UPDATE #tempGameDataFull SET ImpliedProbabilityOutrightPickHomeAway = 'Away'
		WHERE  HomeOddsCloseDevig < @ImpliedProbabilityOutrightPickHomeOddsThreshold
			   AND AwayOddsCloseDevig > @ImpliedProbabilityOutrightPickAwayOddsThreshold
			   AND Season = @Year

		UPDATE #tempGameDataFull SET ImpliedProbabilityOutrightPickHomeAway = CASE WHEN HomeOddsCloseDevig > AwayOddsCloseDevig THEN 'Home' 
																				   WHEN  HomeOddsCloseDevig < AwayOddsCloseDevig THEN 'Away' 
																				   END
		WHERE  HomeOddsCloseDevig > @ImpliedProbabilityOutrightPickHomeOddsThreshold 
		       AND AwayOddsCloseDevig > @ImpliedProbabilityOutrightPickAwayOddsThreshold
			   AND Season = @Year

		UPDATE #tempGameDataFull SET ImpliedProbabilityOutrightPickFavDog = 'Fav'
		WHERE CASE WHEN HomeOddsCloseDevig < AwayOddsCloseDevig THEN HomeOddsCloseDevig 
				   WHEN AwayOddsCloseDevig < HomeOddsCloseDevig THEN AwayOddsCloseDevig
			  END > @ImpliedProbabilityOutrightPickFavoriteOddsThreshold
		AND	  CASE WHEN HomeOddsCloseDevig > AwayOddsCloseDevig THEN HomeOddsCloseDevig 
				   WHEN AwayOddsCloseDevig > HomeOddsCloseDevig THEN AwayOddsCloseDevig
			  END < @ImpliedProbabilityOutrightPickDogOddsThreshold
		AND Season = @Year 

		UPDATE #tempGameDataFull SET ImpliedProbabilityOutrightPickFavDog = 'Dog'
		WHERE CASE WHEN HomeOddsCloseDevig > AwayOddsCloseDevig THEN HomeOddsCloseDevig 
				   WHEN AwayOddsCloseDevig > HomeOddsCloseDevig THEN AwayOddsCloseDevig
			  END > @ImpliedProbabilityOutrightPickDogOddsThreshold
		AND   CASE WHEN HomeOddsCloseDevig < AwayOddsCloseDevig THEN HomeOddsCloseDevig 
				   WHEN AwayOddsCloseDevig < HomeOddsCloseDevig THEN AwayOddsCloseDevig
			  END < @ImpliedProbabilityOutrightPickFavoriteOddsThreshold
		AND Season = @Year 
																					
		UPDATE #tempGameDataFull SET ImpliedProbabilityOutrightPick = CASE WHEN ImpliedProbabilityOutrightPickFavDog = 'Fav' AND ImpliedProbabilityOutrightPickHomeAway = 'Home' AND ISNULL(HomeOddsCloseDevig,0) < ISNULL(AwayOddsCloseDevig,0) THEN 'Home' --Pick home if in agreement
																		   WHEN ImpliedProbabilityOutrightPickFavDog = 'Dog' AND ImpliedProbabilityOutrightPickHomeAway = 'Home' AND ISNULL(HomeOddsCloseDevig,0) > ISNULL(AwayOddsCloseDevig,0) THEN 'Home' --Pick home if in agreement
																		   WHEN ImpliedProbabilityOutrightPickFavDog = 'Fav' AND ImpliedProbabilityOutrightPickHomeAway = 'Away' AND ISNULL(HomeOddsCloseDevig,0) > ISNULL(AwayOddsCloseDevig,0) THEN 'Away' --Pick away if in agreement
																		   WHEN ImpliedProbabilityOutrightPickFavDog = 'Dog' AND ImpliedProbabilityOutrightPickHomeAway = 'Away' AND ISNULL(HomeOddsCloseDevig,0) < ISNULL(AwayOddsCloseDevig,0) THEN 'Away' --Pick away if in agreement
																		   WHEN ImpliedProbabilityOutrightPickFavDog = 'Fav' AND ImpliedProbabilityOutrightPickHomeAway = 'Home' AND ISNULL(HomeOddsCloseDevig,0) < ISNULL(AwayOddsCloseDevig,0) THEN 'Home' --Default to Fav in case of disagreement if Fav is the pick from FavDog and HomeAway picks Home
																		   WHEN ImpliedProbabilityOutrightPickFavDog = 'Dog' AND ImpliedProbabilityOutrightPickHomeAway = 'Away' AND ISNULL(HomeOddsCloseDevig,0) > ISNULL(AwayOddsCloseDevig,0) THEN 'Away' --Default to Dog in case of disagreement if Dog is the pick from FavDog and HomeAway picks Away
																		   WHEN ImpliedProbabilityOutrightPickFavDog = 'Fav' AND ImpliedProbabilityOutrightPickHomeAway = 'Home' AND ISNULL(HomeOddsCloseDevig,0) > ISNULL(AwayOddsCloseDevig,0) THEN 'Home' 
																		   WHEN ImpliedProbabilityOutrightPickFavDog = 'Dog' AND ImpliedProbabilityOutrightPickHomeAway = 'Home' AND ISNULL(HomeOddsCloseDevig,0) < ISNULL(AwayOddsCloseDevig,0) THEN 'Home' 
																		   WHEN ImpliedProbabilityOutrightPickFavDog = 'Fav' AND ImpliedProbabilityOutrightPickHomeAway = 'Away' AND ISNULL(HomeOddsCloseDevig,0) < ISNULL(AwayOddsCloseDevig,0) THEN 'Away' 
																		   WHEN ImpliedProbabilityOutrightPickFavDog = 'Dog' AND ImpliedProbabilityOutrightPickHomeAway = 'Away' AND ISNULL(HomeOddsCloseDevig,0) > ISNULL(AwayOddsCloseDevig,0) THEN 'Away' 
																		   WHEN ImpliedProbabilityOutrightPickFavDog = 'Fav' AND ImpliedProbabilityOutrightPickHomeAway = 'Home' AND ISNULL(HomeOddsCloseDevig,0) > ISNULL(AwayOddsCloseDevig,0) THEN 'Home' --Default to Fav in case of disagreement if Fav is the pick from FavDog and HomeAway picks Home
																		   WHEN ImpliedProbabilityOutrightPickFavDog = 'Dog' AND ImpliedProbabilityOutrightPickHomeAway = 'Away' AND ISNULL(HomeOddsCloseDevig,0) < ISNULL(AwayOddsCloseDevig,0) THEN 'Away' --Default to Dog in case of disagreement if Dog is the pick from FavDog and HomeAway picks Away
																		   WHEN ISNULL(HomeOddsCloseDevig,0) = ISNULL(AwayOddsCloseDevig,0) THEN CASE WHEN COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) < COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) THEN 'Home' WHEN COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) > COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) THEN 'Away' ELSE 'Home' END
																		   --FavDog is null
																		   WHEN ImpliedProbabilityOutrightPickFavDog IS  NULL AND ImpliedProbabilityOutrightPickHomeAway = 'Home'THEN 'Home' 
																		   WHEN ImpliedProbabilityOutrightPickFavDog IS  NULL AND ImpliedProbabilityOutrightPickHomeAway = 'Away'THEN 'Away' 
																		   --HomeAway is null
																		   WHEN ImpliedProbabilityOutrightPickHomeAway IS NULL AND ImpliedProbabilityOutrightPickFavDog = 'Fav' AND ISNULL(HomeOddsCloseDevig,0) < ISNULL(AwayOddsCloseDevig,0) THEN 'Home' 
																		   WHEN ImpliedProbabilityOutrightPickHomeAway IS NULL AND ImpliedProbabilityOutrightPickFavDog = 'Dog' AND ISNULL(HomeOddsCloseDevig,0) > ISNULL(AwayOddsCloseDevig,0) THEN 'Home' 
																		   WHEN ImpliedProbabilityOutrightPickHomeAway IS NULL AND ImpliedProbabilityOutrightPickFavDog = 'Fav' AND ISNULL(HomeOddsCloseDevig,0) > ISNULL(AwayOddsCloseDevig,0) THEN 'Away' 
																		   WHEN ImpliedProbabilityOutrightPickHomeAway IS NULL AND ImpliedProbabilityOutrightPickFavDog = 'Dog' AND ISNULL(HomeOddsCloseDevig,0) < ISNULL(AwayOddsCloseDevig,0) THEN 'Away' 
																		   ELSE 'Debug' --OUTSTANDING BUG, this should not be hit, but it does in case of OutrightFavDog = 'Fav', HomeAway = 'Away', and HomeOddsCloseDevig < AwayOddsCloseDevig
																		   END
		WHERE Season = @Year
		AND COALESCE(ImpliedProbabilityOutrightPickFavDog, ImpliedProbabilityOutrightPickHomeAway) IS NOT NULL

		--Spread Picks
		UPDATE #tempGameDataFull SET ImpliedProbabilitySpreadPickFavDog = 'Fav'
		WHERE CASE WHEN COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) < COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) THEN HomeLineOddsCloseDevig 
				   WHEN COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) < COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) THEN AwayLineOddsCloseDevig
			  END > @ImpliedProbabilitySpreadPickFavoriteOddsThreshold
		AND Season = @Year 

		UPDATE #tempGameDataFull SET ImpliedProbabilitySpreadPickFavDog = 'Dog'
		WHERE CASE WHEN COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) > COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) THEN HomeLineOddsCloseDevig 
				   WHEN COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) > COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) THEN AwayLineOddsCloseDevig
			  END > @ImpliedProbabilitySpreadPickDogOddsThreshold
		AND Season = @Year 
		AND ImpliedProbabilitySpreadPickFavDog IS NULL

		UPDATE #tempGameDataFull SET ImpliedProbabilitySpreadPickHomeAway = 'Home'
		WHERE (HomeLineOddsCloseDevig > @ImpliedProbabilitySpreadPickHomeOddsThreshold)
	    AND Season = @Year 

		UPDATE #tempGameDataFull SET ImpliedProbabilitySpreadPickHomeAway = 'Away'
		WHERE (AwayLineOddsCloseDevig > @ImpliedProbabilitySpreadPickAwayOddsThreshold)
		AND Season = @Year 
		AND ImpliedProbabilitySpreadPickHomeAway IS NULL

		UPDATE #tempGameDataFull SET ImpliedProbabilitySpreadPick =   CASE WHEN ImpliedProbabilitySpreadPickFavDog = 'Fav' AND ImpliedProbabilitySpreadPickHomeAway = 'Home' AND HomeLineOddsCloseDevig < AwayLineOddsCloseDevig THEN 'Home' --Pick home if in agreement
																		   WHEN ImpliedProbabilitySpreadPickFavDog = 'Dog' AND ImpliedProbabilitySpreadPickHomeAway = 'Home' AND HomeLineOddsCloseDevig > AwayLineOddsCloseDevig THEN 'Home' --Pick home if in agreement
																		   WHEN ImpliedProbabilitySpreadPickFavDog = 'Dog' AND ImpliedProbabilitySpreadPickHomeAway = 'Away' AND HomeLineOddsCloseDevig < AwayLineOddsCloseDevig THEN 'Away' --Pick away if in agreement
																		   WHEN ImpliedProbabilitySpreadPickFavDog = 'Fav' AND ImpliedProbabilitySpreadPickHomeAway = 'Away' AND HomeLineOddsCloseDevig > AwayLineOddsCloseDevig THEN 'Away' --Pick away if in agreement
																		   WHEN ImpliedProbabilitySpreadPickFavDog = 'Fav' AND ImpliedProbabilitySpreadPickHomeAway = 'Home' AND HomeLineOddsCloseDevig > AwayLineOddsCloseDevig THEN 'Away' --Default to Fav in case of disagreement if Fav is the pick from FavDog and HomeAway picks Home
																		   WHEN ImpliedProbabilitySpreadPickFavDog = 'Dog' AND ImpliedProbabilitySpreadPickHomeAway = 'Away' AND HomeLineOddsCloseDevig > AwayLineOddsCloseDevig THEN 'Home' --Default to Dog in case of disagreement if Dog is the pick from FavDog and HomeAway picks Away
																		   END
		WHERE Season = @Year 
		--O/U Picks
		--UPDATE #tempGameDataFull SET ImpliedProbabilityTotalPick = 'Over'
		--WHERE TotalScoreOverCloseDevig > @ImpliedProbabilityTotalPickOverOddsThreshold
		--AND (TotalScoreUnderCloseDevig - @ImpliedProbabilityTotalPickUnderOddsThreshold) < (TotalScoreOverCloseDevig - @ImpliedProbabilityTotalPickOverOddsThreshold) --pick greater difference
		--AND Season = @Year 
		--
		--UPDATE #tempGameDataFull SET ImpliedProbabilityTotalPick = 'Under'
		--WHERE TotalScoreUnderCloseDevig > @ImpliedProbabilityTotalPickUnderOddsThreshold
		--AND ((TotalScoreUnderCloseDevig - @ImpliedProbabilityTotalPickUnderOddsThreshold) > (TotalScoreOverCloseDevig - @ImpliedProbabilityTotalPickOverOddsThreshold)
		--OR (TotalScoreUnderCloseDevig - @ImpliedProbabilityTotalPickUnderOddsThreshold) = (TotalScoreOverCloseDevig - @ImpliedProbabilityTotalPickOverOddsThreshold)) --Pick greater difference or Under if equal difference
		--AND Season = @Year 

		UPDATE #tempGameDataFull SET ImpliedProbabilityTotalPick = 'Over'
		WHERE COALESCE(TotalScoreClose,TotalScoreMax,TotalScoreOpen) < (ISNULL(HomeAvgPointsAgainst,0) + ISNULL(HomeAvgPointsFor,0) + ISNULL(AwayAvgPointsFor,0) + ISNULL(AwayAvgPointsAgainst,0))/4
		AND Season = @Year 

		UPDATE #tempGameDataFull SET ImpliedProbabilityTotalPick = 'Under'
		WHERE COALESCE(TotalScoreClose,TotalScoreMax,TotalScoreOpen) >  (ISNULL(HomeAvgPointsAgainst,0) + ISNULL(HomeAvgPointsFor,0) + ISNULL(AwayAvgPointsFor,0) + ISNULL(AwayAvgPointsAgainst,0))/4
		AND Season = @Year 

		/*Check accuracy*/
		--Outright
		UPDATE #tempGameDataFull SET ImpliedProbabilityOutrightPickHACorrect = 'Y' WHERE ((ImpliedProbabilityOutrightPickHomeAway = 'Home' and HomeScore > AwayScore) OR (ImpliedProbabilityOutrightPickHomeAway = 'Away' AND AwayScore > HomeScore)) AND Season = @Year 
		UPDATE #tempGameDataFull SET ImpliedProbabilityOutrightPickHACorrect = 'N' WHERE ((ImpliedProbabilityOutrightPickHomeAway = 'Home' and HomeScore < AwayScore) OR (ImpliedProbabilityOutrightPickHomeAway = 'Away' AND AwayScore < HomeScore)) AND Season = @Year 
		UPDATE #tempGameDataFull SET ImpliedProbabilityOutrightPickFDCorrect = 'Y' WHERE ((ImpliedProbabilityOutrightPickFavDog = 'Fav' and COALESCE(HomeOddsClose,HomeOddsMax,HomeOddsOpen) < COALESCE(AwayOddsClose,AwayOddsMax,AwayOddsOpen) and HomeScore > AwayScore) 
																					   OR (ImpliedProbabilityOutrightPickFavDog = 'Dog' and COALESCE(HomeOddsClose,HomeOddsMax,HomeOddsOpen) > COALESCE(AwayOddsClose,AwayOddsMax,AwayOddsOpen) and HomeScore > AwayScore) 
																					   OR (ImpliedProbabilityOutrightPickFavDog = 'Fav' and COALESCE(HomeOddsClose,HomeOddsMax,HomeOddsOpen) > COALESCE(AwayOddsClose,AwayOddsMax,AwayOddsOpen) and HomeScore < AwayScore) 
																					   OR (ImpliedProbabilityOutrightPickFavDog = 'Dog' and COALESCE(HomeOddsClose,HomeOddsMax,HomeOddsOpen) < COALESCE(AwayOddsClose,AwayOddsMax,AwayOddsOpen) and HomeScore < AwayScore)) 
																					   AND Season = @Year 

		UPDATE #tempGameDataFull SET ImpliedProbabilityOutrightPickFDCorrect = 'N' WHERE ((ImpliedProbabilityOutrightPickFavDog = 'Fav' and COALESCE(HomeOddsClose,HomeOddsMax,HomeOddsOpen) < COALESCE(AwayOddsClose,AwayOddsMax,AwayOddsOpen) and HomeScore < AwayScore) 
																					   OR (ImpliedProbabilityOutrightPickFavDog = 'Dog' and COALESCE(HomeOddsClose,HomeOddsMax,HomeOddsOpen) > COALESCE(AwayOddsClose,AwayOddsMax,AwayOddsOpen) and HomeScore < AwayScore) 
																					   OR (ImpliedProbabilityOutrightPickFavDog = 'Fav' and COALESCE(HomeOddsClose,HomeOddsMax,HomeOddsOpen) > COALESCE(AwayOddsClose,AwayOddsMax,AwayOddsOpen) and HomeScore > AwayScore) 
																					   OR (ImpliedProbabilityOutrightPickFavDog = 'Dog' and COALESCE(HomeOddsClose,HomeOddsMax,HomeOddsOpen) < COALESCE(AwayOddsClose,AwayOddsMax,AwayOddsOpen) and HomeScore > AwayScore)) 
																					   AND Season = @Year 

		UPDATE #tempGameDataFull SET ImpliedProbabilityOutrightPickHACorrect = 'P' WHERE ImpliedProbabilityOutrightPickHomeAway IS NOT NULL AND HomeScore = AwayScore AND Season = @Year 
		UPDATE #tempGameDataFull SET ImpliedProbabilityOutrightPickFDCorrect = 'P' WHERE ImpliedProbabilityOutrightPickFavDog IS NOT NULL  AND HomeScore = AwayScore AND Season = @Year 

		UPDATE #tempGameDataFull SET ImpliedProbabilityOutrightPickCorrect = 'Y' WHERE ImpliedProbabilityOutrightPick = 'Home' AND HomeScore > AwayScore AND Season = @Year 
		UPDATE #tempGameDataFull SET ImpliedProbabilityOutrightPickCorrect = 'Y' WHERE ImpliedProbabilityOutrightPick = 'Away' AND HomeScore < AwayScore AND Season = @Year 
		UPDATE #tempGameDataFull SET ImpliedProbabilityOutrightPickCorrect = 'N' WHERE ImpliedProbabilityOutrightPick = 'Home' AND HomeScore < AwayScore AND Season = @Year 
		UPDATE #tempGameDataFull SET ImpliedProbabilityOutrightPickCorrect = 'N' WHERE ImpliedProbabilityOutrightPick = 'Away' AND HomeScore > AwayScore AND Season = @Year 
		UPDATE #tempGameDataFull SET ImpliedProbabilityOutrightPickCorrect = 'P' WHERE ImpliedProbabilityOutrightPick IS NOT NULL AND HomeScore = AwayScore AND Season = @Year 

		--Spread
		UPDATE #tempGameDataFull SET ImpliedProbabilitySpreadPickHACorrect = 'Y' WHERE  ImpliedProbabilitySpreadPickHomeAway = 'Home' AND HomeScore + COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) > AwayScore AND Season = @Year 
		UPDATE #tempGameDataFull SET ImpliedProbabilitySpreadPickHACorrect = 'P' WHERE  ImpliedProbabilitySpreadPickHomeAway = 'Home' AND HomeScore + COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) = AwayScore AND Season = @Year 
		UPDATE #tempGameDataFull SET ImpliedProbabilitySpreadPickHACorrect = 'N' WHERE  ImpliedProbabilitySpreadPickHomeAway = 'Home' AND HomeScore + COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) < AwayScore AND Season = @Year 
		UPDATE #tempGameDataFull SET ImpliedProbabilitySpreadPickHACorrect = 'Y' WHERE  ImpliedProbabilitySpreadPickHomeAway = 'Away' AND AwayScore + COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) > HomeScore AND Season = @Year 
		UPDATE #tempGameDataFull SET ImpliedProbabilitySpreadPickHACorrect = 'P' WHERE  ImpliedProbabilitySpreadPickHomeAway = 'Away' AND AwayScore + COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) = HomeScore AND Season = @Year 
		UPDATE #tempGameDataFull SET ImpliedProbabilitySpreadPickHACorrect = 'N' WHERE  ImpliedProbabilitySpreadPickHomeAway = 'Away' AND AwayScore + COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) < HomeScore AND Season = @Year 
		UPDATE #tempGameDataFull SET ImpliedProbabilitySpreadPickFDCorrect = 'Y' WHERE  ImpliedProbabilitySpreadPickFavDog = 'Fav' AND CASE WHEN COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) < COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) THEN HomeScore + COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) WHEN COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) < COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) THEN AwayScore + COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) END > CASE WHEN COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) < COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) THEN AwayScore WHEN COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) < COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) THEN HomeScore END AND Season = @Year 
		UPDATE #tempGameDataFull SET ImpliedProbabilitySpreadPickFDCorrect = 'P' WHERE  ImpliedProbabilitySpreadPickFavDog = 'Fav' AND CASE WHEN COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) < COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) THEN HomeScore + COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) WHEN COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) < COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) THEN AwayScore + COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) END = CASE WHEN COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) < COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) THEN AwayScore WHEN COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) < COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) THEN HomeScore END AND Season = @Year 
		UPDATE #tempGameDataFull SET ImpliedProbabilitySpreadPickFDCorrect = 'N' WHERE  ImpliedProbabilitySpreadPickFavDog = 'Fav' AND CASE WHEN COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) < COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) THEN HomeScore + COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) WHEN COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) < COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) THEN AwayScore + COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) END < CASE WHEN COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) < COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) THEN AwayScore WHEN COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) < COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) THEN HomeScore END AND Season = @Year 
		UPDATE #tempGameDataFull SET ImpliedProbabilitySpreadPickFDCorrect = 'Y' WHERE  ImpliedProbabilitySpreadPickFavDog = 'Dog' AND CASE WHEN COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) < COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) THEN AwayScore + COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) WHEN COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) < COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) THEN HomeScore + COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) END > CASE WHEN COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) > COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) THEN HomeScore WHEN COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) > COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) THEN AwayScore END AND Season = @Year 
		UPDATE #tempGameDataFull SET ImpliedProbabilitySpreadPickFDCorrect = 'P' WHERE  ImpliedProbabilitySpreadPickFavDog = 'Dog' AND CASE WHEN COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) < COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) THEN AwayScore + COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) WHEN COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) < COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) THEN HomeScore + COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) END = CASE WHEN COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) > COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) THEN HomeScore WHEN COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) > COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) THEN AwayScore END AND Season = @Year 
		UPDATE #tempGameDataFull SET ImpliedProbabilitySpreadPickFDCorrect = 'N' WHERE  ImpliedProbabilitySpreadPickFavDog = 'Dog' AND CASE WHEN COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) < COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) THEN AwayScore + COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) WHEN COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) < COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) THEN HomeScore + COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) END < CASE WHEN COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) > COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) THEN HomeScore WHEN COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) > COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) THEN AwayScore END AND Season = @Year 
		UPDATE #tempGameDataFull SET ImpliedProbabilitySpreadPickCorrect = 'Y' WHERE ((ImpliedProbabilitySpreadPick = 'Home' AND COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) + HomeScore > AwayScore) OR (ImpliedProbabilitySpreadPick = 'Away' AND COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) + AwayScore > HomeScore)) AND Season = @Year 
		UPDATE #tempGameDataFull SET ImpliedProbabilitySpreadPickCorrect = 'P' WHERE ((ImpliedProbabilitySpreadPick = 'Home' AND COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) + HomeScore = AwayScore) OR (ImpliedProbabilitySpreadPick = 'Away' AND COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) + AwayScore = HomeScore)) AND Season = @Year 
		UPDATE #tempGameDataFull SET ImpliedProbabilitySpreadPickCorrect = 'N' WHERE ((ImpliedProbabilitySpreadPick = 'Home' AND COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) + HomeScore < AwayScore) OR (ImpliedProbabilitySpreadPick = 'Away' AND COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) + AwayScore < HomeScore)) AND Season = @Year 

		--Total
		UPDATE #tempGameDataFull SET ImpliedProbabilityTotalPickCorrect = 'Y' WHERE ImpliedProbabilityTotalPick = 'Over' AND HomeScore + AwayScore > COALESCE(TotalScoreClose,TotalScoreMax,TotalScoreOpen) AND Season = @Year 
		UPDATE #tempGameDataFull SET ImpliedProbabilityTotalPickCorrect = 'Y' WHERE ImpliedProbabilityTotalPick = 'Under' AND HomeScore + AwayScore < COALESCE(TotalScoreClose,TotalScoreMax,TotalScoreOpen) AND Season = @Year 
		UPDATE #tempGameDataFull SET ImpliedProbabilityTotalPickCorrect = 'P' WHERE ImpliedProbabilityTotalPick IS NOT NULL AND (HomeScore + AwayScore = COALESCE(TotalScoreClose,TotalScoreOpen)) AND Season = @Year 
		UPDATE #tempGameDataFull SET ImpliedProbabilityTotalPickCorrect = 'N' WHERE (ImpliedProbabilityTotalPick = 'Under' AND HomeScore + AwayScore > COALESCE(TotalScoreClose,TotalScoreMax,TotalScoreOpen)) OR (ImpliedProbabilityTotalPick = 'Over' AND HomeScore + AwayScore < COALESCE(TotalScoreClose,TotalScoreMax,TotalScoreOpen)) AND Season = @Year 


		
		--Set wager for each bet
		If @OneUnitThreshold IS NULL SET @OneUnitThreshold = 0
		If @FiveUnitThreshold IS NULL SET @FiveUnitThreshold = 0.11
		If @TenUnitThreshold IS NULL SET @TenUnitThreshold = 0.5


		UPDATE #tempGameDataFull SET ImpliedProbabilityOutrightPickWager = CASE WHEN 
																					(
																						(ISNULL(ISNULL(HomeOddsCloseDevig,0),0) < ISNULL(AwayOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(HomeOddsCloseDevig,0) - @ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(HomeOddsCloseDevig,0) * @OneUnitThreshold as DECIMAL(5,2))) 
																					AND (ISNULL(HomeOddsCloseDevig,0) < ISNULL(AwayOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(HomeOddsCloseDevig,0) - @ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2))) < CAST(ISNULL(HomeOddsCloseDevig,0) * @FiveUnitThreshold as DECIMAL(5,2))
																					)
																				OR (
																						(ISNULL(AwayOddsCloseDevig,0) < ISNULL(HomeOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(AwayOddsCloseDevig,0) - @ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(AwayOddsCloseDevig,0) * @OneUnitThreshold as DECIMAL(5,2))) 
																					AND (ISNULL(AwayOddsCloseDevig,0) < ISNULL(HomeOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(AwayOddsCloseDevig,0) - @ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2))) < CAST(ISNULL(AwayOddsCloseDevig,0) * @FiveUnitThreshold as DECIMAL(5,2))
																					)
																				THEN 1
																				WHEN 
																					(
																						(ISNULL(HomeOddsCloseDevig,0) < ISNULL(AwayOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(HomeOddsCloseDevig,0) - @ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(HomeOddsCloseDevig,0) * @FiveUnitThreshold  as DECIMAL(5,2)))
																					AND (ISNULL(HomeOddsCloseDevig,0) < ISNULL(AwayOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(HomeOddsCloseDevig,0) - @ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) < CAST(ISNULL(HomeOddsCloseDevig,0) * @TenUnitThreshold  as DECIMAL(5,2)))
																					)
																				OR (
																						(ISNULL(AwayOddsCloseDevig,0) < ISNULL(HomeOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(AwayOddsCloseDevig,0) - @ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(AwayOddsCloseDevig,0) * @FiveUnitThreshold  as DECIMAL(5,2)))
																					AND (ISNULL(AwayOddsCloseDevig,0) < ISNULL(HomeOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(AwayOddsCloseDevig,0) - @ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) < CAST(ISNULL(AwayOddsCloseDevig,0) * @TenUnitThreshold  as DECIMAL(5,2)))
																					)
																				THEN 5
																				WHEN 
																					(
																						(ISNULL(HomeOddsCloseDevig,0) < ISNULL(AwayOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(HomeOddsCloseDevig,0) - @ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(HomeOddsCloseDevig,0) * @TenUnitThreshold  as DECIMAL(5,2)))
																					)
																				OR (
																						(ISNULL(AwayOddsCloseDevig,0) < ISNULL(HomeOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(AwayOddsCloseDevig,0) - @ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(AwayOddsCloseDevig,0) * @TenUnitThreshold  as DECIMAL(5,2)))
																					)
																				THEN 10
																				ELSE 1
																				END
		WHERE ImpliedProbabilityOutrightPick IS NOT NULL																		
																					
		UPDATE #tempGameDataFull SET ImpliedProbabilityOutrightPickHomeAwayWager = CASE WHEN 
																					(
																						ImpliedProbabilityOutrightPickHomeAway = 'Home'
																					AND (ISNULL(HomeOddsCloseDevig,0) < ISNULL(AwayOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(HomeOddsCloseDevig,0) - @ImpliedProbabilityOutrightPickHomeOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(HomeOddsCloseDevig,0) * @OneUnitThreshold as DECIMAL(5,2))) 
																					AND (ISNULL(HomeOddsCloseDevig,0) < ISNULL(AwayOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(HomeOddsCloseDevig,0) - @ImpliedProbabilityOutrightPickHomeOddsThreshold as DECIMAL(5,2)) < CAST(ISNULL(HomeOddsCloseDevig,0) * @FiveUnitThreshold as DECIMAL(5,2)))
																					)
																				OR (
																						ImpliedProbabilityOutrightPickHomeAway = 'Away'
																					AND (ISNULL(AwayOddsCloseDevig,0) < ISNULL(HomeOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(AwayOddsCloseDevig,0) - @ImpliedProbabilityOutrightPickAwayOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(AwayOddsCloseDevig,0) * @OneUnitThreshold as DECIMAL(5,2))) 
																					AND (ISNULL(AwayOddsCloseDevig,0) < ISNULL(HomeOddsCloseDevig,0))
																					AND (CAST(ISNULL(AwayOddsCloseDevig,0) - @ImpliedProbabilityOutrightPickAwayOddsThreshold as DECIMAL(5,2)) < CAST(ISNULL(AwayOddsCloseDevig,0) * @FiveUnitThreshold as DECIMAL(5,2)))
																					)
																				THEN 1
																				WHEN 
																					(
																						ImpliedProbabilityOutrightPickHomeAway = 'Home'
																					AND (ISNULL(HomeOddsCloseDevig,0) < ISNULL(AwayOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(HomeOddsCloseDevig,0) - @ImpliedProbabilityOutrightPickHomeOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(HomeOddsCloseDevig,0) * @FiveUnitThreshold  as DECIMAL(5,2)))
																					AND (ISNULL(HomeOddsCloseDevig,0) < ISNULL(AwayOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(HomeOddsCloseDevig,0) - @ImpliedProbabilityOutrightPickHomeOddsThreshold as DECIMAL(5,2)) < CAST(ISNULL(HomeOddsCloseDevig,0) * @TenUnitThreshold  as DECIMAL(5,2)))
																					)
																				OR (
																						ImpliedProbabilityOutrightPickHomeAway = 'Away'
																					AND (ISNULL(AwayOddsCloseDevig,0) < ISNULL(HomeOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(AwayOddsCloseDevig,0) - @ImpliedProbabilityOutrightPickAwayOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(AwayOddsCloseDevig,0) * @FiveUnitThreshold  as DECIMAL(5,2)))
																					AND (ISNULL(AwayOddsCloseDevig,0) < ISNULL(HomeOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(AwayOddsCloseDevig,0) - @ImpliedProbabilityOutrightPickAwayOddsThreshold as DECIMAL(5,2)) < CAST(ISNULL(AwayOddsCloseDevig,0) * @TenUnitThreshold  as DECIMAL(5,2)))
																					)
																				THEN 5
																				WHEN 
																					(
																						ImpliedProbabilityOutrightPickHomeAway = 'Home'
																					AND (ISNULL(HomeOddsCloseDevig,0) < ISNULL(AwayOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(HomeOddsCloseDevig,0) - @ImpliedProbabilityOutrightPickHomeOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(HomeOddsCloseDevig,0) * @TenUnitThreshold  as DECIMAL(5,2)))
																					)
																				OR (
																						ImpliedProbabilityOutrightPickHomeAway = 'Away'
																					AND (ISNULL(AwayOddsCloseDevig,0) < ISNULL(HomeOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(AwayOddsCloseDevig,0) - @ImpliedProbabilityOutrightPickAwayOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(AwayOddsCloseDevig,0) * @TenUnitThreshold  as DECIMAL(5,2)))
																					)
																				THEN 10
																				ELSE 1
																				END
		WHERE ImpliedProbabilityOutrightPickHomeAway IS NOT NULL

		UPDATE #tempGameDataFull SET ImpliedProbabilityOutrightPickFavDogWager = CASE WHEN 
																					(
																						ImpliedProbabilityOutrightPickFavDog = 'Fav'
																					And (ISNULL(HomeOddsCloseDevig,0) < ISNULL(AwayOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(HomeOddsCloseDevig,0) - @ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(HomeOddsCloseDevig,0) * @OneUnitThreshold as DECIMAL(5,2))) 
																					AND (ISNULL(HomeOddsCloseDevig,0) < ISNULL(AwayOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(HomeOddsCloseDevig,0) - @ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) < CAST(ISNULL(HomeOddsCloseDevig,0) * @FiveUnitThreshold as DECIMAL(5,2)))
																					)
																				OR (
																						ImpliedProbabilityOutrightPickFavDog = 'Fav'
																					AND (ISNULL(AwayOddsCloseDevig,0) < ISNULL(HomeOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(AwayOddsCloseDevig,0) - @ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(AwayOddsCloseDevig,0) * @OneUnitThreshold as DECIMAL(5,2))) 
																					AND (ISNULL(AwayOddsCloseDevig,0) < ISNULL(HomeOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(AwayOddsCloseDevig,0) - @ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) < CAST(ISNULL(AwayOddsCloseDevig,0) * @FiveUnitThreshold as DECIMAL(5,2)))
																					)
																				OR (
																						ImpliedProbabilityOutrightPickFavDog = 'Dog'
																					And (ISNULL(HomeOddsCloseDevig,0) < ISNULL(AwayOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(HomeOddsCloseDevig,0) - @ImpliedProbabilityOutrightPickDogOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(HomeOddsCloseDevig,0) * @OneUnitThreshold as DECIMAL(5,2))) 
																					AND (ISNULL(HomeOddsCloseDevig,0) < ISNULL(AwayOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(HomeOddsCloseDevig,0) - @ImpliedProbabilityOutrightPickDogOddsThreshold as DECIMAL(5,2)) < CAST(ISNULL(HomeOddsCloseDevig,0) * @FiveUnitThreshold as DECIMAL(5,2)))
																					)
																				OR (
																						ImpliedProbabilityOutrightPickFavDog = 'Dog'
																					AND (ISNULL(AwayOddsCloseDevig,0) < ISNULL(HomeOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(AwayOddsCloseDevig,0) - @ImpliedProbabilityOutrightPickDogOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(AwayOddsCloseDevig,0) * @OneUnitThreshold as DECIMAL(5,2))) 
																					AND (ISNULL(AwayOddsCloseDevig,0) < ISNULL(HomeOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(AwayOddsCloseDevig,0) - @ImpliedProbabilityOutrightPickDogOddsThreshold as DECIMAL(5,2)) < CAST(ISNULL(AwayOddsCloseDevig,0) * @FiveUnitThreshold as DECIMAL(5,2)))
																					)
																				THEN 1
																				WHEN 
																					(
																						ImpliedProbabilityOutrightPickFavDog = 'Fav'
																					AND (ISNULL(HomeOddsCloseDevig,0) < ISNULL(AwayOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(HomeOddsCloseDevig,0) - @ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(HomeOddsCloseDevig,0) * @FiveUnitThreshold  as DECIMAL(5,2)))
																					AND (ISNULL(HomeOddsCloseDevig,0) < ISNULL(AwayOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(HomeOddsCloseDevig,0) - @ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) < CAST(ISNULL(HomeOddsCloseDevig,0) * @TenUnitThreshold  as DECIMAL(5,2)))
																					)
																				OR (
																						ImpliedProbabilityOutrightPickFavDog = 'Fav'
																					AND (ISNULL(AwayOddsCloseDevig,0) < ISNULL(HomeOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(AwayOddsCloseDevig,0) - @ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(AwayOddsCloseDevig,0) * @FiveUnitThreshold  as DECIMAL(5,2)))
																					AND (ISNULL(AwayOddsCloseDevig,0) < ISNULL(HomeOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(AwayOddsCloseDevig,0) - @ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) < CAST(ISNULL(AwayOddsCloseDevig,0) * @TenUnitThreshold  as DECIMAL(5,2)))
																					)
																				OR (
																						ImpliedProbabilityOutrightPickFavDog = 'Dog'
																					AND (ISNULL(HomeOddsCloseDevig,0) < ISNULL(AwayOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(HomeOddsCloseDevig,0) - @ImpliedProbabilityOutrightPickDogOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(HomeOddsCloseDevig,0) * @FiveUnitThreshold  as DECIMAL(5,2)))
																					AND (ISNULL(HomeOddsCloseDevig,0) < ISNULL(AwayOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(HomeOddsCloseDevig,0) - @ImpliedProbabilityOutrightPickDogOddsThreshold as DECIMAL(5,2)) < CAST(ISNULL(HomeOddsCloseDevig,0) * @TenUnitThreshold  as DECIMAL(5,2)))
																					)
																				OR (
																						ImpliedProbabilityOutrightPickFavDog = 'Dog'
																					AND (ISNULL(AwayOddsCloseDevig,0) < ISNULL(HomeOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(AwayOddsCloseDevig,0) - @ImpliedProbabilityOutrightPickDogOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(AwayOddsCloseDevig,0) * @FiveUnitThreshold  as DECIMAL(5,2)))
																					AND (ISNULL(AwayOddsCloseDevig,0) < ISNULL(HomeOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(AwayOddsCloseDevig,0) - @ImpliedProbabilityOutrightPickDogOddsThreshold as DECIMAL(5,2)) < CAST(ISNULL(AwayOddsCloseDevig,0) * @TenUnitThreshold  as DECIMAL(5,2)))
																					)
																				THEN 5
																				WHEN 
																					(
																						ImpliedProbabilityOutrightPickFavDog = 'Fav'
																					AND (ISNULL(HomeOddsCloseDevig,0) < ISNULL(AwayOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(HomeOddsCloseDevig,0) - @ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(HomeOddsCloseDevig,0) * @TenUnitThreshold  as DECIMAL(5,2)))
																					)
																				OR (
																						ImpliedProbabilityOutrightPickFavDog = 'Fav'
																					AND (ISNULL(AwayOddsCloseDevig,0) < ISNULL(HomeOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(AwayOddsCloseDevig,0) - @ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(AwayOddsCloseDevig,0) * @TenUnitThreshold  as DECIMAL(5,2)))
																					)
																				OR (
																						ImpliedProbabilityOutrightPickFavDog = 'Dog'
																					AND (ISNULL(HomeOddsCloseDevig,0) < ISNULL(AwayOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(HomeOddsCloseDevig,0) - @ImpliedProbabilityOutrightPickDogOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(HomeOddsCloseDevig,0) * @TenUnitThreshold  as DECIMAL(5,2)))
																					)
																				OR (
																						ImpliedProbabilityOutrightPickFavDog = 'Dog'
																					AND (ISNULL(AwayOddsCloseDevig,0) < ISNULL(HomeOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(AwayOddsCloseDevig,0) - @ImpliedProbabilityOutrightPickDogOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(AwayOddsCloseDevig,0) * @TenUnitThreshold  as DECIMAL(5,2)))
																					)
																				THEN 10
																				ELSE 1
																				END
		WHERE ImpliedProbabilityOutrightPickFavDog IS NOT NULL

		UPDATE #tempGameDataFull SET ImpliedProbabilitySpreadPickWager = CASE WHEN 
																					(	
																						ImpliedProbabilitySpreadPick = 'Home' 
																					AND	(ISNULL(HomeLineOddsCloseDevig,0) < ISNULL(AwayLineOddsCloseDevig,0))
																					AND (CAST(ISNULL(HomeLineOddsCloseDevig,0) - @ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(HomeLineOddsCloseDevig,0) * @OneUnitThreshold as DECIMAL(5,2))) 
																					AND (ISNULL(HomeLineOddsCloseDevig,0) < ISNULL(AwayLineOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(HomeLineOddsCloseDevig,0) - @ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) < CAST(ISNULL(HomeLineOddsCloseDevig,0) * @FiveUnitThreshold as DECIMAL(5,2)))
																					)
																				OR (
																						ImpliedProbabilitySpreadPick = 'Away' 
																					AND (ISNULL(AwayLineOddsCloseDevig,0) < ISNULL(HomeLineOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(AwayLineOddsCloseDevig,0) - @ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(AwayLineOddsCloseDevig,0) * @OneUnitThreshold as DECIMAL(5,2))) 
																					AND (ISNULL(AwayLineOddsCloseDevig,0) < ISNULL(HomeLineOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(AwayLineOddsCloseDevig,0) - @ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) < CAST(ISNULL(AwayLineOddsCloseDevig,0) * @FiveUnitThreshold as DECIMAL(5,2)))
																					)
																				THEN 1
																				WHEN 
																					(
																						ImpliedProbabilitySpreadPick = 'Home' 
																					AND (ISNULL(HomeLineOddsCloseDevig,0) < ISNULL(AwayLineOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(HomeLineOddsCloseDevig,0) - @ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(HomeLineOddsCloseDevig,0) * @FiveUnitThreshold  as DECIMAL(5,2)))
																					AND (ISNULL(HomeLineOddsCloseDevig,0) < ISNULL(AwayLineOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(HomeLineOddsCloseDevig,0) - @ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) < CAST(ISNULL(HomeLineOddsCloseDevig,0) * @TenUnitThreshold  as DECIMAL(5,2)))
																					)
																				OR (
																						ImpliedProbabilitySpreadPick = 'Away' 
																					AND (ISNULL(AwayLineOddsCloseDevig,0) < ISNULL(HomeLineOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(AwayLineOddsCloseDevig,0) - @ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(AwayLineOddsCloseDevig,0) * @FiveUnitThreshold  as DECIMAL(5,2)))
																					AND (ISNULL(AwayLineOddsCloseDevig,0) < ISNULL(HomeLineOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(AwayLineOddsCloseDevig,0) - @ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) < CAST(ISNULL(AwayLineOddsCloseDevig,0) * @TenUnitThreshold  as DECIMAL(5,2)))
																					)
																				THEN 5
																				WHEN 
																					(
																						ImpliedProbabilitySpreadPick = 'Home' 
																					AND (ISNULL(HomeLineOddsCloseDevig,0) < ISNULL(AwayLineOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(HomeLineOddsCloseDevig,0) - @ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(HomeLineOddsCloseDevig,0) * @TenUnitThreshold  as DECIMAL(5,2)))
																					)
																				OR (
																						ImpliedProbabilitySpreadPick = 'Away' 
																					AND (ISNULL(AwayLineOddsCloseDevig,0) < ISNULL(HomeLineOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(AwayLineOddsCloseDevig,0) - @ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(AwayLineOddsCloseDevig,0) * @TenUnitThreshold  as DECIMAL(5,2)))
																					)
																				THEN 10
																				ELSE 1
																				END	
		WHERE ImpliedProbabilitySpreadPick IS NOT NULL

		UPDATE #tempGameDataFull SET ImpliedProbabilitySpreadPickHomeAwayWager = CASE WHEN 
																					(	
																						ImpliedProbabilitySpreadPick = 'Home' 
																					AND	(ISNULL(HomeLineOddsCloseDevig,0) < ISNULL(AwayLineOddsCloseDevig,0))
																					AND (CAST(ISNULL(HomeLineOddsCloseDevig,0) - @ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(HomeLineOddsCloseDevig,0) * @OneUnitThreshold as DECIMAL(5,2))) 
																					AND (ISNULL(HomeLineOddsCloseDevig,0) < ISNULL(AwayLineOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(HomeLineOddsCloseDevig,0) - @ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) < CAST(ISNULL(HomeLineOddsCloseDevig,0) * @FiveUnitThreshold as DECIMAL(5,2)))
																					)
																				OR (
																						ImpliedProbabilitySpreadPick = 'Away' 
																					AND (ISNULL(AwayLineOddsCloseDevig,0) < ISNULL(HomeLineOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(AwayLineOddsCloseDevig,0) - @ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(AwayLineOddsCloseDevig,0) * @OneUnitThreshold as DECIMAL(5,2))) 
																					AND (ISNULL(AwayLineOddsCloseDevig,0) < ISNULL(HomeLineOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(AwayLineOddsCloseDevig,0) - @ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) < CAST(ISNULL(AwayLineOddsCloseDevig,0) * @FiveUnitThreshold as DECIMAL(5,2)))
																					)
																				THEN 1
																				WHEN 
																					(
																						ImpliedProbabilitySpreadPick = 'Home' 
																					AND (ISNULL(HomeLineOddsCloseDevig,0) < ISNULL(AwayLineOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(HomeLineOddsCloseDevig,0) - @ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(HomeLineOddsCloseDevig,0) * @FiveUnitThreshold  as DECIMAL(5,2)))
																					AND (ISNULL(HomeLineOddsCloseDevig,0) < ISNULL(AwayLineOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(HomeLineOddsCloseDevig,0) - @ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) < CAST(ISNULL(HomeLineOddsCloseDevig,0) * @TenUnitThreshold  as DECIMAL(5,2)))
																					)
																				OR (
																						ImpliedProbabilitySpreadPick = 'Away' 
																					AND (ISNULL(AwayLineOddsCloseDevig,0) < ISNULL(HomeLineOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(AwayLineOddsCloseDevig,0) - @ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(AwayLineOddsCloseDevig,0) * @FiveUnitThreshold  as DECIMAL(5,2)))
																					AND (ISNULL(AwayLineOddsCloseDevig,0) < ISNULL(HomeLineOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(AwayLineOddsCloseDevig,0) - @ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) < CAST(ISNULL(AwayLineOddsCloseDevig,0) * @TenUnitThreshold  as DECIMAL(5,2)))
																					)
																				THEN 5
																				WHEN 
																					(
																						ImpliedProbabilitySpreadPick = 'Home' 
																					AND (ISNULL(HomeLineOddsCloseDevig,0) < ISNULL(AwayLineOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(HomeLineOddsCloseDevig,0) - @ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(HomeLineOddsCloseDevig,0) * @TenUnitThreshold  as DECIMAL(5,2)))
																					)
																				OR (
																						ImpliedProbabilitySpreadPick = 'Away' 
																					AND (ISNULL(AwayLineOddsCloseDevig,0) < ISNULL(HomeLineOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(AwayLineOddsCloseDevig,0) - @ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(AwayLineOddsCloseDevig,0) * @TenUnitThreshold  as DECIMAL(5,2)))
																					)
																				THEN 10
																				ELSE 1
																				END	
		WHERE ImpliedProbabilitySpreadPick IS NOT NULL

		UPDATE #tempGameDataFull SET ImpliedProbabilitySpreadPickFavDogWager = CASE WHEN 
																					(
																						ImpliedProbabilitySpreadPickFavDog = 'Fav'
																					And (ISNULL(HomeLineOddsCloseDevig,0) < ISNULL(AwayLineOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(HomeLineOddsCloseDevig,0) - @ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(HomeLineOddsCloseDevig,0) * @OneUnitThreshold as DECIMAL(5,2)))
																					AND (ISNULL(HomeLineOddsCloseDevig,0) < ISNULL(AwayLineOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(HomeLineOddsCloseDevig,0) - @ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) < CAST(ISNULL(HomeLineOddsCloseDevig,0) * @FiveUnitThreshold  as DECIMAL(5,2)))
																					)
																				OR (
																						ImpliedProbabilitySpreadPickFavDog = 'Fav'
																					AND (ISNULL(AwayLineOddsCloseDevig,0) < ISNULL(HomeLineOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(AwayLineOddsCloseDevig,0) - @ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(AwayLineOddsCloseDevig,0) * @OneUnitThreshold as DECIMAL(5,2)))
																					AND (ISNULL(AwayLineOddsCloseDevig,0) < ISNULL(HomeLineOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(AwayLineOddsCloseDevig,0) - @ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) < CAST(ISNULL(AwayLineOddsCloseDevig,0) * @FiveUnitThreshold  as DECIMAL(5,2)))
																					)
																				OR (
																						ImpliedProbabilitySpreadPickFavDog = 'Dog'
																					And (ISNULL(HomeLineOddsCloseDevig,0) < ISNULL(AwayLineOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(HomeLineOddsCloseDevig,0) - @ImpliedProbabilityOutrightPickDogOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(HomeLineOddsCloseDevig,0) * @OneUnitThreshold as DECIMAL(5,2)))
																					AND (ISNULL(HomeLineOddsCloseDevig,0) < ISNULL(AwayLineOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(HomeLineOddsCloseDevig,0) - @ImpliedProbabilityOutrightPickDogOddsThreshold as DECIMAL(5,2)) < CAST(ISNULL(HomeLineOddsCloseDevig,0) * @FiveUnitThreshold  as DECIMAL(5,2)))
																					)
																				OR (
																						ImpliedProbabilitySpreadPickFavDog = 'Dog'
																					AND (ISNULL(AwayLineOddsCloseDevig,0) < ISNULL(HomeLineOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(AwayLineOddsCloseDevig,0) - @ImpliedProbabilityOutrightPickDogOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(AwayLineOddsCloseDevig,0) * @OneUnitThreshold as DECIMAL(5,2)))
																					AND (ISNULL(AwayLineOddsCloseDevig,0) < ISNULL(HomeLineOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(AwayLineOddsCloseDevig,0) - @ImpliedProbabilityOutrightPickDogOddsThreshold as DECIMAL(5,2)) < CAST(ISNULL(AwayLineOddsCloseDevig,0) * @FiveUnitThreshold  as DECIMAL(5,2)))
																					)
																				THEN 1
																				WHEN 
																					(
																						ImpliedProbabilitySpreadPickFavDog = 'Fav'
																					AND (ISNULL(HomeLineOddsCloseDevig,0) < ISNULL(AwayLineOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(HomeLineOddsCloseDevig,0) - @ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(HomeLineOddsCloseDevig,0) * @FiveUnitThreshold  as DECIMAL(5,2))) 
																					AND (ISNULL(HomeLineOddsCloseDevig,0) < ISNULL(AwayLineOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(HomeLineOddsCloseDevig,0) - @ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) < CAST(ISNULL(HomeLineOddsCloseDevig,0) * @TenUnitThreshold  as DECIMAL(5,2)))
																					)
																				OR (
																						ImpliedProbabilitySpreadPickFavDog = 'Fav'
																					AND (ISNULL(AwayLineOddsCloseDevig,0) < ISNULL(HomeLineOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(AwayLineOddsCloseDevig,0) - @ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(AwayLineOddsCloseDevig,0) * @FiveUnitThreshold  as DECIMAL(5,2))) 
																					AND (ISNULL(AwayLineOddsCloseDevig,0) < ISNULL(HomeLineOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(AwayLineOddsCloseDevig,0) - @ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) < CAST(ISNULL(AwayLineOddsCloseDevig,0) * @TenUnitThreshold  as DECIMAL(5,2)))
																					)
																				OR (
																						ImpliedProbabilitySpreadPickFavDog = 'Dog'
																					AND (ISNULL(HomeLineOddsCloseDevig,0) < ISNULL(AwayLineOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(HomeLineOddsCloseDevig,0) - @ImpliedProbabilityOutrightPickDogOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(HomeLineOddsCloseDevig,0) * @FiveUnitThreshold  as DECIMAL(5,2))) 
																					AND (ISNULL(HomeLineOddsCloseDevig,0) < ISNULL(AwayLineOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(HomeLineOddsCloseDevig,0) - @ImpliedProbabilityOutrightPickDogOddsThreshold as DECIMAL(5,2)) < CAST(ISNULL(HomeLineOddsCloseDevig,0) * @TenUnitThreshold  as DECIMAL(5,2)))
																					)
																				OR (
																						ImpliedProbabilitySpreadPickFavDog = 'Dog'
																					AND (ISNULL(AwayLineOddsCloseDevig,0) < ISNULL(HomeLineOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(AwayLineOddsCloseDevig,0) - @ImpliedProbabilityOutrightPickDogOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(AwayLineOddsCloseDevig,0) * @FiveUnitThreshold  as DECIMAL(5,2)))
																					AND (ISNULL(AwayLineOddsCloseDevig,0) < ISNULL(HomeLineOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(AwayLineOddsCloseDevig,0) - @ImpliedProbabilityOutrightPickDogOddsThreshold as DECIMAL(5,2)) < CAST(ISNULL(AwayLineOddsCloseDevig,0) * @TenUnitThreshold  as DECIMAL(5,2)))
																					)
																				THEN 5
																				WHEN 
																					(
																						ImpliedProbabilitySpreadPickFavDog = 'Fav'
																					AND (ISNULL(HomeLineOddsCloseDevig,0) < ISNULL(AwayLineOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(HomeLineOddsCloseDevig,0) - @ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(HomeLineOddsCloseDevig,0) * @TenUnitThreshold  as DECIMAL(5,2))) 
																					)
																				OR (
																						ImpliedProbabilitySpreadPickFavDog = 'Fav'
																					AND (ISNULL(AwayLineOddsCloseDevig,0) < ISNULL(HomeLineOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(AwayLineOddsCloseDevig,0) - @ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(AwayLineOddsCloseDevig,0) * @TenUnitThreshold  as DECIMAL(5,2))) 
																					)
																				OR (
																						ImpliedProbabilitySpreadPickFavDog = 'Dog'
																					AND (ISNULL(HomeLineOddsCloseDevig,0) < ISNULL(AwayLineOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(HomeLineOddsCloseDevig,0) - @ImpliedProbabilityOutrightPickDogOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(HomeLineOddsCloseDevig,0) * @TenUnitThreshold  as DECIMAL(5,2))) 
																					)
																				OR (
																						ImpliedProbabilitySpreadPickFavDog = 'Dog'
																					AND (ISNULL(AwayLineOddsCloseDevig,0) < ISNULL(HomeLineOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(AwayLineOddsCloseDevig,0) - @ImpliedProbabilityOutrightPickDogOddsThreshold as DECIMAL(5,2))>= CAST(ISNULL(AwayLineOddsCloseDevig,0) * @TenUnitThreshold  as DECIMAL(5,2)))
																					)
																				THEN 10
																				ELSE 1
																				END
		WHERE ImpliedProbabilitySpreadPickFavDog IS NOT NULL

		UPDATE #tempGameDataFull SET ImpliedProbabilityTotalPickWager =  CASE WHEN 
																					(
																						ImpliedProbabilityTotalPick = 'Over'
																					AND (CAST(ISNULL(TotalScoreOverCloseDevig,0) - @ImpliedProbabilityTotalPickOverOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(TotalScoreOverCloseDevig,0) * @OneUnitThreshold as DECIMAL(5,2)))
																					AND (CAST(ISNULL(TotalScoreOverCloseDevig,0) - @ImpliedProbabilityTotalPickOverOddsThreshold as DECIMAL(5,2)) < CAST(ISNULL(TotalScoreOverCloseDevig,0) * @FiveUnitThreshold as DECIMAL(5,2)))
																					)
																				OR (
																						ImpliedProbabilityTotalPick = 'Under'
																					AND (CAST(ISNULL(TotalScoreUnderCloseDevig,0) - @ImpliedProbabilityTotalPickUnderOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(TotalScoreUnderCloseDevig,0) * @OneUnitThreshold as DECIMAL(5,2))) 
																					AND (CAST(ISNULL(TotalScoreUnderCloseDevig,0) - @ImpliedProbabilityTotalPickUnderOddsThreshold as DECIMAL(5,2)) < CAST(ISNULL(TotalScoreUnderCloseDevig,0) * @FiveUnitThreshold as DECIMAL(5,2)))
																					)
																				THEN 1
																				WHEN 
																					(
																						ImpliedProbabilityTotalPick = 'Over'
																					AND (CAST(ISNULL(TotalScoreOverCloseDevig,0) - @ImpliedProbabilityTotalPickOverOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(TotalScoreOverCloseDevig,0) * @FiveUnitThreshold as DECIMAL(5,2)))
																					AND (CAST(ISNULL(TotalScoreOverCloseDevig,0) - @ImpliedProbabilityTotalPickOverOddsThreshold as DECIMAL(5,2)) < CAST(ISNULL(TotalScoreOverCloseDevig,0) * @TenUnitThreshold as DECIMAL(5,2)))
																					)
																				OR (
																						ImpliedProbabilityTotalPick = 'Under'
																					AND (CAST(ISNULL(TotalScoreUnderCloseDevig,0) - @ImpliedProbabilityTotalPickUnderOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(TotalScoreUnderCloseDevig,0) * @FiveUnitThreshold as DECIMAL(5,2)))
																					AND (CAST(ISNULL(TotalScoreUnderCloseDevig,0) - @ImpliedProbabilityTotalPickUnderOddsThreshold as DECIMAL(5,2)) < CAST(ISNULL(TotalScoreUnderCloseDevig,0) * @TenUnitThreshold as DECIMAL(5,2)))
																					)
																				THEN 5
																				WHEN 
																					(
																						ImpliedProbabilityTotalPick = 'Over'
																					AND (CAST(ISNULL(TotalScoreOverCloseDevig,0) - @ImpliedProbabilityTotalPickOverOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(TotalScoreOverCloseDevig,0) * @TenUnitThreshold as DECIMAL(5,2)))
																					)
																				OR (
																						ImpliedProbabilityTotalPick = 'Under'
																					AND (CAST(ISNULL(TotalScoreUnderCloseDevig,0) - @ImpliedProbabilityTotalPickUnderOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(TotalScoreUnderCloseDevig,0) * @TenUnitThreshold as DECIMAL(5,2))) 
																					)
																				THEN 10
																				ELSE 1
																				END
	WHERE ImpliedProbabilityTotalPick IS NOT NULL

	/*Calculate Profit*/

	UPDATE #tempGameDataFull SET ImpliedProbabilityOutrightPickWagerProfit = CASE WHEN ImpliedProbabilityOutrightPickCorrect = 'Y' AND ImpliedProbabilityOutrightPick = 'Home' THEN ImpliedProbabilityOutrightPickWager * ISNULL(COALESCE(HomeLineOddsClose,HomeLineOddsMax,HomeLineOddsOpen),0) 
																			  WHEN ImpliedProbabilityOutrightPickCorrect = 'Y' AND ImpliedProbabilityOutrightPick = 'Away' THEN ImpliedProbabilityOutrightPickWager * ISNULL(COALESCE(AwayLineOddsClose,AwayLineOddsMax,AwayLineOddsOpen),0)
																			  WHEN ImpliedProbabilityOutrightPickCorrect = 'N' THEN ImpliedProbabilityOutrightPickWager * -1
																			  WHEN ImpliedProbabilityOutrightPickCorrect = 'P' THEN 0
																			  END
	WHERE ImpliedProbabilityOutrightPickCorrect IS NOT NULL AND ImpliedProbabilityOutrightPick IS NOT NULL AND ImpliedProbabilityOutrightPickWager IS NOT NULL

	UPDATE #tempGameDataFull SET ImpliedProbabilityOutrightPickHomeAwayWagerProfit = CASE WHEN ImpliedProbabilityOutrightPickHACorrect = 'Y' AND ImpliedProbabilityOutrightPickHomeAway = 'Home' THEN ImpliedProbabilityOutrightPickHomeAwayWager * ISNULL(COALESCE(HomeLineOddsClose,HomeLineOddsMax,HomeLineOddsOpen),0) 
																					  WHEN ImpliedProbabilityOutrightPickHACorrect = 'Y' AND ImpliedProbabilityOutrightPickHomeAway = 'Away' THEN ImpliedProbabilityOutrightPickHomeAwayWager * ISNULL(COALESCE(AwayLineOddsClose,AwayLineOddsMax,AwayLineOddsOpen),0)
																					  WHEN ImpliedProbabilityOutrightPickHACorrect = 'N' THEN ImpliedProbabilityOutrightPickHomeAwayWager * -1
																					  WHEN ImpliedProbabilityOutrightPickHACorrect = 'P' THEN 0
																					  END
	WHERE ImpliedProbabilityOutrightPickHACorrect IS NOT NULL AND ImpliedProbabilityOutrightPickHomeAway IS NOT NULL AND ImpliedProbabilityOutrightPickHomeAwayWager IS NOT NULL

	UPDATE #tempGameDataFull SET ImpliedProbabilityOutrightPickFavDogWagerProfit = CASE WHEN ImpliedProbabilityOutrightPickFDCorrect = 'Y' AND ImpliedProbabilityOutrightPickFavDog = 'Fav' AND ISNULL(HomeOddsCloseDevig,0) < ISNULL(AwayOddsCloseDevig,0) THEN ImpliedProbabilityOutrightPickFavDogWager * ISNULL(COALESCE(HomeLineOddsClose,HomeLineOddsMax,HomeLineOddsOpen),0) 
																				    WHEN ImpliedProbabilityOutrightPickFDCorrect = 'Y' AND ImpliedProbabilityOutrightPickFavDog = 'Fav' AND ISNULL(HomeOddsCloseDevig,0) > ISNULL(AwayOddsCloseDevig,0)  THEN ImpliedProbabilityOutrightPickFavDogWager * ISNULL(COALESCE(AwayLineOddsClose,AwayLineOddsMax,AwayLineOddsOpen),0)
																				    WHEN ImpliedProbabilityOutrightPickFDCorrect = 'Y' AND ImpliedProbabilityOutrightPickFavDog = 'Dog' AND ISNULL(HomeOddsCloseDevig,0) > ISNULL(AwayOddsCloseDevig,0) THEN ImpliedProbabilityOutrightPickFavDogWager * ISNULL(COALESCE(HomeLineOddsClose,HomeLineOddsMax,HomeLineOddsOpen),0) 
																				    WHEN ImpliedProbabilityOutrightPickFDCorrect = 'Y' AND ImpliedProbabilityOutrightPickFavDog = 'Dog' AND ISNULL(HomeOddsCloseDevig,0) < ISNULL(AwayOddsCloseDevig,0)  THEN ImpliedProbabilityOutrightPickFavDogWager * ISNULL(COALESCE(AwayLineOddsClose,AwayLineOddsMax,AwayLineOddsOpen),0)
																					WHEN ImpliedProbabilityOutrightPickFDCorrect = 'N' THEN ImpliedProbabilityOutrightPickFavDogWager * -1
																				    WHEN ImpliedProbabilityOutrightPickFDCorrect = 'P' THEN 0
																					END
	WHERE ImpliedProbabilityOutrightPickFDCorrect IS NOT NULL AND ImpliedProbabilityOutrightPickFavDog IS NOT NULL AND ImpliedProbabilityOutrightPickFavDogWager IS NOT NULL

	UPDATE #tempGameDataFull SET ImpliedProbabilitySpreadPickWagerProfit = CASE WHEN ImpliedProbabilitySpreadPickCorrect = 'Y' AND ImpliedProbabilitySpreadPick = 'Home' THEN ImpliedProbabilitySpreadPickWager * ISNULL(HomeLineOddsCloseDevig,0) 
																		    WHEN ImpliedProbabilitySpreadPickCorrect = 'Y' AND ImpliedProbabilitySpreadPick = 'Away' THEN ImpliedProbabilitySpreadPickWager * ISNULL(AwayLineOddsCloseDevig,0)
																		    WHEN ImpliedProbabilitySpreadPickCorrect = 'N' THEN ImpliedProbabilitySpreadPickWager * -1
																		    WHEN ImpliedProbabilitySpreadPickCorrect = 'P' THEN 0
																			END
	WHERE ImpliedProbabilitySpreadPickCorrect IS NOT NULL AND ImpliedProbabilitySpreadPick IS NOT NULL AND ImpliedProbabilitySpreadPickWager IS NOT NULL

	UPDATE #tempGameDataFull SET ImpliedProbabilitySpreadPickHomeAwayWagerProfit = CASE WHEN ImpliedProbabilitySpreadPickHACorrect = 'Y' AND ImpliedProbabilitySpreadPickHomeAway = 'Home' THEN ImpliedProbabilitySpreadPickHomeAwayWager * ISNULL(COALESCE(HomeLineOddsClose,HomeLineOddsMax,HomeLineOddsOpen),0)
																						WHEN ImpliedProbabilitySpreadPickHACorrect = 'Y' AND ImpliedProbabilitySpreadPickHomeAway = 'Away' THEN ImpliedProbabilitySpreadPickHomeAwayWager * ISNULL(COALESCE(AwayLineOddsClose,AwayLineOddsMax,AwayLineOddsOpen),0)
																						WHEN ImpliedProbabilitySpreadPickHACorrect = 'N' THEN ImpliedProbabilitySpreadPickHomeAwayWager * -1
																						WHEN ImpliedProbabilitySpreadPickHACorrect = 'P' THEN 0
																						END
	WHERE ImpliedProbabilitySpreadPickHACorrect IS NOT NULL AND ImpliedProbabilitySpreadPickHomeAway IS NOT NULL AND ImpliedProbabilitySpreadPickHomeAwayWager IS NOT NULL

	UPDATE #tempGameDataFull SET ImpliedProbabilitySpreadPickFavDogWagerProfit = CASE WHEN ImpliedProbabilitySpreadPickFDCorrect = 'Y' AND ImpliedProbabilitySpreadPickFavDog = 'Fav' AND ISNULL(COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen),0) < ISNULL(COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen),0) THEN ImpliedProbabilitySpreadPickFavDogWager * ISNULL(COALESCE(HomeLineOddsClose,HomeLineOddsMax,HomeLineOddsOpen),0) 
																				    WHEN ImpliedProbabilitySpreadPickFDCorrect = 'Y' AND ImpliedProbabilitySpreadPickFavDog = 'Fav' AND ISNULL(COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen),0) > ISNULL(COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen),0)  THEN ImpliedProbabilitySpreadPickFavDogWager * ISNULL(COALESCE(AwayLineOddsClose,AwayLineOddsMax,AwayLineOddsOpen),0)
																				    WHEN ImpliedProbabilitySpreadPickFDCorrect = 'Y' AND ImpliedProbabilitySpreadPickFavDog = 'Dog' AND ISNULL(COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen),0) > ISNULL(COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen),0) THEN ImpliedProbabilitySpreadPickFavDogWager * ISNULL(COALESCE(HomeLineOddsClose,HomeLineOddsMax,HomeLineOddsOpen),0) 
																				    WHEN ImpliedProbabilitySpreadPickFDCorrect = 'Y' AND ImpliedProbabilitySpreadPickFavDog = 'Dog' AND ISNULL(COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen),0) < ISNULL(COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen),0)  THEN ImpliedProbabilitySpreadPickFavDogWager * ISNULL(COALESCE(AwayLineOddsClose,AwayLineOddsMax,AwayLineOddsOpen),0)
																					WHEN ImpliedProbabilitySpreadPickFDCorrect = 'N' THEN ImpliedProbabilitySpreadPickFavDogWager * -1
																				    WHEN ImpliedProbabilitySpreadPickFDCorrect = 'P' THEN 0
																					END
	WHERE ImpliedProbabilitySpreadPickFDCorrect IS NOT NULL AND ImpliedProbabilitySpreadPickFavDog IS NOT NULL AND ImpliedProbabilitySpreadPickFavDogWager IS NOT NULL

	UPDATE #tempGameDataFull SET ImpliedProbabilityTotalPickWagerProfit = CASE WHEN ImpliedProbabilityTotalPickCorrect = 'Y' AND ImpliedProbabilityTotalPick = 'Over' THEN ImpliedProbabilityTotalPickWager * ISNULL(TotalScoreOverClose,0)
																		   WHEN ImpliedProbabilityTotalPickCorrect = 'Y' AND ImpliedProbabilityTotalPick = 'Under' THEN ImpliedProbabilityTotalPickWager * ISNULL(TotalScoreUnderClose,0)
																		   WHEN ImpliedProbabilityTotalPickCorrect = 'N' THEN ImpliedProbabilityTotalPickWager * -1
																		   WHEN ImpliedProbabilityTotalPickCorrect = 'P' THEN 0
																		   END
	WHERE ImpliedProbabilityTotalPickCorrect IS NOT NULL AND ImpliedProbabilityTotalPick IS NOT NULL AND ImpliedProbabilityTotalPickWager IS NOT NULL


		--Season Accuracy Calculation									    
		--Total Applicable
		/*Calculate floating point accuracy*/
		UPDATE #SeasonData SET ImpliedProbabilityOutrightFDTotApplicable = CAST((SELECT COUNT(*) FROM #tempGameDataFull WHERE ImpliedProbabilityOutrightPickFDCorrect IS NOT NULL AND Season = @Year) as DECIMAL(5,2))
		WHERE Season = @Year
		
		UPDATE #SeasonData SET ImpliedProbabilityOutrightHATotApplicable = CAST((SELECT COUNT(*) FROM #tempGameDataFull WHERE ImpliedProbabilityOutrightPickHACorrect IS NOT NULL AND Season = @Year) as DECIMAL(5,2))
		WHERE Season = @Year

		UPDATE #SeasonData SET ImpliedProbabilityOutrightPickTotApplicable = CAST((SELECT COUNT(*) FROM #tempGameDataFull WHERE ImpliedProbabilityOutrightPickCorrect IS NOT NULL AND Season = @Year) as DECIMAL(5,2))
		WHERE Season = @Year

		UPDATE #SeasonData SET ImpliedProbabilitySpreadFDTotApplicable = CAST((SELECT COUNT(*) FROM #tempGameDataFull WHERE ImpliedProbabilitySpreadPickFDCorrect IS NOT NULL AND Season = @Year) as DECIMAL(5,2))
		WHERE Season = @Year

		UPDATE #SeasonData SET ImpliedProbabilitySpreadHATotApplicable = CAST((SELECT COUNT(*) FROM #tempGameDataFull WHERE ImpliedProbabilitySpreadPickHACorrect IS NOT NULL AND Season = @Year) as DECIMAL(5,2))
		WHERE Season = @Year
		
		UPDATE #SeasonData SET ImpliedProbabilitySpreadPickTotApplicable = CAST((SELECT COUNT(*) FROM #tempGameDataFull WHERE ImpliedProbabilitySpreadPickCorrect IS NOT NULL AND Season = @Year) as DECIMAL(5,2))
		WHERE Season = @Year
		
		UPDATE #SeasonData SET ImpliedProbabilityTotalTotApplicable = CAST((SELECT COUNT(*) FROM #tempGameDataFull WHERE ImpliedProbabilityTotalPickCorrect IS NOT NULL AND Season = @Year) as DECIMAL(5,2))
		WHERE Season = @Year

		--Set Number Correct
		UPDATE #SeasonData SET ImpliedProbabilityOutrightFDNumCorrect = CAST((SELECT COUNT(*) FROM #tempGameDataFull WHERE ImpliedProbabilityOutrightPickFDCorrect = 'Y' AND Season = @Year) as DECIMAL(5,2))
		WHERE (SELECT COUNT(*) FROM #tempGameDataFull WHERE ImpliedProbabilityOutrightPickFDCorrect IS NOT NULL AND Season = @Year) <> 0
		AND Season = @Year
		
		UPDATE #SeasonData SET ImpliedProbabilityOutrightHANumCorrect = CAST((SELECT COUNT(*) FROM #tempGameDataFull WHERE ImpliedProbabilityOutrightPickHACorrect = 'Y' AND Season = @Year) as DECIMAL(5,2))
		WHERE (SELECT COUNT(*) FROM #tempGameDataFull WHERE ImpliedProbabilityOutrightPickHACorrect IS NOT NULL AND Season = @Year) <> 0
		AND Season = @Year

		UPDATE #SeasonData SET ImpliedProbabilityOutrightPickNumCorrect = CAST((SELECT COUNT(*) FROM #tempGameDataFull WHERE ImpliedProbabilityOutrightPickCorrect = 'Y' AND Season = @Year) as DECIMAL(5,2))
		WHERE (SELECT COUNT(*) FROM #tempGameDataFull WHERE ImpliedProbabilityOutrightPickCorrect IS NOT NULL AND Season = @Year) <> 0
		AND Season = @Year

		UPDATE #SeasonData SET ImpliedProbabilitySpreadFDNumCorrect = CAST((SELECT COUNT(*) FROM #tempGameDataFull WHERE ImpliedProbabilitySpreadPickFDCorrect = 'Y' AND Season = @Year) as DECIMAL(5,2))
		WHERE (SELECT COUNT(*) FROM #tempGameDataFull WHERE ImpliedProbabilitySpreadPickFDCorrect IS NOT NULL AND Season = @Year) <> 0
		AND Season = @Year

		UPDATE #SeasonData SET ImpliedProbabilitySpreadHANumCorrect = CAST((SELECT COUNT(*) FROM #tempGameDataFull WHERE ImpliedProbabilitySpreadPickHACorrect = 'Y' AND Season = @Year) as DECIMAL(5,2))
		WHERE (SELECT COUNT(*) FROM #tempGameDataFull WHERE ImpliedProbabilitySpreadPickHACorrect IS NOT NULL AND Season = @Year) <> 0
		AND Season = @Year
		
		UPDATE #SeasonData SET ImpliedProbabilitySpreadPickNumCorrect = CAST((SELECT COUNT(*) FROM #tempGameDataFull WHERE ImpliedProbabilitySpreadPickCorrect = 'Y' AND Season = @Year) as DECIMAL(5,2))
		WHERE (SELECT COUNT(*) FROM #tempGameDataFull WHERE ImpliedProbabilitySpreadPickCorrect IS NOT NULL AND Season = @Year) <> 0
		AND Season = @Year
		
		UPDATE #SeasonData SET ImpliedProbabilityTotalNumCorrect = CAST((SELECT COUNT(*) FROM #tempGameDataFull WHERE ImpliedProbabilityTotalPickCorrect = 'Y' AND Season = @Year) as DECIMAL(5,2))
		WHERE (SELECT COUNT(*) FROM #tempGameDataFull WHERE ImpliedProbabilityTotalPickCorrect IS NOT NULL AND Season = @Year) <> 0
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
			
			IF @TestCode = 1
			BEGIN
				select 'HomeOddsCloseIP Error',* from #tempGameDataFull
				WHERE (HomeOddsCloseIP IS NULL AND (HomeLineOddsClose IS NOT NULL OR HomeLineOddsMax IS NOT NULL OR HomeLineOddsMin IS NOT NULL OR HomeLineOddsOpen IS NOT NULL))
				UNION ALL
				select 'AwayOddsCloseIP Error',* from #tempGameDataFull
				WHERE (AwayOddsCloseIP IS NULL AND (AwayLineOddsClose IS NOT NULL OR AwayLineOddsMax IS NOT NULL OR AwayLineOddsMin IS NOT NULL OR AwayLineOddsOpen IS NOT NULL))
				UNION ALL
				select 'HomeLineOddsCloseIP Error',* from #tempGameDataFull
				WHERE (HomeLineOddsCloseIP IS NULL AND (HomeLineOddsClose IS NOT NULL OR HomeLineOddsMax IS NOT NULL OR HomeLineOddsMin IS NOT NULL OR HomeLineOddsOpen IS NOT NULL))
				UNION ALL
				select 'AwayLineOddsCloseIP Error',* from #tempGameDataFull
				WHERE (AwayLineOddsCloseIP IS NULL AND (AwayLineOddsClose IS NOT NULL OR AwayLineOddsMax IS NOT NULL OR AwayLineOddsMin IS NOT NULL OR AwayLineOddsOpen IS NOT NULL))
				UNION ALL
				select 'TotalScoreOverCloseIP Error',* from #tempGameDataFull
				WHERE (TotalScoreOverCloseIP IS NULL AND (TotalScoreOverClose IS NOT NULL OR TotalScoreOverMax IS NOT NULL OR TotalScoreOverMin IS NOT NULL OR TotalScoreOverOpen IS NOT NULL))
				UNION ALL
				select 'TotalScoreUnderCloseIP Error',* from #tempGameDataFull
				WHERE (TotalScoreUnderCloseIP IS NULL AND (TotalScoreUnderClose IS NOT NULL OR TotalScoreUnderMax IS NOT NULL OR TotalScoreUnderMin IS NOT NULL OR TotalScoreUnderOpen IS NOT NULL))
				UNION ALL
				select 'HomeOddsCloseDevig Error',* from #tempGameDataFull
				WHERE (HomeOddsCloseDevig IS NULL AND (HomeLineOddsClose IS NOT NULL OR HomeLineOddsMax IS NOT NULL OR HomeLineOddsMin IS NOT NULL OR HomeLineOddsOpen IS NOT NULL))
				UNION ALL
				select 'AwayOddsCloseDevig Error',* from #tempGameDataFull
				WHERE (AwayOddsCloseDevig IS NULL AND (AwayLineOddsClose IS NOT NULL OR AwayLineOddsMax IS NOT NULL OR AwayLineOddsMin IS NOT NULL OR AwayLineOddsOpen IS NOT NULL))
				UNION ALL
				select 'HomeLineOddsCloseDevig Error',* from #tempGameDataFull
				WHERE (HomeLineOddsCloseDevig IS NULL AND (HomeLineOddsClose IS NOT NULL OR HomeLineOddsMax IS NOT NULL OR HomeLineOddsMin IS NOT NULL OR HomeLineOddsOpen IS NOT NULL))
				UNION ALL
				select 'AwayLineOddsCloseDevig Error',* from #tempGameDataFull
				WHERE (AwayLineOddsCloseDevig IS NULL AND (AwayLineOddsClose IS NOT NULL OR AwayLineOddsMax IS NOT NULL OR AwayLineOddsMin IS NOT NULL OR AwayLineOddsOpen IS NOT NULL))
				UNION ALL
				select 'TotalScoreOverCloseDevig Error',* from #tempGameDataFull
				WHERE (TotalScoreOverCloseDevig IS NULL AND (TotalScoreOverClose IS NOT NULL OR TotalScoreOverMax IS NOT NULL OR TotalScoreOverMin IS NOT NULL OR TotalScoreOverOpen IS NOT NULL))
				UNION ALL
				select 'TotalScoreUnderCloseDevig Error',* from #tempGameDataFull
				WHERE (TotalScoreUnderCloseDevig IS NULL AND (TotalScoreUnderClose IS NOT NULL OR TotalScoreUnderMax IS NOT NULL OR TotalScoreUnderMin IS NOT NULL OR TotalScoreUnderOpen IS NOT NULL))
				UNION ALL
				select 'Outright Pick Error',* from #tempGameDataFull
				WHERE (ImpliedProbabilityOutrightPickCorrect IS NULL AND ImpliedProbabilityOutrightPick IS NOT NULL)
				UNION ALL
				select 'Outright FD Pick Error',* from #tempGameDataFull
				WHERE (ImpliedProbabilityOutrightPickFavDog IS NULL AND ImpliedProbabilityOutrightPickFDCorrect IS NOT NULL)
				UNION ALL
				select 'Outright HA Pick Error',* from #tempGameDataFull
				WHERE (ImpliedProbabilityOutrightPickHomeAway IS NULL AND ImpliedProbabilityOutrightPickHACorrect IS NOT NULL)
				UNION ALL
				select 'Spread Pick Error',* from #tempGameDataFull
				WHERE (ImpliedProbabilitySpreadPick IS NULL AND ImpliedProbabilitySpreadPickCorrect IS NOT NULL)
				UNION ALL
				select 'Spread Pick FD Error',* from #tempGameDataFull
				WHERE (ImpliedProbabilitySpreadPickFavDog IS NULL AND ImpliedProbabilitySpreadPickFDCorrect IS NOT NULL)
				UNION ALL
				select 'Spread Pick HA Error',* from #tempGameDataFull
				WHERE (ImpliedProbabilitySpreadPickHomeAway IS NULL AND ImpliedProbabilitySpreadPickHACorrect IS NOT NULL)
				UNION ALL
				select 'Total Pick Error',* from #tempGameDataFull
				WHERE (ImpliedProbabilityTotalPick IS NULL AND ImpliedProbabilityTotalPickCorrect IS NOT NULL)

				UNION ALL

				select 'Outright Pick Wager Error',* from #tempGameDataFull
				WHERE (ImpliedProbabilityOutrightPickWager IS NULL AND ImpliedProbabilityOutrightPickWagerProfit IS NOT NULL) OR (ImpliedProbabilityOutrightPickWager IS NOT NULL AND ImpliedProbabilityOutrightPickWagerProfit IS NULL)
				UNION ALL
				select 'Outright FD Pick Wager Error',* from #tempGameDataFull
				WHERE (ImpliedProbabilityOutrightPickFavDogWager IS NULL AND ImpliedProbabilityOutrightPickFavDogWagerProfit IS NOT NULL) OR (ImpliedProbabilityOutrightPickFavDogWager IS NOT NULL AND ImpliedProbabilityOutrightPickFavDogWagerProfit IS NULL)
				UNION ALL
				select 'Outright HA Pick Wager Error',* from #tempGameDataFull
				WHERE (ImpliedProbabilityOutrightPickHomeAwayWager IS NULL AND ImpliedProbabilityOutrightPickHomeAwayWagerProfit IS NOT NULL) OR (ImpliedProbabilityOutrightPickHomeAwayWager IS NOT NULL AND ImpliedProbabilityOutrightPickHomeAwayWagerProfit IS NULL)
				UNION ALL
				select 'Spread Pick Wager Error',* from #tempGameDataFull
				WHERE (ImpliedProbabilitySpreadPickWager IS NULL AND ImpliedProbabilitySpreadPickWagerProfit IS NOT NULL) OR (ImpliedProbabilitySpreadPickWager IS NOT NULL AND ImpliedProbabilitySpreadPickWagerProfit IS NULL)
				UNION ALL
				select 'Spread Pick FD Wager Error',* from #tempGameDataFull
				WHERE (ImpliedProbabilitySpreadPickFavDogWager IS NULL AND ImpliedProbabilitySpreadPickFavDogWagerProfit IS NOT NULL) OR (ImpliedProbabilitySpreadPickFavDogWager IS NOT NULL AND ImpliedProbabilitySpreadPickFavDogWagerProfit IS NULL)
				UNION ALL
				select 'Spread Pick HA Wager Error',* from #tempGameDataFull
				WHERE (ImpliedProbabilitySpreadPickHomeAwayWager IS NULL AND ImpliedProbabilitySpreadPickHomeAwayWagerProfit IS NOT NULL) OR (ImpliedProbabilitySpreadPickHomeAwayWager IS NOT NULL AND ImpliedProbabilitySpreadPickHomeAwayWagerProfit IS NULL)
				UNION ALL
				select 'Total Pick Wager Error',* from #tempGameDataFull
				WHERE (ImpliedProbabilityTotalPickWager IS NULL AND ImpliedProbabilityTotalPickWagerProfit IS NOT NULL) OR (ImpliedProbabilityTotalPickWager IS NOT NULL AND ImpliedProbabilityTotalPickWagerProfit IS NULL)



			END
			IF @TestCode = 1
			select * from #tempGameDataFull

			IF @TestCode = 1
			select   sd.Season				
					/*Summary Data*/
					,gd.SeasonWager
					,gd.SeasonProfit
					,@OneUnitThreshold
					,@FiveUnitThreshold
					,@TenUnitThreshold
					,gd.SeasonProfit / ISNULL(NULLIF(gd.SeasonWager,0),1) as SeasonROI
					/*Regular Columns*/
					,SeasonTotalUnderRate			
					,SeasonTotalPushRate			
					,SeasonTotalOverRate			
					,HomeUnderdogSpreadCoverRate	
					,HomeFavoriteSpreadCoverRate	
					,AwayUnderdogSpreadCoverRate	
					,AwayFavoriteSpreadCoverRate	
					,HomeSpreadCoverRate			
					,AwaySpreadCoverRate			
					,FavoriteSpreadCoverRate		
					,DogSpreadCoverRate				
					,HomeUnderdogOutrightRate		
					,HomeFavoriteOutrightRate		
					,AwayUnderdogOutrightRate		
					,AwayFavoriteOutrightRate		
					,HomeOutrightRate				
					,AwayOutrightRate				
					,FavoriteOutrightRate			
					,DogOutrightRate			
					--Outright Home/Away
					,ImpliedProbabilityOutrightHANumCorrect 
					,ImpliedProbabilityOutrightHATotApplicable
					,ImpliedProbabilityOutrightHAAccuracy 
					,gd.ImpliedProbabilityOutrightPickHomeAwayProfit
					--Outright Favorite/Underdog
					,ImpliedProbabilityOutrightFDNumCorrect 
					,ImpliedProbabilityOutrightFDTotApplicable 
					,ImpliedProbabilityOutrightFDAccuracy 
					,gd.ImpliedProbabilityOutrightFavDogProfit
					--Outright Pick
					,ImpliedProbabilityOutrightPickNumCorrect 
					,ImpliedProbabilityOutrightPickTotApplicable 
					,ImpliedProbabilityOutrightPickAccuracy 
					,gd.ImpliedProbabilityOutrightPickProfit
					--Spread Home/Away
					,ImpliedProbabilitySpreadHANumCorrect 
					,ImpliedProbabilitySpreadHATotApplicable 
					,ImpliedProbabilitySpreadHAAccuracy 
					,gd.ImpliedProbabilitySpreadPickHomeAwayProfit
					--Spread Favorite/Underdog
					,ImpliedProbabilitySpreadFDNumCorrect 
					,ImpliedProbabilitySpreadFDTotApplicable
					,ImpliedProbabilitySpreadFDAccuracy
					,gd.ImpliedProbabilitySpreadPickFavDogProfit
					--Spread Pick
					,ImpliedProbabilitySpreadPickNumCorrect 
					,ImpliedProbabilitySpreadPickTotApplicable 
					,ImpliedProbabilitySpreadPickAccuracy 
					,gd.ImpliedProbabilitySpreadPickProfit
					--Total O/U
					,ImpliedProbabilityTotalNumCorrect 
					,ImpliedProbabilityTotalTotApplicable 
					,ImpliedProbabilityTotalAccuracy 
					,gd.ImpliedProbabilityTotalPickProfit
				from #SeasonData sd
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
					 FROM #tempGameDataFull GROUP BY Season) gd ON gd.Season = sd.Season
				ORDER BY sd.Season ASC

				IF @TestCode = 0
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
					 FROM #tempGameDataFull GROUP BY Season) gd ON gd.Season = sd.Season
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
					,s.ImpliedProbabilityOutrightHAAccuracy = sd.ImpliedProbabilityOutrightHAAccuracy
					,s.ImpliedProbabilityOutrightHAProfit = sd.ImpliedProbabilityOutrightHAProfit
					--Outright Favorite/Underdog
					,s.ImpliedProbabilityOutrightFDNumCorrect = sd.ImpliedProbabilityOutrightFDNumCorrect 
					,s.ImpliedProbabilityOutrightFDTotApplicable = sd.ImpliedProbabilityOutrightFDTotApplicable 
					,s.ImpliedProbabilityOutrightFDAccuracy = sd.ImpliedProbabilityOutrightFDAccuracy 
					,s.ImpliedProbabilityOutrightFDProfit = gd.ImpliedProbabilityOutrightFavDogProfit
					--Outright Pick
					,s.ImpliedProbabilityOutrightPickNumCorrect = sd.ImpliedProbabilityOutrightPickNumCorrect 
					,s.ImpliedProbabilityOutrightPickTotApplicable  = sd.ImpliedProbabilityOutrightPickTotApplicable 
					,s.ImpliedProbabilityOutrightPickAccuracy  = sd.ImpliedProbabilityOutrightPickAccuracy 
					,s.ImpliedProbabilityOutrightPickProfit = gd.ImpliedProbabilityOutrightPickProfit
					--Spread Home/Away
					,s.ImpliedProbabilitySpreadHANumCorrect = sd.ImpliedProbabilitySpreadHANumCorrect 
					,s.ImpliedProbabilitySpreadHATotApplicable  = sd.ImpliedProbabilitySpreadHATotApplicable 
					,s.ImpliedProbabilitySpreadHAAccuracy = sd.ImpliedProbabilitySpreadHAAccuracy 
					,s.ImpliedProbabilitySpreadHAProfit = gd.ImpliedProbabilitySpreadPickHomeAwayProfit
					--Spread Favorite/Underdog
					,s.ImpliedProbabilitySpreadFDNumCorrect = sd.ImpliedProbabilitySpreadFDNumCorrect 
					,s.ImpliedProbabilitySpreadFDTotApplicable = sd.ImpliedProbabilitySpreadFDTotApplicable
					,s.ImpliedProbabilitySpreadFDAccuracy = sd.ImpliedProbabilitySpreadFDAccuracy
					,s.ImpliedProbabilitySpreadFDProfit = gd.ImpliedProbabilitySpreadPickFavDogProfit
					--Spread Pick
					,s.ImpliedProbabilitySpreadPickNumCorrect = sd.ImpliedProbabilitySpreadPickNumCorrect 
					,s.ImpliedProbabilitySpreadPickTotApplicable = sd.ImpliedProbabilitySpreadPickTotApplicable 
					,s.ImpliedProbabilitySpreadPickAccuracy = sd.ImpliedProbabilitySpreadPickAccuracy 
					,s.ImpliedProbabilitySpreadPickProfit = gd.ImpliedProbabilitySpreadPickProfit
					--Total O/U
					,s.ImpliedProbabilityTotalNumCorrect = sd.ImpliedProbabilityTotalNumCorrect 
					,s.ImpliedProbabilityTotalTotApplicable = sd.ImpliedProbabilityTotalTotApplicable 
					,s.ImpliedProbabilityTotalAccuracy = sd.ImpliedProbabilityTotalAccuracy 
					,s.ImpliedProbabilityTotalProfit = gd.ImpliedProbabilityTotalPickProfit
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
					 FROM #tempGameDataFull GROUP BY Season) gd ON gd.Season = sd.Season
				
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
			JOIN #tempGameDataFull tgd ON tgd.Season = gd.Season AND tgd.HomeTeam = gd.HomeTeam AND tgd.AwayTeam = gd.AwayTeam AND tgd.Week = gd.Week
			
		

			INSERT INTO SeasonDataAggregateCache (Season, SeasonWager, SeasonROI, OneUnitThreshold, FiveUnitThreshold, TenUnitThreshold)
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
					 FROM #tempGameDataFull GROUP BY Season) gd ON gd.Season = sd.Season


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
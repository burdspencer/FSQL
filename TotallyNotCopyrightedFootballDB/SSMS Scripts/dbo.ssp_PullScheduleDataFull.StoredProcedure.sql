USE [ProFootballReference]
GO
/****** Object:  StoredProcedure [dbo].[ssp_PullScheduleDataFull]    Script Date: 8/28/2023 6:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_PullScheduleDataFull]

AS
BEGIN TRY
	DECLARE @Season INT

	IF OBJECT_ID('tempdb..#tempGameDataFull','U') IS NOT NULL
		DROP TABLE #tempGameDataFull

	CREATE TABLE #tempGameDataFull (
	Team						varchar(100),
	Week						varchar(20),
	Season						int,
	HomeFlag					varchar(1),
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
	/*Odds Data*/
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
	TotalScoreUnderClose		decimal(5,2),
	/*Odds Movement*/
	HomeLineMovement			decimal(5,2),
	HomeLineOddsUnderMovement	decimal(5,2),
	AwayLineMovement			decimal(5,2),
	AwayLineOddsMovement		decimal(5,2),
	TotalScoreMovement			decimal(5,2),
	TotalScoreOverMovement		decimal(5,2),
	TotalScoreUnderMovement		decimal(5,2),
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
		INSERT INTO #tempGameDataFull (
			 Team
			,Week
			,Season
			,HomeFlag
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
		EXEC ssp_PullScheduleData @Season
	FETCH NEXT FROM year_cur INTO @Season
	END

	SELECT		Team
			,	[Week]
			,	Season
			,	Result
			,	HomeFlag
			,	AvgPointsFor
			,	AvgPointsAgainst
			,	AvgOff1stD
			,	AvgOffTotYd
			,	AvgOffPassYd
			,	AvgOffRushYd	
			,	AvgOffTO			
			,	AvgDef1stD			
			,	AvgDefTotYd		
			,	AvgDefPassYd		
			,	AvgDefRushYd		
			,	AvgDefTO			
			,	AvgExPointsOff		
			,	AvgExPointsDef		
			,	AvgExPointsSpecial
			,	LastPointsFor
			,	LastPointsAgainst
			,	LastOff1stD
			,	LastOffTotYd
			,	LastOffPassYd
			,	LastOffRushYd	
			,	LastOffTO			
			,	LastDef1stD			
			,	LastDefTotYd		
			,	LastDefPassYd		
			,	LastDefRushYd		
			,	LastDefTO			
			,	LastExPointsOff		
			,	LastExPointsDef		
			,	LastExPointsSpecial
			,	HomeOddsOpen
			,	HomeOddsMin
			,	HomeOddsMax
			,	AwayOddsOpen
			,	AwayOddsMin
			,	AwayOddsMax
			,	HomeLineOpen
			,	HomeLineMin
			,	HomeLineMax
			,	HomeLineClose
			,	AwayLineOpen
			,	AwayLineMin
			,	AwayLineMax
			,	AwayLineClose
			,	HomeLineOddsOpen
			,	HomeLineOddsMin
			,	HomeLineOddsMax
			,	HomeLineOddsClose
			,	AwayLineOddsOpen
			,	AwayLineOddsMin
			,	AwayLineOddsMax
			,	AwayLineOddsClose
			,	TotalScoreOpen
			,	TotalScoreMin
			,	TotalScoreMax
			,	TotalScoreClose
			,	TotalScoreOverOpen
			,	TotalScoreOverMin
			,	TotalScoreOverMax
			,	TotalScoreOverClose
			,	TotalScoreUnderOpen
			,	TotalScoreUnderMin
			,	TotalScoreUnderMax
			,	TotalScoreUnderClose
			,	HomeOddsClose as HomeMLClose
			,	AwayOddsClose as AwayMLClose
			,	CONCAT(HomeLineClose, ' @ ', HomeLineOddsClose) as HomeSpreadClose
			,	CONCAT(AwayLineClose, ' @ ', AwayLineOddsClose) as AwaySpreadClose
			,	CONCAT(TotalScoreClose, ' @ ', TotalScoreUnderClose, ' / ', TotalScoreOverClose) as AwaySpreadClose
			,	ISNULL(HomeOddsClose,0) - ISNULL(HomeOddsOpen,0) as HomeLineMovement	
			,	ISNULL(AwayOddsClose,0) - ISNULL(AwayOddsOpen,0) as AwayLineMovement	
			,	ISNULL(HomeLineClose,0) - ISNULL(HomeLineOpen,0) as HomeLineMovement
			,	ISNULL(AwayLineClose,0) - ISNULL(AwayLineOpen,0) as AwayLineMovement		
			,	ISNULL(HomeLineOddsClose,0) - ISNULL(AwayLineOddsOpen,0) as HomeLineOddsMovement	
			,	ISNULL(AwayLineOddsClose,0) - ISNULL(AwayLineOddsOpen,0) as AwayLineOddsMovement	
			,	ISNULL(TotalScoreClose,0) - ISNULL(TotalScoreOpen,0) as TotalScoreMovement		
			,	ISNULL(TotalScoreOverClose,0) - ISNULL(TotalScoreOverClose,0) as TotalScoreOverMovement	
			,	ISNULL(TotalScoreUnderClose,0) - ISNULL(TotalScoreUnderOpen,0) as TotalScoreUnderMovement
	FROM #tempGameDataFull

	
	CLOSE year_cur;
	DEALLOCATE year_cur;
	
END TRY
BEGIN CATCH
	SELECT ERROR_MESSAGE(), ERROR_LINE(), ERROR_PROCEDURE()
END CATCH
GO

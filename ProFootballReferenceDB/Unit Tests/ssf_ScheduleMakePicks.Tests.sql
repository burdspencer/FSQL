/*Unit Test File for Tests_ssf_ScheduleMakePicks*/
/**************************************************
*	Test Case								
*	NULL Team Parameter returns no data
*	NULL Opponent Parameter returns no data
*
*
*
***************************************************/

EXEC tSQLt.NewTestClass @ClassName = 'Tests_ssf_ScheduleMakePicks'
GO

CREATE PROCEDURE Tests_ssf_ScheduleMakePicks.Setup
AS
BEGIN
	IF OBJECT_ID('Tests_ssf_ScheduleMakePicks.Expected','U') IS NOT NULL
		DROP TABLE Tests_ssf_ScheduleMakePicks.Expected

	CREATE TABLE Tests_ssf_ScheduleMakePicks.Expected
	(
	  HomeTeam					varchar(100),
	AwayTeam					varchar(100),
	Week						varchar(20),
	Season						int,
	HomeScore					int,
	AwayScore					int,
	Result						varchar(100),
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
	/*Betting Report Only*/
	ImpliedProbabilityOutrightPick					VARCHAR(10) NULL,
	ImpliedProbabilityOutrightPickHomeAway			VARCHAR(10) NULL,
	ImpliedProbabilityOutrightPickFavDog			VARCHAR(10) NULL,
	ImpliedProbabilityOutrightPickCorrect			VARCHAR(1) NULL, --Outright Best Pick Correct
	ImpliedProbabilityOutrightPickHACorrect			VARCHAR(1) NULL, --Home/Away Pick Correct
	ImpliedProbabilityOutrightPickFDCorrect			VARCHAR(1) NULL, --Fav/Dog Pick Correct
	ImpliedProbabilitySpreadPick					VARCHAR(10) NULL,
	ImpliedProbabilitySpreadPickHomeAway			VARCHAR(10) NULL,
	ImpliedProbabilitySpreadPickFavDog				VARCHAR(10) NULL,
	ImpliedProbabilitySpreadPickHACorrect			VARCHAR(1) NULL,
	ImpliedProbabilitySpreadPickFDCorrect			VARCHAR(1) NULL,
	ImpliedProbabilitySpreadPickCorrect				VARCHAR(1) NULL,
	ImpliedProbabilityTotalPick						VARCHAR(10) NULL,
	ImpliedProbabilityTotalPickCorrect				VARCHAR(1) NULL,
	/*Betting Profit Calc Columns*/
	ImpliedProbabilityOutrightPickWager					DECIMAL(7,2) NULL,
	ImpliedProbabilityOutrightPickHomeAwayWager			DECIMAL(7,2) NULL,
	ImpliedProbabilityOutrightPickFavDogWager			DECIMAL(7,2) NULL,
	ImpliedProbabilitySpreadPickWager					DECIMAL(7,2) NULL,
	ImpliedProbabilitySpreadPickHomeAwayWager			DECIMAL(7,2) NULL,
	ImpliedProbabilitySpreadPickFavDogWager				DECIMAL(7,2) NULL,
	ImpliedProbabilityTotalPickWager					DECIMAL(7,2) NULL,
	ImpliedProbabilityOutrightPickWagerProfit			DECIMAL(11,2) NULL,
	ImpliedProbabilityOutrightPickHomeAwayWagerProfit	DECIMAL(11,2) NULL,
	ImpliedProbabilityOutrightPickFavDogWagerProfit		DECIMAL(11,2) NULL,
	ImpliedProbabilitySpreadPickWagerProfit				DECIMAL(11,2) NULL,
	ImpliedProbabilitySpreadPickHomeAwayWagerProfit		DECIMAL(11,2) NULL,
	ImpliedProbabilitySpreadPickFavDogWagerProfit		DECIMAL(11,2) NULL,
	ImpliedProbabilityTotalPickWagerProfit				DECIMAL(11,2) NULL,
	/*Implied Probability Thresholds*/
	ImpliedProbabilityOutrightPickHomeOddsThreshold		DECIMAL(7,2),
	ImpliedProbabilityOutrightPickAwayOddsThreshold		DECIMAL(7,2),
	ImpliedProbabilityOutrightPickFavoriteOddsThreshold	DECIMAL(7,2),
	ImpliedProbabilityOutrightPickDogOddsThreshold		DECIMAL(7,2),
	ImpliedProbabilitySpreadPickHomeOddsThreshold		DECIMAL(7,2),
	ImpliedProbabilitySpreadPickAwayOddsThreshold		DECIMAL(7,2),
	ImpliedProbabilitySpreadPickFavoriteOddsThreshold	DECIMAL(7,2),
	ImpliedProbabilitySpreadPickDogOddsThreshold		DECIMAL(7,2),
	ImpliedProbabilityTotalPickOverOddsThreshold		DECIMAL(7,2),
	ImpliedProbabilityTotalPickUnderOddsThreshold		DECIMAL(7,2),
	/*Pick Thresholds*/
	OneUnitThreshold DECIMAL(5,2),
	FiveUnitThreshold DECIMAL(5,2),
	TenUnitThreshold DECIMAL(5,2)
	)

	IF OBJECT_ID('Tests_ssf_ScheduleMakePicks.Actual','U') IS NOT NULL
		DROP TABLE Tests_ssf_ScheduleMakePicks.Actual

	CREATE TABLE Tests_ssf_ScheduleMakePicks.Actual
	(
	HomeTeam					varchar(100),
	AwayTeam					varchar(100),
	Week						varchar(20),
	Season						int,
	HomeScore					int,
	AwayScore					int,
	Result						varchar(100),
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
	/*Betting Report Only*/
	ImpliedProbabilityOutrightPick					VARCHAR(10) NULL,
	ImpliedProbabilityOutrightPickHomeAway			VARCHAR(10) NULL,
	ImpliedProbabilityOutrightPickFavDog			VARCHAR(10) NULL,
	ImpliedProbabilityOutrightPickCorrect			VARCHAR(1) NULL, --Outright Best Pick Correct
	ImpliedProbabilityOutrightPickHACorrect			VARCHAR(1) NULL, --Home/Away Pick Correct
	ImpliedProbabilityOutrightPickFDCorrect			VARCHAR(1) NULL, --Fav/Dog Pick Correct
	ImpliedProbabilitySpreadPick					VARCHAR(10) NULL,
	ImpliedProbabilitySpreadPickHomeAway			VARCHAR(10) NULL,
	ImpliedProbabilitySpreadPickFavDog				VARCHAR(10) NULL,
	ImpliedProbabilitySpreadPickHACorrect			VARCHAR(1) NULL,
	ImpliedProbabilitySpreadPickFDCorrect			VARCHAR(1) NULL,
	ImpliedProbabilitySpreadPickCorrect				VARCHAR(1) NULL,
	ImpliedProbabilityTotalPick						VARCHAR(10) NULL,
	ImpliedProbabilityTotalPickCorrect				VARCHAR(1) NULL,
	/*Betting Profit Calc Columns*/
	ImpliedProbabilityOutrightPickWager					DECIMAL(7,2) NULL,
	ImpliedProbabilityOutrightPickHomeAwayWager			DECIMAL(7,2) NULL,
	ImpliedProbabilityOutrightPickFavDogWager			DECIMAL(7,2) NULL,
	ImpliedProbabilitySpreadPickWager					DECIMAL(7,2) NULL,
	ImpliedProbabilitySpreadPickHomeAwayWager			DECIMAL(7,2) NULL,
	ImpliedProbabilitySpreadPickFavDogWager				DECIMAL(7,2) NULL,
	ImpliedProbabilityTotalPickWager					DECIMAL(7,2) NULL,
	ImpliedProbabilityOutrightPickWagerProfit			DECIMAL(11,2) NULL,
	ImpliedProbabilityOutrightPickHomeAwayWagerProfit	DECIMAL(11,2) NULL,
	ImpliedProbabilityOutrightPickFavDogWagerProfit		DECIMAL(11,2) NULL,
	ImpliedProbabilitySpreadPickWagerProfit				DECIMAL(11,2) NULL,
	ImpliedProbabilitySpreadPickHomeAwayWagerProfit		DECIMAL(11,2) NULL,
	ImpliedProbabilitySpreadPickFavDogWagerProfit		DECIMAL(11,2) NULL,
	ImpliedProbabilityTotalPickWagerProfit				DECIMAL(11,2) NULL,
	/*Pick Thresholds*/
	OneUnitThreshold DECIMAL(5,2),
	FiveUnitThreshold DECIMAL(5,2),
	TenUnitThreshold DECIMAL(5,2)
	)

	IF OBJECT_ID('Tests_ssf_ScheduleMakePicks.ExpectedPicks','U') IS NOT NULL
		DROP TABLE Tests_ssf_ScheduleMakePicks.ExpectedPicks

	CREATE TABLE Tests_ssf_ScheduleMakePicks.ExpectedPicks
	(
	  HomeTeam					varchar(100),
	AwayTeam					varchar(100),
	Week						varchar(20),
	Season						int,
	/*Betting Report Only*/
	ImpliedProbabilityOutrightPick					VARCHAR(10) NULL,
	ImpliedProbabilityOutrightPickHomeAway			VARCHAR(10) NULL,
	ImpliedProbabilityOutrightPickFavDog			VARCHAR(10) NULL,
	ImpliedProbabilityOutrightPickCorrect			VARCHAR(1) NULL, --Outright Best Pick Correct
	ImpliedProbabilityOutrightPickHACorrect			VARCHAR(1) NULL, --Home/Away Pick Correct
	ImpliedProbabilityOutrightPickFDCorrect			VARCHAR(1) NULL, --Fav/Dog Pick Correct
	ImpliedProbabilitySpreadPick					VARCHAR(10) NULL,
	ImpliedProbabilitySpreadPickHomeAway			VARCHAR(10) NULL,
	ImpliedProbabilitySpreadPickFavDog				VARCHAR(10) NULL,
	ImpliedProbabilitySpreadPickHACorrect			VARCHAR(1) NULL,
	ImpliedProbabilitySpreadPickFDCorrect			VARCHAR(1) NULL,
	ImpliedProbabilitySpreadPickCorrect				VARCHAR(1) NULL,
	ImpliedProbabilityTotalPick						VARCHAR(10) NULL,
	ImpliedProbabilityTotalPickCorrect				VARCHAR(1) NULL
	)

	IF OBJECT_ID('Tests_ssf_ScheduleMakePicks.ActualPicks','U') IS NOT NULL
		DROP TABLE Tests_ssf_ScheduleMakePicks.ActualPicks

	CREATE TABLE Tests_ssf_ScheduleMakePicks.ActualPicks
	(
	HomeTeam					varchar(100),
	AwayTeam					varchar(100),
	Week						varchar(20),
	Season						int,
	/*Betting Report Only*/
	ImpliedProbabilityOutrightPick					VARCHAR(10) NULL,
	ImpliedProbabilityOutrightPickHomeAway			VARCHAR(10) NULL,
	ImpliedProbabilityOutrightPickFavDog			VARCHAR(10) NULL,
	ImpliedProbabilityOutrightPickCorrect			VARCHAR(1) NULL, --Outright Best Pick Correct
	ImpliedProbabilityOutrightPickHACorrect			VARCHAR(1) NULL, --Home/Away Pick Correct
	ImpliedProbabilityOutrightPickFDCorrect			VARCHAR(1) NULL, --Fav/Dog Pick Correct
	ImpliedProbabilitySpreadPick					VARCHAR(10) NULL,
	ImpliedProbabilitySpreadPickHomeAway			VARCHAR(10) NULL,
	ImpliedProbabilitySpreadPickFavDog				VARCHAR(10) NULL,
	ImpliedProbabilitySpreadPickHACorrect			VARCHAR(1) NULL,
	ImpliedProbabilitySpreadPickFDCorrect			VARCHAR(1) NULL,
	ImpliedProbabilitySpreadPickCorrect				VARCHAR(1) NULL,
	ImpliedProbabilityTotalPick						VARCHAR(10) NULL,
	ImpliedProbabilityTotalPickCorrect				VARCHAR(1) NULL
	)

	IF OBJECT_ID('Tests_ssf_ScheduleMakePicks.ExpectedProfit','U') IS NOT NULL
		DROP TABLE Tests_ssf_ScheduleMakePicks.ExpectedProfit

	CREATE TABLE Tests_ssf_ScheduleMakePicks.ExpectedProfit
	(
	  HomeTeam					varchar(100),
	AwayTeam					varchar(100),
	Week						varchar(20),
	Season						int,
	/*Betting Profit Calc Columns*/
	ImpliedProbabilityOutrightPickWager					DECIMAL(7,2) NULL,
	ImpliedProbabilityOutrightPickHomeAwayWager			DECIMAL(7,2) NULL,
	ImpliedProbabilityOutrightPickFavDogWager			DECIMAL(7,2) NULL,
	ImpliedProbabilitySpreadPickWager					DECIMAL(7,2) NULL,
	ImpliedProbabilitySpreadPickHomeAwayWager			DECIMAL(7,2) NULL,
	ImpliedProbabilitySpreadPickFavDogWager				DECIMAL(7,2) NULL,
	ImpliedProbabilityTotalPickWager					DECIMAL(7,2) NULL,
	ImpliedProbabilityOutrightPickWagerProfit			DECIMAL(11,2) NULL,
	ImpliedProbabilityOutrightPickHomeAwayWagerProfit	DECIMAL(11,2) NULL,
	ImpliedProbabilityOutrightPickFavDogWagerProfit		DECIMAL(11,2) NULL,
	ImpliedProbabilitySpreadPickWagerProfit				DECIMAL(11,2) NULL,
	ImpliedProbabilitySpreadPickHomeAwayWagerProfit		DECIMAL(11,2) NULL,
	ImpliedProbabilitySpreadPickFavDogWagerProfit		DECIMAL(11,2) NULL,
	ImpliedProbabilityTotalPickWagerProfit				DECIMAL(11,2) NULL
	)

	IF OBJECT_ID('Tests_ssf_ScheduleMakePicks.ActualProfit','U') IS NOT NULL
		DROP TABLE Tests_ssf_ScheduleMakePicks.ActualProfit

	CREATE TABLE Tests_ssf_ScheduleMakePicks.ActualProfit
	(
	HomeTeam					varchar(100),
	AwayTeam					varchar(100),
	Week						varchar(20),
	Season						int,
	/*Betting Profit Calc Columns*/
	ImpliedProbabilityOutrightPickWager					DECIMAL(7,2) NULL,
	ImpliedProbabilityOutrightPickHomeAwayWager			DECIMAL(7,2) NULL,
	ImpliedProbabilityOutrightPickFavDogWager			DECIMAL(7,2) NULL,
	ImpliedProbabilitySpreadPickWager					DECIMAL(7,2) NULL,
	ImpliedProbabilitySpreadPickHomeAwayWager			DECIMAL(7,2) NULL,
	ImpliedProbabilitySpreadPickFavDogWager				DECIMAL(7,2) NULL,
	ImpliedProbabilityTotalPickWager					DECIMAL(7,2) NULL,
	ImpliedProbabilityOutrightPickWagerProfit			DECIMAL(11,2) NULL,
	ImpliedProbabilityOutrightPickHomeAwayWagerProfit	DECIMAL(11,2) NULL,
	ImpliedProbabilityOutrightPickFavDogWagerProfit		DECIMAL(11,2) NULL,
	ImpliedProbabilitySpreadPickWagerProfit				DECIMAL(11,2) NULL,
	ImpliedProbabilitySpreadPickHomeAwayWagerProfit		DECIMAL(11,2) NULL,
	ImpliedProbabilitySpreadPickFavDogWagerProfit		DECIMAL(11,2) NULL,
	ImpliedProbabilityTotalPickWagerProfit				DECIMAL(11,2) NULL
	)
END
GO

CREATE PROCEDURE Tests_ssf_ScheduleMakePicks.SetupExpected
	@HomeTeam					varchar(100),
	@AwayTeam					varchar(100),
	@Week						varchar(20),
	@Season						int=2023,
	@HomeScore					int=24,
	@AwayScore					int=20,
	@Result						varchar(100),
	@HomeOddsOpen				decimal(5,2),
	@HomeOddsMin				decimal(5,2),
	@HomeOddsMax				decimal(5,2),
	@HomeOddsClose				decimal(5,2),
	@HomeOddsCloseIP			decimal(5,2),
	@HomeOddsCloseDevig			decimal(5,2),
	@AwayOddsOpen				decimal(5,2),
	@AwayOddsMin				decimal(5,2),
	@AwayOddsMax				decimal(5,2),
	@AwayOddsClose				decimal(5,2),
	@AwayOddsCloseIP			decimal(5,2),
	@AwayOddsCloseDevig			decimal(5,2),
	@HomeLineOpen				decimal(5,2),
	@HomeLineMin				decimal(5,2),
	@HomeLineMax				decimal(5,2),
	@HomeLineClose				decimal(5,2),
	@AwayLineOpen				decimal(5,2),
	@AwayLineMin				decimal(5,2),
	@AwayLineMax				decimal(5,2),
	@AwayLineClose				decimal(5,2),
	@HomeLineOddsOpen			decimal(5,2),
	@HomeLineOddsMin			decimal(5,2),
	@HomeLineOddsMax			decimal(5,2),
	@HomeLineOddsClose			decimal(5,2),
	@HomeLineOddsCloseIP		decimal(5,2),
	@HomeLineOddsCloseDevig		decimal(5,2),
	@AwayLineOddsOpen			decimal(5,2),
	@AwayLineOddsMin			decimal(5,2),
	@AwayLineOddsMax			decimal(5,2),
	@AwayLineOddsClose			decimal(5,2),
	@AwayLineOddsCloseIP		decimal(5,2),
	@AwayLineOddsCloseDevig		decimal(5,2),
	@TotalScoreOpen				decimal(5,2),
	@TotalScoreMin				decimal(5,2),
	@TotalScoreMax				decimal(5,2),
	@TotalScoreClose			decimal(5,2),
	@TotalScoreOverOpen			decimal(5,2),
	@TotalScoreOverMin			decimal(5,2),
	@TotalScoreOverMax			decimal(5,2),
	@TotalScoreOverClose		decimal(5,2),
	@TotalScoreOverCloseIP		decimal(5,2),
	@TotalScoreOverCloseDevig	decimal(5,2),
	@TotalScoreUnderOpen		decimal(5,2),
	@TotalScoreUnderMin			decimal(5,2),
	@TotalScoreUnderMax			decimal(5,2),
	@TotalScoreUnderClose		decimal(5,2),
	@TotalScoreUnderCloseIP		decimal(5,2),
	@TotalScoreUnderCloseDevig	decimal(5,2),
	@ImpliedProbabilityOutrightPick					VARCHAR(10),
	@ImpliedProbabilityOutrightPickHomeAway			VARCHAR(10),
	@ImpliedProbabilityOutrightPickFavDog			VARCHAR(10),
	@ImpliedProbabilityOutrightPickCorrect			VARCHAR(1), --Outright Best Pick Correct
	@ImpliedProbabilityOutrightPickHACorrect		VARCHAR(1), --Home/Away Pick Correct
	@ImpliedProbabilityOutrightPickFDCorrect		VARCHAR(1), --Fav/Dog Pick Correct
	@ImpliedProbabilitySpreadPick					VARCHAR(10),
	@ImpliedProbabilitySpreadPickHomeAway			VARCHAR(10),
	@ImpliedProbabilitySpreadPickFavDog				VARCHAR(10),
	@ImpliedProbabilitySpreadPickHACorrect			VARCHAR(1),
	@ImpliedProbabilitySpreadPickFDCorrect			VARCHAR(1),
	@ImpliedProbabilitySpreadPickCorrect			VARCHAR(1),
	@ImpliedProbabilityTotalPick					VARCHAR(10),
	@ImpliedProbabilityTotalPickCorrect				VARCHAR(1),
	@ImpliedProbabilityOutrightPickWager					DECIMAL(7,2),
	@ImpliedProbabilityOutrightPickHomeAwayWager			DECIMAL(7,2),
	@ImpliedProbabilityOutrightPickFavDogWager				DECIMAL(7,2),
	@ImpliedProbabilitySpreadPickWager						DECIMAL(7,2),
	@ImpliedProbabilitySpreadPickHomeAwayWager				DECIMAL(7,2),
	@ImpliedProbabilitySpreadPickFavDogWager				DECIMAL(7,2),
	@ImpliedProbabilityTotalPickWager						DECIMAL(7,2),
	@ImpliedProbabilityOutrightPickWagerProfit				DECIMAL(11,2),
	@ImpliedProbabilityOutrightPickHomeAwayWagerProfit		DECIMAL(11,2),
	@ImpliedProbabilityOutrightPickFavDogWagerProfit		DECIMAL(11,2),
	@ImpliedProbabilitySpreadPickWagerProfit				DECIMAL(11,2),
	@ImpliedProbabilitySpreadPickHomeAwayWagerProfit		DECIMAL(11,2),
	@ImpliedProbabilitySpreadPickFavDogWagerProfit			DECIMAL(11,2),
	@ImpliedProbabilityTotalPickWagerProfit					DECIMAL(11,2),
	/*Implied Probability Thresholds*/
	@ImpliedProbabilityOutrightPickHomeOddsThreshold		DECIMAL(7,2),
	@ImpliedProbabilityOutrightPickAwayOddsThreshold		DECIMAL(7,2),
	@ImpliedProbabilityOutrightPickFavoriteOddsThreshold	DECIMAL(7,2),
	@ImpliedProbabilityOutrightPickDogOddsThreshold			DECIMAL(7,2),
	@ImpliedProbabilitySpreadPickHomeOddsThreshold			DECIMAL(7,2),
	@ImpliedProbabilitySpreadPickAwayOddsThreshold			DECIMAL(7,2),
	@ImpliedProbabilitySpreadPickFavoriteOddsThreshold		DECIMAL(7,2),
	@ImpliedProbabilitySpreadPickDogOddsThreshold			DECIMAL(7,2),
	@ImpliedProbabilityTotalPickOverOddsThreshold			DECIMAL(7,2),
	@ImpliedProbabilityTotalPickUnderOddsThreshold			DECIMAL(7,2),
	/*Pick Thresholds*/
	@OneUnitThreshold DECIMAL(5,2),
	@FiveUnitThreshold DECIMAL(5,2),
	@TenUnitThreshold DECIMAL(5,2)
AS 
BEGIN 
	INSERT INTO Tests_ssf_ScheduleMakePicks.Expected (HomeTeam,AwayTeam,Week,Season,HomeScore,AwayScore,Result,HomeOddsOpen,HomeOddsMin,HomeOddsMax,HomeOddsClose,HomeOddsCloseIP,HomeOddsCloseDevig,AwayOddsOpen,AwayOddsMin,AwayOddsMax,AwayOddsClose,AwayOddsCloseIP,AwayOddsCloseDevig,HomeLineOpen
,HomeLineMin,HomeLineMax,HomeLineClose,AwayLineOpen,AwayLineMin,AwayLineMax,AwayLineClose,HomeLineOddsOpen,HomeLineOddsMin,HomeLineOddsMax,HomeLineOddsClose,HomeLineOddsCloseIP,HomeLineOddsCloseDevig
,AwayLineOddsOpen,AwayLineOddsMin,AwayLineOddsMax,AwayLineOddsClose,AwayLineOddsCloseIP,AwayLineOddsCloseDevig,TotalScoreOpen,TotalScoreMin,TotalScoreMax,TotalScoreClose,TotalScoreOverOpen
,TotalScoreOverMin,TotalScoreOverMax,TotalScoreOverClose,TotalScoreOverCloseIP,TotalScoreOverCloseDevig,TotalScoreUnderOpen,TotalScoreUnderMin,TotalScoreUnderMax,TotalScoreUnderClose,TotalScoreUnderCloseIP
,TotalScoreUnderCloseDevig,ImpliedProbabilityOutrightPick,ImpliedProbabilityOutrightPickHomeAway,ImpliedProbabilityOutrightPickFavDog,ImpliedProbabilityOutrightPickCorrect,ImpliedProbabilityOutrightPickHACorrect,ImpliedProbabilityOutrightPickFDCorrect
,ImpliedProbabilitySpreadPick,ImpliedProbabilitySpreadPickHomeAway,ImpliedProbabilitySpreadPickFavDog,ImpliedProbabilitySpreadPickHACorrect,ImpliedProbabilitySpreadPickFDCorrect,ImpliedProbabilitySpreadPickCorrect
,ImpliedProbabilityTotalPick,ImpliedProbabilityTotalPickCorrect,ImpliedProbabilityOutrightPickWager,ImpliedProbabilityOutrightPickHomeAwayWager,ImpliedProbabilityOutrightPickFavDogWager,ImpliedProbabilitySpreadPickWager
,ImpliedProbabilitySpreadPickHomeAwayWager,ImpliedProbabilitySpreadPickFavDogWager,ImpliedProbabilityTotalPickWager,ImpliedProbabilityOutrightPickWagerProfit,ImpliedProbabilityOutrightPickHomeAwayWagerProfit,ImpliedProbabilityOutrightPickFavDogWagerProfit
,ImpliedProbabilitySpreadPickWagerProfit,ImpliedProbabilitySpreadPickHomeAwayWagerProfit,ImpliedProbabilitySpreadPickFavDogWagerProfit,ImpliedProbabilityTotalPickWagerProfit,ImpliedProbabilityOutrightPickHomeOddsThreshold,ImpliedProbabilityOutrightPickAwayOddsThreshold
,ImpliedProbabilityOutrightPickFavoriteOddsThreshold,ImpliedProbabilityOutrightPickDogOddsThreshold,ImpliedProbabilitySpreadPickHomeOddsThreshold,ImpliedProbabilitySpreadPickAwayOddsThreshold,ImpliedProbabilitySpreadPickFavoriteOddsThreshold
,ImpliedProbabilitySpreadPickDogOddsThreshold,ImpliedProbabilityTotalPickOverOddsThreshold,ImpliedProbabilityTotalPickUnderOddsThreshold,OneUnitThreshold,FiveUnitThreshold,TenUnitThreshold)
VALUES (@HomeTeam,@AwayTeam,@Week,@Season,@HomeScore,@AwayScore,@Result,@HomeOddsOpen,@HomeOddsMin,@HomeOddsMax,@HomeOddsClose,@HomeOddsCloseIP,@HomeOddsCloseDevig,@AwayOddsOpen,@AwayOddsMin,@AwayOddsMax,@AwayOddsClose,@AwayOddsCloseIP,@AwayOddsCloseDevig,@HomeLineOpen
,@HomeLineMin,@HomeLineMax,@HomeLineClose,@AwayLineOpen,@AwayLineMin,@AwayLineMax,@AwayLineClose,@HomeLineOddsOpen,@HomeLineOddsMin,@HomeLineOddsMax,@HomeLineOddsClose,@HomeLineOddsCloseIP,@HomeLineOddsCloseDevig
,@AwayLineOddsOpen,@AwayLineOddsMin,@AwayLineOddsMax,@AwayLineOddsClose,@AwayLineOddsCloseIP,@AwayLineOddsCloseDevig,@TotalScoreOpen,@TotalScoreMin,@TotalScoreMax,@TotalScoreClose,@TotalScoreOverOpen
,@TotalScoreOverMin,@TotalScoreOverMax,@TotalScoreOverClose,@TotalScoreOverCloseIP,@TotalScoreOverCloseDevig,@TotalScoreUnderOpen,@TotalScoreUnderMin,@TotalScoreUnderMax,@TotalScoreUnderClose,@TotalScoreUnderCloseIP
,@TotalScoreUnderCloseDevig,@ImpliedProbabilityOutrightPick
,@ImpliedProbabilityOutrightPickHomeAway,@ImpliedProbabilityOutrightPickFavDog,@ImpliedProbabilityOutrightPickCorrect,@ImpliedProbabilityOutrightPickHACorrect,@ImpliedProbabilityOutrightPickFDCorrect
,@ImpliedProbabilitySpreadPick,@ImpliedProbabilitySpreadPickHomeAway,@ImpliedProbabilitySpreadPickFavDog,@ImpliedProbabilitySpreadPickHACorrect,@ImpliedProbabilitySpreadPickFDCorrect,@ImpliedProbabilitySpreadPickCorrect
,@ImpliedProbabilityTotalPick,@ImpliedProbabilityTotalPickCorrect,@ImpliedProbabilityOutrightPickWager,@ImpliedProbabilityOutrightPickHomeAwayWager,@ImpliedProbabilityOutrightPickFavDogWager,@ImpliedProbabilitySpreadPickWager
,@ImpliedProbabilitySpreadPickHomeAwayWager,@ImpliedProbabilitySpreadPickFavDogWager,@ImpliedProbabilityTotalPickWager,@ImpliedProbabilityOutrightPickWagerProfit,@ImpliedProbabilityOutrightPickHomeAwayWagerProfit,@ImpliedProbabilityOutrightPickFavDogWagerProfit
,@ImpliedProbabilitySpreadPickWagerProfit,@ImpliedProbabilitySpreadPickHomeAwayWagerProfit,@ImpliedProbabilitySpreadPickFavDogWagerProfit,@ImpliedProbabilityTotalPickWagerProfit,@ImpliedProbabilityOutrightPickHomeOddsThreshold,@ImpliedProbabilityOutrightPickAwayOddsThreshold
,@ImpliedProbabilityOutrightPickFavoriteOddsThreshold,@ImpliedProbabilityOutrightPickDogOddsThreshold,@ImpliedProbabilitySpreadPickHomeOddsThreshold,@ImpliedProbabilitySpreadPickAwayOddsThreshold,@ImpliedProbabilitySpreadPickFavoriteOddsThreshold
,@ImpliedProbabilitySpreadPickDogOddsThreshold,@ImpliedProbabilityTotalPickOverOddsThreshold,@ImpliedProbabilityTotalPickUnderOddsThreshold,@OneUnitThreshold,@FiveUnitThreshold,@TenUnitThreshold)

END
GO

CREATE PROCEDURE Tests_ssf_ScheduleMakePicks.SetupActual
	@HomeTeam					varchar(100),
	@AwayTeam					varchar(100),
	@Week						varchar(20),
	@Season						int=2023,
	@HomeScore					int=24,
	@AwayScore					int=20,
	@Result						varchar(100),
	@HomeOddsOpen				decimal(5,2),
	@HomeOddsMin				decimal(5,2),
	@HomeOddsMax				decimal(5,2),
	@HomeOddsClose				decimal(5,2),
	@HomeOddsCloseIP			decimal(5,2),
	@HomeOddsCloseDevig			decimal(5,2),
	@AwayOddsOpen				decimal(5,2),
	@AwayOddsMin				decimal(5,2),
	@AwayOddsMax				decimal(5,2),
	@AwayOddsClose				decimal(5,2),
	@AwayOddsCloseIP			decimal(5,2),
	@AwayOddsCloseDevig			decimal(5,2),
	@HomeLineOpen				decimal(5,2),
	@HomeLineMin				decimal(5,2),
	@HomeLineMax				decimal(5,2),
	@HomeLineClose				decimal(5,2),
	@AwayLineOpen				decimal(5,2),
	@AwayLineMin				decimal(5,2),
	@AwayLineMax				decimal(5,2),
	@AwayLineClose				decimal(5,2),
	@HomeLineOddsOpen			decimal(5,2),
	@HomeLineOddsMin			decimal(5,2),
	@HomeLineOddsMax			decimal(5,2),
	@HomeLineOddsClose			decimal(5,2),
	@HomeLineOddsCloseIP		decimal(5,2),
	@HomeLineOddsCloseDevig		decimal(5,2),
	@AwayLineOddsOpen			decimal(5,2),
	@AwayLineOddsMin			decimal(5,2),
	@AwayLineOddsMax			decimal(5,2),
	@AwayLineOddsClose			decimal(5,2),
	@AwayLineOddsCloseIP		decimal(5,2),
	@AwayLineOddsCloseDevig		decimal(5,2),
	@TotalScoreOpen				decimal(5,2),
	@TotalScoreMin				decimal(5,2),
	@TotalScoreMax				decimal(5,2),
	@TotalScoreClose			decimal(5,2),
	@TotalScoreOverOpen			decimal(5,2),
	@TotalScoreOverMin			decimal(5,2),
	@TotalScoreOverMax			decimal(5,2),
	@TotalScoreOverClose		decimal(5,2),
	@TotalScoreOverCloseIP		decimal(5,2),
	@TotalScoreOverCloseDevig	decimal(5,2),
	@TotalScoreUnderOpen		decimal(5,2),
	@TotalScoreUnderMin			decimal(5,2),
	@TotalScoreUnderMax			decimal(5,2),
	@TotalScoreUnderClose		decimal(5,2),
	@TotalScoreUnderCloseIP		decimal(5,2),
	@TotalScoreUnderCloseDevig	decimal(5,2),
	@ImpliedProbabilityOutrightPick					VARCHAR(10),
	@ImpliedProbabilityOutrightPickHomeAway			VARCHAR(10),
	@ImpliedProbabilityOutrightPickFavDog			VARCHAR(10),
	@ImpliedProbabilityOutrightPickCorrect			VARCHAR(1), --Outright Best Pick Correct
	@ImpliedProbabilityOutrightPickHACorrect		VARCHAR(1), --Home/Away Pick Correct
	@ImpliedProbabilityOutrightPickFDCorrect		VARCHAR(1), --Fav/Dog Pick Correct
	@ImpliedProbabilitySpreadPick					VARCHAR(10),
	@ImpliedProbabilitySpreadPickHomeAway			VARCHAR(10),
	@ImpliedProbabilitySpreadPickFavDog				VARCHAR(10),
	@ImpliedProbabilitySpreadPickHACorrect			VARCHAR(1),
	@ImpliedProbabilitySpreadPickFDCorrect			VARCHAR(1),
	@ImpliedProbabilitySpreadPickCorrect			VARCHAR(1),
	@ImpliedProbabilityTotalPick					VARCHAR(10),
	@ImpliedProbabilityTotalPickCorrect				VARCHAR(1),
	@ImpliedProbabilityOutrightPickWager					DECIMAL(7,2),
	@ImpliedProbabilityOutrightPickHomeAwayWager			DECIMAL(7,2),
	@ImpliedProbabilityOutrightPickFavDogWager				DECIMAL(7,2),
	@ImpliedProbabilitySpreadPickWager						DECIMAL(7,2),
	@ImpliedProbabilitySpreadPickHomeAwayWager				DECIMAL(7,2),
	@ImpliedProbabilitySpreadPickFavDogWager				DECIMAL(7,2),
	@ImpliedProbabilityTotalPickWager						DECIMAL(7,2),
	@ImpliedProbabilityOutrightPickWagerProfit				DECIMAL(11,2),
	@ImpliedProbabilityOutrightPickHomeAwayWagerProfit		DECIMAL(11,2),
	@ImpliedProbabilityOutrightPickFavDogWagerProfit		DECIMAL(11,2),
	@ImpliedProbabilitySpreadPickWagerProfit				DECIMAL(11,2),
	@ImpliedProbabilitySpreadPickHomeAwayWagerProfit		DECIMAL(11,2),
	@ImpliedProbabilitySpreadPickFavDogWagerProfit			DECIMAL(11,2),
	@ImpliedProbabilityTotalPickWagerProfit					DECIMAL(11,2),
	/*Implied Probability Thresholds*/
	@ImpliedProbabilityOutrightPickHomeOddsThreshold		DECIMAL(7,2),
	@ImpliedProbabilityOutrightPickAwayOddsThreshold		DECIMAL(7,2),
	@ImpliedProbabilityOutrightPickFavoriteOddsThreshold	DECIMAL(7,2),
	@ImpliedProbabilityOutrightPickDogOddsThreshold			DECIMAL(7,2),
	@ImpliedProbabilitySpreadPickHomeOddsThreshold			DECIMAL(7,2),
	@ImpliedProbabilitySpreadPickAwayOddsThreshold			DECIMAL(7,2),
	@ImpliedProbabilitySpreadPickFavoriteOddsThreshold		DECIMAL(7,2),
	@ImpliedProbabilitySpreadPickDogOddsThreshold			DECIMAL(7,2),
	@ImpliedProbabilityTotalPickOverOddsThreshold			DECIMAL(7,2),
	@ImpliedProbabilityTotalPickUnderOddsThreshold			DECIMAL(7,2),
	/*Pick Thresholds*/
	@OneUnitThreshold DECIMAL(5,2),
	@FiveUnitThreshold DECIMAL(5,2),
	@TenUnitThreshold DECIMAL(5,2)
AS 
BEGIN
	INSERT INTO Tests_ssf_ScheduleMakePicks.Actual (HomeTeam,AwayTeam,Week,Season,HomeScore,AwayScore,Result,HomeOddsOpen,HomeOddsMin,HomeOddsMax,HomeOddsClose,HomeOddsCloseIP,HomeOddsCloseDevig,AwayOddsOpen,AwayOddsMin,AwayOddsMax,AwayOddsClose,AwayOddsCloseIP,AwayOddsCloseDevig,HomeLineOpen
,HomeLineMin,HomeLineMax,HomeLineClose,AwayLineOpen,AwayLineMin,AwayLineMax,AwayLineClose,HomeLineOddsOpen,HomeLineOddsMin,HomeLineOddsMax,HomeLineOddsClose,HomeLineOddsCloseIP,HomeLineOddsCloseDevig
,AwayLineOddsOpen,AwayLineOddsMin,AwayLineOddsMax,AwayLineOddsClose,AwayLineOddsCloseIP,AwayLineOddsCloseDevig,TotalScoreOpen,TotalScoreMin,TotalScoreMax,TotalScoreClose,TotalScoreOverOpen
,TotalScoreOverMin,TotalScoreOverMax,TotalScoreOverClose,TotalScoreOverCloseIP,TotalScoreOverCloseDevig,TotalScoreUnderOpen,TotalScoreUnderMin,TotalScoreUnderMax,TotalScoreUnderClose,TotalScoreUnderCloseIP
,TotalScoreUnderCloseDevig,ImpliedProbabilityOutrightPick,ImpliedProbabilityOutrightPickHomeAway,ImpliedProbabilityOutrightPickFavDog,ImpliedProbabilityOutrightPickCorrect,ImpliedProbabilityOutrightPickHACorrect,ImpliedProbabilityOutrightPickFDCorrect
,ImpliedProbabilitySpreadPick,ImpliedProbabilitySpreadPickHomeAway,ImpliedProbabilitySpreadPickFavDog,ImpliedProbabilitySpreadPickHACorrect,ImpliedProbabilitySpreadPickFDCorrect,ImpliedProbabilitySpreadPickCorrect
,ImpliedProbabilityTotalPick,ImpliedProbabilityTotalPickCorrect,ImpliedProbabilityOutrightPickWager,ImpliedProbabilityOutrightPickHomeAwayWager,ImpliedProbabilityOutrightPickFavDogWager,ImpliedProbabilitySpreadPickWager
,ImpliedProbabilitySpreadPickHomeAwayWager,ImpliedProbabilitySpreadPickFavDogWager,ImpliedProbabilityTotalPickWager,ImpliedProbabilityOutrightPickWagerProfit,ImpliedProbabilityOutrightPickHomeAwayWagerProfit,ImpliedProbabilityOutrightPickFavDogWagerProfit
,ImpliedProbabilitySpreadPickWagerProfit,ImpliedProbabilitySpreadPickHomeAwayWagerProfit,ImpliedProbabilitySpreadPickFavDogWagerProfit,ImpliedProbabilityTotalPickWagerProfit,ImpliedProbabilityOutrightPickHomeOddsThreshold,ImpliedProbabilityOutrightPickAwayOddsThreshold
,ImpliedProbabilityOutrightPickFavoriteOddsThreshold,ImpliedProbabilityOutrightPickDogOddsThreshold,ImpliedProbabilitySpreadPickHomeOddsThreshold,ImpliedProbabilitySpreadPickAwayOddsThreshold,ImpliedProbabilitySpreadPickFavoriteOddsThreshold
,ImpliedProbabilitySpreadPickDogOddsThreshold,ImpliedProbabilityTotalPickOverOddsThreshold,ImpliedProbabilityTotalPickUnderOddsThreshold,OneUnitThreshold,FiveUnitThreshold,TenUnitThreshold)
VALUES (@HomeTeam,@AwayTeam,@Week,@Season,@HomeScore,@AwayScore,@Result,@HomeOddsOpen,@HomeOddsMin,@HomeOddsMax,@HomeOddsClose,@HomeOddsCloseIP,@HomeOddsCloseDevig,@AwayOddsOpen,@AwayOddsMin,@AwayOddsMax,@AwayOddsClose,@AwayOddsCloseIP,@AwayOddsCloseDevig,@HomeLineOpen
,@HomeLineMin,@HomeLineMax,@HomeLineClose,@AwayLineOpen,@AwayLineMin,@AwayLineMax,@AwayLineClose,@HomeLineOddsOpen,@HomeLineOddsMin,@HomeLineOddsMax,@HomeLineOddsClose,@HomeLineOddsCloseIP,@HomeLineOddsCloseDevig
,@AwayLineOddsOpen,@AwayLineOddsMin,@AwayLineOddsMax,@AwayLineOddsClose,@AwayLineOddsCloseIP,@AwayLineOddsCloseDevig,@TotalScoreOpen,@TotalScoreMin,@TotalScoreMax,@TotalScoreClose,@TotalScoreOverOpen
,@TotalScoreOverMin,@TotalScoreOverMax,@TotalScoreOverClose,@TotalScoreOverCloseIP,@TotalScoreOverCloseDevig,@TotalScoreUnderOpen,@TotalScoreUnderMin,@TotalScoreUnderMax,@TotalScoreUnderClose,@TotalScoreUnderCloseIP
,@TotalScoreUnderCloseDevig,@ImpliedProbabilityOutrightPick,@ImpliedProbabilityOutrightPickHomeAway,@ImpliedProbabilityOutrightPickFavDog,@ImpliedProbabilityOutrightPickCorrect,@ImpliedProbabilityOutrightPickHACorrect,@ImpliedProbabilityOutrightPickFDCorrect
,@ImpliedProbabilitySpreadPick,@ImpliedProbabilitySpreadPickHomeAway,@ImpliedProbabilitySpreadPickFavDog,@ImpliedProbabilitySpreadPickHACorrect,@ImpliedProbabilitySpreadPickFDCorrect,@ImpliedProbabilitySpreadPickCorrect
,@ImpliedProbabilityTotalPick,@ImpliedProbabilityTotalPickCorrect,@ImpliedProbabilityOutrightPickWager,@ImpliedProbabilityOutrightPickHomeAwayWager,@ImpliedProbabilityOutrightPickFavDogWager,@ImpliedProbabilitySpreadPickWager
,@ImpliedProbabilitySpreadPickHomeAwayWager,@ImpliedProbabilitySpreadPickFavDogWager,@ImpliedProbabilityTotalPickWager,@ImpliedProbabilityOutrightPickWagerProfit,@ImpliedProbabilityOutrightPickHomeAwayWagerProfit,@ImpliedProbabilityOutrightPickFavDogWagerProfit
,@ImpliedProbabilitySpreadPickWagerProfit,@ImpliedProbabilitySpreadPickHomeAwayWagerProfit,@ImpliedProbabilitySpreadPickFavDogWagerProfit,@ImpliedProbabilityTotalPickWagerProfit,@ImpliedProbabilityOutrightPickHomeOddsThreshold,@ImpliedProbabilityOutrightPickAwayOddsThreshold
,@ImpliedProbabilityOutrightPickFavoriteOddsThreshold,@ImpliedProbabilityOutrightPickDogOddsThreshold,@ImpliedProbabilitySpreadPickHomeOddsThreshold,@ImpliedProbabilitySpreadPickAwayOddsThreshold,@ImpliedProbabilitySpreadPickFavoriteOddsThreshold
,@ImpliedProbabilitySpreadPickDogOddsThreshold,@ImpliedProbabilityTotalPickOverOddsThreshold,@ImpliedProbabilityTotalPickUnderOddsThreshold,@OneUnitThreshold,@FiveUnitThreshold,@TenUnitThreshold)

END
GO

CREATE PROCEDURE Tests_ssf_ScheduleMakePicks.SetupExpectedPicks
	@HomeTeam					varchar(100),
	@AwayTeam					varchar(100),
	@Week						varchar(20),
	@Season						int=2023,
	@ImpliedProbabilityOutrightPick					VARCHAR(10),
	@ImpliedProbabilityOutrightPickHomeAway			VARCHAR(10),
	@ImpliedProbabilityOutrightPickFavDog			VARCHAR(10),
	@ImpliedProbabilityOutrightPickCorrect			VARCHAR(1), --Outright Best Pick Correct
	@ImpliedProbabilityOutrightPickHACorrect		VARCHAR(1), --Home/Away Pick Correct
	@ImpliedProbabilityOutrightPickFDCorrect		VARCHAR(1), --Fav/Dog Pick Correct
	@ImpliedProbabilitySpreadPick					VARCHAR(10),
	@ImpliedProbabilitySpreadPickHomeAway			VARCHAR(10),
	@ImpliedProbabilitySpreadPickFavDog				VARCHAR(10),
	@ImpliedProbabilitySpreadPickHACorrect			VARCHAR(1),
	@ImpliedProbabilitySpreadPickFDCorrect			VARCHAR(1),
	@ImpliedProbabilitySpreadPickCorrect			VARCHAR(1),
	@ImpliedProbabilityTotalPick					VARCHAR(10),
	@ImpliedProbabilityTotalPickCorrect				VARCHAR(1)
AS 
BEGIN 
	INSERT INTO Tests_ssf_ScheduleMakePicks.ExpectedPicks (HomeTeam,AwayTeam,Week,Season,ImpliedProbabilityOutrightPick,ImpliedProbabilityOutrightPickHomeAway,ImpliedProbabilityOutrightPickFavDog,ImpliedProbabilityOutrightPickCorrect,ImpliedProbabilityOutrightPickHACorrect,ImpliedProbabilityOutrightPickFDCorrect
,ImpliedProbabilitySpreadPick,ImpliedProbabilitySpreadPickHomeAway,ImpliedProbabilitySpreadPickFavDog,ImpliedProbabilitySpreadPickHACorrect,ImpliedProbabilitySpreadPickFDCorrect,ImpliedProbabilitySpreadPickCorrect
,ImpliedProbabilityTotalPick,ImpliedProbabilityTotalPickCorrect)
VALUES (@HomeTeam,@AwayTeam,@Week,@Season,@ImpliedProbabilityOutrightPick,@ImpliedProbabilityOutrightPickHomeAway,@ImpliedProbabilityOutrightPickFavDog,@ImpliedProbabilityOutrightPickCorrect,@ImpliedProbabilityOutrightPickHACorrect,@ImpliedProbabilityOutrightPickFDCorrect
,@ImpliedProbabilitySpreadPick,@ImpliedProbabilitySpreadPickHomeAway,@ImpliedProbabilitySpreadPickFavDog,@ImpliedProbabilitySpreadPickHACorrect,@ImpliedProbabilitySpreadPickFDCorrect,@ImpliedProbabilitySpreadPickCorrect
,@ImpliedProbabilityTotalPick,@ImpliedProbabilityTotalPickCorrect)

END
GO

CREATE PROCEDURE Tests_ssf_ScheduleMakePicks.SetupActualPicks
	@HomeTeam					varchar(100),
	@AwayTeam					varchar(100),
	@Week						varchar(20),
	@Season						int=2023,
	@ImpliedProbabilityOutrightPick					VARCHAR(10),
	@ImpliedProbabilityOutrightPickHomeAway			VARCHAR(10),
	@ImpliedProbabilityOutrightPickFavDog			VARCHAR(10),
	@ImpliedProbabilityOutrightPickCorrect			VARCHAR(1), --Outright Best Pick Correct
	@ImpliedProbabilityOutrightPickHACorrect		VARCHAR(1), --Home/Away Pick Correct
	@ImpliedProbabilityOutrightPickFDCorrect		VARCHAR(1), --Fav/Dog Pick Correct
	@ImpliedProbabilitySpreadPick					VARCHAR(10),
	@ImpliedProbabilitySpreadPickHomeAway			VARCHAR(10),
	@ImpliedProbabilitySpreadPickFavDog				VARCHAR(10),
	@ImpliedProbabilitySpreadPickHACorrect			VARCHAR(1),
	@ImpliedProbabilitySpreadPickFDCorrect			VARCHAR(1),
	@ImpliedProbabilitySpreadPickCorrect			VARCHAR(1),
	@ImpliedProbabilityTotalPick					VARCHAR(10),
	@ImpliedProbabilityTotalPickCorrect				VARCHAR(1)
AS 
BEGIN 
	INSERT INTO Tests_ssf_ScheduleMakePicks.ExpectedPicks (HomeTeam,AwayTeam,Week,Season,ImpliedProbabilityOutrightPick,ImpliedProbabilityOutrightPickHomeAway,ImpliedProbabilityOutrightPickFavDog,ImpliedProbabilityOutrightPickCorrect,ImpliedProbabilityOutrightPickHACorrect,ImpliedProbabilityOutrightPickFDCorrect
,ImpliedProbabilitySpreadPick,ImpliedProbabilitySpreadPickHomeAway,ImpliedProbabilitySpreadPickFavDog,ImpliedProbabilitySpreadPickHACorrect,ImpliedProbabilitySpreadPickFDCorrect,ImpliedProbabilitySpreadPickCorrect
,ImpliedProbabilityTotalPick,ImpliedProbabilityTotalPickCorrect)
VALUES (@HomeTeam,@AwayTeam,@Week,@Season,@ImpliedProbabilityOutrightPick,@ImpliedProbabilityOutrightPickHomeAway,@ImpliedProbabilityOutrightPickFavDog,@ImpliedProbabilityOutrightPickCorrect,@ImpliedProbabilityOutrightPickHACorrect,@ImpliedProbabilityOutrightPickFDCorrect
,@ImpliedProbabilitySpreadPick,@ImpliedProbabilitySpreadPickHomeAway,@ImpliedProbabilitySpreadPickFavDog,@ImpliedProbabilitySpreadPickHACorrect,@ImpliedProbabilitySpreadPickFDCorrect,@ImpliedProbabilitySpreadPickCorrect
,@ImpliedProbabilityTotalPick,@ImpliedProbabilityTotalPickCorrect)

END
GO

CREATE PROCEDURE Tests_ssf_ScheduleMakePicks.SetupExpectedProfit
	@HomeTeam					varchar(100),
	@AwayTeam					varchar(100),
	@Week						varchar(20),
	@Season						int=2023,
	@ImpliedProbabilityOutrightPickWager					DECIMAL(7,2),
	@ImpliedProbabilityOutrightPickHomeAwayWager			DECIMAL(7,2),
	@ImpliedProbabilityOutrightPickFavDogWager				DECIMAL(7,2),
	@ImpliedProbabilitySpreadPickWager						DECIMAL(7,2),
	@ImpliedProbabilitySpreadPickHomeAwayWager				DECIMAL(7,2),
	@ImpliedProbabilitySpreadPickFavDogWager				DECIMAL(7,2),
	@ImpliedProbabilityTotalPickWager						DECIMAL(7,2),
	@ImpliedProbabilityOutrightPickWagerProfit				DECIMAL(11,2),
	@ImpliedProbabilityOutrightPickHomeAwayWagerProfit		DECIMAL(11,2),
	@ImpliedProbabilityOutrightPickFavDogWagerProfit		DECIMAL(11,2),
	@ImpliedProbabilitySpreadPickWagerProfit				DECIMAL(11,2),
	@ImpliedProbabilitySpreadPickHomeAwayWagerProfit		DECIMAL(11,2),
	@ImpliedProbabilitySpreadPickFavDogWagerProfit			DECIMAL(11,2),
	@ImpliedProbabilityTotalPickWagerProfit					DECIMAL(11,2)
AS 
BEGIN 
	INSERT INTO Tests_ssf_ScheduleMakePicks.ExpectedProfit (HomeTeam,AwayTeam,Week,Season,ImpliedProbabilityOutrightPickWager,ImpliedProbabilityOutrightPickHomeAwayWager,ImpliedProbabilityOutrightPickFavDogWager,ImpliedProbabilitySpreadPickWager
,ImpliedProbabilitySpreadPickHomeAwayWager,ImpliedProbabilitySpreadPickFavDogWager,ImpliedProbabilityTotalPickWager,ImpliedProbabilityOutrightPickWagerProfit,ImpliedProbabilityOutrightPickHomeAwayWagerProfit,ImpliedProbabilityOutrightPickFavDogWagerProfit
,ImpliedProbabilitySpreadPickWagerProfit,ImpliedProbabilitySpreadPickHomeAwayWagerProfit,ImpliedProbabilitySpreadPickFavDogWagerProfit,ImpliedProbabilityTotalPickWagerProfit)
VALUES (@HomeTeam,@AwayTeam,@Week,@Season,@ImpliedProbabilityOutrightPickWager,@ImpliedProbabilityOutrightPickHomeAwayWager,@ImpliedProbabilityOutrightPickFavDogWager,@ImpliedProbabilitySpreadPickWager
,@ImpliedProbabilitySpreadPickHomeAwayWager,@ImpliedProbabilitySpreadPickFavDogWager,@ImpliedProbabilityTotalPickWager,@ImpliedProbabilityOutrightPickWagerProfit,@ImpliedProbabilityOutrightPickHomeAwayWagerProfit,@ImpliedProbabilityOutrightPickFavDogWagerProfit
,@ImpliedProbabilitySpreadPickWagerProfit,@ImpliedProbabilitySpreadPickHomeAwayWagerProfit,@ImpliedProbabilitySpreadPickFavDogWagerProfit,@ImpliedProbabilityTotalPickWagerProfit)

END
GO

CREATE PROCEDURE Tests_ssf_ScheduleMakePicks.SetupActualProfit
	@HomeTeam					varchar(100),
	@AwayTeam					varchar(100),
	@Week						varchar(20),
	@Season						int=2023,
	@ImpliedProbabilityOutrightPickWager					DECIMAL(7,2),
	@ImpliedProbabilityOutrightPickHomeAwayWager			DECIMAL(7,2),
	@ImpliedProbabilityOutrightPickFavDogWager				DECIMAL(7,2),
	@ImpliedProbabilitySpreadPickWager						DECIMAL(7,2),
	@ImpliedProbabilitySpreadPickHomeAwayWager				DECIMAL(7,2),
	@ImpliedProbabilitySpreadPickFavDogWager				DECIMAL(7,2),
	@ImpliedProbabilityTotalPickWager						DECIMAL(7,2),
	@ImpliedProbabilityOutrightPickWagerProfit				DECIMAL(11,2),
	@ImpliedProbabilityOutrightPickHomeAwayWagerProfit		DECIMAL(11,2),
	@ImpliedProbabilityOutrightPickFavDogWagerProfit		DECIMAL(11,2),
	@ImpliedProbabilitySpreadPickWagerProfit				DECIMAL(11,2),
	@ImpliedProbabilitySpreadPickHomeAwayWagerProfit		DECIMAL(11,2),
	@ImpliedProbabilitySpreadPickFavDogWagerProfit			DECIMAL(11,2),
	@ImpliedProbabilityTotalPickWagerProfit					DECIMAL(11,2)
AS 
BEGIN
	INSERT INTO Tests_ssf_ScheduleMakePicks.ActualProfit (HomeTeam,AwayTeam,Week,Season,ImpliedProbabilityOutrightPickWager,ImpliedProbabilityOutrightPickHomeAwayWager,ImpliedProbabilityOutrightPickFavDogWager,ImpliedProbabilitySpreadPickWager
,ImpliedProbabilitySpreadPickHomeAwayWager,ImpliedProbabilitySpreadPickFavDogWager,ImpliedProbabilityTotalPickWager,ImpliedProbabilityOutrightPickWagerProfit,ImpliedProbabilityOutrightPickHomeAwayWagerProfit,ImpliedProbabilityOutrightPickFavDogWagerProfit
,ImpliedProbabilitySpreadPickWagerProfit,ImpliedProbabilitySpreadPickHomeAwayWagerProfit,ImpliedProbabilitySpreadPickFavDogWagerProfit,ImpliedProbabilityTotalPickWagerProfit)
VALUES (@HomeTeam,@AwayTeam,@Week,@Season,@ImpliedProbabilityOutrightPickWager,@ImpliedProbabilityOutrightPickHomeAwayWager,@ImpliedProbabilityOutrightPickFavDogWager,@ImpliedProbabilitySpreadPickWager
,@ImpliedProbabilitySpreadPickHomeAwayWager,@ImpliedProbabilitySpreadPickFavDogWager,@ImpliedProbabilityTotalPickWager,@ImpliedProbabilityOutrightPickWagerProfit,@ImpliedProbabilityOutrightPickHomeAwayWagerProfit,@ImpliedProbabilityOutrightPickFavDogWagerProfit
,@ImpliedProbabilitySpreadPickWagerProfit,@ImpliedProbabilitySpreadPickHomeAwayWagerProfit,@ImpliedProbabilitySpreadPickFavDogWagerProfit,@ImpliedProbabilityTotalPickWagerProfit)
END
GO

CREATE PROCEDURE Tests_ssf_ScheduleMakePicks.[Test - NULL table parameter returns no data]
AS
BEGIN
	SET XACT_ABORT OFF 
	DECLARE @test GameDataTable
	DECLARE @HomeTeam					varchar(100) = NULL,
	@AwayTeam					varchar(100) = NULL,
	@Week						varchar(20) = NULL,
	@Season						int = NULL,
	@HomeScore					int = NULL,
	@AwayScore					int = NULL,
	@Result						varchar(100) = NULL,
	@HomeOddsOpen				decimal(5,2) = NULL,
	@HomeOddsMin				decimal(5,2) = NULL,
	@HomeOddsMax				decimal(5,2) = NULL,
	@HomeOddsClose				decimal(5,2) = NULL,
	@HomeOddsCloseIP			decimal(5,2) = NULL,
	@HomeOddsCloseDevig			decimal(5,2) = NULL,
	@AwayOddsOpen				decimal(5,2) = NULL,
	@AwayOddsMin				decimal(5,2) = NULL,
	@AwayOddsMax				decimal(5,2) = NULL,
	@AwayOddsClose				decimal(5,2) = NULL,
	@AwayOddsCloseIP			decimal(5,2) = NULL,
	@AwayOddsCloseDevig			decimal(5,2) = NULL,
	@HomeLineOpen				decimal(5,2) = NULL,
	@HomeLineMin				decimal(5,2) = NULL,
	@HomeLineMax				decimal(5,2) = NULL,
	@HomeLineClose				decimal(5,2) = NULL,
	@AwayLineOpen				decimal(5,2) = NULL,
	@AwayLineMin				decimal(5,2) = NULL,
	@AwayLineMax				decimal(5,2) = NULL,
	@AwayLineClose				decimal(5,2) = NULL,
	@HomeLineOddsOpen			decimal(5,2) = NULL,
	@HomeLineOddsMin			decimal(5,2) = NULL,
	@HomeLineOddsMax			decimal(5,2) = NULL,
	@HomeLineOddsClose			decimal(5,2) = NULL,
	@HomeLineOddsCloseIP		decimal(5,2) = NULL,
	@HomeLineOddsCloseDevig		decimal(5,2) = NULL,
	@AwayLineOddsOpen			decimal(5,2) = NULL,
	@AwayLineOddsMin			decimal(5,2) = NULL,
	@AwayLineOddsMax			decimal(5,2) = NULL,
	@AwayLineOddsClose			decimal(5,2) = NULL,
	@AwayLineOddsCloseIP		decimal(5,2) = NULL,
	@AwayLineOddsCloseDevig		decimal(5,2) = NULL,
	@TotalScoreOpen				decimal(5,2) = NULL,
	@TotalScoreMin				decimal(5,2) = NULL,
	@TotalScoreMax				decimal(5,2) = NULL,
	@TotalScoreClose			decimal(5,2) = NULL,
	@TotalScoreOverOpen			decimal(5,2) = NULL,
	@TotalScoreOverMin			decimal(5,2) = NULL,
	@TotalScoreOverMax			decimal(5,2) = NULL,
	@TotalScoreOverClose		decimal(5,2) = NULL,
	@TotalScoreOverCloseIP		decimal(5,2) = NULL,
	@TotalScoreOverCloseDevig	decimal(5,2) = NULL,
	@TotalScoreUnderOpen		decimal(5,2) = NULL,
	@TotalScoreUnderMin			decimal(5,2) = NULL,
	@TotalScoreUnderMax			decimal(5,2) = NULL,
	@TotalScoreUnderClose		decimal(5,2) = NULL,
	@TotalScoreUnderCloseIP		decimal(5,2) = NULL,
	@TotalScoreUnderCloseDevig	decimal(5,2) = NULL,
	@ImpliedProbabilityOutrightPick					VARCHAR(10) = NULL,
	@ImpliedProbabilityOutrightPickHomeAway			VARCHAR(10) = NULL,
	@ImpliedProbabilityOutrightPickFavDog			VARCHAR(10) = NULL,
	@ImpliedProbabilityOutrightPickCorrect			VARCHAR(1) = NULL, --Outright Best Pick Correct
	@ImpliedProbabilityOutrightPickHACorrect		VARCHAR(1) = NULL, --Home/Away Pick Correct
	@ImpliedProbabilityOutrightPickFDCorrect		VARCHAR(1) = NULL, --Fav/Dog Pick Correct
	@ImpliedProbabilitySpreadPick					VARCHAR(10) = NULL,
	@ImpliedProbabilitySpreadPickHomeAway			VARCHAR(10) = NULL,
	@ImpliedProbabilitySpreadPickFavDog				VARCHAR(10) = NULL,
	@ImpliedProbabilitySpreadPickHACorrect			VARCHAR(1) =NULL,
	@ImpliedProbabilitySpreadPickFDCorrect			VARCHAR(1) =NULL,
	@ImpliedProbabilitySpreadPickCorrect			VARCHAR(1) =NULL,
	@ImpliedProbabilityTotalPick					VARCHAR(10) = NULL,
	@ImpliedProbabilityTotalPickCorrect				VARCHAR(1) = NULL,
	@ImpliedProbabilityOutrightPickWager					DECIMAL(7,2) = NULL,
	@ImpliedProbabilityOutrightPickHomeAwayWager			DECIMAL(7,2) = NULL,
	@ImpliedProbabilityOutrightPickFavDogWager				DECIMAL(7,2) = NULL,
	@ImpliedProbabilitySpreadPickWager						DECIMAL(7,2) = NULL,
	@ImpliedProbabilitySpreadPickHomeAwayWager				DECIMAL(7,2) = NULL,
	@ImpliedProbabilitySpreadPickFavDogWager				DECIMAL(7,2) = NULL,
	@ImpliedProbabilityTotalPickWager						DECIMAL(7,2) = NULL,
	@ImpliedProbabilityOutrightPickWagerProfit				DECIMAL(11,2) =NULL,
	@ImpliedProbabilityOutrightPickHomeAwayWagerProfit		DECIMAL(11,2) =NULL,
	@ImpliedProbabilityOutrightPickFavDogWagerProfit		DECIMAL(11,2) =NULL,
	@ImpliedProbabilitySpreadPickWagerProfit				DECIMAL(11,2) =NULL,
	@ImpliedProbabilitySpreadPickHomeAwayWagerProfit		DECIMAL(11,2) =NULL,
	@ImpliedProbabilitySpreadPickFavDogWagerProfit			DECIMAL(11,2) =NULL,
	@ImpliedProbabilityTotalPickWagerProfit					DECIMAL(11,2) =NULL,
	/*Implied Probability Thresholds*/
	@ImpliedProbabilityOutrightPickHomeOddsThreshold		DECIMAL(7,2)= NULL,
	@ImpliedProbabilityOutrightPickAwayOddsThreshold		DECIMAL(7,2)= NULL,
	@ImpliedProbabilityOutrightPickFavoriteOddsThreshold	DECIMAL(7,2)= NULL,
	@ImpliedProbabilityOutrightPickDogOddsThreshold			DECIMAL(7,2)= NULL,
	@ImpliedProbabilitySpreadPickHomeOddsThreshold			DECIMAL(7,2)= NULL,
	@ImpliedProbabilitySpreadPickAwayOddsThreshold			DECIMAL(7,2)= NULL,
	@ImpliedProbabilitySpreadPickFavoriteOddsThreshold		DECIMAL(7,2)= NULL,
	@ImpliedProbabilitySpreadPickDogOddsThreshold			DECIMAL(7,2)= NULL,
	@ImpliedProbabilityTotalPickOverOddsThreshold			DECIMAL(7,2)= NULL,
	@ImpliedProbabilityTotalPickUnderOddsThreshold			DECIMAL(7,2)= NULL,
	/*Pick Thresholds*/
	@OneUnitThreshold DECIMAL(5,2) = 0.1,
	@FiveUnitThreshold DECIMAL(5,2) = 0.2,
	@TenUnitThreshold DECIMAL(5,2) = 0.2
	
	INSERT INTO @test (HomeTeam,AwayTeam,Week,Season,HomeScore,AwayScore,Result,HomeOddsOpen,HomeOddsMin,HomeOddsMax,HomeOddsClose,HomeOddsCloseIP,HomeOddsCloseDevig,AwayOddsOpen,AwayOddsMin,AwayOddsMax,AwayOddsClose,AwayOddsCloseIP,AwayOddsCloseDevig,HomeLineOpen
,HomeLineMin,HomeLineMax,HomeLineClose,AwayLineOpen,AwayLineMin,AwayLineMax,AwayLineClose,HomeLineOddsOpen,HomeLineOddsMin,HomeLineOddsMax,HomeLineOddsClose,HomeLineOddsCloseIP,HomeLineOddsCloseDevig
,AwayLineOddsOpen,AwayLineOddsMin,AwayLineOddsMax,AwayLineOddsClose,AwayLineOddsCloseIP,AwayLineOddsCloseDevig,TotalScoreOpen,TotalScoreMin,TotalScoreMax,TotalScoreClose,TotalScoreOverOpen
,TotalScoreOverMin,TotalScoreOverMax,TotalScoreOverClose,TotalScoreOverCloseIP,TotalScoreOverCloseDevig,TotalScoreUnderOpen,TotalScoreUnderMin,TotalScoreUnderMax,TotalScoreUnderClose,TotalScoreUnderCloseIP
,TotalScoreUnderCloseDevig,ImpliedProbabilityOutrightPick,ImpliedProbabilityOutrightPickHomeAway,ImpliedProbabilityOutrightPickFavDog,ImpliedProbabilityOutrightPickCorrect,ImpliedProbabilityOutrightPickHACorrect,ImpliedProbabilityOutrightPickFDCorrect
,ImpliedProbabilitySpreadPick,ImpliedProbabilitySpreadPickHomeAway,ImpliedProbabilitySpreadPickFavDog,ImpliedProbabilitySpreadPickHACorrect,ImpliedProbabilitySpreadPickFDCorrect,ImpliedProbabilitySpreadPickCorrect
,ImpliedProbabilityTotalPick,ImpliedProbabilityTotalPickCorrect,ImpliedProbabilityOutrightPickWager,ImpliedProbabilityOutrightPickHomeAwayWager,ImpliedProbabilityOutrightPickFavDogWager,ImpliedProbabilitySpreadPickWager
,ImpliedProbabilitySpreadPickHomeAwayWager,ImpliedProbabilitySpreadPickFavDogWager,ImpliedProbabilityTotalPickWager,ImpliedProbabilityOutrightPickWagerProfit,ImpliedProbabilityOutrightPickHomeAwayWagerProfit,ImpliedProbabilityOutrightPickFavDogWagerProfit
,ImpliedProbabilitySpreadPickWagerProfit,ImpliedProbabilitySpreadPickHomeAwayWagerProfit,ImpliedProbabilitySpreadPickFavDogWagerProfit,ImpliedProbabilityTotalPickWagerProfit,ImpliedProbabilityOutrightPickHomeOddsThreshold,ImpliedProbabilityOutrightPickAwayOddsThreshold
,ImpliedProbabilityOutrightPickFavoriteOddsThreshold,ImpliedProbabilityOutrightPickDogOddsThreshold,ImpliedProbabilitySpreadPickHomeOddsThreshold,ImpliedProbabilitySpreadPickAwayOddsThreshold,ImpliedProbabilitySpreadPickFavoriteOddsThreshold
,ImpliedProbabilitySpreadPickDogOddsThreshold,ImpliedProbabilityTotalPickOverOddsThreshold,ImpliedProbabilityTotalPickUnderOddsThreshold,OneUnitThreshold,FiveUnitThreshold,TenUnitThreshold)
VALUES (@HomeTeam,@AwayTeam,@Week,@Season,@HomeScore,@AwayScore,@Result,@HomeOddsOpen,@HomeOddsMin,@HomeOddsMax,@HomeOddsClose,@HomeOddsCloseIP,@HomeOddsCloseDevig,@AwayOddsOpen,@AwayOddsMin,@AwayOddsMax,@AwayOddsClose,@AwayOddsCloseIP,@AwayOddsCloseDevig,@HomeLineOpen
,@HomeLineMin,@HomeLineMax,@HomeLineClose,@AwayLineOpen,@AwayLineMin,@AwayLineMax,@AwayLineClose,@HomeLineOddsOpen,@HomeLineOddsMin,@HomeLineOddsMax,@HomeLineOddsClose,@HomeLineOddsCloseIP,@HomeLineOddsCloseDevig
,@AwayLineOddsOpen,@AwayLineOddsMin,@AwayLineOddsMax,@AwayLineOddsClose,@AwayLineOddsCloseIP,@AwayLineOddsCloseDevig,@TotalScoreOpen,@TotalScoreMin,@TotalScoreMax,@TotalScoreClose,@TotalScoreOverOpen
,@TotalScoreOverMin,@TotalScoreOverMax,@TotalScoreOverClose,@TotalScoreOverCloseIP,@TotalScoreOverCloseDevig,@TotalScoreUnderOpen,@TotalScoreUnderMin,@TotalScoreUnderMax,@TotalScoreUnderClose,@TotalScoreUnderCloseIP
,@TotalScoreUnderCloseDevig,@ImpliedProbabilityOutrightPick,@ImpliedProbabilityOutrightPickHomeAway,@ImpliedProbabilityOutrightPickFavDog,@ImpliedProbabilityOutrightPickCorrect,@ImpliedProbabilityOutrightPickHACorrect,@ImpliedProbabilityOutrightPickFDCorrect
,@ImpliedProbabilitySpreadPick,@ImpliedProbabilitySpreadPickHomeAway,@ImpliedProbabilitySpreadPickFavDog,@ImpliedProbabilitySpreadPickHACorrect,@ImpliedProbabilitySpreadPickFDCorrect,@ImpliedProbabilitySpreadPickCorrect
,@ImpliedProbabilityTotalPick,@ImpliedProbabilityTotalPickCorrect,@ImpliedProbabilityOutrightPickWager,@ImpliedProbabilityOutrightPickHomeAwayWager,@ImpliedProbabilityOutrightPickFavDogWager,@ImpliedProbabilitySpreadPickWager
,@ImpliedProbabilitySpreadPickHomeAwayWager,@ImpliedProbabilitySpreadPickFavDogWager,@ImpliedProbabilityTotalPickWager,@ImpliedProbabilityOutrightPickWagerProfit,@ImpliedProbabilityOutrightPickHomeAwayWagerProfit,@ImpliedProbabilityOutrightPickFavDogWagerProfit
,@ImpliedProbabilitySpreadPickWagerProfit,@ImpliedProbabilitySpreadPickHomeAwayWagerProfit,@ImpliedProbabilitySpreadPickFavDogWagerProfit,@ImpliedProbabilityTotalPickWagerProfit,@ImpliedProbabilityOutrightPickHomeOddsThreshold,@ImpliedProbabilityOutrightPickAwayOddsThreshold
,@ImpliedProbabilityOutrightPickFavoriteOddsThreshold,@ImpliedProbabilityOutrightPickDogOddsThreshold,@ImpliedProbabilitySpreadPickHomeOddsThreshold,@ImpliedProbabilitySpreadPickAwayOddsThreshold,@ImpliedProbabilitySpreadPickFavoriteOddsThreshold
,@ImpliedProbabilitySpreadPickDogOddsThreshold,@ImpliedProbabilityTotalPickOverOddsThreshold,@ImpliedProbabilityTotalPickUnderOddsThreshold,@OneUnitThreshold,@FiveUnitThreshold,@TenUnitThreshold)
	
		INSERT INTO Tests_ssf_ScheduleMakePicks.ActualPicks		select HomeTeam,AwayTeam,Week,Season,ImpliedProbabilityOutrightPick,ImpliedProbabilityOutrightPickHomeAway,ImpliedProbabilityOutrightPickFavDog,ImpliedProbabilityOutrightPickCorrect,ImpliedProbabilityOutrightPickHACorrect,ImpliedProbabilityOutrightPickFDCorrect

			,ImpliedProbabilitySpreadPick,ImpliedProbabilitySpreadPickHomeAway,ImpliedProbabilitySpreadPickFavDog,ImpliedProbabilitySpreadPickHACorrect,ImpliedProbabilitySpreadPickFDCorrect,ImpliedProbabilitySpreadPickCorrect
			,ImpliedProbabilityTotalPick,ImpliedProbabilityTotalPickCorrect
		from ssf_ScheduleMakePicks(@test)
		--select * from @test
	
		EXEC tSQLt.AssertEmptyTable @TableName ='Tests_ssf_ScheduleMakePicks.ActualPicks', @Message ='Unexpected results in ActualPicks'
END
GO

CREATE PROCEDURE Tests_ssf_ScheduleMakePicks.[Test - Not Null parameters return data]
AS
BEGIN
	DECLARE @test GameDataTable
	DECLARE @HomeTeam			varchar(100) = 'Test Team 1',
	@AwayTeam					varchar(100) = 'Test Team 2',
	@Week						varchar(20) = 1,
	@Season						int = 2022,
	@HomeScore					int = 24,
	@AwayScore					int = 17,
	@Result						varchar(100) = 'Home',
	@HomeOddsOpen				decimal(5,2) = 0,
	@HomeOddsMin				decimal(5,2) = 0,
	@HomeOddsMax				decimal(5,2) = 0,
	@HomeOddsClose				decimal(5,2) = 1.91,
	@HomeOddsCloseIP			decimal(5,2) = NULL,
	@HomeOddsCloseDevig			decimal(5,2) = NULL,
	@AwayOddsOpen				decimal(5,2) = 0,
	@AwayOddsMin				decimal(5,2) = 0,
	@AwayOddsMax				decimal(5,2) = 0,
	@AwayOddsClose				decimal(5,2) = 1.91,
	@AwayOddsCloseIP			decimal(5,2) = NULL,
	@AwayOddsCloseDevig			decimal(5,2) = NULL,
	@HomeLineOpen				decimal(5,2) = 0,
	@HomeLineMin				decimal(5,2) = 0,
	@HomeLineMax				decimal(5,2) = 0,
	@HomeLineClose				decimal(5,2) = 1.91,
	@AwayLineOpen				decimal(5,2) = 0,
	@AwayLineMin				decimal(5,2) = 0,
	@AwayLineMax				decimal(5,2) = 0,
	@AwayLineClose				decimal(5,2) = 1.91,
	@HomeLineOddsOpen			decimal(5,2) = 0,
	@HomeLineOddsMin			decimal(5,2) = 0,
	@HomeLineOddsMax			decimal(5,2) = 0,
	@HomeLineOddsClose			decimal(5,2) = 1.91,
	@HomeLineOddsCloseIP		decimal(5,2) = NULL,
	@HomeLineOddsCloseDevig		decimal(5,2) = NULL,
	@AwayLineOddsOpen			decimal(5,2) = 0,
	@AwayLineOddsMin			decimal(5,2) = 0,
	@AwayLineOddsMax			decimal(5,2) = 0,
	@AwayLineOddsClose			decimal(5,2) = 1.91,
	@AwayLineOddsCloseIP		decimal(5,2) = NULL,
	@AwayLineOddsCloseDevig		decimal(5,2) = NULL,
	@TotalScoreOpen				decimal(5,2) = 0,
	@TotalScoreMin				decimal(5,2) = 0,
	@TotalScoreMax				decimal(5,2) = 0,
	@TotalScoreClose			decimal(5,2) = 45,
	@TotalScoreOverOpen			decimal(5,2) = 0,
	@TotalScoreOverMin			decimal(5,2) = 0,
	@TotalScoreOverMax			decimal(5,2) = 0,
	@TotalScoreOverClose		decimal(5,2) = 1.91,
	@TotalScoreOverCloseIP		decimal(5,2) = NULL,
	@TotalScoreOverCloseDevig	decimal(5,2) = NULL,
	@TotalScoreUnderOpen		decimal(5,2) = 0,
	@TotalScoreUnderMin			decimal(5,2) = 0,
	@TotalScoreUnderMax			decimal(5,2) = 0,
	@TotalScoreUnderClose		decimal(5,2) = 1.91,
	@TotalScoreUnderCloseIP		decimal(5,2) = NULL,
	@TotalScoreUnderCloseDevig	decimal(5,2) = NULL,
	@ImpliedProbabilityOutrightPick					VARCHAR(10) = NULL,
	@ImpliedProbabilityOutrightPickHomeAway			VARCHAR(10) = NULL,
	@ImpliedProbabilityOutrightPickFavDog			VARCHAR(10) = NULL,
	@ImpliedProbabilityOutrightPickCorrect			VARCHAR(1) = NULL, --Outright Best Pick Correct
	@ImpliedProbabilityOutrightPickHACorrect		VARCHAR(1) = NULL, --Home/Away Pick Correct
	@ImpliedProbabilityOutrightPickFDCorrect		VARCHAR(1) = NULL, --Fav/Dog Pick Correct
	@ImpliedProbabilitySpreadPick					VARCHAR(10) = NULL,
	@ImpliedProbabilitySpreadPickHomeAway			VARCHAR(10) = NULL,
	@ImpliedProbabilitySpreadPickFavDog				VARCHAR(10) = NULL,
	@ImpliedProbabilitySpreadPickHACorrect			VARCHAR(1) = NULL,
	@ImpliedProbabilitySpreadPickFDCorrect			VARCHAR(1) = NULL,
	@ImpliedProbabilitySpreadPickCorrect			VARCHAR(1) = NULL,
	@ImpliedProbabilityTotalPick					VARCHAR(10) = NULL,
	@ImpliedProbabilityTotalPickCorrect				VARCHAR(1) = NULL,
	@ImpliedProbabilityOutrightPickWager					DECIMAL(7,2) =  NULL,
	@ImpliedProbabilityOutrightPickHomeAwayWager			DECIMAL(7,2) =  NULL,
	@ImpliedProbabilityOutrightPickFavDogWager				DECIMAL(7,2) =  NULL,
	@ImpliedProbabilitySpreadPickWager						DECIMAL(7,2) =  NULL,
	@ImpliedProbabilitySpreadPickHomeAwayWager				DECIMAL(7,2) =  NULL,
	@ImpliedProbabilitySpreadPickFavDogWager				DECIMAL(7,2) =  NULL,
	@ImpliedProbabilityTotalPickWager						DECIMAL(7,2) =  NULL,
	@ImpliedProbabilityOutrightPickWagerProfit				DECIMAL(11,2) = NULL,
	@ImpliedProbabilityOutrightPickHomeAwayWagerProfit		DECIMAL(11,2) = NULL,
	@ImpliedProbabilityOutrightPickFavDogWagerProfit		DECIMAL(11,2) = NULL,
	@ImpliedProbabilitySpreadPickWagerProfit				DECIMAL(11,2) = NULL,
	@ImpliedProbabilitySpreadPickHomeAwayWagerProfit		DECIMAL(11,2) = NULL,
	@ImpliedProbabilitySpreadPickFavDogWagerProfit			DECIMAL(11,2) = NULL,
	@ImpliedProbabilityTotalPickWagerProfit					DECIMAL(11,2) = NULL,
	/*Implied Probability Thresholds*/
	@ImpliedProbabilityOutrightPickHomeOddsThreshold		DECIMAL(7,2)= 1.91,
	@ImpliedProbabilityOutrightPickAwayOddsThreshold		DECIMAL(7,2)= 1.91,
	@ImpliedProbabilityOutrightPickFavoriteOddsThreshold	DECIMAL(7,2)= 1.91,
	@ImpliedProbabilityOutrightPickDogOddsThreshold			DECIMAL(7,2)= 1.91,
	@ImpliedProbabilitySpreadPickHomeOddsThreshold			DECIMAL(7,2)= 1.91,
	@ImpliedProbabilitySpreadPickAwayOddsThreshold			DECIMAL(7,2)= 1.91,
	@ImpliedProbabilitySpreadPickFavoriteOddsThreshold		DECIMAL(7,2)= 1.91,
	@ImpliedProbabilitySpreadPickDogOddsThreshold			DECIMAL(7,2)= 1.91,
	@ImpliedProbabilityTotalPickOverOddsThreshold			DECIMAL(7,2)= 1.91,
	@ImpliedProbabilityTotalPickUnderOddsThreshold			DECIMAL(7,2)= 1.91,
	/*Pick Thresholds*/
	@OneUnitThreshold DECIMAL(5,2) = 0.1,
	@FiveUnitThreshold DECIMAL(5,2) = 0.2,
	@TenUnitThreshold DECIMAL(5,2) = 0.2
	
	INSERT INTO @test (HomeTeam,AwayTeam,Week,Season,HomeScore,AwayScore,Result,HomeOddsOpen,HomeOddsMin,HomeOddsMax,HomeOddsClose,HomeOddsCloseIP,HomeOddsCloseDevig,AwayOddsOpen,AwayOddsMin,AwayOddsMax,AwayOddsClose,AwayOddsCloseIP,AwayOddsCloseDevig,HomeLineOpen
,HomeLineMin,HomeLineMax,HomeLineClose,AwayLineOpen,AwayLineMin,AwayLineMax,AwayLineClose,HomeLineOddsOpen,HomeLineOddsMin,HomeLineOddsMax,HomeLineOddsClose,HomeLineOddsCloseIP,HomeLineOddsCloseDevig
,AwayLineOddsOpen,AwayLineOddsMin,AwayLineOddsMax,AwayLineOddsClose,AwayLineOddsCloseIP,AwayLineOddsCloseDevig,TotalScoreOpen,TotalScoreMin,TotalScoreMax,TotalScoreClose,TotalScoreOverOpen
,TotalScoreOverMin,TotalScoreOverMax,TotalScoreOverClose,TotalScoreOverCloseIP,TotalScoreOverCloseDevig,TotalScoreUnderOpen,TotalScoreUnderMin,TotalScoreUnderMax,TotalScoreUnderClose,TotalScoreUnderCloseIP
,TotalScoreUnderCloseDevig,ImpliedProbabilityOutrightPick,ImpliedProbabilityOutrightPickHomeAway,ImpliedProbabilityOutrightPickFavDog,ImpliedProbabilityOutrightPickCorrect,ImpliedProbabilityOutrightPickHACorrect,ImpliedProbabilityOutrightPickFDCorrect
,ImpliedProbabilitySpreadPick,ImpliedProbabilitySpreadPickHomeAway,ImpliedProbabilitySpreadPickFavDog,ImpliedProbabilitySpreadPickHACorrect,ImpliedProbabilitySpreadPickFDCorrect,ImpliedProbabilitySpreadPickCorrect
,ImpliedProbabilityTotalPick,ImpliedProbabilityTotalPickCorrect,ImpliedProbabilityOutrightPickWager,ImpliedProbabilityOutrightPickHomeAwayWager,ImpliedProbabilityOutrightPickFavDogWager,ImpliedProbabilitySpreadPickWager
,ImpliedProbabilitySpreadPickHomeAwayWager,ImpliedProbabilitySpreadPickFavDogWager,ImpliedProbabilityTotalPickWager,ImpliedProbabilityOutrightPickWagerProfit,ImpliedProbabilityOutrightPickHomeAwayWagerProfit,ImpliedProbabilityOutrightPickFavDogWagerProfit
,ImpliedProbabilitySpreadPickWagerProfit,ImpliedProbabilitySpreadPickHomeAwayWagerProfit,ImpliedProbabilitySpreadPickFavDogWagerProfit,ImpliedProbabilityTotalPickWagerProfit,ImpliedProbabilityOutrightPickHomeOddsThreshold,ImpliedProbabilityOutrightPickAwayOddsThreshold
,ImpliedProbabilityOutrightPickFavoriteOddsThreshold,ImpliedProbabilityOutrightPickDogOddsThreshold,ImpliedProbabilitySpreadPickHomeOddsThreshold,ImpliedProbabilitySpreadPickAwayOddsThreshold,ImpliedProbabilitySpreadPickFavoriteOddsThreshold
,ImpliedProbabilitySpreadPickDogOddsThreshold,ImpliedProbabilityTotalPickOverOddsThreshold,ImpliedProbabilityTotalPickUnderOddsThreshold,OneUnitThreshold,FiveUnitThreshold,TenUnitThreshold)
VALUES (@HomeTeam,@AwayTeam,@Week,@Season,@HomeScore,@AwayScore,@Result,@HomeOddsOpen,@HomeOddsMin,@HomeOddsMax,@HomeOddsClose,@HomeOddsCloseIP,@HomeOddsCloseDevig,@AwayOddsOpen,@AwayOddsMin,@AwayOddsMax,@AwayOddsClose,@AwayOddsCloseIP,@AwayOddsCloseDevig,@HomeLineOpen
,@HomeLineMin,@HomeLineMax,@HomeLineClose,@AwayLineOpen,@AwayLineMin,@AwayLineMax,@AwayLineClose,@HomeLineOddsOpen,@HomeLineOddsMin,@HomeLineOddsMax,@HomeLineOddsClose,@HomeLineOddsCloseIP,@HomeLineOddsCloseDevig
,@AwayLineOddsOpen,@AwayLineOddsMin,@AwayLineOddsMax,@AwayLineOddsClose,@AwayLineOddsCloseIP,@AwayLineOddsCloseDevig,@TotalScoreOpen,@TotalScoreMin,@TotalScoreMax,@TotalScoreClose,@TotalScoreOverOpen
,@TotalScoreOverMin,@TotalScoreOverMax,@TotalScoreOverClose,@TotalScoreOverCloseIP,@TotalScoreOverCloseDevig,@TotalScoreUnderOpen,@TotalScoreUnderMin,@TotalScoreUnderMax,@TotalScoreUnderClose,@TotalScoreUnderCloseIP
,@TotalScoreUnderCloseDevig,@ImpliedProbabilityOutrightPick,@ImpliedProbabilityOutrightPickHomeAway,@ImpliedProbabilityOutrightPickFavDog,@ImpliedProbabilityOutrightPickCorrect,@ImpliedProbabilityOutrightPickHACorrect,@ImpliedProbabilityOutrightPickFDCorrect
,@ImpliedProbabilitySpreadPick,@ImpliedProbabilitySpreadPickHomeAway,@ImpliedProbabilitySpreadPickFavDog,@ImpliedProbabilitySpreadPickHACorrect,@ImpliedProbabilitySpreadPickFDCorrect,@ImpliedProbabilitySpreadPickCorrect
,@ImpliedProbabilityTotalPick,@ImpliedProbabilityTotalPickCorrect,@ImpliedProbabilityOutrightPickWager,@ImpliedProbabilityOutrightPickHomeAwayWager,@ImpliedProbabilityOutrightPickFavDogWager,@ImpliedProbabilitySpreadPickWager
,@ImpliedProbabilitySpreadPickHomeAwayWager,@ImpliedProbabilitySpreadPickFavDogWager,@ImpliedProbabilityTotalPickWager,@ImpliedProbabilityOutrightPickWagerProfit,@ImpliedProbabilityOutrightPickHomeAwayWagerProfit,@ImpliedProbabilityOutrightPickFavDogWagerProfit
,@ImpliedProbabilitySpreadPickWagerProfit,@ImpliedProbabilitySpreadPickHomeAwayWagerProfit,@ImpliedProbabilitySpreadPickFavDogWagerProfit,@ImpliedProbabilityTotalPickWagerProfit,@ImpliedProbabilityOutrightPickHomeOddsThreshold,@ImpliedProbabilityOutrightPickAwayOddsThreshold
,@ImpliedProbabilityOutrightPickFavoriteOddsThreshold,@ImpliedProbabilityOutrightPickDogOddsThreshold,@ImpliedProbabilitySpreadPickHomeOddsThreshold,@ImpliedProbabilitySpreadPickAwayOddsThreshold,@ImpliedProbabilitySpreadPickFavoriteOddsThreshold
,@ImpliedProbabilitySpreadPickDogOddsThreshold,@ImpliedProbabilityTotalPickOverOddsThreshold,@ImpliedProbabilityTotalPickUnderOddsThreshold,@OneUnitThreshold,@FiveUnitThreshold,@TenUnitThreshold)
	
		EXEC Tests_ssf_ScheduleMakePicks.SetupExpectedPicks
			 @HomeTeam = 'Test Team 1'
			,@AwayTeam = 'Test Team 2'
			,@Week = 1
			,@Season = 2022
			,@ImpliedProbabilityOutrightPick = NULL
			,@ImpliedProbabilityOutrightPickHomeAway = NULL
			,@ImpliedProbabilityOutrightPickFavDog = NULL
			,@ImpliedProbabilityOutrightPickCorrect = NULL
			,@ImpliedProbabilityOutrightPickHACorrect = NULL
			,@ImpliedProbabilityOutrightPickFDCorrect = NULL
			,@ImpliedProbabilitySpreadPick = NULL
			,@ImpliedProbabilitySpreadPickHomeAway = 'Home'
			,@ImpliedProbabilitySpreadPickFavDog = NULL
			,@ImpliedProbabilitySpreadPickHACorrect = 'Y'
			,@ImpliedProbabilitySpreadPickFDCorrect = NULL
			,@ImpliedProbabilitySpreadPickCorrect = NULL
			,@ImpliedProbabilityTotalPick = 'Under'
			,@ImpliedProbabilityTotalPickCorrect = 'Y'

		INSERT INTO Tests_ssf_ScheduleMakePicks.ActualPicks
		select HomeTeam,AwayTeam,Week,Season,ImpliedProbabilityOutrightPick,ImpliedProbabilityOutrightPickHomeAway,ImpliedProbabilityOutrightPickFavDog,ImpliedProbabilityOutrightPickCorrect,ImpliedProbabilityOutrightPickHACorrect,ImpliedProbabilityOutrightPickFDCorrect
			,ImpliedProbabilitySpreadPick,ImpliedProbabilitySpreadPickHomeAway,ImpliedProbabilitySpreadPickFavDog,ImpliedProbabilitySpreadPickHACorrect,ImpliedProbabilitySpreadPickFDCorrect,ImpliedProbabilitySpreadPickCorrect
			,ImpliedProbabilityTotalPick,ImpliedProbabilityTotalPickCorrect
		FROM ssf_ScheduleMakePicks(@test)
		--select * from @test
	
		EXEC tSQLt.AssertEqualsTable @Expected ='Tests_ssf_ScheduleMakePicks.ExpectedPicks', @Actual = 'Tests_ssf_ScheduleMakePicks.ActualPicks', @Message ='Unexpected results in ActualPicks'
END
GO

EXEC tSQLt.Run @TestName = 'Tests_ssf_ScheduleMakePicks.[Test - NULL table parameter returns no data]'
EXEC tSQLt.Run @TestName = 'Tests_ssf_ScheduleMakePicks.[Test - Not Null parameters return data]'

GO
DECLARE @test GameDataTable
DECLARE @HomeTeam					varchar(100) = NULL,
	@AwayTeam					varchar(100) =NULL,
	@Week						varchar(20)=NULL,
	@Season						int=NULL,
	@HomeScore					int=NULL,
	@AwayScore					int=NULL,
	@Result						varchar(100)=NULL,
	@HomeAvgPointsFor			decimal(5,2)= NULL,
	@HomeAvgPointsAgainst		decimal(5,2)= NULL,
	@HomeAvgOff1stD				decimal(5,2)= NULL,
	@HomeAvgOffTotYd			decimal(5,2)= NULL,
	@HomeAvgOffPassYd			decimal(5,2)= NULL,
	@HomeAvgOffRushYd			decimal(5,2)= NULL,
	@HomeAvgOffTO				decimal(5,2)= NULL,
	@HomeAvgDef1stD				decimal(5,2)= NULL,
	@HomeAvgDefTotYd			decimal(5,2)= NULL,
	@HomeAvgDefPassYd			decimal(5,2)= NULL,
	@HomeAvgDefRushYd			decimal(5,2)= NULL,
	@HomeAvgDefTO				decimal(5,2)= NULL,
	@HomeAvgExPointsOff			decimal(5,2)= NULL,
	@HomeAvgExPointsDef			decimal(5,2)= NULL,
	@HomeAvgExPointsSpecial		decimal(5,2)= NULL,
	@HomeLastPointsFor			int=NULL,
	@HomeLastPointsAgainst		int=NULL,
	@HomeLastOff1stD			int=NULL,
	@HomeLastOffTotYd			int=NULL,
	@HomeLastOffPassYd			int=NULL,
	@HomeLastOffRushYd			int=NULL,
	@HomeLastOffTO				int=NULL,
	@HomeLastDef1stD			int=NULL,
	@HomeLastDefTotYd			int=NULL,
	@HomeLastDefPassYd			int=NULL,
	@HomeLastDefRushYd			int=NULL,
	@HomeLastDefTO				int=NULL,
	@HomeLastExPointsOff		decimal(5,2)=NULL,
	@HomeLastExPointsDef		decimal(5,2)=NULL,
	@HomeLastExPointsSpecial	decimal(5,2)=NULL,
	@AwayAvgPointsFor			decimal(5,2)=NULL,
	@AwayAvgPointsAgainst		decimal(5,2)=NULL,
	@AwayAvgOff1stD				decimal(5,2)=NULL,
	@AwayAvgOffTotYd			decimal(5,2)=NULL,
	@AwayAvgOffPassYd			decimal(5,2)=NULL,
	@AwayAvgOffRushYd			decimal(5,2)=NULL,
	@AwayAvgOffTO				decimal(5,2)=NULL,
	@AwayAvgDef1stD				decimal(5,2)=NULL,
	@AwayAvgDefTotYd			decimal(5,2)=NULL,
	@AwayAvgDefPassYd			decimal(5,2)=NULL,
	@AwayAvgDefRushYd			decimal(5,2)=NULL,
	@AwayAvgDefTO				decimal(5,2)=NULL,
	@AwayAvgExPointsOff			decimal(5,2)=NULL,
	@AwayAvgExPointsDef			decimal(5,2)=NULL,
	@AwayAvgExPointsSpecial		decimal(5,2)=NULL,
	@AwayLastPointsFor			int= NULL,
	@AwayLastPointsAgainst		int= NULL,
	@AwayLastOff1stD			int= NULL,
	@AwayLastOffTotYd			int= NULL,
	@AwayLastOffPassYd			int= NULL,
	@AwayLastOffRushYd			int= NULL,
	@AwayLastOffTO				int= NULL,
	@AwayLastDef1stD			int= NULL,
	@AwayLastDefTotYd			int= NULL,
	@AwayLastDefPassYd			int= NULL,
	@AwayLastDefRushYd			int= NULL,
	@AwayLastDefTO				int= NULL,
	@AwayLastExPointsOff		decimal(5,2)= NULL,
	@AwayLastExPointsDef		decimal(5,2)= NULL,
	@AwayLastExPointsSpecial	decimal(5,2)= NULL,
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
	@HomeLineMovement			decimal(5,2) = NULL,
	@HomeLineOddsMovement		decimal(5,2) = NULL,
	@AwayLineMovement			decimal(5,2) = NULL,
	@AwayLineOddsMovement		decimal(5,2) = NULL,
	@TotalScoreMovement			decimal(5,2) = NULL,
	@TotalScoreOverMovement		decimal(5,2) = NULL,
	@TotalScoreUnderMovement	decimal(5,2) = NULL,
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
	@ImpliedProbabilityOutrightPickHomeOddsThreshold		DECIMAL(7,2)=NULL,
	@ImpliedProbabilityOutrightPickAwayOddsThreshold		DECIMAL(7,2)=NULL,
	@ImpliedProbabilityOutrightPickFavoriteOddsThreshold	DECIMAL(7,2)=NULL,
	@ImpliedProbabilityOutrightPickDogOddsThreshold			DECIMAL(7,2)=NULL,
	@ImpliedProbabilitySpreadPickHomeOddsThreshold			DECIMAL(7,2)=NULL,
	@ImpliedProbabilitySpreadPickAwayOddsThreshold			DECIMAL(7,2)=NULL,
	@ImpliedProbabilitySpreadPickFavoriteOddsThreshold		DECIMAL(7,2)=NULL,
	@ImpliedProbabilitySpreadPickDogOddsThreshold			DECIMAL(7,2)=NULL,
	@ImpliedProbabilityTotalPickOverOddsThreshold			DECIMAL(7,2)=NULL,
	@ImpliedProbabilityTotalPickUnderOddsThreshold			DECIMAL(7,2)=NULL,
	/*Pick Thresholds*/
	@OneUnitThreshold DECIMAL(5,2) = NULL,
	@FiveUnitThreshold DECIMAL(5,2) = NULL,
	@TenUnitThreshold DECIMAL(5,2) = NULL

INSERT INTO @test (HomeTeam,AwayTeam,Week,Season,HomeScore,AwayScore,Result,HomeAvgPointsFor,HomeAvgPointsAgainst,HomeAvgOff1stD,HomeAvgOffTotYd,HomeAvgOffPassYd,HomeAvgOffRushYd
,HomeAvgOffTO,HomeAvgDef1stD,HomeAvgDefTotYd,HomeAvgDefPassYd,HomeAvgDefRushYd,HomeAvgDefTO,HomeAvgExPointsOff,HomeAvgExPointsDef,HomeAvgExPointsSpecial,HomeLastPointsFor,HomeLastPointsAgainst
,HomeLastOff1stD,HomeLastOffTotYd,HomeLastOffPassYd,HomeLastOffRushYd,HomeLastOffTO,HomeLastDef1stD,HomeLastDefTotYd,HomeLastDefPassYd,HomeLastDefRushYd,HomeLastDefTO,HomeLastExPointsOff
,HomeLastExPointsDef,HomeLastExPointsSpecial,AwayAvgPointsFor,AwayAvgPointsAgainst,AwayAvgOff1stD,AwayAvgOffTotYd,AwayAvgOffPassYd,AwayAvgOffRushYd,AwayAvgOffTO,AwayAvgDef1stD,AwayAvgDefTotYd
,AwayAvgDefPassYd,AwayAvgDefRushYd,AwayAvgDefTO,AwayAvgExPointsOff,AwayAvgExPointsDef,AwayAvgExPointsSpecial,AwayLastPointsFor,AwayLastPointsAgainst,AwayLastOff1stD,AwayLastOffTotYd
,AwayLastOffPassYd,AwayLastOffRushYd,AwayLastOffTO,AwayLastDef1stD,AwayLastDefTotYd,AwayLastDefPassYd,AwayLastDefRushYd,AwayLastDefTO,AwayLastExPointsOff,AwayLastExPointsDef,AwayLastExPointsSpecial
,HomeOddsOpen,HomeOddsMin,HomeOddsMax,HomeOddsClose,HomeOddsCloseIP,HomeOddsCloseDevig,AwayOddsOpen,AwayOddsMin,AwayOddsMax,AwayOddsClose,AwayOddsCloseIP,AwayOddsCloseDevig,HomeLineOpen
,HomeLineMin,HomeLineMax,HomeLineClose,AwayLineOpen,AwayLineMin,AwayLineMax,AwayLineClose,HomeLineOddsOpen,HomeLineOddsMin,HomeLineOddsMax,HomeLineOddsClose,HomeLineOddsCloseIP,HomeLineOddsCloseDevig
,AwayLineOddsOpen,AwayLineOddsMin,AwayLineOddsMax,AwayLineOddsClose,AwayLineOddsCloseIP,AwayLineOddsCloseDevig,TotalScoreOpen,TotalScoreMin,TotalScoreMax,TotalScoreClose,TotalScoreOverOpen
,TotalScoreOverMin,TotalScoreOverMax,TotalScoreOverClose,TotalScoreOverCloseIP,TotalScoreOverCloseDevig,TotalScoreUnderOpen,TotalScoreUnderMin,TotalScoreUnderMax,TotalScoreUnderClose,TotalScoreUnderCloseIP
,TotalScoreUnderCloseDevig,HomeLineMovement,HomeLineOddsMovement ,AwayLineMovement,AwayLineOddsMovement,TotalScoreMovement,TotalScoreOverMovement,TotalScoreUnderMovement,ImpliedProbabilityOutrightPick
,ImpliedProbabilityOutrightPickHomeAway,ImpliedProbabilityOutrightPickFavDog,ImpliedProbabilityOutrightPickCorrect,ImpliedProbabilityOutrightPickHACorrect,ImpliedProbabilityOutrightPickFDCorrect
,ImpliedProbabilitySpreadPick,ImpliedProbabilitySpreadPickHomeAway,ImpliedProbabilitySpreadPickFavDog,ImpliedProbabilitySpreadPickHACorrect,ImpliedProbabilitySpreadPickFDCorrect,ImpliedProbabilitySpreadPickCorrect
,ImpliedProbabilityTotalPick,ImpliedProbabilityTotalPickCorrect,ImpliedProbabilityOutrightPickWager,ImpliedProbabilityOutrightPickHomeAwayWager,ImpliedProbabilityOutrightPickFavDogWager,ImpliedProbabilitySpreadPickWager
,ImpliedProbabilitySpreadPickHomeAwayWager,ImpliedProbabilitySpreadPickFavDogWager,ImpliedProbabilityTotalPickWager,ImpliedProbabilityOutrightPickWagerProfit,ImpliedProbabilityOutrightPickHomeAwayWagerProfit,ImpliedProbabilityOutrightPickFavDogWagerProfit
,ImpliedProbabilitySpreadPickWagerProfit,ImpliedProbabilitySpreadPickHomeAwayWagerProfit,ImpliedProbabilitySpreadPickFavDogWagerProfit,ImpliedProbabilityTotalPickWagerProfit,ImpliedProbabilityOutrightPickHomeOddsThreshold,ImpliedProbabilityOutrightPickAwayOddsThreshold
,ImpliedProbabilityOutrightPickFavoriteOddsThreshold,ImpliedProbabilityOutrightPickDogOddsThreshold,ImpliedProbabilitySpreadPickHomeOddsThreshold,ImpliedProbabilitySpreadPickAwayOddsThreshold,ImpliedProbabilitySpreadPickFavoriteOddsThreshold
,ImpliedProbabilitySpreadPickDogOddsThreshold,ImpliedProbabilityTotalPickOverOddsThreshold,ImpliedProbabilityTotalPickUnderOddsThreshold,OneUnitThreshold,FiveUnitThreshold,TenUnitThreshold)
VALUES (@HomeTeam,@AwayTeam,@Week,@Season,@HomeScore,@AwayScore,@Result,@HomeAvgPointsFor,@HomeAvgPointsAgainst,@HomeAvgOff1stD,@HomeAvgOffTotYd,@HomeAvgOffPassYd,@HomeAvgOffRushYd
,@HomeAvgOffTO,@HomeAvgDef1stD,@HomeAvgDefTotYd,@HomeAvgDefPassYd,@HomeAvgDefRushYd,@HomeAvgDefTO,@HomeAvgExPointsOff,@HomeAvgExPointsDef,@HomeAvgExPointsSpecial,@HomeLastPointsFor,@HomeLastPointsAgainst
,@HomeLastOff1stD,@HomeLastOffTotYd,@HomeLastOffPassYd,@HomeLastOffRushYd,@HomeLastOffTO,@HomeLastDef1stD,@HomeLastDefTotYd,@HomeLastDefPassYd,@HomeLastDefRushYd,@HomeLastDefTO,@HomeLastExPointsOff
,@HomeLastExPointsDef,@HomeLastExPointsSpecial,@AwayAvgPointsFor,@AwayAvgPointsAgainst,@AwayAvgOff1stD,@AwayAvgOffTotYd,@AwayAvgOffPassYd,@AwayAvgOffRushYd,@AwayAvgOffTO,@AwayAvgDef1stD,@AwayAvgDefTotYd
,@AwayAvgDefPassYd,@AwayAvgDefRushYd,@AwayAvgDefTO,@AwayAvgExPointsOff,@AwayAvgExPointsDef,@AwayAvgExPointsSpecial,@AwayLastPointsFor,@AwayLastPointsAgainst,@AwayLastOff1stD,@AwayLastOffTotYd
,@AwayLastOffPassYd,@AwayLastOffRushYd,@AwayLastOffTO,@AwayLastDef1stD,@AwayLastDefTotYd,@AwayLastDefPassYd,@AwayLastDefRushYd,@AwayLastDefTO,@AwayLastExPointsOff,@AwayLastExPointsDef,@AwayLastExPointsSpecial
,@HomeOddsOpen,@HomeOddsMin,@HomeOddsMax,@HomeOddsClose,@HomeOddsCloseIP,@HomeOddsCloseDevig,@AwayOddsOpen,@AwayOddsMin,@AwayOddsMax,@AwayOddsClose,@AwayOddsCloseIP,@AwayOddsCloseDevig,@HomeLineOpen
,@HomeLineMin,@HomeLineMax,@HomeLineClose,@AwayLineOpen,@AwayLineMin,@AwayLineMax,@AwayLineClose,@HomeLineOddsOpen,@HomeLineOddsMin,@HomeLineOddsMax,@HomeLineOddsClose,@HomeLineOddsCloseIP,@HomeLineOddsCloseDevig
,@AwayLineOddsOpen,@AwayLineOddsMin,@AwayLineOddsMax,@AwayLineOddsClose,@AwayLineOddsCloseIP,@AwayLineOddsCloseDevig,@TotalScoreOpen,@TotalScoreMin,@TotalScoreMax,@TotalScoreClose,@TotalScoreOverOpen
,@TotalScoreOverMin,@TotalScoreOverMax,@TotalScoreOverClose,@TotalScoreOverCloseIP,@TotalScoreOverCloseDevig,@TotalScoreUnderOpen,@TotalScoreUnderMin,@TotalScoreUnderMax,@TotalScoreUnderClose,@TotalScoreUnderCloseIP
,@TotalScoreUnderCloseDevig,@HomeLineMovement,@HomeLineOddsMovement ,@AwayLineMovement,@AwayLineOddsMovement,@TotalScoreMovement,@TotalScoreOverMovement,@TotalScoreUnderMovement,@ImpliedProbabilityOutrightPick
,@ImpliedProbabilityOutrightPickHomeAway,@ImpliedProbabilityOutrightPickFavDog,@ImpliedProbabilityOutrightPickCorrect,@ImpliedProbabilityOutrightPickHACorrect,@ImpliedProbabilityOutrightPickFDCorrect
,@ImpliedProbabilitySpreadPick,@ImpliedProbabilitySpreadPickHomeAway,@ImpliedProbabilitySpreadPickFavDog,@ImpliedProbabilitySpreadPickHACorrect,@ImpliedProbabilitySpreadPickFDCorrect,@ImpliedProbabilitySpreadPickCorrect
,@ImpliedProbabilityTotalPick,@ImpliedProbabilityTotalPickCorrect,@ImpliedProbabilityOutrightPickWager,@ImpliedProbabilityOutrightPickHomeAwayWager,@ImpliedProbabilityOutrightPickFavDogWager,@ImpliedProbabilitySpreadPickWager
,@ImpliedProbabilitySpreadPickHomeAwayWager,@ImpliedProbabilitySpreadPickFavDogWager,@ImpliedProbabilityTotalPickWager,@ImpliedProbabilityOutrightPickWagerProfit,@ImpliedProbabilityOutrightPickHomeAwayWagerProfit,@ImpliedProbabilityOutrightPickFavDogWagerProfit
,@ImpliedProbabilitySpreadPickWagerProfit,@ImpliedProbabilitySpreadPickHomeAwayWagerProfit,@ImpliedProbabilitySpreadPickFavDogWagerProfit,@ImpliedProbabilityTotalPickWagerProfit,@ImpliedProbabilityOutrightPickHomeOddsThreshold,@ImpliedProbabilityOutrightPickAwayOddsThreshold
,@ImpliedProbabilityOutrightPickFavoriteOddsThreshold,@ImpliedProbabilityOutrightPickDogOddsThreshold,@ImpliedProbabilitySpreadPickHomeOddsThreshold,@ImpliedProbabilitySpreadPickAwayOddsThreshold,@ImpliedProbabilitySpreadPickFavoriteOddsThreshold
,@ImpliedProbabilitySpreadPickDogOddsThreshold,@ImpliedProbabilityTotalPickOverOddsThreshold,@ImpliedProbabilityTotalPickUnderOddsThreshold,@OneUnitThreshold,@FiveUnitThreshold,@TenUnitThreshold)

	--INSERT INTO Tests_ssf_ScheduleMakePicks.Actual
	select * from ssf_ScheduleMakePicks(@test)
	select * from @test

	exec ssp_ScheduleDataReport_Dev 'B', 0.1, 0.25, 0.5
	select * from Seasons
	ORDER BY Season ASC
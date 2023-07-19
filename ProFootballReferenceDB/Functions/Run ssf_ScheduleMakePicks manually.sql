DECLARE @test GameDataTable
DECLARE @HomeTeam					varchar(100) = 'Detroit Lions',
	@AwayTeam					varchar(100) ='Green Bay Packers',
	@Week						varchar(20)='1',
	@Season						int=2023,
	@HomeScore					int=24,
	@AwayScore					int=20,
	@Result						varchar(100)='Home',
	@HomeAvgPointsFor			decimal(5,2)= 0,
	@HomeAvgPointsAgainst		decimal(5,2)= 0,
	@HomeAvgOff1stD				decimal(5,2)= 0,
	@HomeAvgOffTotYd			decimal(5,2)= 0,
	@HomeAvgOffPassYd			decimal(5,2)= 0,
	@HomeAvgOffRushYd			decimal(5,2)= 0,
	@HomeAvgOffTO				decimal(5,2)= 0,
	@HomeAvgDef1stD				decimal(5,2)= 0,
	@HomeAvgDefTotYd			decimal(5,2)= 0,
	@HomeAvgDefPassYd			decimal(5,2)= 0,
	@HomeAvgDefRushYd			decimal(5,2)= 0,
	@HomeAvgDefTO				decimal(5,2)= 0,
	@HomeAvgExPointsOff			decimal(5,2)= 0,
	@HomeAvgExPointsDef			decimal(5,2)= 0,
	@HomeAvgExPointsSpecial		decimal(5,2)= 0,
	@HomeLastPointsFor			int=0,
	@HomeLastPointsAgainst		int=0,
	@HomeLastOff1stD			int=0,
	@HomeLastOffTotYd			int=0,
	@HomeLastOffPassYd			int=0,
	@HomeLastOffRushYd			int=0,
	@HomeLastOffTO				int=0,
	@HomeLastDef1stD			int=0,
	@HomeLastDefTotYd			int=0,
	@HomeLastDefPassYd			int=0,
	@HomeLastDefRushYd			int=0,
	@HomeLastDefTO				int=0,
	@HomeLastExPointsOff		decimal(5,2)=0,
	@HomeLastExPointsDef		decimal(5,2)=0,
	@HomeLastExPointsSpecial	decimal(5,2)=0,
	@AwayAvgPointsFor			decimal(5,2)=0,
	@AwayAvgPointsAgainst		decimal(5,2)=0,
	@AwayAvgOff1stD				decimal(5,2)=0,
	@AwayAvgOffTotYd			decimal(5,2)=0,
	@AwayAvgOffPassYd			decimal(5,2)=0,
	@AwayAvgOffRushYd			decimal(5,2)=0,
	@AwayAvgOffTO				decimal(5,2)=0,
	@AwayAvgDef1stD				decimal(5,2)=0,
	@AwayAvgDefTotYd			decimal(5,2)=0,
	@AwayAvgDefPassYd			decimal(5,2)=0,
	@AwayAvgDefRushYd			decimal(5,2)=0,
	@AwayAvgDefTO				decimal(5,2)=0,
	@AwayAvgExPointsOff			decimal(5,2)=0,
	@AwayAvgExPointsDef			decimal(5,2)=0,
	@AwayAvgExPointsSpecial		decimal(5,2)=0,
	@AwayLastPointsFor			int=0,
	@AwayLastPointsAgainst		int=0,
	@AwayLastOff1stD			int=0,
	@AwayLastOffTotYd			int=0,
	@AwayLastOffPassYd			int=0,
	@AwayLastOffRushYd			int=0,
	@AwayLastOffTO				int=0,
	@AwayLastDef1stD			int=0,
	@AwayLastDefTotYd			int=0,
	@AwayLastDefPassYd			int=0,
	@AwayLastDefRushYd			int=0,
	@AwayLastDefTO				int=0,
	@AwayLastExPointsOff		decimal(5,2)=0,
	@AwayLastExPointsDef		decimal(5,2)=0,
	@AwayLastExPointsSpecial	decimal(5,2)=0,
	@HomeOddsOpen				decimal(5,2) = 1.91,
	@HomeOddsMin				decimal(5,2) = 1.91,
	@HomeOddsMax				decimal(5,2) = 1.91,
	@HomeOddsClose				decimal(5,2) = 1.91,
	@HomeOddsCloseIP			decimal(5,2) = 0.00,
	@HomeOddsCloseDevig			decimal(5,2) = 0.00,
	@AwayOddsOpen				decimal(5,2) = 2.00,
	@AwayOddsMin				decimal(5,2) = 2.00,
	@AwayOddsMax				decimal(5,2) = 2.00,
	@AwayOddsClose				decimal(5,2) = 2.00,
	@AwayOddsCloseIP			decimal(5,2) = 0.00,
	@AwayOddsCloseDevig			decimal(5,2) = 0.00,
	@HomeLineOpen				decimal(5,2) = -4,
	@HomeLineMin				decimal(5,2) = -4,
	@HomeLineMax				decimal(5,2) = -4,
	@HomeLineClose				decimal(5,2) = -4,
	@AwayLineOpen				decimal(5,2) = 4,
	@AwayLineMin				decimal(5,2) = 4,
	@AwayLineMax				decimal(5,2) = 4,
	@AwayLineClose				decimal(5,2) = 4,
	@HomeLineOddsOpen			decimal(5,2) = 1.91,
	@HomeLineOddsMin			decimal(5,2) = 1.91,
	@HomeLineOddsMax			decimal(5,2) = 1.91,
	@HomeLineOddsClose			decimal(5,2) = 1.91,
	@HomeLineOddsCloseIP		decimal(5,2) = 0.00,
	@HomeLineOddsCloseDevig		decimal(5,2) = 0.00,
	@AwayLineOddsOpen			decimal(5,2) = 1.91,
	@AwayLineOddsMin			decimal(5,2) = 1.91,
	@AwayLineOddsMax			decimal(5,2) = 1.91,
	@AwayLineOddsClose			decimal(5,2) = 1.91,
	@AwayLineOddsCloseIP		decimal(5,2) = 0.00,
	@AwayLineOddsCloseDevig		decimal(5,2) = 0.00,
	@TotalScoreOpen				decimal(5,2) = 46,
	@TotalScoreMin				decimal(5,2) = 46,
	@TotalScoreMax				decimal(5,2) = 46,
	@TotalScoreClose			decimal(5,2) = 46,
	@TotalScoreOverOpen			decimal(5,2) = 1.91,
	@TotalScoreOverMin			decimal(5,2) = 1.91,
	@TotalScoreOverMax			decimal(5,2) = 1.91,
	@TotalScoreOverClose		decimal(5,2) = 1.91,
	@TotalScoreOverCloseIP		decimal(5,2) = 0.00,
	@TotalScoreOverCloseDevig	decimal(5,2) = 0.00,
	@TotalScoreUnderOpen		decimal(5,2) = 1.91,
	@TotalScoreUnderMin			decimal(5,2) = 1.91,
	@TotalScoreUnderMax			decimal(5,2) = 1.91,
	@TotalScoreUnderClose		decimal(5,2) = 1.91,
	@TotalScoreUnderCloseIP		decimal(5,2) = 0.00,
	@TotalScoreUnderCloseDevig	decimal(5,2) = 0.00,
	@HomeLineMovement			decimal(5,2) = 0.00,
	@HomeLineOddsMovement		decimal(5,2) = 0.00,
	@AwayLineMovement			decimal(5,2) = 0.00,
	@AwayLineOddsMovement		decimal(5,2) = 0.00,
	@TotalScoreMovement			decimal(5,2) = 0.00,
	@TotalScoreOverMovement		decimal(5,2) = 0.00,
	@TotalScoreUnderMovement	decimal(5,2) = 0.00,
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
	@ImpliedProbabilityOutrightPickHomeOddsThreshold		DECIMAL(7,2)=0.50,
	@ImpliedProbabilityOutrightPickAwayOddsThreshold		DECIMAL(7,2)=0.50,
	@ImpliedProbabilityOutrightPickFavoriteOddsThreshold	DECIMAL(7,2)=0.50,
	@ImpliedProbabilityOutrightPickDogOddsThreshold			DECIMAL(7,2)=0.50,
	@ImpliedProbabilitySpreadPickHomeOddsThreshold			DECIMAL(7,2)=0.50,
	@ImpliedProbabilitySpreadPickAwayOddsThreshold			DECIMAL(7,2)=0.50,
	@ImpliedProbabilitySpreadPickFavoriteOddsThreshold		DECIMAL(7,2)=0.50,
	@ImpliedProbabilitySpreadPickDogOddsThreshold			DECIMAL(7,2)=0.50,
	@ImpliedProbabilityTotalPickOverOddsThreshold			DECIMAL(7,2)=0.50,
	@ImpliedProbabilityTotalPickUnderOddsThreshold			DECIMAL(7,2)=0.50,
	/*Pick Thresholds*/
	@OneUnitThreshold DECIMAL(5,2) = 0.1,
	@FiveUnitThreshold DECIMAL(5,2) = 0.2,
	@TenUnitThreshold DECIMAL(5,2) = 0.2

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

select * from @test
select * from ssf_ScheduleMakePicks(@test)





--exec ssp_ScheduleDataReport_Dev 'B', 0.1, 0.2, 0.2
--
--select * from GameData


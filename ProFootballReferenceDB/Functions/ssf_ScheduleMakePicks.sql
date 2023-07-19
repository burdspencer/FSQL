IF OBJECT_ID('ssf_ScheduleMakePicks') IS NOT NULL
	DROP FUNCTION ssf_ScheduleMakePicks
GO

CREATE FUNCTION ssf_ScheduleMakePicks(
	@GameDataTable dbo.GameDataTable READONLY
)
RETURNS @Output TABLE (
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
	HomeLineOddsMovement		decimal(5,2),
	AwayLineMovement			decimal(5,2),
	AwayLineOddsMovement		decimal(5,2),
	TotalScoreMovement			decimal(5,2),
	TotalScoreOverMovement		decimal(5,2),
	TotalScoreUnderMovement		decimal(5,2),
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
AS
BEGIN
	INSERT INTO @Output (
		HomeTeam,
		AwayTeam,
		Week,
		Season,
		HomeScore,
		AwayScore,
		Result,
		HomeAvgPointsFor,
		HomeAvgPointsAgainst,
		HomeAvgOff1stD,
		HomeAvgOffTotYd,
		HomeAvgOffPassYd,
		HomeAvgOffRushYd,
		HomeAvgOffTO,
		HomeAvgDef1stD,
		HomeAvgDefTotYd,
		HomeAvgDefPassYd,
		HomeAvgDefRushYd,
		HomeAvgDefTO,
		HomeAvgExPointsOff,
		HomeAvgExPointsDef,
		HomeAvgExPointsSpecial,
		HomeLastPointsFor,
		HomeLastPointsAgainst,
		HomeLastOff1stD,
		HomeLastOffTotYd,
		HomeLastOffPassYd,
		HomeLastOffRushYd,
		HomeLastOffTO,
		HomeLastDef1stD,
		HomeLastDefTotYd,
		HomeLastDefPassYd,
		HomeLastDefRushYd,
		HomeLastDefTO,
		HomeLastExPointsOff,
		HomeLastExPointsDef,
		HomeLastExPointsSpecial,
		AwayAvgPointsFor,
		AwayAvgPointsAgainst,
		AwayAvgOff1stD,
		AwayAvgOffTotYd,
		AwayAvgOffPassYd,
		AwayAvgOffRushYd,
		AwayAvgOffTO,
		AwayAvgDef1stD,
		AwayAvgDefTotYd,
		AwayAvgDefPassYd,
		AwayAvgDefRushYd,
		AwayAvgDefTO,
		AwayAvgExPointsOff,
		AwayAvgExPointsDef,
		AwayAvgExPointsSpecial,
		AwayLastPointsFor,
		AwayLastPointsAgainst,
		AwayLastOff1stD,
		AwayLastOffTotYd,
		AwayLastOffPassYd,
		AwayLastOffRushYd,
		AwayLastOffTO,
		AwayLastDef1stD,
		AwayLastDefTotYd,
		AwayLastDefPassYd,
		AwayLastDefRushYd,
		AwayLastDefTO,
		AwayLastExPointsOff,
		AwayLastExPointsDef,
		AwayLastExPointsSpecial,
		HomeOddsOpen,
		HomeOddsMin,
		HomeOddsMax,
		HomeOddsClose,
		HomeOddsCloseIP,
		HomeOddsCloseDevig,
		AwayOddsOpen,
		AwayOddsMin,
		AwayOddsMax,
		AwayOddsClose,
		AwayOddsCloseIP,
		AwayOddsCloseDevig,
		HomeLineOpen,
		HomeLineMin,
		HomeLineMax,
		HomeLineClose,
		AwayLineOpen,
		AwayLineMin,
		AwayLineMax,
		AwayLineClose,
		HomeLineOddsOpen,
		HomeLineOddsMin,
		HomeLineOddsMax,
		HomeLineOddsClose,
		HomeLineOddsCloseIP,
		HomeLineOddsCloseDevig,
		AwayLineOddsOpen,
		AwayLineOddsMin,
		AwayLineOddsMax,
		AwayLineOddsClose,
		AwayLineOddsCloseIP,
		AwayLineOddsCloseDevig,
		TotalScoreOpen,
		TotalScoreMin,
		TotalScoreMax,
		TotalScoreClose,
		TotalScoreOverOpen,
		TotalScoreOverMin,
		TotalScoreOverMax,
		TotalScoreOverClose,
		TotalScoreOverCloseIP,
		TotalScoreOverCloseDevig,
		TotalScoreUnderOpen,
		TotalScoreUnderMin,
		TotalScoreUnderMax,
		TotalScoreUnderClose,
		TotalScoreUnderCloseIP,
		TotalScoreUnderCloseDevig,
		HomeLineMovement,
		HomeLineOddsMovement,
		AwayLineMovement,
		AwayLineOddsMovement,
		TotalScoreMovement,
		TotalScoreOverMovement,
		ImpliedProbabilityOutrightPickHomeOddsThreshold,
		ImpliedProbabilityOutrightPickAwayOddsThreshold,
		ImpliedProbabilityOutrightPickFavoriteOddsThreshold,
		ImpliedProbabilityOutrightPickDogOddsThreshold,
		ImpliedProbabilitySpreadPickHomeOddsThreshold,
		ImpliedProbabilitySpreadPickAwayOddsThreshold,
		ImpliedProbabilitySpreadPickFavoriteOddsThreshold,
		ImpliedProbabilitySpreadPickDogOddsThreshold,
		ImpliedProbabilityTotalPickOverOddsThreshold,
		ImpliedProbabilityTotalPickUnderOddsThreshold)
Select 
	HomeTeam,
	AwayTeam,
	Week,
	Season,
	HomeScore,
	AwayScore,
	Result,
	HomeAvgPointsFor,
	HomeAvgPointsAgainst,
	HomeAvgOff1stD,
	HomeAvgOffTotYd,
	HomeAvgOffPassYd,
	HomeAvgOffRushYd,
	HomeAvgOffTO,
	HomeAvgDef1stD,
	HomeAvgDefTotYd,
	HomeAvgDefPassYd,
	HomeAvgDefRushYd,
	HomeAvgDefTO,
	HomeAvgExPointsOff,
	HomeAvgExPointsDef,
	HomeAvgExPointsSpecial,
	HomeLastPointsFor,
	HomeLastPointsAgainst,
	HomeLastOff1stD,
	HomeLastOffTotYd,
	HomeLastOffPassYd,
	HomeLastOffRushYd,
	HomeLastOffTO,
	HomeLastDef1stD,
	HomeLastDefTotYd,
	HomeLastDefPassYd,
	HomeLastDefRushYd,
	HomeLastDefTO,
	HomeLastExPointsOff,
	HomeLastExPointsDef,
	HomeLastExPointsSpecial,
	AwayAvgPointsFor,
	AwayAvgPointsAgainst,
	AwayAvgOff1stD,
	AwayAvgOffTotYd,
	AwayAvgOffPassYd,
	AwayAvgOffRushYd,
	AwayAvgOffTO,
	AwayAvgDef1stD,
	AwayAvgDefTotYd,
	AwayAvgDefPassYd,
	AwayAvgDefRushYd,
	AwayAvgDefTO,
	AwayAvgExPointsOff,
	AwayAvgExPointsDef,
	AwayAvgExPointsSpecial,
	AwayLastPointsFor,
	AwayLastPointsAgainst,
	AwayLastOff1stD,
	AwayLastOffTotYd,
	AwayLastOffPassYd,
	AwayLastOffRushYd,
	AwayLastOffTO,
	AwayLastDef1stD,
	AwayLastDefTotYd,
	AwayLastDefPassYd,
	AwayLastDefRushYd,
	AwayLastDefTO,
	AwayLastExPointsOff,
	AwayLastExPointsDef,
	AwayLastExPointsSpecial,
	HomeOddsOpen,
	HomeOddsMin,
	HomeOddsMax,
	HomeOddsClose,
	HomeOddsCloseIP,
	HomeOddsCloseDevig,
	AwayOddsOpen,
	AwayOddsMin,
	AwayOddsMax,
	AwayOddsClose,
	AwayOddsCloseIP,
	AwayOddsCloseDevig,
	HomeLineOpen,
	HomeLineMin,
	HomeLineMax,
	HomeLineClose,
	AwayLineOpen,
	AwayLineMin,
	AwayLineMax,
	AwayLineClose,
	HomeLineOddsOpen,
	HomeLineOddsMin,
	HomeLineOddsMax,
	HomeLineOddsClose,
	HomeLineOddsCloseIP,
	HomeLineOddsCloseDevig,
	AwayLineOddsOpen,
	AwayLineOddsMin,
	AwayLineOddsMax,
	AwayLineOddsClose,
	AwayLineOddsCloseIP,
	AwayLineOddsCloseDevig,
	TotalScoreOpen,
	TotalScoreMin,
	TotalScoreMax,
	TotalScoreClose,
	TotalScoreOverOpen,
	TotalScoreOverMin,
	TotalScoreOverMax,
	TotalScoreOverClose,
	TotalScoreOverCloseIP,
	TotalScoreOverCloseDevig,
	TotalScoreUnderOpen,
	TotalScoreUnderMin,
	TotalScoreUnderMax,
	TotalScoreUnderClose,
	TotalScoreUnderCloseIP,
	TotalScoreUnderCloseDevig,
	HomeLineMovement,
	HomeLineOddsMovement,
	AwayLineMovement,
	AwayLineOddsMovement,
	TotalScoreMovement,
	TotalScoreOverMovement,
	ImpliedProbabilityOutrightPickHomeOddsThreshold,
	ImpliedProbabilityOutrightPickAwayOddsThreshold,
	ImpliedProbabilityOutrightPickFavoriteOddsThreshold,
	ImpliedProbabilityOutrightPickDogOddsThreshold,
	ImpliedProbabilitySpreadPickHomeOddsThreshold,
	ImpliedProbabilitySpreadPickAwayOddsThreshold,
	ImpliedProbabilitySpreadPickFavoriteOddsThreshold,
	ImpliedProbabilitySpreadPickDogOddsThreshold,
	ImpliedProbabilityTotalPickOverOddsThreshold,
	ImpliedProbabilityTotalPickUnderOddsThreshold
from @GameDataTable

	/*Devig Logic*/
		--Team A IP / (Team A IP + Team B IP) where IP = Implied Probability
		--Get implied probability
		UPDATE @Output SET HomeOddsCloseIP = (1/COALESCE(HomeOddsClose,HomeOddsMax,HomeOddsOpen,HomeOddsMin))*100 
			WHERE COALESCE(HomeOddsClose,HomeOddsMax,HomeOddsOpen,HomeOddsMin) IS NOT NULL

		UPDATE @Output SET AwayOddsCloseIP = (1/COALESCE(AwayOddsClose,AwayOddsMax,AwayOddsOpen,AwayOddsMin))*100 
			WHERE COALESCE(AwayOddsClose,AwayOddsMax,AwayOddsOpen,AwayOddsMin) IS NOT NULL

		UPDATE @Output SET HomeLineOddsCloseIP = (1/COALESCE(HomeLineOddsClose,HomeLineOddsMax,HomeLineOddsOpen,HomeLineOddsMin))*100 
			WHERE COALESCE(HomeLineOddsClose,HomeLineOddsMax,HomeLineOddsOpen,HomeLineOddsMin) IS NOT NULL

		UPDATE @Output SET AwayLineOddsCloseIP = (1/COALESCE(AwayLineOddsClose,AwayLineOddsMax,AwayLineOddsOpen, AwayLineOddsMin))*100 
			WHERE COALESCE(AwayLineOddsClose,AwayLineOddsMax,AwayLineOddsOpen,AwayLineOddsMin) IS NOT NULL

		UPDATE @Output SET TotalScoreOverCloseIP = (1/COALESCE(TotalScoreOverClose,TotalScoreOverMax,TotalScoreOverOpen,TotalScoreOverMin))*100 
			WHERE COALESCE(TotalScoreOverClose,TotalScoreOverMax,TotalScoreOverOpen,TotalScoreOverMin) IS NOT NULL
	
		UPDATE @Output SET TotalScoreUnderCloseIP = (1/COALESCE(TotalScoreUnderClose,TotalScoreUnderMax,TotalScoreUnderOpen,TotalScoreUnderMin))*100 
			WHERE COALESCE(TotalScoreUnderClose,TotalScoreUnderMax,TotalScoreUnderOpen,TotalScoreUnderMin) IS NOT NULL

		--Convert back to decimal
		UPDATE @Output SET HomeOddsCloseDevig = 1/(HomeOddsCloseIP / ISNULL(NULLIF(HomeOddsCloseIP + AwayOddsCloseIP,0),1))
			WHERE HomeOddsCloseIP IS NOT NULL AND AwayOddsCloseIP IS NOT NULL

		UPDATE @Output SET AwayOddsCloseDevig = 1/(AwayOddsCloseIP / ISNULL(NULLIF(AwayOddsCloseIP + HomeOddsCloseIP,0),1))
			WHERE HomeOddsCloseIP IS NOT NULL AND AwayOddsCloseIP IS NOT NULL

		UPDATE @Output SET HomeLineOddsCloseDevig = 1/(HomeLineOddsCloseIP / ISNULL(NULLIF(AwayLineOddsCloseIP + HomeLineOddsCloseIP,0),1))
			WHERE HomeLineOddsCloseIP IS NOT NULL AND AwayLineOddsCloseIP IS NOT NULL

		UPDATE @Output SET AwayLineOddsCloseDevig = 1/(AwayLineOddsCloseIP / ISNULL(NULLIF(AwayLineOddsCloseIP + HomeLineOddsCloseIP,0),1))
			WHERE HomeLineOddsCloseIP IS NOT NULL AND AwayLineOddsCloseIP IS NOT NULL

		UPDATE @Output SET TotalScoreOverCloseDevig = 1/(TotalScoreOverCloseIP / ISNULL(NULLIF(TotalScoreUnderCloseIP + TotalScoreOverCloseIP,0),1))
			WHERE TotalScoreUnderCloseIP IS NOT NULL AND TotalScoreOverCloseIP IS NOT NULL
		
		UPDATE @Output SET TotalScoreUnderCloseDevig = 1/(TotalScoreUnderCloseIP / ISNULL(NULLIF(TotalScoreUnderCloseIP + TotalScoreOverCloseIP,0),1))
			WHERE TotalScoreUnderCloseIP IS NOT NULL AND TotalScoreOverCloseIP IS NOT NULL

		/*Make picks*/
		UPDATE @Output SET ImpliedProbabilityOutrightPickHomeAway = 'Home'
		WHERE  HomeOddsCloseDevig > ImpliedProbabilityOutrightPickHomeOddsThreshold			   
			   AND AwayOddsCloseDevig < ImpliedProbabilityOutrightPickAwayOddsThreshold
			   

		UPDATE @Output SET ImpliedProbabilityOutrightPickHomeAway = 'Away'
		WHERE  HomeOddsCloseDevig < ImpliedProbabilityOutrightPickHomeOddsThreshold
			   AND AwayOddsCloseDevig > ImpliedProbabilityOutrightPickAwayOddsThreshold
			   

		UPDATE @Output SET ImpliedProbabilityOutrightPickHomeAway = CASE WHEN HomeOddsCloseDevig > AwayOddsCloseDevig THEN 'Home' 
																				   WHEN  HomeOddsCloseDevig < AwayOddsCloseDevig THEN 'Away' 
																				   END
		WHERE  HomeOddsCloseDevig > ImpliedProbabilityOutrightPickHomeOddsThreshold 
		       AND AwayOddsCloseDevig > ImpliedProbabilityOutrightPickAwayOddsThreshold
			   

		UPDATE @Output SET ImpliedProbabilityOutrightPickFavDog = 'Fav'
		WHERE CASE WHEN HomeOddsCloseDevig < AwayOddsCloseDevig THEN HomeOddsCloseDevig 
				   WHEN AwayOddsCloseDevig < HomeOddsCloseDevig THEN AwayOddsCloseDevig
			  END > ImpliedProbabilityOutrightPickFavoriteOddsThreshold
		AND	  CASE WHEN HomeOddsCloseDevig > AwayOddsCloseDevig THEN HomeOddsCloseDevig 
				   WHEN AwayOddsCloseDevig > HomeOddsCloseDevig THEN AwayOddsCloseDevig
			  END < ImpliedProbabilityOutrightPickDogOddsThreshold
		 

		UPDATE @Output SET ImpliedProbabilityOutrightPickFavDog = 'Dog'
		WHERE CASE WHEN HomeOddsCloseDevig > AwayOddsCloseDevig THEN HomeOddsCloseDevig 
				   WHEN AwayOddsCloseDevig > HomeOddsCloseDevig THEN AwayOddsCloseDevig
			  END > ImpliedProbabilityOutrightPickDogOddsThreshold
		AND   CASE WHEN HomeOddsCloseDevig < AwayOddsCloseDevig THEN HomeOddsCloseDevig 
				   WHEN AwayOddsCloseDevig < HomeOddsCloseDevig THEN AwayOddsCloseDevig
			  END < ImpliedProbabilityOutrightPickFavoriteOddsThreshold
		 
																					
		UPDATE @Output SET ImpliedProbabilityOutrightPick = CASE WHEN ImpliedProbabilityOutrightPickFavDog = 'Fav' AND ImpliedProbabilityOutrightPickHomeAway = 'Home' AND ISNULL(HomeOddsCloseDevig,0) < ISNULL(AwayOddsCloseDevig,0) THEN 'Home' --Pick home if in agreement
																		   WHEN ImpliedProbabilityOutrightPickFavDog = 'Dog' AND ImpliedProbabilityOutrightPickHomeAway = 'Home' AND ISNULL(HomeOddsCloseDevig,0) > ISNULL(AwayOddsCloseDevig,0) THEN 'Home' --Pick home if in agreement
																		   WHEN ImpliedProbabilityOutrightPickFavDog = 'Fav' AND ImpliedProbabilityOutrightPickHomeAway = 'Away' AND ISNULL(HomeOddsCloseDevig,0) > ISNULL(AwayOddsCloseDevig,0) THEN 'Away' --Pick away if in agreement
																		   WHEN ImpliedProbabilityOutrightPickFavDog = 'Dog' AND ImpliedProbabilityOutrightPickHomeAway = 'Away' AND ISNULL(HomeOddsCloseDevig,0) < ISNULL(AwayOddsCloseDevig,0) THEN 'Away' --Pick away if in agreement
																		   WHEN ImpliedProbabilityOutrightPickFavDog = 'Fav' AND ImpliedProbabilityOutrightPickHomeAway = 'Home' AND ISNULL(HomeOddsCloseDevig,0) < ISNULL(AwayOddsCloseDevig,0) THEN 'Home' --Default to Fav in case of disagreement if Fav is the pick from FavDog and HomeAway picks Home
																		   WHEN ImpliedProbabilityOutrightPickFavDog = 'Dog' AND ImpliedProbabilityOutrightPickHomeAway = 'Away' AND ISNULL(HomeOddsCloseDevig,0) > ISNULL(AwayOddsCloseDevig,0) THEN 'Away' --Default to Dog in case of disagreement if Dog is the pick from FavDog and HomeAway picks Away
																		   WHEN ImpliedProbabilityOutrightPickFavDog = 'Fav' AND ImpliedProbabilityOutrightPickHomeAway = 'Home' AND ISNULL(HomeOddsCloseDevig,0) > ISNULL(AwayOddsCloseDevig,0) THEN 'Home' 
																		   WHEN ImpliedProbabilityOutrightPickFavDog = 'Dog' AND ImpliedProbabilityOutrightPickHomeAway = 'Home' AND ISNULL(HomeOddsCloseDevig,0) < ISNULL(AwayOddsCloseDevig,0) THEN 'Home' 
																		   WHEN ImpliedProbabilityOutrightPickFavDog = 'Fav' AND ImpliedP6robabilityOutrightPickHomeAway = 'Away' AND ISNULL(HomeOddsCloseDevig,0) < ISNULL(AwayOddsCloseDevig,0) THEN 'Away' 
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
		WHERE COALESCE(ImpliedProbabilityOutrightPickFavDog, ImpliedProbabilityOutrightPickHomeAway) IS NOT NULL

		--Spread Picks
		UPDATE @Output SET ImpliedProbabilitySpreadPickFavDog = 'Fav'
		WHERE CASE WHEN COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) < COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) THEN HomeLineOddsCloseDevig 
				   WHEN COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) < COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) THEN AwayLineOddsCloseDevig
			  END > ImpliedProbabilitySpreadPickFavoriteOddsThreshold

		UPDATE @Output SET ImpliedProbabilitySpreadPickFavDog = 'Dog'
		WHERE CASE WHEN COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) > COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) THEN HomeLineOddsCloseDevig 
				   WHEN COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) > COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) THEN AwayLineOddsCloseDevig
			  END > ImpliedProbabilitySpreadPickDogOddsThreshold
		AND ImpliedProbabilitySpreadPickFavDog IS NULL

		UPDATE @Output SET ImpliedProbabilitySpreadPickHomeAway = 'Home'
		WHERE (HomeLineOddsCloseDevig > ImpliedProbabilitySpreadPickHomeOddsThreshold)

		UPDATE @Output SET ImpliedProbabilitySpreadPickHomeAway = 'Away'
		WHERE (AwayLineOddsCloseDevig > ImpliedProbabilitySpreadPickAwayOddsThreshold)
		AND ImpliedProbabilitySpreadPickHomeAway IS NULL

		UPDATE @Output SET ImpliedProbabilitySpreadPick =   CASE WHEN ImpliedProbabilitySpreadPickFavDog = 'Fav' AND ImpliedProbabilitySpreadPickHomeAway = 'Home' AND HomeLineOddsCloseDevig < AwayLineOddsCloseDevig THEN 'Home' --Pick home if in agreement
																		   WHEN ImpliedProbabilitySpreadPickFavDog = 'Dog' AND ImpliedProbabilitySpreadPickHomeAway = 'Home' AND HomeLineOddsCloseDevig > AwayLineOddsCloseDevig THEN 'Home' --Pick home if in agreement
																		   WHEN ImpliedProbabilitySpreadPickFavDog = 'Dog' AND ImpliedProbabilitySpreadPickHomeAway = 'Away' AND HomeLineOddsCloseDevig < AwayLineOddsCloseDevig THEN 'Away' --Pick away if in agreement
																		   WHEN ImpliedProbabilitySpreadPickFavDog = 'Fav' AND ImpliedProbabilitySpreadPickHomeAway = 'Away' AND HomeLineOddsCloseDevig > AwayLineOddsCloseDevig THEN 'Away' --Pick away if in agreement
																		   WHEN ImpliedProbabilitySpreadPickFavDog = 'Fav' AND ImpliedProbabilitySpreadPickHomeAway = 'Home' AND HomeLineOddsCloseDevig > AwayLineOddsCloseDevig THEN 'Away' --Default to Fav in case of disagreement if Fav is the pick from FavDog and HomeAway picks Home
																		   WHEN ImpliedProbabilitySpreadPickFavDog = 'Dog' AND ImpliedProbabilitySpreadPickHomeAway = 'Away' AND HomeLineOddsCloseDevig > AwayLineOddsCloseDevig THEN 'Home' --Default to Dog in case of disagreement if Dog is the pick from FavDog and HomeAway picks Away
																		   END
		--O/U Picks
		--UPDATE @Output SET ImpliedProbabilityTotalPick = 'Over'
		--WHERE TotalScoreOverCloseDevig > ImpliedProbabilityTotalPickOverOddsThreshold
		--AND (TotalScoreUnderCloseDevig - ImpliedProbabilityTotalPickUnderOddsThreshold) < (TotalScoreOverCloseDevig - ImpliedProbabilityTotalPickOverOddsThreshold) --pick greater difference
		-- 
		--
		--UPDATE @Output SET ImpliedProbabilityTotalPick = 'Under'
		--WHERE TotalScoreUnderCloseDevig > ImpliedProbabilityTotalPickUnderOddsThreshold
		--AND ((TotalScoreUnderCloseDevig - ImpliedProbabilityTotalPickUnderOddsThreshold) > (TotalScoreOverCloseDevig - ImpliedProbabilityTotalPickOverOddsThreshold)
		--OR (TotalScoreUnderCloseDevig - ImpliedProbabilityTotalPickUnderOddsThreshold) = (TotalScoreOverCloseDevig - ImpliedProbabilityTotalPickOverOddsThreshold)) --Pick greater difference or Under if equal difference
		-- 

		UPDATE @Output SET ImpliedProbabilityTotalPick = 'Over'
		WHERE COALESCE(TotalScoreClose,TotalScoreMax,TotalScoreOpen) < (ISNULL(HomeAvgPointsAgainst,0) + ISNULL(HomeAvgPointsFor,0) + ISNULL(AwayAvgPointsFor,0) + ISNULL(AwayAvgPointsAgainst,0))/4


		UPDATE @Output SET ImpliedProbabilityTotalPick = 'Under'
		WHERE COALESCE(TotalScoreClose,TotalScoreMax,TotalScoreOpen) >  (ISNULL(HomeAvgPointsAgainst,0) + ISNULL(HomeAvgPointsFor,0) + ISNULL(AwayAvgPointsFor,0) + ISNULL(AwayAvgPointsAgainst,0))/4


		/*Check accuracy*/
		--Outright
		UPDATE @Output SET ImpliedProbabilityOutrightPickHACorrect = 'Y' WHERE ((ImpliedProbabilityOutrightPickHomeAway = 'Home' and HomeScore > AwayScore) OR (ImpliedProbabilityOutrightPickHomeAway = 'Away' AND AwayScore > HomeScore))  
		UPDATE @Output SET ImpliedProbabilityOutrightPickHACorrect = 'N' WHERE ((ImpliedProbabilityOutrightPickHomeAway = 'Home' and HomeScore < AwayScore) OR (ImpliedProbabilityOutrightPickHomeAway = 'Away' AND AwayScore < HomeScore))  
		UPDATE @Output SET ImpliedProbabilityOutrightPickFDCorrect = 'Y' WHERE ((ImpliedProbabilityOutrightPickFavDog = 'Fav' and COALESCE(HomeOddsClose,HomeOddsMax,HomeOddsOpen) < COALESCE(AwayOddsClose,AwayOddsMax,AwayOddsOpen) and HomeScore > AwayScore) 
																					   OR (ImpliedProbabilityOutrightPickFavDog = 'Dog' and COALESCE(HomeOddsClose,HomeOddsMax,HomeOddsOpen) > COALESCE(AwayOddsClose,AwayOddsMax,AwayOddsOpen) and HomeScore > AwayScore) 
																					   OR (ImpliedProbabilityOutrightPickFavDog = 'Fav' and COALESCE(HomeOddsClose,HomeOddsMax,HomeOddsOpen) > COALESCE(AwayOddsClose,AwayOddsMax,AwayOddsOpen) and HomeScore < AwayScore) 
																					   OR (ImpliedProbabilityOutrightPickFavDog = 'Dog' and COALESCE(HomeOddsClose,HomeOddsMax,HomeOddsOpen) < COALESCE(AwayOddsClose,AwayOddsMax,AwayOddsOpen) and HomeScore < AwayScore)) 
																		

		UPDATE @Output SET ImpliedProbabilityOutrightPickFDCorrect = 'N' WHERE ((ImpliedProbabilityOutrightPickFavDog = 'Fav' and COALESCE(HomeOddsClose,HomeOddsMax,HomeOddsOpen) < COALESCE(AwayOddsClose,AwayOddsMax,AwayOddsOpen) and HomeScore < AwayScore) 
																					   OR (ImpliedProbabilityOutrightPickFavDog = 'Dog' and COALESCE(HomeOddsClose,HomeOddsMax,HomeOddsOpen) > COALESCE(AwayOddsClose,AwayOddsMax,AwayOddsOpen) and HomeScore < AwayScore) 
																					   OR (ImpliedProbabilityOutrightPickFavDog = 'Fav' and COALESCE(HomeOddsClose,HomeOddsMax,HomeOddsOpen) > COALESCE(AwayOddsClose,AwayOddsMax,AwayOddsOpen) and HomeScore > AwayScore) 
																					   OR (ImpliedProbabilityOutrightPickFavDog = 'Dog' and COALESCE(HomeOddsClose,HomeOddsMax,HomeOddsOpen) < COALESCE(AwayOddsClose,AwayOddsMax,AwayOddsOpen) and HomeScore > AwayScore)) 
																	

		UPDATE @Output SET ImpliedProbabilityOutrightPickHACorrect = 'P' WHERE ImpliedProbabilityOutrightPickHomeAway IS NOT NULL AND HomeScore = AwayScore  
		UPDATE @Output SET ImpliedProbabilityOutrightPickFDCorrect = 'P' WHERE ImpliedProbabilityOutrightPickFavDog IS NOT NULL  AND HomeScore = AwayScore  

		UPDATE @Output SET ImpliedProbabilityOutrightPickCorrect = 'Y' WHERE ImpliedProbabilityOutrightPick = 'Home' AND HomeScore > AwayScore  
		UPDATE @Output SET ImpliedProbabilityOutrightPickCorrect = 'Y' WHERE ImpliedProbabilityOutrightPick = 'Away' AND HomeScore < AwayScore  
		UPDATE @Output SET ImpliedProbabilityOutrightPickCorrect = 'N' WHERE ImpliedProbabilityOutrightPick = 'Home' AND HomeScore < AwayScore  
		UPDATE @Output SET ImpliedProbabilityOutrightPickCorrect = 'N' WHERE ImpliedProbabilityOutrightPick = 'Away' AND HomeScore > AwayScore  
		UPDATE @Output SET ImpliedProbabilityOutrightPickCorrect = 'P' WHERE ImpliedProbabilityOutrightPick IS NOT NULL AND HomeScore = AwayScore  

		--Spread
		UPDATE @Output SET ImpliedProbabilitySpreadPickHACorrect = 'Y' WHERE  ImpliedProbabilitySpreadPickHomeAway = 'Home' AND HomeScore + COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) > AwayScore  
		UPDATE @Output SET ImpliedProbabilitySpreadPickHACorrect = 'P' WHERE  ImpliedProbabilitySpreadPickHomeAway = 'Home' AND HomeScore + COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) = AwayScore  
		UPDATE @Output SET ImpliedProbabilitySpreadPickHACorrect = 'N' WHERE  ImpliedProbabilitySpreadPickHomeAway = 'Home' AND HomeScore + COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) < AwayScore  
		UPDATE @Output SET ImpliedProbabilitySpreadPickHACorrect = 'Y' WHERE  ImpliedProbabilitySpreadPickHomeAway = 'Away' AND AwayScore + COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) > HomeScore  
		UPDATE @Output SET ImpliedProbabilitySpreadPickHACorrect = 'P' WHERE  ImpliedProbabilitySpreadPickHomeAway = 'Away' AND AwayScore + COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) = HomeScore  
		UPDATE @Output SET ImpliedProbabilitySpreadPickHACorrect = 'N' WHERE  ImpliedProbabilitySpreadPickHomeAway = 'Away' AND AwayScore + COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) < HomeScore  
		UPDATE @Output SET ImpliedProbabilitySpreadPickFDCorrect = 'Y' WHERE  ImpliedProbabilitySpreadPickFavDog = 'Fav' AND CASE WHEN COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) < COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) THEN HomeScore + COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) WHEN COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) < COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) THEN AwayScore + COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) END > CASE WHEN COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) < COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) THEN AwayScore WHEN COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) < COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) THEN HomeScore END  
		UPDATE @Output SET ImpliedProbabilitySpreadPickFDCorrect = 'P' WHERE  ImpliedProbabilitySpreadPickFavDog = 'Fav' AND CASE WHEN COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) < COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) THEN HomeScore + COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) WHEN COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) < COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) THEN AwayScore + COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) END = CASE WHEN COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) < COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) THEN AwayScore WHEN COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) < COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) THEN HomeScore END  
		UPDATE @Output SET ImpliedProbabilitySpreadPickFDCorrect = 'N' WHERE  ImpliedProbabilitySpreadPickFavDog = 'Fav' AND CASE WHEN COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) < COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) THEN HomeScore + COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) WHEN COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) < COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) THEN AwayScore + COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) END < CASE WHEN COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) < COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) THEN AwayScore WHEN COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) < COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) THEN HomeScore END  
		UPDATE @Output SET ImpliedProbabilitySpreadPickFDCorrect = 'Y' WHERE  ImpliedProbabilitySpreadPickFavDog = 'Dog' AND CASE WHEN COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) < COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) THEN AwayScore + COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) WHEN COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) < COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) THEN HomeScore + COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) END > CASE WHEN COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) > COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) THEN HomeScore WHEN COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) > COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) THEN AwayScore END  
		UPDATE @Output SET ImpliedProbabilitySpreadPickFDCorrect = 'P' WHERE  ImpliedProbabilitySpreadPickFavDog = 'Dog' AND CASE WHEN COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) < COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) THEN AwayScore + COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) WHEN COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) < COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) THEN HomeScore + COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) END = CASE WHEN COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) > COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) THEN HomeScore WHEN COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) > COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) THEN AwayScore END  
		UPDATE @Output SET ImpliedProbabilitySpreadPickFDCorrect = 'N' WHERE  ImpliedProbabilitySpreadPickFavDog = 'Dog' AND CASE WHEN COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) < COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) THEN AwayScore + COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) WHEN COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) < COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) THEN HomeScore + COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) END < CASE WHEN COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) > COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) THEN HomeScore WHEN COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) > COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) THEN AwayScore END  
		UPDATE @Output SET ImpliedProbabilitySpreadPickCorrect = 'Y' WHERE ((ImpliedProbabilitySpreadPick = 'Home' AND COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) + HomeScore > AwayScore) OR (ImpliedProbabilitySpreadPick = 'Away' AND COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) + AwayScore > HomeScore))  
		UPDATE @Output SET ImpliedProbabilitySpreadPickCorrect = 'P' WHERE ((ImpliedProbabilitySpreadPick = 'Home' AND COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) + HomeScore = AwayScore) OR (ImpliedProbabilitySpreadPick = 'Away' AND COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) + AwayScore = HomeScore))  
		UPDATE @Output SET ImpliedProbabilitySpreadPickCorrect = 'N' WHERE ((ImpliedProbabilitySpreadPick = 'Home' AND COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen) + HomeScore < AwayScore) OR (ImpliedProbabilitySpreadPick = 'Away' AND COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen) + AwayScore < HomeScore))  

		--Total
		UPDATE @Output SET ImpliedProbabilityTotalPickCorrect = 'Y' WHERE ImpliedProbabilityTotalPick = 'Over' AND HomeScore + AwayScore > COALESCE(TotalScoreClose,TotalScoreMax,TotalScoreOpen)  
		UPDATE @Output SET ImpliedProbabilityTotalPickCorrect = 'Y' WHERE ImpliedProbabilityTotalPick = 'Under' AND HomeScore + AwayScore < COALESCE(TotalScoreClose,TotalScoreMax,TotalScoreOpen)  
		UPDATE @Output SET ImpliedProbabilityTotalPickCorrect = 'P' WHERE ImpliedProbabilityTotalPick IS NOT NULL AND (HomeScore + AwayScore = COALESCE(TotalScoreClose,TotalScoreOpen))  
		UPDATE @Output SET ImpliedProbabilityTotalPickCorrect = 'N' WHERE (ImpliedProbabilityTotalPick = 'Under' AND HomeScore + AwayScore > COALESCE(TotalScoreClose,TotalScoreMax,TotalScoreOpen)) OR (ImpliedProbabilityTotalPick = 'Over' AND HomeScore + AwayScore < COALESCE(TotalScoreClose,TotalScoreMax,TotalScoreOpen))  


		
		--Set wager for each bet
		UPDATE @Output SET OneUnitThreshold = 0 WHERE OneUnitThreshold IS NULL
		UPDATE @Output SET FiveUnitThreshold = 0 WHERE FiveUnitThreshold IS NULL
		UPDATE @Output SET TenUnitThreshold = 0 WHERE TenUnitThreshold IS NULL

		UPDATE @Output SET ImpliedProbabilityOutrightPickWager = CASE WHEN 
																					(
																						(ISNULL(ISNULL(HomeOddsCloseDevig,0),0) < ISNULL(AwayOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(HomeOddsCloseDevig,0) - ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(HomeOddsCloseDevig,0) * OneUnitThreshold as DECIMAL(5,2))) 
																					AND (ISNULL(HomeOddsCloseDevig,0) < ISNULL(AwayOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(HomeOddsCloseDevig,0) - ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2))) < CAST(ISNULL(HomeOddsCloseDevig,0) * FiveUnitThreshold as DECIMAL(5,2))
																					)
																				OR (
																						(ISNULL(AwayOddsCloseDevig,0) < ISNULL(HomeOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(AwayOddsCloseDevig,0) - ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(AwayOddsCloseDevig,0) * OneUnitThreshold as DECIMAL(5,2))) 
																					AND (ISNULL(AwayOddsCloseDevig,0) < ISNULL(HomeOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(AwayOddsCloseDevig,0) - ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2))) < CAST(ISNULL(AwayOddsCloseDevig,0) * FiveUnitThreshold as DECIMAL(5,2))
																					)
																				THEN 1
																				WHEN 
																					(
																						(ISNULL(HomeOddsCloseDevig,0) < ISNULL(AwayOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(HomeOddsCloseDevig,0) - ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(HomeOddsCloseDevig,0) * FiveUnitThreshold  as DECIMAL(5,2)))
																					AND (ISNULL(HomeOddsCloseDevig,0) < ISNULL(AwayOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(HomeOddsCloseDevig,0) - ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) < CAST(ISNULL(HomeOddsCloseDevig,0) * TenUnitThreshold  as DECIMAL(5,2)))
																					)
																				OR (
																						(ISNULL(AwayOddsCloseDevig,0) < ISNULL(HomeOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(AwayOddsCloseDevig,0) - ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(AwayOddsCloseDevig,0) * FiveUnitThreshold  as DECIMAL(5,2)))
																					AND (ISNULL(AwayOddsCloseDevig,0) < ISNULL(HomeOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(AwayOddsCloseDevig,0) - ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) < CAST(ISNULL(AwayOddsCloseDevig,0) * TenUnitThreshold  as DECIMAL(5,2)))
																					)
																				THEN 5
																				WHEN 
																					(
																						(ISNULL(HomeOddsCloseDevig,0) < ISNULL(AwayOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(HomeOddsCloseDevig,0) - ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(HomeOddsCloseDevig,0) * TenUnitThreshold  as DECIMAL(5,2)))
																					)
																				OR (
																						(ISNULL(AwayOddsCloseDevig,0) < ISNULL(HomeOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(AwayOddsCloseDevig,0) - ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(AwayOddsCloseDevig,0) * TenUnitThreshold  as DECIMAL(5,2)))
																					)
																				THEN 10
																				ELSE 0
																				END
		WHERE ImpliedProbabilityOutrightPick IS NOT NULL																		
																					
		UPDATE @Output SET ImpliedProbabilityOutrightPickHomeAwayWager = CASE WHEN 
																					(
																						ImpliedProbabilityOutrightPickHomeAway = 'Home'
																					AND (ISNULL(HomeOddsCloseDevig,0) < ISNULL(AwayOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(HomeOddsCloseDevig,0) - ImpliedProbabilityOutrightPickHomeOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(HomeOddsCloseDevig,0) * OneUnitThreshold as DECIMAL(5,2))) 
																					AND (ISNULL(HomeOddsCloseDevig,0) < ISNULL(AwayOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(HomeOddsCloseDevig,0) - ImpliedProbabilityOutrightPickHomeOddsThreshold as DECIMAL(5,2)) < CAST(ISNULL(HomeOddsCloseDevig,0) * FiveUnitThreshold as DECIMAL(5,2)))
																					)
																				OR (
																						ImpliedProbabilityOutrightPickHomeAway = 'Away'
																					AND (ISNULL(AwayOddsCloseDevig,0) < ISNULL(HomeOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(AwayOddsCloseDevig,0) - ImpliedProbabilityOutrightPickAwayOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(AwayOddsCloseDevig,0) * OneUnitThreshold as DECIMAL(5,2))) 
																					AND (ISNULL(AwayOddsCloseDevig,0) < ISNULL(HomeOddsCloseDevig,0))
																					AND (CAST(ISNULL(AwayOddsCloseDevig,0) - ImpliedProbabilityOutrightPickAwayOddsThreshold as DECIMAL(5,2)) < CAST(ISNULL(AwayOddsCloseDevig,0) * FiveUnitThreshold as DECIMAL(5,2)))
																					)
																				THEN 1
																				WHEN 
																					(
																						ImpliedProbabilityOutrightPickHomeAway = 'Home'
																					AND (ISNULL(HomeOddsCloseDevig,0) < ISNULL(AwayOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(HomeOddsCloseDevig,0) - ImpliedProbabilityOutrightPickHomeOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(HomeOddsCloseDevig,0) * FiveUnitThreshold  as DECIMAL(5,2)))
																					AND (ISNULL(HomeOddsCloseDevig,0) < ISNULL(AwayOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(HomeOddsCloseDevig,0) - ImpliedProbabilityOutrightPickHomeOddsThreshold as DECIMAL(5,2)) < CAST(ISNULL(HomeOddsCloseDevig,0) * TenUnitThreshold  as DECIMAL(5,2)))
																					)
																				OR (
																						ImpliedProbabilityOutrightPickHomeAway = 'Away'
																					AND (ISNULL(AwayOddsCloseDevig,0) < ISNULL(HomeOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(AwayOddsCloseDevig,0) - ImpliedProbabilityOutrightPickAwayOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(AwayOddsCloseDevig,0) * FiveUnitThreshold  as DECIMAL(5,2)))
																					AND (ISNULL(AwayOddsCloseDevig,0) < ISNULL(HomeOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(AwayOddsCloseDevig,0) - ImpliedProbabilityOutrightPickAwayOddsThreshold as DECIMAL(5,2)) < CAST(ISNULL(AwayOddsCloseDevig,0) * TenUnitThreshold  as DECIMAL(5,2)))
																					)
																				THEN 5
																				WHEN 
																					(
																						ImpliedProbabilityOutrightPickHomeAway = 'Home'
																					AND (ISNULL(HomeOddsCloseDevig,0) < ISNULL(AwayOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(HomeOddsCloseDevig,0) - ImpliedProbabilityOutrightPickHomeOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(HomeOddsCloseDevig,0) * TenUnitThreshold  as DECIMAL(5,2)))
																					)
																				OR (
																						ImpliedProbabilityOutrightPickHomeAway = 'Away'
																					AND (ISNULL(AwayOddsCloseDevig,0) < ISNULL(HomeOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(AwayOddsCloseDevig,0) - ImpliedProbabilityOutrightPickAwayOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(AwayOddsCloseDevig,0) * TenUnitThreshold  as DECIMAL(5,2)))
																					)
																				THEN 10
																				ELSE 0
																				END
		WHERE ImpliedProbabilityOutrightPickHomeAway IS NOT NULL

		UPDATE @Output SET ImpliedProbabilityOutrightPickFavDogWager = CASE WHEN 
																					(
																						ImpliedProbabilityOutrightPickFavDog = 'Fav'
																					And (ISNULL(HomeOddsCloseDevig,0) < ISNULL(AwayOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(HomeOddsCloseDevig,0) - ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(HomeOddsCloseDevig,0) * OneUnitThreshold as DECIMAL(5,2))) 
																					AND (ISNULL(HomeOddsCloseDevig,0) < ISNULL(AwayOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(HomeOddsCloseDevig,0) - ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) < CAST(ISNULL(HomeOddsCloseDevig,0) * FiveUnitThreshold as DECIMAL(5,2)))
																					)
																				OR (
																						ImpliedProbabilityOutrightPickFavDog = 'Fav'
																					AND (ISNULL(AwayOddsCloseDevig,0) < ISNULL(HomeOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(AwayOddsCloseDevig,0) - ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(AwayOddsCloseDevig,0) * OneUnitThreshold as DECIMAL(5,2))) 
																					AND (ISNULL(AwayOddsCloseDevig,0) < ISNULL(HomeOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(AwayOddsCloseDevig,0) - ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) < CAST(ISNULL(AwayOddsCloseDevig,0) * FiveUnitThreshold as DECIMAL(5,2)))
																					)
																				OR (
																						ImpliedProbabilityOutrightPickFavDog = 'Dog'
																					And (ISNULL(HomeOddsCloseDevig,0) < ISNULL(AwayOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(HomeOddsCloseDevig,0) - ImpliedProbabilityOutrightPickDogOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(HomeOddsCloseDevig,0) * OneUnitThreshold as DECIMAL(5,2))) 
																					AND (ISNULL(HomeOddsCloseDevig,0) < ISNULL(AwayOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(HomeOddsCloseDevig,0) - ImpliedProbabilityOutrightPickDogOddsThreshold as DECIMAL(5,2)) < CAST(ISNULL(HomeOddsCloseDevig,0) * FiveUnitThreshold as DECIMAL(5,2)))
																					)
																				OR (
																						ImpliedProbabilityOutrightPickFavDog = 'Dog'
																					AND (ISNULL(AwayOddsCloseDevig,0) < ISNULL(HomeOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(AwayOddsCloseDevig,0) - ImpliedProbabilityOutrightPickDogOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(AwayOddsCloseDevig,0) * OneUnitThreshold as DECIMAL(5,2))) 
																					AND (ISNULL(AwayOddsCloseDevig,0) < ISNULL(HomeOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(AwayOddsCloseDevig,0) - ImpliedProbabilityOutrightPickDogOddsThreshold as DECIMAL(5,2)) < CAST(ISNULL(AwayOddsCloseDevig,0) * FiveUnitThreshold as DECIMAL(5,2)))
																					)
																				THEN 1
																				WHEN 
																					(
																						ImpliedProbabilityOutrightPickFavDog = 'Fav'
																					AND (ISNULL(HomeOddsCloseDevig,0) < ISNULL(AwayOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(HomeOddsCloseDevig,0) - ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(HomeOddsCloseDevig,0) * FiveUnitThreshold  as DECIMAL(5,2)))
																					AND (ISNULL(HomeOddsCloseDevig,0) < ISNULL(AwayOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(HomeOddsCloseDevig,0) - ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) < CAST(ISNULL(HomeOddsCloseDevig,0) * TenUnitThreshold  as DECIMAL(5,2)))
																					)
																				OR (
																						ImpliedProbabilityOutrightPickFavDog = 'Fav'
																					AND (ISNULL(AwayOddsCloseDevig,0) < ISNULL(HomeOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(AwayOddsCloseDevig,0) - ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(AwayOddsCloseDevig,0) * FiveUnitThreshold  as DECIMAL(5,2)))
																					AND (ISNULL(AwayOddsCloseDevig,0) < ISNULL(HomeOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(AwayOddsCloseDevig,0) - ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) < CAST(ISNULL(AwayOddsCloseDevig,0) * TenUnitThreshold  as DECIMAL(5,2)))
																					)
																				OR (
																						ImpliedProbabilityOutrightPickFavDog = 'Dog'
																					AND (ISNULL(HomeOddsCloseDevig,0) < ISNULL(AwayOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(HomeOddsCloseDevig,0) - ImpliedProbabilityOutrightPickDogOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(HomeOddsCloseDevig,0) * FiveUnitThreshold  as DECIMAL(5,2)))
																					AND (ISNULL(HomeOddsCloseDevig,0) < ISNULL(AwayOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(HomeOddsCloseDevig,0) - ImpliedProbabilityOutrightPickDogOddsThreshold as DECIMAL(5,2)) < CAST(ISNULL(HomeOddsCloseDevig,0) * TenUnitThreshold  as DECIMAL(5,2)))
																					)
																				OR (
																						ImpliedProbabilityOutrightPickFavDog = 'Dog'
																					AND (ISNULL(AwayOddsCloseDevig,0) < ISNULL(HomeOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(AwayOddsCloseDevig,0) - ImpliedProbabilityOutrightPickDogOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(AwayOddsCloseDevig,0) * FiveUnitThreshold  as DECIMAL(5,2)))
																					AND (ISNULL(AwayOddsCloseDevig,0) < ISNULL(HomeOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(AwayOddsCloseDevig,0) - ImpliedProbabilityOutrightPickDogOddsThreshold as DECIMAL(5,2)) < CAST(ISNULL(AwayOddsCloseDevig,0) * TenUnitThreshold  as DECIMAL(5,2)))
																					)
																				THEN 5
																				WHEN 
																					(
																						ImpliedProbabilityOutrightPickFavDog = 'Fav'
																					AND (ISNULL(HomeOddsCloseDevig,0) < ISNULL(AwayOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(HomeOddsCloseDevig,0) - ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(HomeOddsCloseDevig,0) * TenUnitThreshold  as DECIMAL(5,2)))
																					)
																				OR (
																						ImpliedProbabilityOutrightPickFavDog = 'Fav'
																					AND (ISNULL(AwayOddsCloseDevig,0) < ISNULL(HomeOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(AwayOddsCloseDevig,0) - ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(AwayOddsCloseDevig,0) * TenUnitThreshold  as DECIMAL(5,2)))
																					)
																				OR (
																						ImpliedProbabilityOutrightPickFavDog = 'Dog'
																					AND (ISNULL(HomeOddsCloseDevig,0) < ISNULL(AwayOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(HomeOddsCloseDevig,0) - ImpliedProbabilityOutrightPickDogOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(HomeOddsCloseDevig,0) * TenUnitThreshold  as DECIMAL(5,2)))
																					)
																				OR (
																						ImpliedProbabilityOutrightPickFavDog = 'Dog'
																					AND (ISNULL(AwayOddsCloseDevig,0) < ISNULL(HomeOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(AwayOddsCloseDevig,0) - ImpliedProbabilityOutrightPickDogOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(AwayOddsCloseDevig,0) * TenUnitThreshold  as DECIMAL(5,2)))
																					)
																				THEN 10
																				ELSE 0
																				END
		WHERE ImpliedProbabilityOutrightPickFavDog IS NOT NULL

		UPDATE @Output SET ImpliedProbabilitySpreadPickWager = CASE WHEN 
																					(	
																						ImpliedProbabilitySpreadPick = 'Home' 
																					AND	(ISNULL(HomeLineOddsCloseDevig,0) < ISNULL(AwayLineOddsCloseDevig,0))
																					AND (CAST(ISNULL(HomeLineOddsCloseDevig,0) - ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(HomeLineOddsCloseDevig,0) * OneUnitThreshold as DECIMAL(5,2))) 
																					AND (ISNULL(HomeLineOddsCloseDevig,0) < ISNULL(AwayLineOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(HomeLineOddsCloseDevig,0) - ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) < CAST(ISNULL(HomeLineOddsCloseDevig,0) * FiveUnitThreshold as DECIMAL(5,2)))
																					)
																				OR (
																						ImplieProbabilitySpreadPick = 'Away' 
																					AND (ISNULL(AwayLineOddsCloseDevig,0) < ISNULL(HomeLineOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(AwayLineOddsCloseDevig,0) - ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(AwayLineOddsCloseDevig,0) * OneUnitThreshold as DECIMAL(5,2))) 
																					AND (ISNULL(AwayLineOddsCloseDevig,0) < ISNULL(HomeLineOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(AwayLineOddsCloseDevig,0) - ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) < CAST(ISNULL(AwayLineOddsCloseDevig,0) * FiveUnitThreshold as DECIMAL(5,2)))
																					)
																				THEN 1
																				WHEN 
																					(
																						ImpliedProbabilitySpreadPick = 'Home' 
																					AND (ISNULL(HomeLineOddsCloseDevig,0) < ISNULL(AwayLineOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(HomeLineOddsCloseDevig,0) - ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(HomeLineOddsCloseDevig,0) * FiveUnitThreshold  as DECIMAL(5,2)))
																					AND (ISNULL(HomeLineOddsCloseDevig,0) < ISNULL(AwayLineOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(HomeLineOddsCloseDevig,0) - ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) < CAST(ISNULL(HomeLineOddsCloseDevig,0) * TenUnitThreshold  as DECIMAL(5,2)))
																					)
																				OR (
																						ImpliedProbabilitySpreadPick = 'Away' 
																					AND (ISNULL(AwayLineOddsCloseDevig,0) < ISNULL(HomeLineOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(AwayLineOddsCloseDevig,0) - ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(AwayLineOddsCloseDevig,0) * FiveUnitThreshold  as DECIMAL(5,2)))
																					AND (ISNULL(AwayLineOddsCloseDevig,0) < ISNULL(HomeLineOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(AwayLineOddsCloseDevig,0) - ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) < CAST(ISNULL(AwayLineOddsCloseDevig,0) * TenUnitThreshold  as DECIMAL(5,2)))
																					)
																				THEN 5
																				WHEN 
																					(
																						ImpliedProbabilitySpreadPick = 'Home' 
																					AND (ISNULL(HomeLineOddsCloseDevig,0) < ISNULL(AwayLineOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(HomeLineOddsCloseDevig,0) - ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(HomeLineOddsCloseDevig,0) * TenUnitThreshold  as DECIMAL(5,2)))
																					)
																				OR (
																						ImpliedProbabilitySpreadPick = 'Away' 
																					AND (ISNULL(AwayLineOddsCloseDevig,0) < ISNULL(HomeLineOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(AwayLineOddsCloseDevig,0) - ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(AwayLineOddsCloseDevig,0) * TenUnitThreshold  as DECIMAL(5,2)))
																					)
																				THEN 10
																				ELSE 1
																				END	
		WHERE ImpliedProbabilitySpreadPick IS NOT NULL

		UPDATE @Output SET ImpliedProbabilitySpreadPickHomeAwayWager = CASE WHEN 
																					(	
																						ImpliedProbabilitySpreadPick = 'Home' 
																					AND	(ISNULL(HomeLineOddsCloseDevig,0) < ISNULL(AwayLineOddsCloseDevig,0))
																					AND (CAST(ISNULL(HomeLineOddsCloseDevig,0) - ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(HomeLineOddsCloseDevig,0) * OneUnitThreshold as DECIMAL(5,2))) 
																					AND (ISNULL(HomeLineOddsCloseDevig,0) < ISNULL(AwayLineOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(HomeLineOddsCloseDevig,0) - ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) < CAST(ISNULL(HomeLineOddsCloseDevig,0) * FiveUnitThreshold as DECIMAL(5,2)))
																					)
																				OR (
																						ImpliedProbabilitySpreadPick = 'Away' 
																					AND (ISNULL(AwayLineOddsCloseDevig,0) < ISNULL(HomeLineOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(AwayLineOddsCloseDevig,0) - ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(AwayLineOddsCloseDevig,0) * OneUnitThreshold as DECIMAL(5,2))) 
																					AND (ISNULL(AwayLineOddsCloseDevig,0) < ISNULL(HomeLineOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(AwayLineOddsCloseDevig,0) - ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) < CAST(ISNULL(AwayLineOddsCloseDevig,0) * FiveUnitThreshold as DECIMAL(5,2)))
																					)
																				THEN 1
																				WHEN 
																					(
																						ImpliedProbabilitySpreadPick = 'Home' 
																					AND (ISNULL(HomeLineOddsCloseDevig,0) < ISNULL(AwayLineOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(HomeLineOddsCloseDevig,0) - ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(HomeLineOddsCloseDevig,0) * FiveUnitThreshold  as DECIMAL(5,2)))
																					AND (ISNULL(HomeLineOddsCloseDevig,0) < ISNULL(AwayLineOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(HomeLineOddsCloseDevig,0) - ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) < CAST(ISNULL(HomeLineOddsCloseDevig,0) * TenUnitThreshold  as DECIMAL(5,2)))
																					)
																				OR (
																						ImpliedProbabilitySpreadPick = 'Away' 
																					AND (ISNULL(AwayLineOddsCloseDevig,0) < ISNULL(HomeLineOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(AwayLineOddsCloseDevig,0) - ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(AwayLineOddsCloseDevig,0) * FiveUnitThreshold  as DECIMAL(5,2)))
																					AND (ISNULL(AwayLineOddsCloseDevig,0) < ISNULL(HomeLineOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(AwayLineOddsCloseDevig,0) - ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) < CAST(ISNULL(AwayLineOddsCloseDevig,0) * TenUnitThreshold  as DECIMAL(5,2)))
																					)
																				THEN 5
																				WHEN 
																					(
																						ImpliedProbabilitySpreadPick = 'Home' 
																					AND (ISNULL(HomeLineOddsCloseDevig,0) < ISNULL(AwayLineOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(HomeLineOddsCloseDevig,0) - ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(HomeLineOddsCloseDevig,0) * TenUnitThreshold  as DECIMAL(5,2)))
																					)
																				OR (
																						ImpliedProbabilitySpreadPick = 'Away' 
																					AND (ISNULL(AwayLineOddsCloseDevig,0) < ISNULL(HomeLineOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(AwayLineOddsCloseDevig,0) - ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(AwayLineOddsCloseDevig,0) * TenUnitThreshold  as DECIMAL(5,2)))
																					)
																				THEN 10
																				ELSE 1
																				END	
		WHERE ImpliedProbabilitySpreadPick IS NOT NULL

		UPDATE @Output SET ImpliedProbabilitySpreadPickFavDogWager = CASE WHEN 
																					(
																						ImpliedProbabilitySpreadPickFavDog = 'Fav'
																					And (ISNULL(HomeLineOddsCloseDevig,0) < ISNULL(AwayLineOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(HomeLineOddsCloseDevig,0) - ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(HomeLineOddsCloseDevig,0) * OneUnitThreshold as DECIMAL(5,2)))
																					AND (ISNULL(HomeLineOddsCloseDevig,0) < ISNULL(AwayLineOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(HomeLineOddsCloseDevig,0) - ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) < CAST(ISNULL(HomeLineOddsCloseDevig,0) * FiveUnitThreshold  as DECIMAL(5,2)))
																					)
																				OR (
																						ImpliedProbabilitySpreadPickFavDog = 'Fav'
																					AND (ISNULL(AwayLineOddsCloseDevig,0) < ISNULL(HomeLineOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(AwayLineOddsCloseDevig,0) - ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(AwayLineOddsCloseDevig,0) * OneUnitThreshold as DECIMAL(5,2)))
																					AND (ISNULL(AwayLineOddsCloseDevig,0) < ISNULL(HomeLineOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(AwayLineOddsCloseDevig,0) - ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) < CAST(ISNULL(AwayLineOddsCloseDevig,0) * FiveUnitThreshold  as DECIMAL(5,2)))
																					)
																				OR (
																						ImpliedProbabilitySpreadPickFavDog = 'Dog'
																					And (ISNULL(HomeLineOddsCloseDevig,0) < ISNULL(AwayLineOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(HomeLineOddsCloseDevig,0) - ImpliedProbabilityOutrightPickDogOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(HomeLineOddsCloseDevig,0) * OneUnitThreshold as DECIMAL(5,2)))
																					AND (ISNULL(HomeLineOddsCloseDevig,0) < ISNULL(AwayLineOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(HomeLineOddsCloseDevig,0) - ImpliedProbabilityOutrightPickDogOddsThreshold as DECIMAL(5,2)) < CAST(ISNULL(HomeLineOddsCloseDevig,0) * FiveUnitThreshold  as DECIMAL(5,2)))
																					)
																				OR (
																						ImpliedProbabilitySpreadPickFavDog = 'Dog'
																					AND (ISNULL(AwayLineOddsCloseDevig,0) < ISNULL(HomeLineOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(AwayLineOddsCloseDevig,0) - ImpliedProbabilityOutrightPickDogOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(AwayLineOddsCloseDevig,0) * OneUnitThreshold as DECIMAL(5,2)))
																					AND (ISNULL(AwayLineOddsCloseDevig,0) < ISNULL(HomeLineOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(AwayLineOddsCloseDevig,0) - ImpliedProbabilityOutrightPickDogOddsThreshold as DECIMAL(5,2)) < CAST(ISNULL(AwayLineOddsCloseDevig,0) * FiveUnitThreshold  as DECIMAL(5,2)))
																					)
																				THEN 1
																				WHEN 
																					(
																						ImpliedProbabilitySpreadPickFavDog = 'Fav'
																					AND (ISNULL(HomeLineOddsCloseDevig,0) < ISNULL(AwayLineOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(HomeLineOddsCloseDevig,0) - ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(HomeLineOddsCloseDevig,0) * FiveUnitThreshold  as DECIMAL(5,2))) 
																					AND (ISNULL(HomeLineOddsCloseDevig,0) < ISNULL(AwayLineOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(HomeLineOddsCloseDevig,0) - ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) < CAST(ISNULL(HomeLineOddsCloseDevig,0) * TenUnitThreshold  as DECIMAL(5,2)))
																					)
																				OR (
																						ImpliedProbabilitySpreadPickFavDog = 'Fav'
																					AND (ISNULL(AwayLineOddsCloseDevig,0) < ISNULL(HomeLineOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(AwayLineOddsCloseDevig,0) - ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(AwayLineOddsCloseDevig,0) * FiveUnitThreshold  as DECIMAL(5,2))) 
																					AND (ISNULL(AwayLineOddsCloseDevig,0) < ISNULL(HomeLineOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(AwayLineOddsCloseDevig,0) - ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) < CAST(ISNULL(AwayLineOddsCloseDevig,0) * TenUnitThreshold  as DECIMAL(5,2)))
																					)
																				OR (
																						ImpliedProbabilitySpreadPickFavDog = 'Dog'
																					AND (ISNULL(HomeLineOddsCloseDevig,0) < ISNULL(AwayLineOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(HomeLineOddsCloseDevig,0) - ImpliedProbabilityOutrightPickDogOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(HomeLineOddsCloseDevig,0) * FiveUnitThreshold  as DECIMAL(5,2))) 
																					AND (ISNULL(HomeLineOddsCloseDevig,0) < ISNULL(AwayLineOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(HomeLineOddsCloseDevig,0) - ImpliedProbabilityOutrightPickDogOddsThreshold as DECIMAL(5,2)) < CAST(ISNULL(HomeLineOddsCloseDevig,0) * TenUnitThreshold  as DECIMAL(5,2)))
																					)
																				OR (
																						ImpliedProbabilitySpreadPickFavDog = 'Dog'
																					AND (ISNULL(AwayLineOddsCloseDevig,0) < ISNULL(HomeLineOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(AwayLineOddsCloseDevig,0) - ImpliedProbabilityOutrightPickDogOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(AwayLineOddsCloseDevig,0) * FiveUnitThreshold  as DECIMAL(5,2)))
																					AND (ISNULL(AwayLineOddsCloseDevig,0) < ISNULL(HomeLineOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(AwayLineOddsCloseDevig,0) - ImpliedProbabilityOutrightPickDogOddsThreshold as DECIMAL(5,2)) < CAST(ISNULL(AwayLineOddsCloseDevig,0) * TenUnitThreshold  as DECIMAL(5,2)))
																					)
																				THEN 5
																				WHEN 
																					(
																						ImpliedProbabilitySpreadPickFavDog = 'Fav'
																					AND (ISNULL(HomeLineOddsCloseDevig,0) < ISNULL(AwayLineOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(HomeLineOddsCloseDevig,0) - ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(HomeLineOddsCloseDevig,0) * TenUnitThreshold  as DECIMAL(5,2))) 
																					)
																				OR (
																						ImpliedProbabilitySpreadPickFavDog = 'Fav'
																					AND (ISNULL(AwayLineOddsCloseDevig,0) < ISNULL(HomeLineOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(AwayLineOddsCloseDevig,0) - ImpliedProbabilityOutrightPickFavoriteOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(AwayLineOddsCloseDevig,0) * TenUnitThreshold  as DECIMAL(5,2))) 
																					)
																				OR (
																						ImpliedProbabilitySpreadPickFavDog = 'Dog'
																					AND (ISNULL(HomeLineOddsCloseDevig,0) < ISNULL(AwayLineOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(HomeLineOddsCloseDevig,0) - ImpliedProbabilityOutrightPickDogOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(HomeLineOddsCloseDevig,0) * TenUnitThreshold  as DECIMAL(5,2))) 
																					)
																				OR (
																						ImpliedProbabilitySpreadPickFavDog = 'Dog'
																					AND (ISNULL(AwayLineOddsCloseDevig,0) < ISNULL(HomeLineOddsCloseDevig,0)) 
																					AND (CAST(ISNULL(AwayLineOddsCloseDevig,0) - ImpliedProbabilityOutrightPickDogOddsThreshold as DECIMAL(5,2))>= CAST(ISNULL(AwayLineOddsCloseDevig,0) * TenUnitThreshold  as DECIMAL(5,2)))
																					)
																				THEN 10
																				ELSE 1
																				END
		WHERE ImpliedProbabilitySpreadPickFavDog IS NOT NULL

		UPDATE @Output SET ImpliedProbabilityTotalPickWager =  CASE WHEN 
																					(
																						ImpliedProbabilityTotalPick = 'Over'
																					AND (CAST(ISNULL(TotalScoreOverCloseDevig,0) - ImpliedProbabilityTotalPickOverOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(TotalScoreOverCloseDevig,0) * OneUnitThreshold as DECIMAL(5,2)))
																					AND (CAST(ISNULL(TotalScoreOverCloseDevig,0) - ImpliedProbabilityTotalPickOverOddsThreshold as DECIMAL(5,2)) < CAST(ISNULL(TotalScoreOverCloseDevig,0) * FiveUnitThreshold as DECIMAL(5,2)))
																					)
																				OR (
																						ImpliedProbabilityTotalPick = 'Under'
																					AND (CAST(ISNULL(TotalScoreUnderCloseDevig,0) - ImpliedProbabilityTotalPickUnderOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(TotalScoreUnderCloseDevig,0) * OneUnitThreshold as DECIMAL(5,2))) 
																					AND (CAST(ISNULL(TotalScoreUnderCloseDevig,0) - ImpliedProbabilityTotalPickUnderOddsThreshold as DECIMAL(5,2)) < CAST(ISNULL(TotalScoreUnderCloseDevig,0) * FiveUnitThreshold as DECIMAL(5,2)))
																					)
																				THEN 1
																				WHEN 
																					(
																						ImpliedProbabilityTotalPick = 'Over'
																					AND (CAST(ISNULL(TotalScoreOverCloseDevig,0) - ImpliedProbabilityTotalPickOverOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(TotalScoreOverCloseDevig,0) * FiveUnitThreshold as DECIMAL(5,2)))
																					AND (CAST(ISNULL(TotalScoreOverCloseDevig,0) - ImpliedProbabilityTotalPickOverOddsThreshold as DECIMAL(5,2)) < CAST(ISNULL(TotalScoreOverCloseDevig,0) * TenUnitThreshold as DECIMAL(5,2)))
																					)
																				OR (
																						ImpliedProbabilityTotalPick = 'Under'
																					AND (CAST(ISNULL(TotalScoreUnderCloseDevig,0) - ImpliedProbabilityTotalPickUnderOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(TotalScoreUnderCloseDevig,0) * FiveUnitThreshold as DECIMAL(5,2)))
																					AND (CAST(ISNULL(TotalScoreUnderCloseDevig,0) - ImpliedProbabilityTotalPickUnderOddsThreshold as DECIMAL(5,2)) < CAST(ISNULL(TotalScoreUnderCloseDevig,0) * TenUnitThreshold as DECIMAL(5,2)))
																					)
																				THEN 5
																				WHEN 
																					(
																						ImpliedProbabilityTotalPick = 'Over'
																					AND (CAST(ISNULL(TotalScoreOverCloseDevig,0) - ImpliedProbabilityTotalPickOverOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(TotalScoreOverCloseDevig,0) * TenUnitThreshold as DECIMAL(5,2)))
																					)
																				OR (
																						ImpliedProbabilityTotalPick = 'Under'
																					AND (CAST(ISNULL(TotalScoreUnderCloseDevig,0) - ImpliedProbabilityTotalPickUnderOddsThreshold as DECIMAL(5,2)) >= CAST(ISNULL(TotalScoreUnderCloseDevig,0) * TenUnitThreshold as DECIMAL(5,2))) 
																					)
																				THEN 10
																				ELSE 1
																				END
	WHERE ImpliedProbabilityTotalPick IS NOT NULL

	/*Calculate Profit*/

	UPDATE @Output SET ImpliedProbabilityOutrightPickWagerProfit = CASE WHEN ImpliedProbabilityOutrightPickCorrect = 'Y' AND ImpliedProbabilityOutrightPick = 'Home' THEN ImpliedProbabilityOutrightPickWager * ISNULL(COALESCE(HomeLineOddsClose,HomeLineOddsMax,HomeLineOddsOpen),0) 
																			  WHEN ImpliedProbabilityOutrightPickCorrect = 'Y' AND ImpliedProbabilityOutrightPick = 'Away' THEN ImpliedProbabilityOutrightPickWager * ISNULL(COALESCE(AwayLineOddsClose,AwayLineOddsMax,AwayLineOddsOpen),0)
																			  WHEN ImpliedProbabilityOutrightPickCorrect = 'N' THEN ImpliedProbabilityOutrightPickWager * -1
																			  WHEN ImpliedProbabilityOutrightPickCorrect = 'P' THEN 0
																			  END
	WHERE ImpliedProbabilityOutrightPickCorrect IS NOT NULL AND ImpliedProbabilityOutrightPick IS NOT NULL AND ImpliedProbabilityOutrightPickWager IS NOT NULL

	UPDATE @Output SET ImpliedProbabilityOutrightPickHomeAwayWagerProfit = CASE WHEN ImpliedProbabilityOutrightPickHACorrect = 'Y' AND ImpliedProbabilityOutrightPickHomeAway = 'Home' THEN ImpliedProbabilityOutrightPickHomeAwayWager * ISNULL(COALESCE(HomeLineOddsClose,HomeLineOddsMax,HomeLineOddsOpen),0) 
																					  WHEN ImpliedProbabilityOutrightPickHACorrect = 'Y' AND ImpliedProbabilityOutrightPickHomeAway = 'Away' THEN ImpliedProbabilityOutrightPickHomeAwayWager * ISNULL(COALESCE(AwayLineOddsClose,AwayLineOddsMax,AwayLineOddsOpen),0)
																					  WHEN ImpliedProbabilityOutrightPickHACorrect = 'N' THEN ImpliedProbabilityOutrightPickHomeAwayWager * -1
																					  WHEN ImpliedProbabilityOutrightPickHACorrect = 'P' THEN 0
																					  END
	WHERE ImpliedProbabilityOutrightPickHACorrect IS NOT NULL AND ImpliedProbabilityOutrightPickHomeAway IS NOT NULL AND ImpliedProbabilityOutrightPickHomeAwayWager IS NOT NULL

	UPDATE @Output SET ImpliedProbabilityOutrightPickFavDogWagerProfit = CASE WHEN ImpliedProbabilityOutrightPickFDCorrect = 'Y' AND ImpliedProbabilityOutrightPickFavDog = 'Fav' AND ISNULL(HomeOddsCloseDevig,0) < ISNULL(AwayOddsCloseDevig,0) THEN ImpliedProbabilityOutrightPickFavDogWager * ISNULL(COALESCE(HomeLineOddsClose,HomeLineOddsMax,HomeLineOddsOpen),0) 
																				    WHEN ImpliedProbabilityOutrightPickFDCorrect = 'Y' AND ImpliedProbabilityOutrightPickFavDog = 'Fav' AND ISNULL(HomeOddsCloseDevig,0) > ISNULL(AwayOddsCloseDevig,0)  THEN ImpliedProbabilityOutrightPickFavDogWager * ISNULL(COALESCE(AwayLineOddsClose,AwayLineOddsMax,AwayLineOddsOpen),0)
																				    WHEN ImpliedProbabilityOutrightPickFDCorrect = 'Y' AND ImpliedProbabilityOutrightPickFavDog = 'Dog' AND ISNULL(HomeOddsCloseDevig,0) > ISNULL(AwayOddsCloseDevig,0) THEN ImpliedProbabilityOutrightPickFavDogWager * ISNULL(COALESCE(HomeLineOddsClose,HomeLineOddsMax,HomeLineOddsOpen),0) 
																				    WHEN ImpliedProbabilityOutrightPickFDCorrect = 'Y' AND ImpliedProbabilityOutrightPickFavDog = 'Dog' AND ISNULL(HomeOddsCloseDevig,0) < ISNULL(AwayOddsCloseDevig,0)  THEN ImpliedProbabilityOutrightPickFavDogWager * ISNULL(COALESCE(AwayLineOddsClose,AwayLineOddsMax,AwayLineOddsOpen),0)
																					WHEN ImpliedProbabilityOutrightPickFDCorrect = 'N' THEN ImpliedProbabilityOutrightPickFavDogWager * -1
																				    WHEN ImpliedProbabilityOutrightPickFDCorrect = 'P' THEN 0
																					END
	WHERE ImpliedProbabilityOutrightPickFDCorrect IS NOT NULL AND ImpliedProbabilityOutrightPickFavDog IS NOT NULL AND ImpliedProbabilityOutrightPickFavDogWager IS NOT NULL

	UPDATE @Output SET ImpliedProbabilitySpreadPickWagerProfit = CASE WHEN ImpliedProbabilitySpreadPickCorrect = 'Y' AND ImpliedProbabilitySpreadPick = 'Home' THEN ImpliedProbabilitySpreadPickWager * ISNULL(HomeLineOddsCloseDevig,0) 
																		    WHEN ImpliedProbabilitySpreadPickCorrect = 'Y' AND ImpliedProbabilitySpreadPick = 'Away' THEN ImpliedProbabilitySpreadPickWager * ISNULL(AwayLineOddsCloseDevig,0)
																		    WHEN ImpliedProbabilitySpreadPickCorrect = 'N' THEN ImpliedProbabilitySpreadPickWager * -1
																		    WHEN ImpliedProbabilitySpreadPickCorrect = 'P' THEN 0
																			END
	WHERE ImpliedProbabilitySpreadPickCorrect IS NOT NULL AND ImpliedProbabilitySpreadPick IS NOT NULL AND ImpliedProbabilitySpreadPickWager IS NOT NULL

	UPDATE @Output SET ImpliedProbabilitySpreadPickHomeAwayWagerProfit = CASE WHEN ImpliedProbabilitySpreadPickHACorrect = 'Y' AND ImpliedProbabilitySpreadPickHomeAway = 'Home' THEN ImpliedProbabilitySpreadPickHomeAwayWager * ISNULL(COALESCE(HomeLineOddsClose,HomeLineOddsMax,HomeLineOddsOpen),0)
																						WHEN ImpliedProbabilitySpreadPickHACorrect = 'Y' AND ImpliedProbabilitySpreadPickHomeAway = 'Away' THEN ImpliedProbabilitySpreadPickHomeAwayWager * ISNULL(COALESCE(AwayLineOddsClose,AwayLineOddsMax,AwayLineOddsOpen),0)
																						WHEN ImpliedProbabilitySpreadPickHACorrect = 'N' THEN ImpliedProbabilitySpreadPickHomeAwayWager * -1
																						WHEN ImpliedProbabilitySpreadPickHACorrect = 'P' THEN 0
																						END
	WHERE ImpliedProbabilitySpreadPickHACorrect IS NOT NULL AND ImpliedProbabilitySpreadPickHomeAway IS NOT NULL AND ImpliedProbabilitySpreadPickHomeAwayWager IS NOT NULL

	UPDATE @Output SET ImpliedProbabilitySpreadPickFavDogWagerProfit = CASE WHEN ImpliedProbabilitySpreadPickFDCorrect = 'Y' AND ImpliedProbabilitySpreadPickFavDog = 'Fav' AND ISNULL(COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen),0) < ISNULL(COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen),0) THEN ImpliedProbabilitySpreadPickFavDogWager * ISNULL(COALESCE(HomeLineOddsClose,HomeLineOddsMax,HomeLineOddsOpen),0) 
																				    WHEN ImpliedProbabilitySpreadPickFDCorrect = 'Y' AND ImpliedProbabilitySpreadPickFavDog = 'Fav' AND ISNULL(COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen),0) > ISNULL(COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen),0)  THEN ImpliedProbabilitySpreadPickFavDogWager * ISNULL(COALESCE(AwayLineOddsClose,AwayLineOddsMax,AwayLineOddsOpen),0)
																				    WHEN ImpliedProbabilitySpreadPickFDCorrect = 'Y' AND ImpliedProbabilitySpreadPickFavDog = 'Dog' AND ISNULL(COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen),0) > ISNULL(COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen),0) THEN ImpliedProbabilitySpreadPickFavDogWager * ISNULL(COALESCE(HomeLineOddsClose,HomeLineOddsMax,HomeLineOddsOpen),0) 
																				    WHEN ImpliedProbabilitySpreadPickFDCorrect = 'Y' AND ImpliedProbabilitySpreadPickFavDog = 'Dog' AND ISNULL(COALESCE(HomeLineClose,HomeLineMax,HomeLineOpen),0) < ISNULL(COALESCE(AwayLineClose,AwayLineMax,AwayLineOpen),0)  THEN ImpliedProbabilitySpreadPickFavDogWager * ISNULL(COALESCE(AwayLineOddsClose,AwayLineOddsMax,AwayLineOddsOpen),0)
																					WHEN ImpliedProbabilitySpreadPickFDCorrect = 'N' THEN ImpliedProbabilitySpreadPickFavDogWager * -1
																				    WHEN ImpliedProbabilitySpreadPickFDCorrect = 'P' THEN 0
																					END
	WHERE ImpliedProbabilitySpreadPickFDCorrect IS NOT NULL AND ImpliedProbabilitySpreadPickFavDog IS NOT NULL AND ImpliedProbabilitySpreadPickFavDogWager IS NOT NULL

	UPDATE @Output SET ImpliedProbabilityTotalPickWagerProfit = CASE WHEN ImpliedProbabilityTotalPickCorrect = 'Y' AND ImpliedProbabilityTotalPick = 'Over' THEN ImpliedProbabilityTotalPickWager * ISNULL(TotalScoreOverClose,0)
																		   WHEN ImpliedProbabilityTotalPickCorrect = 'Y' AND ImpliedProbabilityTotalPick = 'Under' THEN ImpliedProbabilityTotalPickWager * ISNULL(TotalScoreUnderClose,0)
																		   WHEN ImpliedProbabilityTotalPickCorrect = 'N' THEN ImpliedProbabilityTotalPickWager * -1
																		   WHEN ImpliedProbabilityTotalPickCorrect = 'P' THEN 0
																		   END
	WHERE ImpliedProbabilityTotalPickCorrect IS NOT NULL AND ImpliedProbabilityTotalPick IS NOT NULL AND ImpliedProbabilityTotalPickWager IS NOT NULL
	
	DELETE FROM @Output WHERE HomeTeam IS NULL OR AwayTeam IS NULL

	RETURN
END

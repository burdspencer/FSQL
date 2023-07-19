-- ================================
-- Create User-defined Table Type
-- ================================
USE ProFootballReference
GO
-- Create the data type

CREATE TYPE GameDataTable AS TABLE 
(
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
	HomeLineMovement			decimal(5,2),
	HomeLineOddsMovement		decimal(5,2),
	AwayLineMovement			decimal(5,2),
	AwayLineOddsMovement		decimal(5,2),
	TotalScoreMovement			decimal(5,2),
	TotalScoreOverMovement		decimal(5,2),
	TotalScoreUnderMovement		decimal(5,2),
	ImpliedProbabilityOutrightPick					VARCHAR(10),
	ImpliedProbabilityOutrightPickHomeAway			VARCHAR(10),
	ImpliedProbabilityOutrightPickFavDog			VARCHAR(10),
	ImpliedProbabilityOutrightPickCorrect			VARCHAR(1), 
	ImpliedProbabilityOutrightPickHACorrect			VARCHAR(1), 
	ImpliedProbabilityOutrightPickFDCorrect			VARCHAR(1),
	ImpliedProbabilitySpreadPick					VARCHAR(10),
	ImpliedProbabilitySpreadPickHomeAway			VARCHAR(10),
	ImpliedProbabilitySpreadPickFavDog				VARCHAR(10),
	ImpliedProbabilitySpreadPickHACorrect			VARCHAR(1),
	ImpliedProbabilitySpreadPickFDCorrect			VARCHAR(1),
	ImpliedProbabilitySpreadPickCorrect				VARCHAR(1),
	ImpliedProbabilityTotalPick						VARCHAR(10),
	ImpliedProbabilityTotalPickCorrect				VARCHAR(1),
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
	ImpliedProbabilityTotalPickWagerProfit					DECIMAL(11,2),
	ImpliedProbabilityOutrightPickHomeOddsThreshold DECIMAL(7,2),
	ImpliedProbabilityOutrightPickAwayOddsThreshold DECIMAL(7,2),
	ImpliedProbabilityOutrightPickFavoriteOddsThreshold DECIMAL(7,2),
	ImpliedProbabilityOutrightPickDogOddsThreshold DECIMAL(7,2),
	ImpliedProbabilitySpreadPickHomeOddsThreshold DECIMAL(7,2),
	ImpliedProbabilitySpreadPickAwayOddsThreshold DECIMAL(7,2),
	ImpliedProbabilitySpreadPickFavoriteOddsThreshold DECIMAL(7,2),
	ImpliedProbabilitySpreadPickDogOddsThreshold DECIMAL(7,2),
	ImpliedProbabilityTotalPickOverOddsThreshold DECIMAL(7,2),
	ImpliedProbabilityTotalPickUnderOddsThreshold DECIMAL(7,2),
	OneUnitThreshold DECIMAL(7,2),
	FiveUnitThreshold DECIMAL(7,2),
	TenUnitThreshold DECIMAL(7,2)
)
GO
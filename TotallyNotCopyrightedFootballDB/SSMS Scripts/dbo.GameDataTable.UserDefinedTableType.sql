USE [ProFootballReference]
GO
/****** Object:  UserDefinedTableType [dbo].[GameDataTable]    Script Date: 8/28/2023 6:27:09 PM ******/
CREATE TYPE [dbo].[GameDataTable] AS TABLE(
	[HomeTeam] [varchar](100) NULL,
	[AwayTeam] [varchar](100) NULL,
	[Week] [varchar](20) NULL,
	[Season] [int] NULL,
	[HomeScore] [int] NULL,
	[AwayScore] [int] NULL,
	[Result] [varchar](100) NULL,
	[HomeAvgPointsFor] [decimal](5, 2) NULL,
	[HomeAvgPointsAgainst] [decimal](5, 2) NULL,
	[HomeAvgOff1stD] [decimal](5, 2) NULL,
	[HomeAvgOffTotYd] [decimal](5, 2) NULL,
	[HomeAvgOffPassYd] [decimal](5, 2) NULL,
	[HomeAvgOffRushYd] [decimal](5, 2) NULL,
	[HomeAvgOffTO] [decimal](5, 2) NULL,
	[HomeAvgDef1stD] [decimal](5, 2) NULL,
	[HomeAvgDefTotYd] [decimal](5, 2) NULL,
	[HomeAvgDefPassYd] [decimal](5, 2) NULL,
	[HomeAvgDefRushYd] [decimal](5, 2) NULL,
	[HomeAvgDefTO] [decimal](5, 2) NULL,
	[HomeAvgExPointsOff] [decimal](5, 2) NULL,
	[HomeAvgExPointsDef] [decimal](5, 2) NULL,
	[HomeAvgExPointsSpecial] [decimal](5, 2) NULL,
	[HomeLastPointsFor] [int] NULL,
	[HomeLastPointsAgainst] [int] NULL,
	[HomeLastOff1stD] [int] NULL,
	[HomeLastOffTotYd] [int] NULL,
	[HomeLastOffPassYd] [int] NULL,
	[HomeLastOffRushYd] [int] NULL,
	[HomeLastOffTO] [int] NULL,
	[HomeLastDef1stD] [int] NULL,
	[HomeLastDefTotYd] [int] NULL,
	[HomeLastDefPassYd] [int] NULL,
	[HomeLastDefRushYd] [int] NULL,
	[HomeLastDefTO] [int] NULL,
	[HomeLastExPointsOff] [decimal](5, 2) NULL,
	[HomeLastExPointsDef] [decimal](5, 2) NULL,
	[HomeLastExPointsSpecial] [decimal](5, 2) NULL,
	[AwayAvgPointsFor] [decimal](5, 2) NULL,
	[AwayAvgPointsAgainst] [decimal](5, 2) NULL,
	[AwayAvgOff1stD] [decimal](5, 2) NULL,
	[AwayAvgOffTotYd] [decimal](5, 2) NULL,
	[AwayAvgOffPassYd] [decimal](5, 2) NULL,
	[AwayAvgOffRushYd] [decimal](5, 2) NULL,
	[AwayAvgOffTO] [decimal](5, 2) NULL,
	[AwayAvgDef1stD] [decimal](5, 2) NULL,
	[AwayAvgDefTotYd] [decimal](5, 2) NULL,
	[AwayAvgDefPassYd] [decimal](5, 2) NULL,
	[AwayAvgDefRushYd] [decimal](5, 2) NULL,
	[AwayAvgDefTO] [decimal](5, 2) NULL,
	[AwayAvgExPointsOff] [decimal](5, 2) NULL,
	[AwayAvgExPointsDef] [decimal](5, 2) NULL,
	[AwayAvgExPointsSpecial] [decimal](5, 2) NULL,
	[AwayLastPointsFor] [int] NULL,
	[AwayLastPointsAgainst] [int] NULL,
	[AwayLastOff1stD] [int] NULL,
	[AwayLastOffTotYd] [int] NULL,
	[AwayLastOffPassYd] [int] NULL,
	[AwayLastOffRushYd] [int] NULL,
	[AwayLastOffTO] [int] NULL,
	[AwayLastDef1stD] [int] NULL,
	[AwayLastDefTotYd] [int] NULL,
	[AwayLastDefPassYd] [int] NULL,
	[AwayLastDefRushYd] [int] NULL,
	[AwayLastDefTO] [int] NULL,
	[AwayLastExPointsOff] [decimal](5, 2) NULL,
	[AwayLastExPointsDef] [decimal](5, 2) NULL,
	[AwayLastExPointsSpecial] [decimal](5, 2) NULL,
	[HomeOddsOpen] [decimal](5, 2) NULL,
	[HomeOddsMin] [decimal](5, 2) NULL,
	[HomeOddsMax] [decimal](5, 2) NULL,
	[HomeOddsClose] [decimal](5, 2) NULL,
	[HomeOddsCloseIP] [decimal](5, 2) NULL,
	[HomeOddsCloseDevig] [decimal](5, 2) NULL,
	[AwayOddsOpen] [decimal](5, 2) NULL,
	[AwayOddsMin] [decimal](5, 2) NULL,
	[AwayOddsMax] [decimal](5, 2) NULL,
	[AwayOddsClose] [decimal](5, 2) NULL,
	[AwayOddsCloseIP] [decimal](5, 2) NULL,
	[AwayOddsCloseDevig] [decimal](5, 2) NULL,
	[HomeLineOpen] [decimal](5, 2) NULL,
	[HomeLineMin] [decimal](5, 2) NULL,
	[HomeLineMax] [decimal](5, 2) NULL,
	[HomeLineClose] [decimal](5, 2) NULL,
	[AwayLineOpen] [decimal](5, 2) NULL,
	[AwayLineMin] [decimal](5, 2) NULL,
	[AwayLineMax] [decimal](5, 2) NULL,
	[AwayLineClose] [decimal](5, 2) NULL,
	[HomeLineOddsOpen] [decimal](5, 2) NULL,
	[HomeLineOddsMin] [decimal](5, 2) NULL,
	[HomeLineOddsMax] [decimal](5, 2) NULL,
	[HomeLineOddsClose] [decimal](5, 2) NULL,
	[HomeLineOddsCloseIP] [decimal](5, 2) NULL,
	[HomeLineOddsCloseDevig] [decimal](5, 2) NULL,
	[AwayLineOddsOpen] [decimal](5, 2) NULL,
	[AwayLineOddsMin] [decimal](5, 2) NULL,
	[AwayLineOddsMax] [decimal](5, 2) NULL,
	[AwayLineOddsClose] [decimal](5, 2) NULL,
	[AwayLineOddsCloseIP] [decimal](5, 2) NULL,
	[AwayLineOddsCloseDevig] [decimal](5, 2) NULL,
	[TotalScoreOpen] [decimal](5, 2) NULL,
	[TotalScoreMin] [decimal](5, 2) NULL,
	[TotalScoreMax] [decimal](5, 2) NULL,
	[TotalScoreClose] [decimal](5, 2) NULL,
	[TotalScoreOverOpen] [decimal](5, 2) NULL,
	[TotalScoreOverMin] [decimal](5, 2) NULL,
	[TotalScoreOverMax] [decimal](5, 2) NULL,
	[TotalScoreOverClose] [decimal](5, 2) NULL,
	[TotalScoreOverCloseIP] [decimal](5, 2) NULL,
	[TotalScoreOverCloseDevig] [decimal](5, 2) NULL,
	[TotalScoreUnderOpen] [decimal](5, 2) NULL,
	[TotalScoreUnderMin] [decimal](5, 2) NULL,
	[TotalScoreUnderMax] [decimal](5, 2) NULL,
	[TotalScoreUnderClose] [decimal](5, 2) NULL,
	[TotalScoreUnderCloseIP] [decimal](5, 2) NULL,
	[TotalScoreUnderCloseDevig] [decimal](5, 2) NULL,
	[HomeLineMovement] [decimal](5, 2) NULL,
	[HomeLineOddsMovement] [decimal](5, 2) NULL,
	[AwayLineMovement] [decimal](5, 2) NULL,
	[AwayLineOddsMovement] [decimal](5, 2) NULL,
	[TotalScoreMovement] [decimal](5, 2) NULL,
	[TotalScoreOverMovement] [decimal](5, 2) NULL,
	[TotalScoreUnderMovement] [decimal](5, 2) NULL,
	[ImpliedProbabilityOutrightPick] [varchar](10) NULL,
	[ImpliedProbabilityOutrightPickHomeAway] [varchar](10) NULL,
	[ImpliedProbabilityOutrightPickFavDog] [varchar](10) NULL,
	[ImpliedProbabilityOutrightPickCorrect] [varchar](1) NULL,
	[ImpliedProbabilityOutrightPickHACorrect] [varchar](1) NULL,
	[ImpliedProbabilityOutrightPickFDCorrect] [varchar](1) NULL,
	[ImpliedProbabilitySpreadPick] [varchar](10) NULL,
	[ImpliedProbabilitySpreadPickHomeAway] [varchar](10) NULL,
	[ImpliedProbabilitySpreadPickFavDog] [varchar](10) NULL,
	[ImpliedProbabilitySpreadPickHACorrect] [varchar](1) NULL,
	[ImpliedProbabilitySpreadPickFDCorrect] [varchar](1) NULL,
	[ImpliedProbabilitySpreadPickCorrect] [varchar](1) NULL,
	[ImpliedProbabilityTotalPick] [varchar](10) NULL,
	[ImpliedProbabilityTotalPickCorrect] [varchar](1) NULL,
	[ImpliedProbabilityOutrightPickWager] [decimal](7, 2) NULL,
	[ImpliedProbabilityOutrightPickHomeAwayWager] [decimal](7, 2) NULL,
	[ImpliedProbabilityOutrightPickFavDogWager] [decimal](7, 2) NULL,
	[ImpliedProbabilitySpreadPickWager] [decimal](7, 2) NULL,
	[ImpliedProbabilitySpreadPickHomeAwayWager] [decimal](7, 2) NULL,
	[ImpliedProbabilitySpreadPickFavDogWager] [decimal](7, 2) NULL,
	[ImpliedProbabilityTotalPickWager] [decimal](7, 2) NULL,
	[ImpliedProbabilityOutrightPickWagerProfit] [decimal](11, 2) NULL,
	[ImpliedProbabilityOutrightPickHomeAwayWagerProfit] [decimal](11, 2) NULL,
	[ImpliedProbabilityOutrightPickFavDogWagerProfit] [decimal](11, 2) NULL,
	[ImpliedProbabilitySpreadPickWagerProfit] [decimal](11, 2) NULL,
	[ImpliedProbabilitySpreadPickHomeAwayWagerProfit] [decimal](11, 2) NULL,
	[ImpliedProbabilitySpreadPickFavDogWagerProfit] [decimal](11, 2) NULL,
	[ImpliedProbabilityTotalPickWagerProfit] [decimal](11, 2) NULL,
	[ImpliedProbabilityOutrightPickHomeOddsThreshold] [decimal](7, 2) NULL,
	[ImpliedProbabilityOutrightPickAwayOddsThreshold] [decimal](7, 2) NULL,
	[ImpliedProbabilityOutrightPickFavoriteOddsThreshold] [decimal](7, 2) NULL,
	[ImpliedProbabilityOutrightPickDogOddsThreshold] [decimal](7, 2) NULL,
	[ImpliedProbabilitySpreadPickHomeOddsThreshold] [decimal](7, 2) NULL,
	[ImpliedProbabilitySpreadPickAwayOddsThreshold] [decimal](7, 2) NULL,
	[ImpliedProbabilitySpreadPickFavoriteOddsThreshold] [decimal](7, 2) NULL,
	[ImpliedProbabilitySpreadPickDogOddsThreshold] [decimal](7, 2) NULL,
	[ImpliedProbabilityTotalPickOverOddsThreshold] [decimal](7, 2) NULL,
	[ImpliedProbabilityTotalPickUnderOddsThreshold] [decimal](7, 2) NULL,
	[OneUnitThreshold] [decimal](7, 2) NULL,
	[FiveUnitThreshold] [decimal](7, 2) NULL,
	[TenUnitThreshold] [decimal](7, 2) NULL
)
GO

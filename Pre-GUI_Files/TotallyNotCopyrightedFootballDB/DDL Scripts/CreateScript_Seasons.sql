USE [ProFootballReference]
GO

/****** Object:  Table [dbo].[Seasons]    Script Date: 8/28/2023 5:12:03 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Seasons](
	[Season] [int] NULL,
	[SeasonTotalUnderRate] [decimal](5, 2) NULL,
	[SeasonTotalPushRate] [decimal](5, 2) NULL,
	[SeasonTotalOverRate] [decimal](5, 2) NULL,
	[HomeUnderdogSpreadCoverRate] [decimal](5, 2) NULL,
	[HomeFavoriteSpreadCoverRate] [decimal](5, 2) NULL,
	[AwayUnderdogSpreadCoverRate] [decimal](5, 2) NULL,
	[AwayFavoriteSpreadCoverRate] [decimal](5, 2) NULL,
	[HomeSpreadCoverRate] [decimal](5, 2) NULL,
	[AwaySpreadCoverRate] [decimal](5, 2) NULL,
	[FavoriteSpreadCoverRate] [decimal](5, 2) NULL,
	[DogSpreadCoverRate] [decimal](5, 2) NULL,
	[HomeUnderdogOutrightRate] [decimal](5, 2) NULL,
	[HomeFavoriteOutrightRate] [decimal](5, 2) NULL,
	[AwayUnderdogOutrightRate] [decimal](5, 2) NULL,
	[AwayFavoriteOutrightRate] [decimal](5, 2) NULL,
	[HomeOutrightRate] [decimal](5, 2) NULL,
	[AwayOutrightRate] [decimal](5, 2) NULL,
	[FavoriteOutrightRate] [decimal](5, 2) NULL,
	[DogOutrightRate] [decimal](5, 2) NULL,
	[ImpliedProbabilityOutrightHANumCorrect] [decimal](5, 2) NULL,
	[ImpliedProbabilityOutrightFDNumCorrect] [decimal](5, 2) NULL,
	[ImpliedProbabilityOutrightPickNumCorrect] [decimal](5, 2) NULL,
	[ImpliedProbabilitySpreadHANumCorrect] [decimal](5, 2) NULL,
	[ImpliedProbabilitySpreadFDNumCorrect] [decimal](5, 2) NULL,
	[ImpliedProbabilitySpreadPickNumCorrect] [decimal](5, 2) NULL,
	[ImpliedProbabilityTotalNumCorrect] [decimal](5, 2) NULL,
	[ImpliedProbabilityOutrightHATotApplicable] [decimal](5, 2) NULL,
	[ImpliedProbabilityOutrightFDTotApplicable] [decimal](5, 2) NULL,
	[ImpliedProbabilityOutrightPickTotApplicable] [decimal](5, 2) NULL,
	[ImpliedProbabilitySpreadHATotApplicable] [decimal](5, 2) NULL,
	[ImpliedProbabilitySpreadFDTotApplicable] [decimal](5, 2) NULL,
	[ImpliedProbabilitySpreadPickTotApplicable] [decimal](5, 2) NULL,
	[ImpliedProbabilityTotalTotApplicable] [decimal](5, 2) NULL,
	[ImpliedProbabilityOutrightHAAccuracy] [decimal](5, 2) NULL,
	[ImpliedProbabilityOutrightFDAccuracy] [decimal](5, 2) NULL,
	[ImpliedProbabilityOutrightPickAccuracy] [decimal](5, 2) NULL,
	[ImpliedProbabilitySpreadHAAccuracy] [decimal](5, 2) NULL,
	[ImpliedProbabilitySpreadFDAccuracy] [decimal](5, 2) NULL,
	[ImpliedProbabilitySpreadPickAccuracy] [decimal](5, 2) NULL,
	[ImpliedProbabilityTotalAccuracy] [decimal](5, 2) NULL,
	[ImpliedProbabilityOutrightHAAvgOdds] [decimal](5, 2) NULL,
	[ImpliedProbabilityOutrightFDAvgOdds] [decimal](5, 2) NULL,
	[ImpliedProbabilityOutrightPickAvgOdds] [decimal](5, 2) NULL,
	[ImpliedProbabilitySpreadHAAvgOdds] [decimal](5, 2) NULL,
	[ImpliedProbabilitySpreadFDAvgOdds] [decimal](5, 2) NULL,
	[ImpliedProbabilitySpreadPickAvgOdds] [decimal](5, 2) NULL,
	[ImpliedProbabilityTotalAvgOdds] [decimal](5, 2) NULL,
	[ImpliedProbabilityOutrightHAProfit] [decimal](5, 2) NULL,
	[ImpliedProbabilityOutrightFDProfit] [decimal](5, 2) NULL,
	[ImpliedProbabilityOutrightPickProfit] [decimal](5, 2) NULL,
	[ImpliedProbabilitySpreadHAProfit] [decimal](5, 2) NULL,
	[ImpliedProbabilitySpreadFDProfit] [decimal](5, 2) NULL,
	[ImpliedProbabilitySpreadPickProfit] [decimal](5, 2) NULL,
	[ImpliedProbabilityTotalProfit] [decimal](5, 2) NULL,
	[SeasonImpliedProbabilityWager] [decimal](8, 2) NULL,
	[SeasonImpliedProbabilityProfit] [decimal](8, 2) NULL,
	[SeasonImpliedProbabilityROI] [decimal](5, 2) NULL
) ON [PRIMARY]
GO


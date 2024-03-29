USE [ProFootballReference]
GO
/****** Object:  Table [dbo].[OddsImport]    Script Date: 8/28/2023 6:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OddsImport](
	[Date] [date] NULL,
	[HomeTeam] [varchar](50) NULL,
	[AwayTeam] [varchar](50) NULL,
	[HomeScore] [varchar](50) NULL,
	[AwayScore] [varchar](50) NULL,
	[Overtime] [varchar](50) NULL,
	[PlayoffGame] [varchar](50) NULL,
	[NeutralVenue] [varchar](50) NULL,
	[HomeOddsOpen] [varchar](50) NULL,
	[HomeOddsMin] [varchar](50) NULL,
	[HomeOddsMax] [varchar](50) NULL,
	[HomeOddsClose] [varchar](50) NULL,
	[AwayOddsOpen] [varchar](50) NULL,
	[AwayOddsMin] [varchar](50) NULL,
	[AwayOddsMax] [varchar](50) NULL,
	[AwayOddsClose] [varchar](50) NULL,
	[HomeLineOpen] [varchar](50) NULL,
	[HomeLineMin] [varchar](50) NULL,
	[HomeLineMax] [varchar](50) NULL,
	[HomeLineClose] [varchar](50) NULL,
	[AwayLineOpen] [varchar](50) NULL,
	[AwayLineMin] [varchar](50) NULL,
	[AwayLineMax] [varchar](50) NULL,
	[AwayLineClose] [varchar](50) NULL,
	[HomeLineOddsOpen] [varchar](50) NULL,
	[HomeLineOddsMin] [varchar](50) NULL,
	[HomeLineOddsMax] [varchar](50) NULL,
	[HomeLineOddsClose] [varchar](50) NULL,
	[AwayLineOddsOpen] [varchar](50) NULL,
	[AwayLineOddsMin] [varchar](50) NULL,
	[AwayLineOddsMax] [varchar](50) NULL,
	[AwayLineOddsClose] [varchar](50) NULL,
	[TotalScoreOpen] [varchar](50) NULL,
	[TotalScoreMin] [varchar](50) NULL,
	[TotalScoreMax] [varchar](50) NULL,
	[TotalScoreClose] [varchar](50) NULL,
	[TotalScoreOverOpen] [varchar](50) NULL,
	[TotalScoreOverMin] [varchar](50) NULL,
	[TotalScoreOverMax] [varchar](50) NULL,
	[TotalScoreOverClose] [varchar](50) NULL,
	[TotalScoreUnderOpen] [varchar](50) NULL,
	[TotalScoreUnderMin] [varchar](50) NULL,
	[TotalScoreUnderMax] [varchar](50) NULL,
	[TotalScoreUnderClose] [varchar](50) NULL
) ON [PRIMARY]
GO

USE [ProFootballReference]
GO

/****** Object:  Table [dbo].[SeasonDataAggregateCache]    Script Date: 8/28/2023 5:02:55 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SeasonDataAggregateCache](
	[Season] [int] NULL,
	[SeasonWager] [float] NULL,
	[SeasonProfit] [decimal](8, 2) NULL,
	[OneUnitThreshold] [decimal](5, 2) NULL,
	[FiveUnitThreshold] [decimal](5, 2) NULL,
	[TenUnitThreshold] [decimal](5, 2) NULL
) ON [PRIMARY]
GO


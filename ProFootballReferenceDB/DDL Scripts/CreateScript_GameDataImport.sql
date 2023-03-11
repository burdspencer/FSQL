USE [ProFootballReference]
GO

/****** Object:  Table [dbo].[GameDataImport]    Script Date: 3/10/2023 11:19:59 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[GameDataImport](
	[GameDataId] [int] IDENTITY(1,1) NOT NULL,
	[Week] [varchar](100) NULL,
	[Day] [varchar](100) NULL,
	[Date] [varchar](100) NULL,
	[Time] [varchar](100) NULL,
	[Season] [varchar](100) NULL,
	[Result] [varchar](100) NULL,
	[OT] [varchar](100) NULL,
	[Record] [varchar](100) NULL,
	[Team] [varchar](100) NULL,
	[VisitorFlag] [varchar](100) NULL,
	[Opponent] [varchar](100) NULL,
	[TeamScore] [varchar](100) NULL,
	[OpponentScore] [varchar](100) NULL,
	[Off1stD] [varchar](100) NULL,
	[OffTotYd] [varchar](100) NULL,
	[OffPassYd] [varchar](100) NULL,
	[OffRushYd] [varchar](100) NULL,
	[OffTO] [varchar](100) NULL,
	[Def1stD] [varchar](100) NULL,
	[DefTotYd] [varchar](100) NULL,
	[DefPassYd] [varchar](100) NULL,
	[DefRushYd] [varchar](100) NULL,
	[DefTO] [varchar](100) NULL,
	[ExPointsOff] [varchar](100) NULL,
	[ExPointsDef] [varchar](100) NULL,
	[ExPointsSpecial] [varchar](100) NULL
) ON [PRIMARY]
GO


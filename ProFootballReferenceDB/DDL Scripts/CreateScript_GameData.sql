USE [ProFootballReference]
GO

/****** Object:  Table [dbo].[GameData]    Script Date: 3/10/2023 11:20:11 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[GameData](
	[GameDataId] [int] IDENTITY(1,1) NOT NULL,
	[HomeTeam] [varchar](100) NOT NULL,
	[AwayTeam] [varchar](100) NOT NULL,
	[Week] [varchar](20) NOT NULL,
	[Day] [varchar](5) NOT NULL,
	[Time] [varchar](25) NOT NULL,
	[Date] [date] NOT NULL,
	[Season] [int] NOT NULL,
	[HomeResult] [varchar](100) NULL,
	[AwayResult] [varchar](100) NULL,
	[HomeRecord] [varchar](100) NULL,
	[AwayRecord] [varchar](100) NULL,
	[HomeScore] [int] NOT NULL,
	[AwayScore] [int] NOT NULL,
	[HomeOff1stD] [int] NULL,
	[HomeOffTotYd] [int] NULL,
	[HomeOffPassYd] [int] NULL,
	[HomeOffRushYd] [int] NULL,
	[HomeOffTO] [int] NULL,
	[HomeDef1stD] [int] NULL,
	[HomeDefTotYd] [int] NULL,
	[HomeDefPassYd] [int] NULL,
	[HomeDefRushYd] [int] NULL,
	[HomeDefTO] [int] NULL,
	[HomeExPointsOff] [decimal](5, 2) NULL,
	[HomeExPointsDef] [decimal](5, 2) NULL,
	[HomeExPointsSpecial] [decimal](5, 2) NULL,
	[AwayOff1stD] [int] NULL,
	[AwayOffTotYd] [int] NULL,
	[AwayOffPassYd] [int] NULL,
	[AwayOffRushYd] [int] NULL,
	[AwayOffTO] [int] NULL,
	[AwayDef1stD] [int] NULL,
	[AwayDefTotYd] [int] NULL,
	[AwayDefPassYd] [int] NULL,
	[AwayDefRushYd] [int] NULL,
	[AwayDefTO] [int] NULL,
	[AwayExPointsOff] [decimal](5, 2) NULL,
	[AwayExPointsDef] [decimal](5, 2) NULL,
	[AwayExPointsSpecial] [decimal](5, 2) NULL
) ON [PRIMARY]
GO


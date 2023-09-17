USE [ProFootballReference]
GO
/****** Object:  Table [dbo].[TeamLogos]    Script Date: 8/28/2023 6:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TeamLogos](
	[TeamName] [varchar](75) NULL,
	[LogoURL] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

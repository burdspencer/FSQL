USE [ProFootballReference]
GO
/****** Object:  View [dbo].[ssv_ListTeams]    Script Date: 8/28/2023 6:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ssv_ListTeams]
AS
	SELECT TOP(35) HomeTeam
	FROM GameData
	GROUP BY HomeTeam
	ORDER BY HomeTeam 
	ASC
GO

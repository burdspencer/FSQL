USE [ProFootballReference]
GO
/****** Object:  UserDefinedFunction [dbo].[ssf_SeasonStatsUpTo]    Script Date: 8/28/2023 6:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Spencer Burd
-- Create date: 03/22/23
-- Description:	Get Last 5 Games for a given team
-- =============================================
CREATE FUNCTION [dbo].[ssf_SeasonStatsUpTo]
(	
	-- Add the parameters for the function here
	  @Team VARCHAR(100)
	, @Season INT
	, @Week VARCHAR(25)
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
	SELECT TOP 20
		   @Team as TeamParam
		 , @Season as SeasonParam
		 , @Week as WeekParam
	     , CASE WHEN HomeTeam = @Team THEN HomeTeam ELSE AwayTeam END as Team
	     , Week
	     , Day
	     , Time
	     , Date
	     , Season
	     , CASE WHEN HomeTeam = @Team THEN 'Y' ELSE 'N' END as HomeFlag
		 , CASE WHEN HomeTeam =  @Team THEN HomeResult		   ELSE AwayResult			END AS Result
	     , CASE WHEN HomeTeam =  @Team THEN HomeScore		   ELSE AwayScore			END AS Score
	     , CASE WHEN HomeTeam =  @Team THEN HomeOff1stD		   ELSE AwayOff1stD			END AS Off1stD
	     , CASE WHEN HomeTeam =  @Team THEN HomeOffTotYd	   ELSE AwayOffTotYd		END AS OffTotYd
	     , CASE WHEN HomeTeam =  @Team THEN HomeOffPassYd	   ELSE AwayOffPassYd		END as OffPassYd
	     , CASE WHEN HomeTeam =  @Team THEN HomeOffRushYd	   ELSE AwayOffRushYd		END AS OffRushYd
	     , CASE WHEN HomeTeam =  @Team THEN HomeOffTO		   ELSE AwayOffTO			END AS OffTO
	     , CASE WHEN HomeTeam =  @Team THEN HomeDef1stD		   ELSE AwayDef1stD			END AS Def1stD
	     , CASE WHEN HomeTeam =  @Team THEN HomeDefTotYd	   ELSE AwayDefTotYd		END AS DefTotYd
	     , CASE WHEN HomeTeam =  @Team THEN HomeDefPassYd	   ELSE AwayDefPassYd		END AS DefPassYd
	     , CASE WHEN HomeTeam =  @Team THEN HomeDefRushYd	   ELSE AwayDefRushYd		END AS DefRushYd
	     , CASE WHEN HomeTeam =  @Team THEN HomeDefTO		   ELSE AwayDefTO			END AS DefTO
	     , CASE WHEN HomeTeam =  @Team THEN HomeExPointsOff	   ELSE AwayExPointsOff		END AS ExPointsOff
	     , CASE WHEN HomeTeam =  @Team THEN HomeExPointsDef	   ELSE AwayExPointsDef		END AS ExPointsDef
	     , CASE WHEN HomeTeam =  @Team THEN HomeExPointsSpecial ELSE AwayExPointsSpecial END AS ExPointsSpecial
	FROM GameData
	WHERE Season = @Season
	AND  (HomeTeam = @Team OR AwayTeam = @Team)
	AND   Week
			< 
		  CAST(CASE WHEN @Week = 'Wild Card' THEN 50 
			   WHEN @Week = 'Division' THEN 65
			   WHEN @Week = 'Conf. Champ.' THEN 75 
			   WHEN @Week = 'SuperBowl' THEN 100 
			   ELSE CAST(@Week as INT)
			   END AS Int)
	ORDER BY Week DESC

)
GO

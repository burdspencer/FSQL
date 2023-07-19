SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Spencer Burd
-- Create date: 03/22/23
-- Description:	Get Last 5 Games for a given team
-- =============================================
ALTER FUNCTION ssf_LastGameStats
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
	SELECT TOP 1
		   @Team as Team
		 , @Season as Season
		 , Week
	     , CAST(CASE WHEN HomeTeam =  @Team THEN HomeScore			ELSE AwayScore			  END AS DECIMAL(7,2)) AS PointsFor
	     , CAST(CASE WHEN HomeTeam =  @Team THEN AwayScore			ELSE HomeScore			  END AS DECIMAL(7,2)) AS PointsAgainst
	     , CAST(CASE WHEN HomeTeam =  @Team THEN HomeOff1stD		ELSE AwayOff1stD		  END AS DECIMAL(7,2)) AS Off1stD
	     , CAST(CASE WHEN HomeTeam =  @Team THEN HomeOffTotYd		ELSE AwayOffTotYd		  END AS DECIMAL(7,2)) AS OffTotYd
	     , CAST(CASE WHEN HomeTeam =  @Team THEN HomeOffPassYd		ELSE AwayOffPassYd		  END AS DECIMAL(7,2)) as OffPassYd
	     , CAST(CASE WHEN HomeTeam =  @Team THEN HomeOffRushYd		ELSE AwayOffRushYd		  END AS DECIMAL(7,2)) AS OffRushYd
	     , CAST(CASE WHEN HomeTeam =  @Team THEN HomeOffTO			ELSE AwayOffTO			  END AS DECIMAL(7,2)) AS OffTO
	     , CAST(CASE WHEN HomeTeam =  @Team THEN HomeDef1stD		ELSE AwayDef1stD		  END AS DECIMAL(7,2)) AS Def1stD
	     , CAST(CASE WHEN HomeTeam =  @Team THEN HomeDefTotYd		ELSE AwayDefTotYd		  END AS DECIMAL(7,2)) AS DefTotYd
	     , CAST(CASE WHEN HomeTeam =  @Team THEN HomeDefPassYd		ELSE AwayDefPassYd		  END AS DECIMAL(7,2)) AS DefPassYd
	     , CAST(CASE WHEN HomeTeam =  @Team THEN HomeDefRushYd		ELSE AwayDefRushYd		  END AS DECIMAL(7,2)) AS DefRushYd
	     , CAST(CASE WHEN HomeTeam =  @Team THEN HomeDefTO			ELSE AwayDefTO			  END AS DECIMAL(7,2)) AS DefTO
	     , CAST(CASE WHEN HomeTeam =  @Team THEN HomeExPointsOff	ELSE AwayExPointsOff	  END AS DECIMAL(7,2)) AS ExPointsOff
	     , CAST(CASE WHEN HomeTeam =  @Team THEN HomeExPointsDef	ELSE AwayExPointsDef	  END AS DECIMAL(7,2)) AS ExPointsDef
	     , CAST(CASE WHEN HomeTeam =  @Team THEN HomeExPointsSpecial ELSE AwayExPointsSpecial END AS DECIMAL(7,2)) AS ExPointsSpecial
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

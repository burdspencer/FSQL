SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Spencer Burd
-- Create date: 03/22/23
-- Description:	Get Last 5 Games for a given team
-- =============================================
ALTER FUNCTION ssf_AggSeasonStatsUpTo
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
		   @Team as Team
		 , @Season as Season
	     , AVG(CAST(CASE WHEN HomeTeam =  @Team THEN HomeScore			ELSE AwayScore			  END AS DECIMAL(7,2))) AS AvgPointsFor
	     , AVG(CAST(CASE WHEN HomeTeam =  @Team THEN AwayScore			ELSE HomeScore			  END AS DECIMAL(7,2))) AS AvgPointsAgainst
	     , AVG(CAST(CASE WHEN HomeTeam =  @Team THEN HomeOff1stD		ELSE AwayOff1stD		  END AS DECIMAL(7,2))) AS AvgOff1stD
	     , AVG(CAST(CASE WHEN HomeTeam =  @Team THEN HomeOffTotYd		ELSE AwayOffTotYd		  END AS DECIMAL(7,2))) AS AvgOffTotYd
	     , AVG(CAST(CASE WHEN HomeTeam =  @Team THEN HomeOffPassYd		ELSE AwayOffPassYd		  END AS DECIMAL(7,2))) as AvgOffPassYd
	     , AVG(CAST(CASE WHEN HomeTeam =  @Team THEN HomeOffRushYd		ELSE AwayOffRushYd		  END AS DECIMAL(7,2))) AS AvgOffRushYd
	     , AVG(CAST(CASE WHEN HomeTeam =  @Team THEN HomeOffTO			ELSE AwayOffTO			  END AS DECIMAL(7,2))) AS AvgOffTO
	     , AVG(CAST(CASE WHEN HomeTeam =  @Team THEN HomeDef1stD		ELSE AwayDef1stD		  END AS DECIMAL(7,2))) AS AvgDef1stD
	     , AVG(CAST(CASE WHEN HomeTeam =  @Team THEN HomeDefTotYd		ELSE AwayDefTotYd		  END AS DECIMAL(7,2))) AS AvgDefTotYd
	     , AVG(CAST(CASE WHEN HomeTeam =  @Team THEN HomeDefPassYd		ELSE AwayDefPassYd		  END AS DECIMAL(7,2))) AS AvgDefPassYd
	     , AVG(CAST(CASE WHEN HomeTeam =  @Team THEN HomeDefRushYd		ELSE AwayDefRushYd		  END AS DECIMAL(7,2))) AS AvgDefRushYd
	     , AVG(CAST(CASE WHEN HomeTeam =  @Team THEN HomeDefTO			ELSE AwayDefTO			  END AS DECIMAL(7,2))) AS AvgDefTO
	     , AVG(CAST(CASE WHEN HomeTeam =  @Team THEN HomeExPointsOff	ELSE AwayExPointsOff	  END AS DECIMAL(7,2))) AS AvgExPointsOff
	     , AVG(CAST(CASE WHEN HomeTeam =  @Team THEN HomeExPointsDef	ELSE AwayExPointsDef	  END AS DECIMAL(7,2))) AS AvgExPointsDef
	     , AVG(CAST(CASE WHEN HomeTeam =  @Team THEN HomeExPointsSpecial ELSE AwayExPointsSpecial END AS DECIMAL(7,2))) AS AvgExPointsSpecial
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
	GROUP BY Season,CASE WHEN HomeTeam = @Team THEN HomeTeam ELSE AwayTeam END

)
GO

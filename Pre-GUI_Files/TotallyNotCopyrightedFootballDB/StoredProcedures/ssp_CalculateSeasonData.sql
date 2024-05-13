IF OBJECT_ID('ssp_CalculateSeasonData','P') IS NOT NULL
	DROP PROCEDURE ssp_CalculateSeasonData
	GO

CREATE PROCEDURE ssp_CalculateSeasonData

AS
BEGIN TRY
	DECLARE @Season INT

	IF OBJECT_ID('tempdb..#SeasonAverages','U') IS NOT NULL
		DROP TABLE #SeasonAverages

	CREATE TABLE #SeasonAverages (
	 Season							INT
	,SeasonTotalUnderRate			DECIMAL(5,2)
	,SeasonTotalPushRate			DECIMAL(5,2)
	,SeasonTotalOverRate			DECIMAL(5,2)
	,HomeUnderdogSpreadCoverRate	DECIMAL(5,2)
	,HomeFavoriteSpreadCoverRate	DECIMAL(5,2)
	,AwayUnderdogSpreadCoverRate	DECIMAL(5,2)
	,AwayFavoriteSpreadCoverRate	DECIMAL(5,2)
	,HomeSpreadCoverRate			DECIMAL(5,2)
	,AwaySpreadCoverRate			DECIMAL(5,2)
	,FavoriteSpreadCoverRate		DECIMAL(5,2)
	,DogSpreadCoverRate				DECIMAL(5,2)
	,HomeUnderdogOutrightRate		DECIMAL(5,2)
	,HomeFavoriteOutrightRate		DECIMAL(5,2)
	,AwayUnderdogOutrightRate		DECIMAL(5,2)
	,AwayFavoriteOutrightRate		DECIMAL(5,2)
	,HomeOutrightRate				DECIMAL(5,2)
	,AwayOutrightRate				DECIMAL(5,2)
	,FavoriteOutrightRate			DECIMAL(5,2)
	,DogOutrightRate				DECIMAL(5,2)
	)

	
	INSERT INTO #SeasonAverages (Season) 
	SELECT Season
	FROM GameData
	WHERE Season >= 2014
	GROUP BY Season
	ORDER BY Season

	--Total O/U
	UPDATE sa SET SeasonTotalOverRate = CAST((SELECT COUNT(*) FROM GameData gd WHERE sa.Season = gd.Season AND (HomeScore + AwayScore > TotalScoreClose) AND TotalScoreClose IS NOT NULL) as float) / CAST((SELECT COUNT(*) FROM GameData gd WHERE sa.Season = gd.Season AND TotalScoreClose IS NOT NULL) as float)
	FROM #SeasonAverages sa 
	WHERE (SELECT COUNT(*) FROM GameData gd WHERE sa.Season = gd.Season AND TotalScoreClose IS NOT NULL) <> 0

	UPDATE sa SET SeasonTotalUnderRate = CAST((SELECT COUNT(*) FROM GameData gd WHERE sa.Season = gd.Season AND (HomeScore + AwayScore < TotalScoreClose) AND TotalScoreClose IS NOT NULL) as float) / CAST((SELECT COUNT(*) FROM GameData gd WHERE sa.Season = gd.Season AND TotalScoreClose IS NOT NULL) as float)
	FROM #SeasonAverages sa 
	WHERE (SELECT COUNT(*) FROM GameData gd WHERE sa.Season = gd.Season AND TotalScoreClose IS NOT NULL) <> 0

	UPDATE sa SET SeasonTotalPushRate = CAST((SELECT COUNT(*) FROM GameData gd WHERE sa.Season = gd.Season AND (HomeScore + AwayScore = TotalScoreClose) AND TotalScoreClose IS NOT NULL) as float) / CAST((SELECT COUNT(*) FROM GameData gd WHERE sa.Season = gd.Season AND TotalScoreClose IS NOT NULL) as float)
	FROM #SeasonAverages sa 
	WHERE (SELECT COUNT(*) FROM GameData gd WHERE sa.Season = gd.Season AND TotalScoreClose IS NOT NULL) <> 0

	--Outright
	UPDATE sa SET HomeFavoriteOutrightRate = CAST((SELECT COUNT(*) FROM GameData gd WHERE sa.Season = gd.Season AND (HomeScore > AwayScore) AND HomeLineClose < AwayLineClose) as float) / CAST((SELECT COUNT(*) FROM GameData gd WHERE sa.Season = gd.Season AND HomeLineClose < AwayLineClose) as float)
	FROM #SeasonAverages sa 
	WHERE (SELECT COUNT(*) FROM GameData gd WHERE sa.Season = gd.Season AND HomeLineClose < AwayLineClose) <> 0

	UPDATE sa SET HomeUnderdogOutrightRate = CAST((SELECT COUNT(*) FROM GameData gd WHERE sa.Season = gd.Season AND (HomeScore > AwayScore) AND HomeLineClose > AwayLineClose) as float) / CAST((SELECT COUNT(*) FROM GameData gd WHERE sa.Season = gd.Season AND HomeLineClose > AwayLineClose) as float)
	FROM #SeasonAverages sa 
	WHERE (SELECT COUNT(*) FROM GameData gd WHERE sa.Season = gd.Season AND HomeLineClose > AwayLineClose) <> 0

	UPDATE sa SET AwayFavoriteOutrightRate = CAST((SELECT COUNT(*) FROM GameData gd WHERE sa.Season = gd.Season AND (HomeScore < AwayScore) AND HomeLineClose > AwayLineClose) as float) / CAST((SELECT COUNT(*) FROM GameData gd WHERE sa.Season = gd.Season AND HomeLineClose > AwayLineClose) as float)
	FROM #SeasonAverages sa 
	WHERE (SELECT COUNT(*) FROM GameData gd WHERE sa.Season = gd.Season AND HomeLineClose > AwayLineClose) <> 0

	UPDATE sa SET AwayUnderdogOutrightRate = CAST((SELECT COUNT(*) FROM GameData gd WHERE sa.Season = gd.Season AND (HomeScore < AwayScore) AND HomeLineClose < AwayLineClose) as float) / CAST((SELECT COUNT(*) FROM GameData gd WHERE sa.Season = gd.Season AND HomeLineClose < AwayLineClose) as float)
	FROM #SeasonAverages sa 
	WHERE (SELECT COUNT(*) FROM GameData gd WHERE sa.Season = gd.Season AND HomeLineClose < AwayLineClose) <> 0

	UPDATE sa SET HomeOutrightRate = CAST((SELECT COUNT(*) FROM GameData gd WHERE sa.Season = gd.Season AND (HomeScore > AwayScore)) as float) / CAST((SELECT COUNT(*) FROM GameData gd WHERE sa.Season = gd.Season) as float)
	FROM #SeasonAverages sa 
	WHERE (SELECT COUNT(*) FROM GameData gd WHERE sa.Season = gd.Season) <> 0

	UPDATE sa SET AwayOutrightRate = CAST((SELECT COUNT(*) FROM GameData gd WHERE sa.Season = gd.Season AND (HomeScore < AwayScore)) as float) / CAST((SELECT COUNT(*) FROM GameData gd WHERE sa.Season = gd.Season) as float)
	FROM #SeasonAverages sa 
	WHERE (SELECT COUNT(*) FROM GameData gd WHERE sa.Season = gd.Season) <> 0

	
	UPDATE sa SET DogOutrightRate = CAST((SELECT COUNT(*) FROM GameData gd WHERE sa.Season = gd.Season AND    CASE WHEN gd.HomeOddsClose < AwayOddsClose THEN  HomeScore
																												   WHEN gd.HomeOddsClose > AwayOddsClose THEN AwayScore END 
																												   < 
																											  CASE WHEN gd.HomeOddsClose < AwayOddsClose THEN AwayScore
																												   WHEN gd.HomeOddsClose > AwayOddsClose THEN HomeScore END) as float) 
																												/ CAST((SELECT COUNT(*) FROM GameData gd WHERE sa.Season = gd.Season) as float)
	FROM #SeasonAverages sa 
	WHERE (SELECT COUNT(*) FROM GameData gd WHERE sa.Season = gd.Season) <> 0

	UPDATE sa SET FavoriteOutrightRate = CAST((SELECT COUNT(*) FROM GameData gd WHERE sa.Season = gd.Season AND CASE WHEN gd.HomeOddsClose < AwayOddsClose THEN  HomeScore
																													    WHEN gd.HomeOddsClose > AwayOddsClose THEN AwayScore END 
																													   > 
																												   CASE WHEN gd.HomeOddsClose < AwayOddsClose THEN AwayScore
																													    WHEN gd.HomeOddsClose > AwayOddsClose THEN HomeScore END) as float) 
																													/ CAST((SELECT COUNT(*) FROM GameData gd WHERE sa.Season = gd.Season) as float)
	FROM #SeasonAverages sa 
	WHERE (SELECT COUNT(*) FROM GameData gd WHERE sa.Season = gd.Season AND	CASE WHEN gd.HomeOddsClose < AwayLineClose THEN  HomeScore
																			     WHEN gd.HomeOddsClose > AwayOddsClose THEN AwayScore END 
																		    > 
																		    CASE WHEN gd.HomeOddsClose < AwayOddsClose THEN AwayScore
																			     WHEN gd.HomeOddsClose > AwayOddsClose THEN HomeScore END) <> 0

	--Spread

	UPDATE sa SET HomeFavoriteSpreadCoverRate = CAST((SELECT COUNT(*) FROM GameData gd WHERE sa.Season = gd.Season AND gd.HomeLineOddsClose < AwayLineOddsClose AND HomeScore + HomeLineClose > AwayScore) as float) / CAST((SELECT COUNT(*) FROM GameData gd WHERE sa.Season = gd.Season AND HomeLineOddsClose < AwayLineOddsClose) as float)
	FROM #SeasonAverages sa 
	WHERE (SELECT COUNT(*) FROM GameData gd WHERE sa.Season = gd.Season AND HomeLineOddsClose < AwayLineOddsClose) <> 0

	UPDATE sa SET HomeUnderdogSpreadCoverRate = CAST((SELECT COUNT(*) FROM GameData gd WHERE sa.Season = gd.Season AND gd.HomeLineOddsClose > AwayLineOddsClose AND HomeScore + HomeLineClose > AwayScore) as float) / CAST((SELECT COUNT(*) FROM GameData gd WHERE sa.Season = gd.Season AND gd.HomeLineOddsClose > AwayLineOddsClose) as float)
	FROM #SeasonAverages sa 
	WHERE (SELECT COUNT(*) FROM GameData gd WHERE sa.Season = gd.Season AND HomeLineOddsClose > AwayLineOddsClose) <> 0

	UPDATE sa SET AwayFavoriteSpreadCoverRate = CAST((SELECT COUNT(*) FROM GameData gd WHERE sa.Season = gd.Season AND gd.HomeLineOddsClose > AwayLineOddsClose AND AwayScore + AwayLineClose > HomeScore) as float) / CAST((SELECT COUNT(*) FROM GameData gd WHERE sa.Season = gd.Season AND HomeLineOddsClose > AwayLineOddsClose) as float)
	FROM #SeasonAverages sa 
	WHERE (SELECT COUNT(*) FROM GameData gd WHERE sa.Season = gd.Season AND HomeLineOddsClose > AwayLineOddsClose) <> 0

	UPDATE sa SET AwayUnderdogSpreadCoverRate = CAST((SELECT COUNT(*) FROM GameData gd WHERE sa.Season = gd.Season AND gd.HomeLineOddsClose < AwayLineOddsClose AND AwayScore + AwayLineClose > HomeScore) as float) / CAST((SELECT COUNT(*) FROM GameData gd WHERE sa.Season = gd.Season AND gd.HomeLineOddsClose < AwayLineOddsClose) as float)
	FROM #SeasonAverages sa 
	WHERE (SELECT COUNT(*) FROM GameData gd WHERE sa.Season = gd.Season AND HomeLineOddsClose < AwayLineOddsClose) <> 0

	UPDATE sa SET HomeSpreadCoverRate = CAST((SELECT COUNT(*) FROM GameData gd WHERE sa.Season = gd.Season AND HomeScore + HomeLineClose > AwayScore) as float) / CAST((SELECT COUNT(*) FROM GameData gd WHERE sa.Season = gd.Season) as float)
	FROM #SeasonAverages sa 
	WHERE (SELECT COUNT(*) FROM GameData gd WHERE sa.Season = gd.Season) <> 0

	UPDATE sa SET AwaySpreadCoverRate = CAST((SELECT COUNT(*) FROM GameData gd WHERE sa.Season = gd.Season AND AwayScore + AwayLineClose > HomeScore) as float) / CAST((SELECT COUNT(*) FROM GameData gd WHERE sa.Season = gd.Season) as float)
	FROM #SeasonAverages sa 
	WHERE (SELECT COUNT(*) FROM GameData gd WHERE sa.Season = gd.Season) <> 0

	UPDATE sa SET DogSpreadCoverRate = CAST((SELECT COUNT(*) FROM GameData gd WHERE sa.Season = gd.Season AND CASE WHEN gd.HomeLineClose < AwayLineClose THEN  HomeScore + HomeLineClose 
																												   WHEN gd.HomeLineClose > AwayLineClose THEN AwayScore + AwayLineClose END 
																												   < 
																											  CASE WHEN gd.HomeLineClose < AwayLineClose THEN AwayScore
																												   WHEN gd.HomeLineClose > AwayLineClose THEN HomeScore END) as float) 
																												/ CAST((SELECT COUNT(*) FROM GameData gd WHERE sa.Season = gd.Season) as float)
	FROM #SeasonAverages sa 
	WHERE (SELECT COUNT(*) FROM GameData gd WHERE sa.Season = gd.Season) <> 0

	UPDATE sa SET FavoriteSpreadCoverRate = CAST((SELECT COUNT(*) FROM GameData gd WHERE sa.Season = gd.Season AND CASE WHEN gd.HomeLineClose < AwayLineClose THEN  HomeScore + HomeLineClose 
																													    WHEN gd.HomeLineClose > AwayLineClose THEN AwayScore + AwayLineClose END 
																													   > 
																												   CASE WHEN gd.HomeLineClose < AwayLineClose THEN AwayScore
																													    WHEN gd.HomeLineClose > AwayLineClose THEN HomeScore END) as float) 
																													/ CAST((SELECT COUNT(*) FROM GameData gd WHERE sa.Season = gd.Season) as float)
	FROM #SeasonAverages sa 
	WHERE (SELECT COUNT(*) FROM GameData gd WHERE sa.Season = gd.Season AND CASE WHEN gd.HomeLineClose < AwayLineClose THEN  HomeScore + HomeLineClose 
																													    WHEN gd.HomeLineClose > AwayLineClose THEN AwayScore + AwayLineClose END 
																													   > 
																												   CASE WHEN gd.HomeLineClose < AwayLineClose THEN AwayScore
																													    WHEN gd.HomeLineClose > AwayLineClose THEN HomeScore END) <> 0

	TRUNCATE TABLE Seasons

	INSERT INTO Seasons(
	Season							
	,SeasonTotalUnderRate			
	,SeasonTotalPushRate			
	,SeasonTotalOverRate			
	,HomeUnderdogSpreadCoverRate	
	,HomeFavoriteSpreadCoverRate	
	,AwayUnderdogSpreadCoverRate	
	,AwayFavoriteSpreadCoverRate	
	,HomeSpreadCoverRate			
	,AwaySpreadCoverRate			
	,FavoriteSpreadCoverRate		
	,DogSpreadCoverRate				
	,HomeUnderdogOutrightRate		
	,HomeFavoriteOutrightRate		
	,AwayUnderdogOutrightRate		
	,AwayFavoriteOutrightRate		
	,HomeOutrightRate				
	,AwayOutrightRate				
	,FavoriteOutrightRate			
	,DogOutrightRate				
	)
	SELECT 
	 Season							
	,SeasonTotalUnderRate			
	,SeasonTotalPushRate			
	,SeasonTotalOverRate			
	,HomeUnderdogSpreadCoverRate	
	,HomeFavoriteSpreadCoverRate	
	,AwayUnderdogSpreadCoverRate	
	,AwayFavoriteSpreadCoverRate	
	,HomeSpreadCoverRate			
	,AwaySpreadCoverRate			
	,FavoriteSpreadCoverRate		
	,DogSpreadCoverRate				
	,HomeUnderdogOutrightRate		
	,HomeFavoriteOutrightRate		
	,AwayUnderdogOutrightRate		
	,AwayFavoriteOutrightRate		
	,HomeOutrightRate				
	,AwayOutrightRate				
	,FavoriteOutrightRate			
	,DogOutrightRate				
	FROM #SeasonAverages
	ORDER BY Season ASC


	TRUNCATE TABLE #SeasonAverages

	DROP TABLE #SeasonAverages

END TRY
BEGIN CATCH
	SELECT ERROR_MESSAGE(), ERROR_LINE(), ERROR_PROCEDURE()
END CATCH
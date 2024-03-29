USE [ProFootballReference]
GO
/****** Object:  StoredProcedure [dbo].[ssp_CalculateSeasonData]    Script Date: 8/28/2023 6:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_CalculateSeasonData]
AS
BEGIN TRY
	DECLARE @Season INT

	IF OBJECT_ID('tempdb..#SeasonAverages', 'U') IS NOT NULL
		DROP TABLE #SeasonAverages

	CREATE TABLE #SeasonAverages (Season INT, SeasonTotalUnderRate DECIMAL(5, 2), SeasonTotalPushRate DECIMAL(5, 2), SeasonTotalOverRate DECIMAL(5, 2), HomeUnderdogSpreadCoverRate DECIMAL(5, 2), HomeFavoriteSpreadCoverRate DECIMAL(5, 2), AwayUnderdogSpreadCoverRate DECIMAL(5, 2), AwayFavoriteSpreadCoverRate DECIMAL(5, 2), HomeSpreadCoverRate DECIMAL(5, 2), AwaySpreadCoverRate DECIMAL(5, 2), FavoriteSpreadCoverRate DECIMAL(5, 2), DogSpreadCoverRate DECIMAL(5, 2), HomeUnderdogOutrightRate DECIMAL(5, 2), HomeFavoriteOutrightRate DECIMAL(5, 2), AwayUnderdogOutrightRate DECIMAL(5, 2), AwayFavoriteOutrightRate DECIMAL(5, 2), HomeOutrightRate DECIMAL(5, 2), AwayOutrightRate DECIMAL(5, 2), FavoriteOutrightRate DECIMAL(5, 2), DogOutrightRate DECIMAL(5, 2))

	INSERT INTO #SeasonAverages (Season)
	SELECT Season
	FROM GameData
	WHERE Season >= 2014
	GROUP BY Season
	ORDER BY Season

	--Total O/U
	UPDATE sa
	SET SeasonTotalOverRate = CAST((
				SELECT COUNT(1)
				FROM GameData gd
				WHERE sa.Season = gd.Season
					AND (HomeScore + AwayScore > COALESCE(TotalScoreClose, TotalScoreMax, TotalScoreMin, TotalScoreOpen))
					AND COALESCE(TotalScoreClose, TotalScoreMax, TotalScoreMin, TotalScoreOpen) IS NOT NULL
				) AS FLOAT) / CAST((
				SELECT COUNT(1)
				FROM GameData gd
				WHERE sa.Season = gd.Season
					AND COALESCE(TotalScoreClose, TotalScoreMax, TotalScoreMin, TotalScoreOpen) IS NOT NULL
				) AS FLOAT)
	FROM #SeasonAverages sa
	WHERE (
			SELECT COUNT(1)
			FROM GameData gd
			WHERE sa.Season = gd.Season
				AND COALESCE(TotalScoreClose, TotalScoreMax, TotalScoreMin, TotalScoreOpen) IS NOT NULL
			) <> 0

	UPDATE sa
	SET SeasonTotalUnderRate = CAST((
				SELECT COUNT(1)
				FROM GameData gd
				WHERE sa.Season = gd.Season
					AND (HomeScore + AwayScore < COALESCE(TotalScoreClose, TotalScoreMax, TotalScoreMin, TotalScoreOpen))
					AND COALESCE(TotalScoreClose, TotalScoreMax, TotalScoreMin, TotalScoreOpen) IS NOT NULL
				) AS FLOAT) / CAST((
				SELECT COUNT(1)
				FROM GameData gd
				WHERE sa.Season = gd.Season
					AND COALESCE(TotalScoreClose, TotalScoreMax, TotalScoreMin, TotalScoreOpen) IS NOT NULL
				) AS FLOAT)
	FROM #SeasonAverages sa
	WHERE (
			SELECT COUNT(1)
			FROM GameData gd
			WHERE sa.Season = gd.Season
				AND COALESCE(TotalScoreClose, TotalScoreMax, TotalScoreMin, TotalScoreOpen) IS NOT NULL
			) <> 0

	UPDATE sa
	SET SeasonTotalPushRate = CAST((
				SELECT COUNT(1)
				FROM GameData gd
				WHERE sa.Season = gd.Season
					AND (HomeScore + AwayScore = COALESCE(TotalScoreClose, TotalScoreMax, TotalScoreMin, TotalScoreOpen))
					AND COALESCE(TotalScoreClose, TotalScoreMax, TotalScoreMin, TotalScoreOpen) IS NOT NULL
				) AS FLOAT) / CAST((
				SELECT COUNT(1)
				FROM GameData gd
				WHERE sa.Season = gd.Season
					AND COALESCE(TotalScoreClose, TotalScoreMax, TotalScoreMin, TotalScoreOpen) IS NOT NULL
				) AS FLOAT)
	FROM #SeasonAverages sa
	WHERE (
			SELECT COUNT(1)
			FROM GameData gd
			WHERE sa.Season = gd.Season
				AND COALESCE(TotalScoreClose, TotalScoreMax, TotalScoreMin, TotalScoreOpen) IS NOT NULL
			) <> 0

	--Outright
	UPDATE sa
	SET HomeFavoriteOutrightRate = CAST((
				SELECT COUNT(1)
				FROM GameData gd
				WHERE sa.Season = gd.Season
					AND (HomeScore > AwayScore)
					AND COALESCE(HomeLineClose, HomeLineMax, HomeLineMin, HomeLineOpen) < COALESCE(AwayLineClose, AwayLineMax, AwayLineMin, AwayLineOpen)
				) AS FLOAT) / CAST((
				SELECT COUNT(1)
				FROM GameData gd
				WHERE sa.Season = gd.Season
					AND COALESCE(HomeLineClose, HomeLineMax, HomeLineMin, HomeLineOpen) < COALESCE(AwayLineClose, AwayLineMax, AwayLineMin, AwayLineOpen)
				) AS FLOAT)
	FROM #SeasonAverages sa
	WHERE (
			SELECT COUNT(1)
			FROM GameData gd
			WHERE sa.Season = gd.Season
				AND COALESCE(HomeLineClose, HomeLineMax, HomeLineMin, HomeLineOpen) < COALESCE(AwayLineClose, AwayLineMax, AwayLineMin, AwayLineOpen)
			) <> 0

	UPDATE sa
	SET HomeUnderdogOutrightRate = CAST((
				SELECT COUNT(1)
				FROM GameData gd
				WHERE sa.Season = gd.Season
					AND (HomeScore > AwayScore)
					AND COALESCE(HomeLineClose, HomeLineMax, HomeLineMin, HomeLineOpen) > COALESCE(AwayLineClose, AwayLineMax, AwayLineMin, AwayLineOpen)
				) AS FLOAT) / CAST((
				SELECT COUNT(1)
				FROM GameData gd
				WHERE sa.Season = gd.Season
					AND COALESCE(HomeLineClose, HomeLineMax, HomeLineMin, HomeLineOpen) > COALESCE(AwayLineClose, AwayLineMax, AwayLineMin, AwayLineOpen)
				) AS FLOAT)
	FROM #SeasonAverages sa
	WHERE (
			SELECT COUNT(1)
			FROM GameData gd
			WHERE sa.Season = gd.Season
				AND COALESCE(HomeLineClose, HomeLineMax, HomeLineMin, HomeLineOpen) > COALESCE(AwayLineClose, AwayLineMax, AwayLineMin, AwayLineOpen)
			) <> 0

	UPDATE sa
	SET AwayFavoriteOutrightRate = CAST((
				SELECT COUNT(1)
				FROM GameData gd
				WHERE sa.Season = gd.Season
					AND (HomeScore < AwayScore)
					AND COALESCE(HomeLineClose, HomeLineMax, HomeLineMin, HomeLineOpen) > COALESCE(AwayLineClose, AwayLineMax, AwayLineMin, AwayLineOpen)
				) AS FLOAT) / CAST((
				SELECT COUNT(1)
				FROM GameData gd
				WHERE sa.Season = gd.Season
					AND COALESCE(HomeLineClose, HomeLineMax, HomeLineMin, HomeLineOpen) > COALESCE(AwayLineClose, AwayLineMax, AwayLineMin, AwayLineOpen)
				) AS FLOAT)
	FROM #SeasonAverages sa
	WHERE (
			SELECT COUNT(1)
			FROM GameData gd
			WHERE sa.Season = gd.Season
				AND COALESCE(HomeLineClose, HomeLineMax, HomeLineMin, HomeLineOpen) > COALESCE(AwayLineClose, AwayLineMax, AwayLineMin, AwayLineOpen)
			) <> 0

	UPDATE sa
	SET AwayUnderdogOutrightRate = CAST((
				SELECT COUNT(1)
				FROM GameData gd
				WHERE sa.Season = gd.Season
					AND (HomeScore < AwayScore)
					AND COALESCE(HomeLineClose, HomeLineMax, HomeLineMin, HomeLineOpen) < COALESCE(AwayLineClose, AwayLineMax, AwayLineMin, AwayLineOpen)
				) AS FLOAT) / CAST((
				SELECT COUNT(1)
				FROM GameData gd
				WHERE sa.Season = gd.Season
					AND COALESCE(HomeLineClose, HomeLineMax, HomeLineMin, HomeLineOpen) < COALESCE(AwayLineClose, AwayLineMax, AwayLineMin, AwayLineOpen)
				) AS FLOAT)
	FROM #SeasonAverages sa
	WHERE (
			SELECT COUNT(1)
			FROM GameData gd
			WHERE sa.Season = gd.Season
				AND COALESCE(HomeLineClose, HomeLineMax, HomeLineMin, HomeLineOpen) < COALESCE(AwayLineClose, AwayLineMax, AwayLineMin, AwayLineOpen)
			) <> 0

	UPDATE sa
	SET HomeOutrightRate = CAST((
				SELECT COUNT(1)
				FROM GameData gd
				WHERE sa.Season = gd.Season
					AND (HomeScore > AwayScore)
				) AS FLOAT) / CAST((
				SELECT COUNT(1)
				FROM GameData gd
				WHERE sa.Season = gd.Season
				) AS FLOAT)
	FROM #SeasonAverages sa
	WHERE (
			SELECT COUNT(1)
			FROM GameData gd
			WHERE sa.Season = gd.Season
			) <> 0

	UPDATE sa
	SET AwayOutrightRate = CAST((
				SELECT COUNT(1)
				FROM GameData gd
				WHERE sa.Season = gd.Season
					AND (HomeScore < AwayScore)
				) AS FLOAT) / CAST((
				SELECT COUNT(1)
				FROM GameData gd
				WHERE sa.Season = gd.Season
				) AS FLOAT)
	FROM #SeasonAverages sa
	WHERE (
			SELECT COUNT(1)
			FROM GameData gd
			WHERE sa.Season = gd.Season
			) <> 0

	UPDATE sa
	SET DogOutrightRate = (CAST((SELECT COUNT(1)
				FROM GameData gd
				WHERE sa.Season = gd.Season
					AND (HomeScore < AwayScore)
					AND COALESCE(HomeLineClose, HomeLineMax, HomeLineMin, HomeLineOpen) < COALESCE(AwayLineClose, AwayLineMax, AwayLineMin, AwayLineOpen)
				) AS FLOAT) + CAST((SELECT COUNT(1)
				FROM GameData gd
				WHERE sa.Season = gd.Season
					AND (HomeScore > AwayScore)
					AND COALESCE(HomeLineClose, HomeLineMax, HomeLineMin, HomeLineOpen) > COALESCE(AwayLineClose, AwayLineMax, AwayLineMin, AwayLineOpen)
				) AS FLOAT)) / CAST((
				SELECT COUNT(1)
				FROM GameData gd
				WHERE sa.Season = gd.Season
				) AS FLOAT)
	FROM #SeasonAverages sa
	WHERE CAST((
				SELECT COUNT(1)
				FROM GameData gd
				WHERE sa.Season = gd.Season
					AND COALESCE(HomeOddsClose, HomeOddsMax, HomeOddsOpen, HomeOddsMin) IS NOT NULL
					AND COALESCE(AwayOddsClose, AwayOddsMax, AwayOddsOpen, AwayOddsMin) IS NOT NULL
				) AS FLOAT) <> 0

	UPDATE sa
	SET FavoriteOutrightRate = (CAST((SELECT COUNT(1)
				FROM GameData gd
				WHERE sa.Season = gd.Season
					AND (HomeScore < AwayScore)
					AND COALESCE(HomeLineClose, HomeLineMax, HomeLineMin, HomeLineOpen) > COALESCE(AwayLineClose, AwayLineMax, AwayLineMin, AwayLineOpen)
				) AS FLOAT) + CAST((SELECT COUNT(1)
				FROM GameData gd
				WHERE sa.Season = gd.Season
					AND (HomeScore > AwayScore)
					AND COALESCE(HomeLineClose, HomeLineMax, HomeLineMin, HomeLineOpen) < COALESCE(AwayLineClose, AwayLineMax, AwayLineMin, AwayLineOpen)
				) AS FLOAT)) / CAST((
				SELECT COUNT(1)
				FROM GameData gd
				WHERE sa.Season = gd.Season
				) AS FLOAT)
	FROM #SeasonAverages sa
	WHERE CAST((
				SELECT COUNT(1)
				FROM GameData gd
				WHERE sa.Season = gd.Season
					AND COALESCE(HomeOddsClose, HomeOddsMax, HomeOddsOpen, HomeOddsMin) IS NOT NULL
					AND COALESCE(AwayOddsClose, AwayOddsMax, AwayOddsOpen, AwayOddsMin) IS NOT NULL
				) AS FLOAT) <> 0

	--Spread
	UPDATE sa
	SET HomeFavoriteSpreadCoverRate = CAST((
				SELECT COUNT(1)
				FROM GameData gd
				WHERE sa.Season = gd.Season
					AND COALESCE(HomeLineOddsClose, HomeLineOddsMax, HomeLineOddsMin, HomeLineOddsOpen) < COALESCE(AwayLineOddsClose, AwayLineOddsMax, AwayLineOddsMin, AwayLineOddsOpen)
					AND HomeScore + COALESCE(HomeLineClose, HomeLineMax, HomeLineMin, HomeLineOpen) > AwayScore
				) AS FLOAT) / CAST((
				SELECT COUNT(1)
				FROM GameData gd
				WHERE sa.Season = gd.Season
					AND COALESCE(HomeLineOddsClose, HomeLineOddsMax, HomeLineOddsMin, HomeLineOddsOpen) < COALESCE(AwayLineOddsClose, AwayLineOddsMax, AwayLineOddsMin, AwayLineOddsOpen)
				) AS FLOAT)
	FROM #SeasonAverages sa
	WHERE (
			SELECT COUNT(1)
			FROM GameData gd
			WHERE sa.Season = gd.Season
				AND COALESCE(HomeLineOddsClose, HomeLineOddsMax, HomeLineOddsMin, HomeLineOddsOpen) < COALESCE(AwayLineOddsClose, AwayLineOddsMax, AwayLineOddsMin, AwayLineOddsOpen)
			) <> 0

	UPDATE sa
	SET HomeUnderdogSpreadCoverRate = CAST((
				SELECT COUNT(1)
				FROM GameData gd
				WHERE sa.Season = gd.Season
					AND COALESCE(HomeLineOddsClose, HomeLineOddsMax, HomeLineOddsMin, HomeLineOddsOpen) > COALESCE(AwayLineOddsClose, AwayLineOddsMax, AwayLineOddsMin, AwayLineOddsOpen)
					AND HomeScore + COALESCE(HomeLineClose, HomeLineMax, HomeLineMin, HomeLineOpen) > AwayScore
				) AS FLOAT) / CAST((
				SELECT COUNT(1)
				FROM GameData gd
				WHERE sa.Season = gd.Season
					AND COALESCE(HomeLineOddsClose, HomeLineOddsMax, HomeLineOddsMin, HomeLineOddsOpen) > COALESCE(AwayLineOddsClose, AwayLineOddsMax, AwayLineOddsMin, AwayLineOddsOpen)
				) AS FLOAT)
	FROM #SeasonAverages sa
	WHERE (
			SELECT COUNT(1)
			FROM GameData gd
			WHERE sa.Season = gd.Season
				AND COALESCE(HomeLineOddsClose, HomeLineOddsMax, HomeLineOddsMin, HomeLineOddsOpen) > COALESCE(AwayLineOddsClose, AwayLineOddsMax, AwayLineOddsMin, AwayLineOddsOpen)
			) <> 0

	UPDATE sa
	SET AwayFavoriteSpreadCoverRate = CAST((
				SELECT COUNT(1)
				FROM GameData gd
				WHERE sa.Season = gd.Season
					AND COALESCE(HomeLineOddsClose, HomeLineOddsMax, HomeLineOddsMin, HomeLineOddsOpen) > COALESCE(AwayLineOddsClose, AwayLineOddsMax, AwayLineOddsMin, AwayLineOddsOpen)
					AND AwayScore + COALESCE(AwayLineClose, AwayLineMax, AwayLineMin, AwayLineOpen) > HomeScore
				) AS FLOAT) / CAST((
				SELECT COUNT(1)
				FROM GameData gd
				WHERE sa.Season = gd.Season
					AND COALESCE(HomeLineOddsClose, HomeLineOddsMax, HomeLineOddsMin, HomeLineOddsOpen) > COALESCE(AwayLineOddsClose, AwayLineOddsMax, AwayLineOddsMin, AwayLineOddsOpen)
				) AS FLOAT)
	FROM #SeasonAverages sa
	WHERE (
			SELECT COUNT(1)
			FROM GameData gd
			WHERE sa.Season = gd.Season
				AND COALESCE(HomeLineOddsClose, HomeLineOddsMax, HomeLineOddsMin, HomeLineOddsOpen) > COALESCE(AwayLineOddsClose, AwayLineOddsMax, AwayLineOddsMin, AwayLineOddsOpen)
			) <> 0

	UPDATE sa
	SET AwayUnderdogSpreadCoverRate = CAST((
				SELECT COUNT(1)
				FROM GameData gd
				WHERE sa.Season = gd.Season
					AND COALESCE(HomeLineOddsClose, HomeLineOddsMax, HomeLineOddsMin, HomeLineOddsOpen) < COALESCE(AwayLineOddsClose, AwayLineOddsMax, AwayLineOddsMin, AwayLineOddsOpen)
					AND AwayScore + COALESCE(AwayLineClose, AwayLineMax, AwayLineMin, AwayLineOpen) > HomeScore
				) AS FLOAT) / CAST((
				SELECT COUNT(1)
				FROM GameData gd
				WHERE sa.Season = gd.Season
					AND COALESCE(HomeLineOddsClose, HomeLineOddsMax, HomeLineOddsMin, HomeLineOddsOpen) < COALESCE(AwayLineOddsClose, AwayLineOddsMax, AwayLineOddsMin, AwayLineOddsOpen)
				) AS FLOAT)
	FROM #SeasonAverages sa
	WHERE (
			SELECT COUNT(1)
			FROM GameData gd
			WHERE sa.Season = gd.Season
				AND COALESCE(HomeLineOddsClose, HomeLineOddsMax, HomeLineOddsMin, HomeLineOddsOpen) < COALESCE(AwayLineOddsClose, AwayLineOddsMax, AwayLineOddsMin, AwayLineOddsOpen)
			) <> 0

	UPDATE sa
	SET HomeSpreadCoverRate = CAST((
				SELECT COUNT(1)
				FROM GameData gd
				WHERE sa.Season = gd.Season
					AND HomeScore + COALESCE(HomeLineClose, HomeLineMax, HomeLineMin, HomeLineOpen) > AwayScore
				) AS FLOAT) / CAST((
				SELECT COUNT(1)
				FROM GameData gd
				WHERE sa.Season = gd.Season
				) AS FLOAT)
	FROM #SeasonAverages sa
	WHERE (
			SELECT COUNT(1)
			FROM GameData gd
			WHERE sa.Season = gd.Season
				AND COALESCE(HomeLineOddsClose, HomeLineOddsMax, HomeLineOddsMin, HomeLineOddsOpen) < COALESCE(AwayLineOddsClose, AwayLineOddsMax, AwayLineOddsMin, AwayLineOddsOpen)
			) <> 0

	UPDATE sa
	SET AwaySpreadCoverRate = CAST((
				SELECT COUNT(1)
				FROM GameData gd
				WHERE sa.Season = gd.Season
					AND AwayScore + COALESCE(AwayLineClose, AwayLineMax, AwayLineMin, AwayLineOpen) > HomeScore
				) AS FLOAT) / CAST((
				SELECT COUNT(1)
				FROM GameData gd
				WHERE sa.Season = gd.Season
				) AS FLOAT)
	FROM #SeasonAverages sa
	WHERE (
			SELECT COUNT(1)
			FROM GameData gd
			WHERE sa.Season = gd.Season
				AND COALESCE(HomeLineClose, HomeLineMax, HomeLineMin, HomeLineOpen) IS NOT NULL
				AND COALESCE(AwayLineClose, AwayLineMax, AwayLineMin, AwayLineOpen) IS NOT NULL
				AND COALESCE(HomeLineClose, HomeLineMax, HomeLineMin, HomeLineOpen) <> COALESCE(AwayLineClose, AwayLineMax, AwayLineMin, AwayLineOpen)
			) <> 0

	UPDATE sa
	SET DogSpreadCoverRate = CAST((
				SELECT COUNT(1)
				FROM GameData gd
				WHERE sa.Season = gd.Season
					AND CASE 
						WHEN COALESCE(HomeLineClose, HomeLineMax, HomeLineMin, HomeLineOpen) < COALESCE(AwayLineClose, AwayLineMax, AwayLineMin, AwayLineOpen)
							THEN HomeScore + COALESCE(HomeLineClose, HomeLineMax, HomeLineMin, HomeLineOpen)
						WHEN COALESCE(HomeLineClose, HomeLineMax, HomeLineMin, HomeLineOpen) > COALESCE(AwayLineClose, AwayLineMax, AwayLineMin, AwayLineOpen)
							THEN AwayScore + COALESCE(AwayLineClose, AwayLineMax, AwayLineMin, AwayLineOpen)
						END < CASE 
						WHEN COALESCE(HomeLineClose, HomeLineMax, HomeLineMin, HomeLineOpen) < COALESCE(AwayLineClose, AwayLineMax, AwayLineMin, AwayLineOpen)
							THEN AwayScore
						WHEN COALESCE(HomeLineClose, HomeLineMax, HomeLineMin, HomeLineOpen) > COALESCE(AwayLineClose, AwayLineMax, AwayLineMin, AwayLineOpen)
							THEN HomeScore
						END
				) AS FLOAT) / CAST((
				SELECT COUNT(1)
				FROM GameData gd
				WHERE sa.Season = gd.Season
					AND COALESCE(HomeLineClose, HomeLineMax, HomeLineMin, HomeLineOpen) IS NOT NULL
					AND COALESCE(AwayLineClose, AwayLineMax, AwayLineMin, AwayLineOpen) IS NOT NULL
					AND COALESCE(HomeLineClose, HomeLineMax, HomeLineMin, HomeLineOpen) <> COALESCE(AwayLineClose, AwayLineMax, AwayLineMin, AwayLineOpen)
				) AS FLOAT)
	FROM #SeasonAverages sa
	WHERE CAST((
				SELECT COUNT(1)
				FROM GameData gd
				WHERE sa.Season = gd.Season
					AND COALESCE(HomeLineClose, HomeLineMax, HomeLineMin, HomeLineOpen) IS NOT NULL
					AND COALESCE(AwayLineClose, AwayLineMax, AwayLineMin, AwayLineOpen) IS NOT NULL
					AND COALESCE(HomeLineClose, HomeLineMax, HomeLineMin, HomeLineOpen) <> COALESCE(AwayLineClose, AwayLineMax, AwayLineMin, AwayLineOpen)
				) AS FLOAT) <> 0

	UPDATE sa
	SET FavoriteSpreadCoverRate = CAST((
				SELECT COUNT(1)
				FROM GameData gd
				WHERE sa.Season = gd.Season
					AND CASE 
						WHEN COALESCE(HomeLineClose, HomeLineMax, HomeLineMin, HomeLineOpen) < COALESCE(AwayLineClose, AwayLineMax, AwayLineMin, AwayLineOpen)
							THEN HomeScore + COALESCE(HomeLineClose, HomeLineMax, HomeLineMin, HomeLineOpen)
						WHEN COALESCE(HomeLineClose, HomeLineMax, HomeLineMin, HomeLineOpen) > COALESCE(AwayLineClose, AwayLineMax, AwayLineMin, AwayLineOpen)
							THEN AwayScore + COALESCE(AwayLineClose, AwayLineMax, AwayLineMin, AwayLineOpen)
						END > CASE 
						WHEN COALESCE(HomeLineClose, HomeLineMax, HomeLineMin, HomeLineOpen) < COALESCE(AwayLineClose, AwayLineMax, AwayLineMin, AwayLineOpen)
							THEN AwayScore
						WHEN COALESCE(HomeLineClose, HomeLineMax, HomeLineMin, HomeLineOpen) > COALESCE(AwayLineClose, AwayLineMax, AwayLineMin, AwayLineOpen)
							THEN HomeScore
						END
				) AS FLOAT) / CAST((
				SELECT COUNT(1)
				FROM GameData gd
				WHERE sa.Season = gd.Season
					AND COALESCE(HomeLineClose, HomeLineMax, HomeLineMin, HomeLineOpen) IS NOT NULL
					AND COALESCE(AwayLineClose, AwayLineMax, AwayLineMin, AwayLineOpen) IS NOT NULL
					AND COALESCE(HomeLineClose, HomeLineMax, HomeLineMin, HomeLineOpen) <> COALESCE(AwayLineClose, AwayLineMax, AwayLineMin, AwayLineOpen)
				) AS FLOAT)
	FROM #SeasonAverages sa
	WHERE CAST((
				SELECT COUNT(1)
				FROM GameData gd
				WHERE sa.Season = gd.Season
					AND COALESCE(HomeLineClose, HomeLineMax, HomeLineMin, HomeLineOpen) IS NOT NULL
					AND COALESCE(AwayLineClose, AwayLineMax, AwayLineMin, AwayLineOpen) IS NOT NULL
					AND COALESCE(HomeLineClose, HomeLineMax, HomeLineMin, HomeLineOpen) <> COALESCE(AwayLineClose, AwayLineMax, AwayLineMin, AwayLineOpen)
				) AS FLOAT) <> 0

	TRUNCATE TABLE Seasons

	INSERT INTO Seasons (Season, SeasonTotalUnderRate, SeasonTotalPushRate, SeasonTotalOverRate, HomeUnderdogSpreadCoverRate, HomeFavoriteSpreadCoverRate, AwayUnderdogSpreadCoverRate, AwayFavoriteSpreadCoverRate, HomeSpreadCoverRate, AwaySpreadCoverRate, FavoriteSpreadCoverRate, DogSpreadCoverRate, HomeUnderdogOutrightRate, HomeFavoriteOutrightRate, AwayUnderdogOutrightRate, AwayFavoriteOutrightRate, HomeOutrightRate, AwayOutrightRate, FavoriteOutrightRate, DogOutrightRate)
	SELECT Season, SeasonTotalUnderRate, SeasonTotalPushRate, SeasonTotalOverRate, HomeUnderdogSpreadCoverRate, HomeFavoriteSpreadCoverRate, AwayUnderdogSpreadCoverRate, AwayFavoriteSpreadCoverRate, HomeSpreadCoverRate, AwaySpreadCoverRate, FavoriteSpreadCoverRate, DogSpreadCoverRate, HomeUnderdogOutrightRate, HomeFavoriteOutrightRate, AwayUnderdogOutrightRate, AwayFavoriteOutrightRate, HomeOutrightRate, AwayOutrightRate, FavoriteOutrightRate, DogOutrightRate
	FROM #SeasonAverages
	ORDER BY Season ASC

	TRUNCATE TABLE #SeasonAverages

	DROP TABLE #SeasonAverages
END TRY

BEGIN CATCH
	SELECT ERROR_MESSAGE(), ERROR_LINE(), ERROR_PROCEDURE()
END CATCH
GO

CREATE PROCEDURE sp_ProcessImportHeadshots
AS
BEGIN TRY
IF OBJECT_ID('tempdb..#StagingTable','U') is not null
	DROP TABLE #StagingTable

CREATE TABLE #StagingTable (
	headshot_url VARCHAR(100),
	player_id VARCHAR(10)
	)

INSERT INTO #StagingTable (headshot_url,player_id)
SELECT   TRY_CAST(headshot_url as VARCHAR(100)),
		 TRY_CAST(player_id as VARCHAR(10))
FROM import.HeadshotURLs
WHERE headshot_url is not null

MERGE HeadshotURLs AS tgt
USING (Select	headshot_url,
				player_id
				FROM #StagingTable
				GROUP BY headshot_url,
						 player_id) as src ( headshot_url,
											 player_id)
							ON				tgt.headshot_url = src.headshot_url
										AND tgt.player_id = src.player_id
				WHEN MATCHED THEN
					UPDATE SET				tgt.headshot_url = src.headshot_url
										,   tgt.player_id = src.player_id	
				WHEN NOT MATCHED THEN
				INSERT (headshot_url,player_id)
				VALUES (src.headshot_url,src.player_id)
				;

				TRUNCATE TABLE import.HeadshotURLs
				
END TRY
BEGIN CATCH
	PRINT('-------------------------------sp_ProcessImportHeadshots failed. See error below -------------------------------')
	PRINT('Error: ' + CAST(@@ERROR as VARCHAR(10)) + ' --- ' + ERROR_MESSAGE())
END CATCH

CREATE PROCEDURE sp_ProcessImportWeeklyData
AS
BEGIN TRY
IF OBJECT_ID('tempdb..#StagingTable','U') is not null
	DROP TABLE #StagingTable

CREATE TABLE #StagingTable (
 player_id VARCHAR(30),
 player_name VARCHAR(30),
 player_display_name VARCHAR(30),
 position VARCHAR(30),
 position_group VARCHAR(30),
 recent_team VARCHAR(30),
 season INT,
 week INT,
 season_type VARCHAR(4),
 completions INT,
 attempts INT,
 passing_yards DECIMAL(10,2),
 passing_tds INT,
 interceptions INT,
 sacks DECIMAL(5,2),
 sack_yards DECIMAL(10,2),
 sack_fumbles DECIMAL(5,2),
 sack_fumbles_lost INT,
 passing_air_yards DECIMAL(10,2),
 passing_yards_after_catch DECIMAL(10,2),
 passing_first_downs INT,
 passing_epa DECIMAL(10,5),
 passing_2pt_conversions INT,
 pacr DECIMAL(10,5),
 dakota DECIMAL(10,5),
 carries INT,
 rushing_yards DECIMAL(10,2),
 rushing_tds INT,
 rushing_fumbles INT,
 rushing_fumbles_lost INT,
 rushing_first_downs INT,
 rushing_epa DECIMAL(10,5),
 rushing_2pt_conversions INT,
 receptions INT,
 targets INT,
 receiving_yards DECIMAL(10,2),
 receiving_tds INT,
 receiving_fumbles INT,
 receiving_fumbles_lost INT,
 receiving_air_yards DECIMAL(10,2),
 receiving_yards_after_catch DECIMAL(10,2),
 receiving_first_downs INT,
 receiving_epa DECIMAL(10,5),
 receiving_2pt_conversions int,
 racr DECIMAL(10,5),
 target_share DECIMAL(10,5),
 air_yards_share DECIMAL(10,5),
 wopr DECIMAL(10,5),
 special_teams_tds int,
 fantasy_points DECIMAL(18,2),
 fantasy_points_ppr DECIMAL(18,2)
)

INSERT INTO #StagingTable (player_id,player_name,player_display_name,position,position_group,recent_team,season,week,season_type,completions,attempts,passing_yards,passing_tds,interceptions,sacks,sack_yards,sack_fumbles,sack_fumbles_lost,passing_air_yards,passing_yards_after_catch,passing_first_downs,passing_epa,passing_2pt_conversions,pacr,dakota,carries,rushing_yards,rushing_tds,rushing_fumbles,rushing_fumbles_lost,rushing_first_downs,rushing_epa,rushing_2pt_conversions,receptions,targets,receiving_yards,receiving_tds,receiving_fumbles,receiving_fumbles_lost,receiving_air_yards,receiving_yards_after_catch,receiving_first_downs,receiving_epa,receiving_2pt_conversions,racr,target_share,air_yards_share,wopr,special_teams_tds,fantasy_points,fantasy_points_ppr)
SELECT   TRY_CAST(player_id as VARCHAR(30))
		,TRY_CAST(player_name as VARCHAR(30))
		,TRY_CAST(player_display_name as VARCHAR(30))
		,TRY_CAST(position as VARCHAR(30))
		,TRY_CAST(position_group as VARCHAR(30))
		,TRY_CAST(recent_team as VARCHAR(30))
		,TRY_CAST(season as int)
		,TRY_CAST(week as int)
		,TRY_CAST(season_type as VARCHAR(4))
		,TRY_CAST(completions as int)
		,TRY_CAST(attempts as int)
		,TRY_CAST(passing_yards as int)
		,TRY_CAST(passing_tds as int)
		,TRY_CAST(interceptions as int)
		,TRY_CAST(sacks as DECIMAL(5,2))
		,TRY_CAST(sack_yards as int)
		,TRY_CAST(sack_fumbles as int)
		,TRY_CAST(sack_fumbles_lost as int)
		,TRY_CAST(passing_air_yards as int)
		,TRY_CAST(passing_yards_after_catch as int)
		,TRY_CAST(passing_first_downs as int)
		,TRY_CAST(passing_epa as DECIMAL(10,5))
		,TRY_CAST(passing_2pt_conversions as int)
		,TRY_CAST(pacr as DECIMAL(10,5))
		,TRY_CAST(dakota as DECIMAL(10,5))
		,TRY_CAST(carries as int)
		,TRY_CAST(rushing_yards as int)
		,TRY_CAST(rushing_tds as int)
		,TRY_CAST(rushing_fumbles as int)
		,TRY_CAST(rushing_fumbles_lost as int)
		,TRY_CAST(rushing_first_downs as int)
		,TRY_CAST(rushing_epa as DECIMAL(10,5))
		,TRY_CAST(rushing_2pt_conversions as int)
		,TRY_CAST(receptions as int)
		,TRY_CAST(targets as int)
		,TRY_CAST(receiving_yards as int)
		,TRY_CAST(receiving_tds as int)
		,TRY_CAST(receiving_fumbles as int)
		,TRY_CAST(receiving_fumbles_lost as int)
		,TRY_CAST(receiving_air_yards as int)
		,TRY_CAST(receiving_yards_after_catch as int)
		,TRY_CAST(receiving_first_downs as int)
		,TRY_CAST(receiving_epa as DECIMAL(10,5))
		,TRY_CAST(receiving_2pt_conversions as int)
		,TRY_CAST(racr as DECIMAL(10,5))
		,TRY_CAST(target_share as DECIMAL(10,5))
		,TRY_CAST(air_yards_share as DECIMAL(10,5))
		,TRY_CAST(wopr as DECIMAL(10,5))
		,TRY_CAST(special_teams_tds as int)
		,TRY_CAST(fantasy_points as DECIMAL(18,2))
		,TRY_CAST(fantasy_points_ppr as DECIMAL(18,2))
FROM import.WeeklyStats

MERGE WeeklyStats AS tgt
USING (Select	 player_id
				,player_name
				,player_display_name
				,position
				,position_group
				,recent_team
				,season
				,week
				,season_type
				,completions
				,attempts
				,passing_yards
				,passing_tds
				,interceptions
				,sacks
				,sack_yards
				,sack_fumbles
				,sack_fumbles_lost
				,passing_air_yards
				,passing_yards_after_catch
				,passing_first_downs
				,passing_epa
				,passing_2pt_conversions
				,pacr
				,dakota
				,carries
				,rushing_yards
				,rushing_tds
				,rushing_fumbles
				,rushing_fumbles_lost
				,rushing_first_downs
				,rushing_epa
				,rushing_2pt_conversions
				,receptions
				,targets
				,receiving_yards
				,receiving_tds
				,receiving_fumbles
				,receiving_fumbles_lost
				,receiving_air_yards
				,receiving_yards_after_catch
				,receiving_first_downs
				,receiving_epa
				,receiving_2pt_conversions
				,racr
				,target_share
				,air_yards_share
				,wopr
				,special_teams_tds
				,fantasy_points
				,fantasy_points_ppr 
				FROM #StagingTable) as src ( player_id
											,player_name
											,player_display_name
											,position
											,position_group
											,recent_team
											,season
											,week
											,season_type
											,completions
											,attempts
											,passing_yards
											,passing_tds
											,interceptions
											,sacks
											,sack_yards
											,sack_fumbles
											,sack_fumbles_lost
											,passing_air_yards
											,passing_yards_after_catch
											,passing_first_downs
											,passing_epa
											,passing_2pt_conversions
											,pacr
											,dakota
											,carries
											,rushing_yards
											,rushing_tds
											,rushing_fumbles
											,rushing_fumbles_lost
											,rushing_first_downs
											,rushing_epa
											,rushing_2pt_conversions
											,receptions
											,targets
											,receiving_yards
											,receiving_tds
											,receiving_fumbles
											,receiving_fumbles_lost
											,receiving_air_yards
											,receiving_yards_after_catch
											,receiving_first_downs
											,receiving_epa
											,receiving_2pt_conversions
											,racr
											,target_share
											,air_yards_share
											,wopr
											,special_teams_tds
											,fantasy_points
											,fantasy_points_ppr)
							ON		tgt.player_id = src.player_id
								AND tgt.player_name = src.player_name
								AND tgt.player_display_name = src.player_display_name
								AND tgt.position = src.position
								AND tgt.position_group = src.position_group
								AND tgt.recent_team = src.recent_team
								AND tgt.season = src.season
								AND tgt.week = src.week
								AND tgt.season_type = src.season_type
								AND tgt.completions = src.completions
								AND tgt.attempts = src.attempts
								AND tgt.passing_yards = src.passing_yards
								AND tgt.passing_tds = src.passing_tds
								AND tgt.interceptions = src.interceptions
								AND tgt.sacks = src.sacks
								AND tgt.sack_yards = src.sack_yards
								AND tgt.sack_fumbles = src.sack_fumbles
								AND tgt.sack_fumbles_lost = src.sack_fumbles_lost
								AND tgt.passing_air_yards = src.passing_air_yards
								AND tgt.passing_yards_after_catch = src.passing_yards_after_catch
								AND tgt.passing_first_downs = src.passing_first_downs
								AND tgt.passing_epa = src.passing_epa
								AND tgt.passing_2pt_conversions = src.passing_2pt_conversions
								AND tgt.pacr = src.pacr
								AND tgt.dakota = src.dakota
								AND tgt.carries = src.carries
								AND tgt.rushing_yards = src.rushing_yards
								AND tgt.rushing_tds = src.rushing_tds
								AND tgt.rushing_fumbles = src.rushing_fumbles
								AND tgt.rushing_fumbles_lost = src.rushing_fumbles_lost
								AND tgt.rushing_first_downs = src.rushing_first_downs
								AND tgt.rushing_epa = src.rushing_epa
								AND tgt.rushing_2pt_conversions = src.rushing_2pt_conversions
								AND tgt.receptions = src.receptions
								AND tgt.targets = src.targets
								AND tgt.receiving_yards = src.receiving_yards
								AND tgt.receiving_tds = src.receiving_tds
								AND tgt.receiving_fumbles = src.receiving_fumbles
								AND tgt.receiving_fumbles_lost = src.receiving_fumbles_lost
								AND tgt.receiving_air_yards = src.receiving_air_yards
								AND tgt.receiving_yards_after_catch = src.receiving_yards_after_catch
								AND tgt.receiving_first_downs = src.receiving_first_downs
								AND tgt.receiving_epa = src.receiving_epa
								AND tgt.receiving_2pt_conversions = src.receiving_2pt_conversions
								AND tgt.racr = src.racr
								AND tgt.target_share = src.target_share
								AND tgt.air_yards_share = src.air_yards_share
								AND tgt.wopr = src.wopr
								AND tgt.special_teams_tds = src.special_teams_tds
								AND tgt.fantasy_points = src.fantasy_points
								AND tgt.fantasy_points_ppr  = src.fantasy_points_ppr 
				WHEN MATCHED THEN
					UPDATE SET    tgt.player_id = src.player_id
								, tgt.player_name = src.player_name
								, tgt.player_display_name = src.player_display_name
								, tgt.position = src.position
								, tgt.position_group = src.position_group
								, tgt.recent_team = src.recent_team
								, tgt.season = src.season
								, tgt.week = src.week
								, tgt.season_type = src.season_type
								, tgt.completions = src.completions
								, tgt.attempts = src.attempts
								, tgt.passing_yards = src.passing_yards
								, tgt.passing_tds = src.passing_tds
								, tgt.interceptions = src.interceptions
								, tgt.sacks = src.sacks
								, tgt.sack_yards = src.sack_yards
								, tgt.sack_fumbles = src.sack_fumbles
								, tgt.sack_fumbles_lost = src.sack_fumbles_lost
								, tgt.passing_air_yards = src.passing_air_yards
								, tgt.passing_yards_after_catch = src.passing_yards_after_catch
								, tgt.passing_first_downs = src.passing_first_downs
								, tgt.passing_epa = src.passing_epa
								, tgt.passing_2pt_conversions = src.passing_2pt_conversions
								, tgt.pacr = src.pacr
								, tgt.dakota = src.dakota
								, tgt.carries = src.carries
								, tgt.rushing_yards = src.rushing_yards
								, tgt.rushing_tds = src.rushing_tds
								, tgt.rushing_fumbles = src.rushing_fumbles
								, tgt.rushing_fumbles_lost = src.rushing_fumbles_lost
								, tgt.rushing_first_downs = src.rushing_first_downs
								, tgt.rushing_epa = src.rushing_epa
								, tgt.rushing_2pt_conversions = src.rushing_2pt_conversions
								, tgt.receptions = src.receptions
								, tgt.targets = src.targets
								, tgt.receiving_yards = src.receiving_yards
								, tgt.receiving_tds = src.receiving_tds
								, tgt.receiving_fumbles = src.receiving_fumbles
								, tgt.receiving_fumbles_lost = src.receiving_fumbles_lost
								, tgt.receiving_air_yards = src.receiving_air_yards
								, tgt.receiving_yards_after_catch = src.receiving_yards_after_catch
								, tgt.receiving_first_downs = src.receiving_first_downs
								, tgt.receiving_epa = src.receiving_epa
								, tgt.receiving_2pt_conversions = src.receiving_2pt_conversions
								, tgt.racr = src.racr
								, tgt.target_share = src.target_share
								, tgt.air_yards_share = src.air_yards_share
								, tgt.wopr = src.wopr
								, tgt.special_teams_tds = src.special_teams_tds
								, tgt.fantasy_points = src.fantasy_points
								, tgt.fantasy_points_ppr  = src.fantasy_points_ppr
				WHEN NOT MATCHED THEN
				INSERT (player_id, player_name, player_display_name, position, position_group, recent_team, season, week, season_type, completions, attempts, passing_yards, passing_tds, interceptions, sacks, sack_yards, sack_fumbles, sack_fumbles_lost, passing_air_yards, passing_yards_after_catch, passing_first_downs, passing_epa, passing_2pt_conversions, pacr, dakota, carries, rushing_yards, rushing_tds, rushing_fumbles, rushing_fumbles_lost, rushing_first_downs, rushing_epa, rushing_2pt_conversions, receptions, targets, receiving_yards, receiving_tds, receiving_fumbles, receiving_fumbles_lost, receiving_air_yards, receiving_yards_after_catch, receiving_first_downs, receiving_epa, receiving_2pt_conversions, racr, target_share, air_yards_share, wopr, special_teams_tds, fantasy_points, fantasy_points_ppr)
				VALUES (src.player_id, src.player_name, src.player_display_name, src.position, src.position_group, src.recent_team, src.season, src.week, src.season_type, src.completions, src.attempts, src.passing_yards, src.passing_tds, src.interceptions, src.sacks, src.sack_yards, src.sack_fumbles, src.sack_fumbles_lost, src.passing_air_yards, src.passing_yards_after_catch, src.passing_first_downs, src.passing_epa, src.passing_2pt_conversions, src.pacr, src.dakota, src.carries, src.rushing_yards, src.rushing_tds, src.rushing_fumbles, src.rushing_fumbles_lost, src.rushing_first_downs, src.rushing_epa, src.rushing_2pt_conversions, src.receptions, src.targets, src.receiving_yards, src.receiving_tds, src.receiving_fumbles, src.receiving_fumbles_lost, src.receiving_air_yards, src.receiving_yards_after_catch, src.receiving_first_downs, src.receiving_epa, src.receiving_2pt_conversions, src.racr, src.target_share, src.air_yards_share, src.wopr, src.special_teams_tds, src.fantasy_points, src.fantasy_points_ppr)
				;
				
				MERGE Players as tgt
				USING (Select DISTINCT player_id, player_name, player_display_name, position, position_group, recent_team, season from #StagingTable) as src (player_id, player_name, player_display_name, position, position_group, recent_team, season)
				ON tgt.player_display_name = src.player_display_name and tgt.season = src.season
				WHEN MATCHED THEN
					UPDATE SET tgt.player_display_name = src.player_display_name, tgt.season = src.season
				WHEN NOT MATCHED THEN 
					INSERT (player_id, player_name, player_display_name, position, position_group, recent_team, season)
					VALUES (src.player_id, src.player_name, src.player_display_name, src.position, src.position_group, src.recent_team, src.season)			
				;

				
				With WeeklyDupes
				AS
				(
				Select *, Row_number() over(partition by player_id,season,week order by player_id,season,week)as RowNumber from 
				WeeklyStats
				)
				Delete from WeeklyDupes where RowNumber > 1
				
				With PlayerDupes
				AS
				(
				Select *, Row_number() over(partition by player_id,season order by player_id,season)as RowNumber from 
				WeeklyStats
				)
				Delete from PlayerDupes where RowNumber > 1

				TRUNCATE TABLE import.WeeklyStats
				
END TRY
BEGIN CATCH
	PRINT('-------------------------------sp_ProcessImportWeeklyData failed. See error below -------------------------------')
	PRINT('Error: ' + CAST(@@ERROR as VARCHAR(10)) + ' --- ' + ERROR_MESSAGE())
END CATCH

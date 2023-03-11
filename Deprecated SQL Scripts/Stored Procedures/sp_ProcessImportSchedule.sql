CREATE PROCEDURE sp_ProcessImportSchedule 
AS
BEGIN TRY
IF OBJECT_ID('tempdb..#StagingTable','U') is not null
	DROP TABLE #StagingTable

CREATE TABLE #StagingTable (
	game_id VARCHAR(15),
	season VARCHAR(4),
	game_type VARCHAR(3),
	[week] INT,
	gameday DATE,
	[weekday] VARCHAR(8),
	gametime TIME,
	away_team CHAR(3),
	away_score int,
	home_team CHAR(3),
	home_score int,
	winner char(3),
	loser char(3),
	tie char(1),
	[location] VARCHAR(30),
	result int,
	total int,
	overtime char(1), --T/F True/False
	old_game_id CHAR(10),
	gsis int,
	nfl_detail_id VARCHAR(40),
	pfr VARCHAR(12), --ProFootballReference ID
	pff INT, --Pro Football Focus ID
	espn INT, --ESPN ID
	away_rest INT,
	home_rest INT,
	away_moneyline INT,
	home_moneyline INT,
	spread_line DECIMAL(4,2),
	away_spread_odds INT,
	home_spread_odds INT,
	total_line INT,
	under_odds INT,
	over_odds INT,
	div_game char(1), --T/F True/False
	roof VARCHAR(8),
	surface VARCHAR(10),
	temp INT,
	wind INT,
	away_qb_id VARCHAR(10),
	home_qb_id VARCHAR(10),
	away_qb_name VARCHAR(20),
	home_qb_name VARCHAR(20),
	away_coach VARCHAR(20),
	home_coach VARCHAR(20),
	referee VARCHAR(14),
	stadium_id VARCHAR(5),
	stadium VARCHAR(35)
	)

INSERT INTO #StagingTable (game_id, season, game_type, week, gameday, weekday, gametime, away_team, away_score, home_team, home_score, winner, loser, tie, location, result, total, overtime, old_game_id, gsis, nfl_detail_id, pfr, pff, espn, away_rest, home_rest, away_moneyline, home_moneyline, spread_line, away_spread_odds, home_spread_odds, total_line, under_odds, over_odds, div_game, roof, surface, temp, wind, away_qb_id, home_qb_id, away_qb_name, home_qb_name, away_coach, home_coach, referee, stadium_id, stadium)
SELECT   TRY_CAST(NULLIF(game_id,'nan') as VARCHAR(15)),
		 TRY_CAST(NULLIF(season,'nan') as VARCHAR(4)),
		 TRY_CAST(NULLIF(game_type,'nan') as VARCHAR(3)),
		 TRY_CAST([week] as INT),
		 TRY_CAST(gameday as DATE),
		 TRY_CAST(NULLIF([weekday],'nan') as VARCHAR(8)),
		 TRY_CAST(gametime as TIME),
		 TRY_CAST(away_team as CHAR(3)),
		 TRY_CAST(away_score as DECIMAL(3,0)),
		 TRY_CAST(home_team as CHAR(3)),
		 TRY_CAST(home_score as DECIMAL(3,0)),
		 CASE WHEN TRY_CAST(home_score as DECIMAL(3,0)) > TRY_CAST(away_score as DECIMAL(3,0)) THEN home_team
			  WHEN TRY_CAST(away_score as DECIMAL(3,0)) > TRY_CAST(home_score as DECIMAL(3,0)) THEN away_team
			  ELSE NULL
			  END, --Winner
		CASE WHEN TRY_CAST(home_score as DECIMAL(3,0)) < TRY_CAST(away_score as DECIMAL(3,0)) THEN home_team
			  WHEN TRY_CAST(away_score as DECIMAL(3,0)) < TRY_CAST(home_score as DECIMAL(3,0)) THEN away_team
			  ELSE NULL
			  END, --Loser
		CASE WHEN TRY_CAST(home_score as DECIMAL(3,0)) = TRY_CAST(away_score as DECIMAL(3,0)) THEN 'T'
			  ELSE 'F'
			  END, --Tie
		 TRY_CAST(NULLIF([location],'nan') as VARCHAR(30)),
		 TRY_CAST(result as DECIMAL(3,0)),
		 TRY_CAST(total as DECIMAL(3,0)),
		 CASE WHEN TRY_CAST(overtime as DECIMAL(3,0)) = 1 THEN 'T'
			  WHEN TRY_CAST(overtime as DECIMAL(3,0)) = 0 THEN 'F'
			  ELSE NULL
			  END,--T/F True/False
		 TRY_CAST(old_game_id as CHAR(10)),
		 TRY_CAST(gsis as int),
		 TRY_CAST(NULLIF(nfl_detail_id,'nan') as VARCHAR(40)),
		 TRY_CAST(NULLIF(pfr,'nan') as VARCHAR(12)), --ProFootballReference ID
		 TRY_CAST(pff as INT), --Pro Football Focus ID
		 TRY_CAST(espn as INT), --ESPN ID
		 TRY_CAST(away_rest as INT),
		 TRY_CAST(home_rest as INT),
		 TRY_CAST(away_moneyline as DECIMAL(4,0)),
		 TRY_CAST(home_moneyline as DECIMAL(4,0)),
		 TRY_CAST(spread_line as DECIMAL(3,0)),
		 TRY_CAST(away_spread_odds as DECIMAL(4,0)),
		 TRY_CAST(home_spread_odds as DECIMAL(4,0)),
		 TRY_CAST(total_line as DECIMAL(4,0)),
		 TRY_CAST(under_odds as DECIMAL(4,0)),
		 TRY_CAST(over_odds as DECIMAL(4,0)),
		 CASE WHEN TRY_CAST(div_game as DECIMAL(3,0)) = 1 THEN 'T'
			  WHEN TRY_CAST(div_game as DECIMAL(3,0)) = 0 THEN 'F'
			  ELSE NULL
			  END,--T/F True/False
		 TRY_CAST(NULLIF(roof,'nan') as VARCHAR(8)),
		 TRY_CAST(NULLIF(surface,'nan') as VARCHAR(10)),
		 TRY_CAST(temp as DECIMAL(3,0)),
		 TRY_CAST(wind as DECIMAL(3,0)),
		 TRY_CAST(NULLIF(away_qb_id,'nan') as VARCHAR(10)),
		 TRY_CAST(NULLIF(home_qb_id,'nan') as VARCHAR(10)),
		 TRY_CAST(NULLIF(away_qb_name,'nan') as VARCHAR(20)),
		 TRY_CAST(NULLIF(home_qb_name,'nan') as VARCHAR(20)),
		 TRY_CAST(NULLIF(away_coach,'nan') as VARCHAR(20)),
		 TRY_CAST(NULLIF(home_coach,'nan') as VARCHAR(20)),
		 TRY_CAST(NULLIF(referee,'nan') as VARCHAR(14)),
		 TRY_CAST(NULLIF(stadium_id,'nan') as VARCHAR(5)),
		 TRY_CAST(NULLIF(stadium,'nan') as VARCHAR(35))
FROM import.Schedule

MERGE Schedule AS tgt
USING (Select	 	 game_id
				,	 season
				,	 game_type
				,	 week
				,	 gameday
				,	 weekday
				,	 gametime
				,	 away_team
				,	 away_score
				,	 home_team
				,	 home_score
				,	 winner
				,	 loser
				,	 tie
				,	 location
				,	 result
				,	 total
				,	 overtime
				,	 old_game_id
				,	 gsis
				,	 nfl_detail_id
				,	 pfr
				,	 pff
				,	 espn
				,	 away_rest
				,	 home_rest
				,	 away_moneyline
				,	 home_moneyline
				,	 spread_line
				,	 away_spread_odds
				,	 home_spread_odds
				,	 total_line
				,	 under_odds
				,	 over_odds
				,	 div_game
				,	 roof
				,	 surface
				,	 temp
				,	 wind
				,	 away_qb_id
				,	 home_qb_id
				,	 away_qb_name
				,	 home_qb_name
				,	 away_coach
				,	 home_coach
				,	 referee
				,	 stadium_id
				,	 stadium	
				FROM #StagingTable) as src ( game_id
										,	 season
										,	 game_type
										,	 week
										,	 gameday
										,	 weekday
										,	 gametime
										,	 away_team
										,	 away_score
										,	 home_team
										,	 home_score
										,	 winner
										,	 loser
										,	 tie
										,	 location
										,	 result
										,	 total
										,	 overtime
										,	 old_game_id
										,	 gsis
										,	 nfl_detail_id
										,	 pfr
										,	 pff
										,	 espn
										,	 away_rest
										,	 home_rest
										,	 away_moneyline
										,	 home_moneyline
										,	 spread_line
										,	 away_spread_odds
										,	 home_spread_odds
										,	 total_line
										,	 under_odds
										,	 over_odds
										,	 div_game
										,	 roof
										,	 surface
										,	 temp
										,	 wind
										,	 away_qb_id
										,	 home_qb_id
										,	 away_qb_name
										,	 home_qb_name
										,	 away_coach
										,	 home_coach
										,	 referee
										,	 stadium_id
										,	 stadium	)
							ON				tgt.game_id = src.season
										AND	tgt.season = src.season
										AND	tgt.game_type = src.game_type
										AND	tgt.week = src.week
										AND	tgt.gameday = src.gameday
										AND	tgt.weekday = src.weekday
										AND	tgt.gametime = src.gametime
										AND	tgt.away_team = src.away_team
										AND	tgt.away_score = src.away_score
										AND	tgt.home_team = src.home_team
										AND	tgt.home_score = src.home_score
										AND	tgt.location = src.location
										AND	tgt.result = src.result
										AND	tgt.total = src.total
										AND	tgt.overtime = src.overtime
										AND	tgt.old_game_id = src.old_game_id
										AND	tgt.gsis = src.gsis
										AND	tgt.nfl_detail_id = src.nfl_detail_id
										AND	tgt.pfr = src.pfr
										AND	tgt.pff = src.pff
										AND	tgt.espn = src.espn
										AND	tgt.away_rest = src.away_rest
										AND	tgt.home_rest = src.home_rest
										AND	tgt.away_moneyline = src.away_moneyline
										AND	tgt.home_moneyline = src.home_moneyline
										AND	tgt.spread_line = src.spread_line
										AND	tgt.away_spread_odds = src.away_spread_odds
										AND	tgt.home_spread_odds = src.home_spread_odds
										AND	tgt.total_line = src.total_line
										AND	tgt.under_odds = src.under_odds
										AND	tgt.over_odds = src.over_odds
										AND	tgt.div_game = src.div_game
										AND	tgt.roof = src.roof
										AND	tgt.surface = src.surface
										AND	tgt.temp = src.temp
										AND	tgt.wind = src.wind
										AND	tgt.away_qb_id = src.away_qb_id
										AND	tgt.home_qb_id = src.home_qb_id
										AND	tgt.away_qb_name = src.away_qb_name
										AND	tgt.home_qb_name = src.home_qb_name
										AND	tgt.away_coach = src.away_coach
										AND	tgt.home_coach = src.home_coach
										AND	tgt.referee = src.referee
										AND	tgt.stadium_id = src.stadium_id
										AND	tgt.stadium = src.stadium	
				WHEN MATCHED THEN
					UPDATE SET				tgt.game_id = src.season
										, 	tgt.season = src.season
										, 	tgt.game_type = src.game_type
										, 	tgt.week = src.week
										, 	tgt.gameday = src.gameday
										, 	tgt.weekday = src.weekday
										, 	tgt.gametime = src.gametime
										, 	tgt.away_team = src.away_team
										, 	tgt.away_score = src.away_score
										, 	tgt.home_team = src.home_team
										, 	tgt.home_score = src.home_score
										,	tgt.winner = CASE WHEN TRY_CAST(src.home_score as DECIMAL(3,0)) > TRY_CAST(src.away_score as DECIMAL(3,0)) THEN src.home_team
															  WHEN TRY_CAST(src.away_score as DECIMAL(3,0)) > TRY_CAST(src.home_score as DECIMAL(3,0)) THEN src.away_team
															  ELSE NULL
															  END --Winner
										,	tgt.loser =  CASE WHEN TRY_CAST(src.home_score as DECIMAL(3,0)) < TRY_CAST(src.away_score as DECIMAL(3,0)) THEN src.home_team
															  WHEN TRY_CAST(src.away_score as DECIMAL(3,0)) < TRY_CAST(src.home_score as DECIMAL(3,0)) THEN src.away_team
															  ELSE NULL
															  END --Loser
										,	tgt.Tie = 	 CASE WHEN TRY_CAST(src.home_score as DECIMAL(3,0)) = TRY_CAST(src.away_score as DECIMAL(3,0)) THEN 'T'
																ELSE 'F'
																END --Tie
										, 	tgt.location = src.location
										, 	tgt.result = src.result
										, 	tgt.total = src.total
										, 	tgt.overtime = src.overtime
										, 	tgt.old_game_id = src.old_game_id
										, 	tgt.gsis = src.gsis
										, 	tgt.nfl_detail_id = src.nfl_detail_id
										, 	tgt.pfr = src.pfr
										, 	tgt.pff = src.pff
										, 	tgt.espn = src.espn
										, 	tgt.away_rest = src.away_rest
										, 	tgt.home_rest = src.home_rest
										, 	tgt.away_moneyline = src.away_moneyline
										, 	tgt.home_moneyline = src.home_moneyline
										, 	tgt.spread_line = src.spread_line
										, 	tgt.away_spread_odds = src.away_spread_odds
										, 	tgt.home_spread_odds = src.home_spread_odds
										, 	tgt.total_line = src.total_line
										, 	tgt.under_odds = src.under_odds
										, 	tgt.over_odds = src.over_odds
										, 	tgt.div_game = src.div_game
										, 	tgt.roof = src.roof
										, 	tgt.surface = src.surface
										, 	tgt.temp = src.temp
										, 	tgt.wind = src.wind
										, 	tgt.away_qb_id = src.away_qb_id
										, 	tgt.home_qb_id = src.home_qb_id
										, 	tgt.away_qb_name = src.away_qb_name
										, 	tgt.home_qb_name = src.home_qb_name
										, 	tgt.away_coach = src.away_coach
										, 	tgt.home_coach = src.home_coach
										, 	tgt.referee = src.referee
										, 	tgt.stadium_id = src.stadium_id
										, 	tgt.stadium = src.stadium	
				WHEN NOT MATCHED THEN
				INSERT (game_id, season, game_type, week, gameday, weekday, gametime, away_team, away_score, home_team, home_score, winner, loser, tie, location, result, total, overtime, old_game_id, gsis, nfl_detail_id, pfr, pff, espn, away_rest, home_rest, away_moneyline, home_moneyline, spread_line, away_spread_odds, home_spread_odds, total_line, under_odds, over_odds, div_game, roof, surface, temp, wind, away_qb_id, home_qb_id, away_qb_name, home_qb_name, away_coach, home_coach, referee, stadium_id, stadium)
				VALUES (src.game_id, src.season, src.game_type, src.week, src.gameday, src.weekday, src.gametime, src.away_team, src.away_score, src.home_team, src.home_score, CASE WHEN TRY_CAST(src.home_score as DECIMAL(3,0)) > TRY_CAST(src.away_score as DECIMAL(3,0)) THEN src.home_team WHEN TRY_CAST(src.away_score as DECIMAL(3,0)) > TRY_CAST(src.home_score as DECIMAL(3,0)) THEN src.away_team ELSE NULL END, CASE WHEN TRY_CAST(src.home_score as DECIMAL(3,0)) < TRY_CAST(src.away_score as DECIMAL(3,0)) THEN src.home_team WHEN TRY_CAST(src.away_score as DECIMAL(3,0)) < TRY_CAST(src.home_score as DECIMAL(3,0)) THEN src.away_team ELSE NULL END,	 CASE WHEN TRY_CAST(src.home_score as DECIMAL(3,0)) = TRY_CAST(src.away_score as DECIMAL(3,0)) THEN 'T' ELSE 'F' END, src.location, src.result, src.total, src.overtime, src.old_game_id, src.gsis, src.nfl_detail_id, src.pfr, src.pff, src.espn, src.away_rest, src.home_rest, src.away_moneyline, src.home_moneyline, src.spread_line, src.away_spread_odds, src.home_spread_odds, src.total_line, src.under_odds, src.over_odds, src.div_game, src.roof, src.surface, src.temp, src.wind, src.away_qb_id, src.home_qb_id, src.away_qb_name, src.home_qb_name, src.away_coach, src.home_coach, src.referee, src.stadium_id, src.stadium)
				;

				TRUNCATE TABLE import.Schedule
				
END TRY
BEGIN CATCH
	PRINT('-------------------------------sp_ProcessImportSchedule failed. See error below -------------------------------')
	PRINT('Error: ' + CAST(@@ERROR as VARCHAR(10)) + ' --- ' + ERROR_MESSAGE())
END CATCH

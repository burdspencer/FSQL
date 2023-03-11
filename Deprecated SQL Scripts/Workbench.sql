exec ProcessImportWeeklyData

select * from weeklystats
where recent_team = 'GB' AND Player_display_name = 'Aaron Rodgers'
ORDER BY Season DESC,Week ASC

select * from players where season = 2022

select player_id,player_name,position,recent_team,season,week From weeklystats ws
where ws.season = 2022
and ws.player_display_name = 'Corey Davis'
group by player_id,player_name,position,recent_team,season,week
ORDER BY Week asc

delete from players

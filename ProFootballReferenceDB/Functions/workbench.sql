--use ProFootballReference

--select DISTINCT Date from GameData
----WHERE Season = 2022
----AND (HomeTeam = 'Green Bay Packers' OR AwayTeam = 'Green Bay Packers')
--ORDER BY Date ASC

--select GameDataId, HomeTeam,AwayTeam,Week,Season,HomeResult,AwayResult,HomeScore,AwayScore 
--, sum(awayScore) OVER (Partition BY HomeTeam
--						Order By week ASC
--						ROWS 5 Preceding) as LastFiveAwayScore
--from GameData gd
--WHERE Season = 2022
--AND (HomeTeam = 'Green Bay Packers' OR AwayTeam = 'Green Bay Packers')
--ORDER BY Date ASC




--select * from ssf_SeasonStatsUpTo('Green Bay Packers', 2010,'SuperBowl')

--exec ssp_GetCommonOpponents 'Green Bay Packers', 'Chicago Bears', 2022
--exec ssp_GetCommonOpponents 'Chicago Bears', 'Green Bay Packers'



--exec ssp_GetCommonOpponentsDetail 'Chicago Bears', 'Green Bay Packers', 2022
--exec ssp_GetCommonOpponentsDetail 'Green Bay Packers', 'Chicago Bears', 2022


--exec ssp_GetCommonOpponentsDetail 'Houston Texans', 'Chicago Bears', 2021
--exec ssp_GetCommonOpponentsDetail 'Chicago Bears', 'Houston Texans', 2021

--AvgOppOff1stD
--select * from ssv_ListTeams

--exec ssp_GetFormattedSchedule 'Chicago Bears', 2022

--select distinct week from GameData
s
select * from ssf_AggSeasonStatsUpTo('Cleveland Browns', 2018,'1')
select * from ssf_AggSeasonStatsUpTo('Cleveland Browns', 2018,'2')
select * from ssf_AggSeasonStatsUpTo('Cleveland Browns', 2018,'3')
select * from ssf_AggSeasonStatsUpTo('Cleveland Browns', 2018,'4')

select * From GameData 
WHERE (HomeTeam = 'Cleveland Browns' OR AwayTeam = 'Cleveland Browns' )
and Week IN ('1','2','3','4','5') 
and Season = 2018
exec ssp_PullScheduleData 2022
select * from ssf_AggSeasonStatsUpTo('Green Bay Packers', 2013,'2')

select * from ssf_LastGameStats('Green Bay Packers', 2010,'1')


select COUNT(*)/2 from GameDataImport
WHERE Season = 2022
AND Opponent <> 'Bye Week'
AND Opponent <> '0'
ORDER BY Week

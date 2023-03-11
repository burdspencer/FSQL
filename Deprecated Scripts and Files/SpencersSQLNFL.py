#!/usr/bin/env python
# coding: utf-8

##1a. Get Libraries needed to gather data
import nfl_data_py as nfl
import numpy as np
import pandas as pd
import os as OperatingSystem
from datetime import date
import time as t
import warnings
warnings.filterwarnings("ignore")

##1b. Import Data
startTime = t.perf_counter_ns()
years = range(2022, 2023)
weeklyData = nfl.import_weekly_data(years,downcast=False)
schedData = nfl.import_schedules(years)
scoringLines = nfl.import_sc_lines(years)
seasonalData1 = nfl.import_seasonal_data(years)
seasonalData = seasonalData1[['player_id','season','season_type','completions','attempts','passing_yards','passing_tds','interceptions','sacks','sack_yards','sack_fumbles','sack_fumbles_lost','passing_air_yards','passing_yards_after_catch','passing_first_downs','passing_epa','passing_2pt_conversions','carries','rushing_yards','rushing_tds','rushing_fumbles','rushing_fumbles_lost','rushing_first_downs','rushing_epa','rushing_2pt_conversions','receptions','targets','receiving_yards','receiving_tds','receiving_fumbles','receiving_fumbles_lost','receiving_air_yards','receiving_yards_after_catch','receiving_first_downs','receiving_epa','receiving_2pt_conversions','target_share','air_yards_share','special_teams_tds','fantasy_points','fantasy_points_ppr','games']]
winTotals = nfl.import_win_totals(years)
headshots = nfl.import_weekly_data(years,['headshot_url','player_id'])

def createSQLInsertScript(filename,table, data):
	file = "C:\\Users\\Spencer\\NFL-Py\\SQL Scripts\\Python-Generated\\" + filename + ".sql"
	f = open(file, "x")
	script = "INSERT INTO " + table + " ("
	for col in data.columns:
		script = script + col + ", "
	script = script.rstrip(", ")
	script = script + ")"
	
	script = script + "\nSELECT * FROM (VALUES"
	for i in range(len(data)): #for every row 
		script = script + "("
		for item in data.loc[i]: #for every column name
			if pd.isna(item) == False or item is not None or item != "":
				if item is None:
					script = script + "\'NULL\',"
				else:
					script = script + "\'" + str(item) + "\',"
			elif pd.isna(item) or item is None or item == "" or item == "<NA>":
				script = script + "\'NULL\',"
		script = script.rstrip(",")
		script = script + "),\n"
	script = script.rstrip(",\n")
	script = script + ") as temp ("
	for col in data.columns:
		script = script + col + ", "
	
	script = script.rstrip(", ")
	script = script + ")"
	f.write(script)
	f.close()
		
weeklyData.replace(to_replace="\'",value="''",inplace=True, regex=True)
weeklyData.reset_index(drop=True, inplace=True)

seasonalData.replace(to_replace="\'",value="''",inplace=True, regex=True)
seasonalData.reset_index(drop=True, inplace=True)

schedData.replace(to_replace="\'",value="''",inplace=True, regex=True)
schedData.reset_index(drop=True, inplace=True)


winTotals.reset_index(drop=True, inplace=True)
scoringLines.reset_index(drop=True, inplace=True)
headshots.reset_index(drop=True,inplace=True)
today = date.today()

# dd-mm-YY
#append a random int to file
randInt = np.random.randint(0,1000)
d1 = today.strftime("%Y-%m-%d")
weeklyDataFile = d1 + "weeklydata" + str(randInt)
seasonFile = d1 + "season" + str(randInt)
scheduleFile = d1 + "schedule" + str(randInt)
winsFile = d1 + "wins" + str(randInt)
bettingFile = d1 + "betting" + str(randInt)
headshotsFile = d1 + "headshots" + str(randInt)


files = [weeklyDataFile, seasonFile, scheduleFile, winsFile, bettingFile, headshotsFile]

for path in files:
	if OperatingSystem.path.exists(path):
		OperatingSystem.remove(path)
		print("Path: " + path + " removed.")
print("attempting to write " + weeklyDataFile + ".sql")
createSQLInsertScript(weeklyDataFile,"import.WeeklyStats",weeklyData)
print("attempting to write " + seasonFile + ".sql")
createSQLInsertScript(seasonFile,"import.Seasons",seasonalData)
print("attempting to write " + scheduleFile + ".sql")
createSQLInsertScript(scheduleFile,"import.Schedule",schedData)
print("attempting to write " + winsFile + ".sql")
createSQLInsertScript(winsFile,"import.Wins",winTotals)
print("attempting to write " + bettingFile + ".sql")
createSQLInsertScript(bettingFile,"import.BettingLines",scoringLines)
print("attempting to write " + headshotsFile + ".sql")
createSQLInsertScript(headshotsFile,"import.HeadshotURLs",headshots)

endTime = t.perf_counter_ns()
print(weeklyData[weeklyData['player_name'] == "D'Onta Foreman"])
print("Finished processing in " + str(((endTime - startTime))/(1000000000)) + " seconds.")
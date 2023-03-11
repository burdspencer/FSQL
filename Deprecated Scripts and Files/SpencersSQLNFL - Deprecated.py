#!/usr/bin/env python
# coding: utf-8

##1a. Get Libraries needed to gather data
import nfl_data_py as nfl
import numpy as np
import pandas as pd
import os as OperatingSystem
from datetime import date

##1b. Import Data
years = range(2021, 2023)
weeklyData = nfl.import_weekly_data(years)
schedData = nfl.import_schedules(years)
scoringLines = nfl.import_sc_lines(years)
seasonalData = nfl.import_seasonal_data(years)
winTotals = nfl.import_win_totals(years)

def createSQLInsertScript(filename,table, data):
	file = "C:\\Users\\Spencer\\NFL-Py\\" + filename + ".sql"
	f = open(file, "x")
	script = "INSERT INTO " + table + " ("
	for col in data.columns:
		script = script + col + ", "
	script = script.rstrip(",")
	script = script + ")"
	
	script = script + "\nSELECT * FROM VALUES"
	for i in range(len(data)): #for every row 
		script = script + "("
		for item in data.loc[i]: #for every column name
			if pd.isna(item) == False or item is not None or item != "":
				if item is None:
					script = script + "\"NULL\","
				else:
					script = script + "\"" + str(item) + "\","
			elif pd.isna(item) or item is None or item == "" or item == "<NA>":
				script = script + "\"NULL\","
		script = script.rstrip(",")
		script = script + ")\n"
	script = script + " as temp ("
	for col in data.columns:
		script = script + col + ", "
	
	script = script.rstrip(" ,")
	script = script + ")"
	f.write(script)
	f.close()
		
weeklyData.reset_index(drop=True, inplace=True)
seasonalData.reset_index(drop=True, inplace=True)
schedData.reset_index(drop=True, inplace=True)
winTotals.reset_index(drop=True, inplace=True)
scoringLines.reset_index(drop=True, inplace=True)

today = date.today()

# dd-mm-YY
#append a random int to file
randInt = np.random.randint(0,1000)
d1 = today.strftime("%d-%m-%Y")
weeklyDataFile = "weeklydata" + d1 + str(randInt)
seasonFile = "season" + d1 + str(randInt)
scheduleFile = "schedule" + d1 + str(randInt)
winsFile = "wins" + d1 + str(randInt)
bettingFile = "betting" + d1 + str(randInt)



files = [weeklyDataFile, seasonFile, scheduleFile, winsFile, bettingFile]

for path in files:
	if OperatingSystem.path.exists(path):
		OperatingSystem.remove(path)

print("attempting to write " + weeklyDataFile + ".sql")
createSQLInsertScript(weeklyDataFile,"import.Weeks",weeklyData)
print("attempting to write " + seasonFile + ".sql")
createSQLInsertScript(seasonFile,"import.Seasons",seasonalData)
print("attempting to write " + scheduleFile + ".sql")
createSQLInsertScript(scheduleFile,"import.Schedule",schedData)
print("attempting to write " + winsFile + ".sql")
createSQLInsertScript(winsFile,"import.Wins",winTotals)
print("attempting to write " + bettingFile + ".sql")
createSQLInsertScript(bettingFile,"import.BettingLines",scoringLines)

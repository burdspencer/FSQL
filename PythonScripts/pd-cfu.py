#!/usr/bin/env python
# coding: utf-8

#1. Get Libraries needed to gather data
import numpy as np
import pandas as pd
import os
from datetime import date
import time as t
from urllib.request import urlopen
import regex as re
import pyarrow.feather as feather
import pyodbc
import sqlalchemy as sa
#additional dependencies = lxml (tested @ 4.9.3)


#runtime configuration junk
runTypeSetting = 0 #0 = run as normal, 1 = only test insert into db, 2 = only test update feathers
startTime = t.perf_counter_ns()
featherDir = 'C:\\Users\\sburd\\source\\repos\\PigskinProbability\\Feathers'


#write_to_feather takes data from URL request and stores in .feather format (for storage consciousness and processing speed)
def write_to_feather (data, filename, year):
    if (os.getcwd() != featherDir): #change cwd if not set correctly
        os.chdir(featherDir)

    if (os.path.exists(filename) == False):
        print("Writing {0}.feather".format(filename))

        feather.write_feather(data, filename + '.feather')

    if (os.path.exists(filename) and year == 2023):
        os.remove(filename + '.feather')
        print("Updating {0}.feather".format(filename))

        feather.write_feather(data, filename + '.feather')
    
  
#read_feather_dataframe does the inverse of #write_to_feather and reads a .feather file into a dataframe
def read_feather_dataframe (filename):
    featherDF = pd.DataFrame()
    featherDF = pd.read_feather(filename)
    fileInfo = re.search(r'(...)(....)\.feather',filename)
    teamAbbrev = fileInfo.group(1)
    seasonYear = fileInfo.group(2)
    featherDF.columns = featherDF.columns.map(' - '.join).str.strip(' - ')
    columnsDict = {
        'Unnamed: 0_level_0 - Week' : 'Week', 
        'Unnamed: 1_level_0 - Day' : 'Day',
        'Unnamed: 2_level_0 - Date' : 'Date',
        'Unnamed: 3_level_0 - Unnamed: 3_level_1' : 'Time',
        'Unnamed: 4_level_0 - Unnamed: 4_level_1' : 'Boxscore',
        'Unnamed: 5_level_0 - Unnamed: 5_level_1' : 'Result',
        'Unnamed: 6_level_0 - OT' : 'OT',
        'Unnamed: 7_level_0 - Rec' : 'Record',
        'Unnamed: 8_level_0 - Unnamed: 8_level_1' : 'VisitorFlag',
        'Unnamed: 9_level_0 - Opp' : 'Opponent',
        'Score - Tm' : 'TeamScore',
        'Score - Opp' : 'OpponentScore',
        'Offense - 1stD' : 'Off1stD',
        'Offense - TotYd' : 'OffTotYd',
        'Offense - PassY' : 'OffPassYd',
        'Offense - RushY' : 'OffRushYd',
        'Offense - TO' : 'OffTO',
        'Defense - 1stD' : 'Def1stD',
        'Defense - TotYd' : 'DefTotYd',
        'Defense - PassY' : 'DefPassYd',
        'Defense - RushY' : 'DefRushYd',
        'Defense - TO' : 'DefTO',
        'Expected Points - Offense' : 'ExPointsOff',
        'Expected Points - Defense' : 'ExPointsDef',
        'Expected Points - Sp. Tms' : 'ExPointsSpecial'
    }

    team_abbrevs_reversed = {
    "crd": "Arizona Cardinals",
    "atl": "Atlanta Falcons",
    "rav": "Baltimore Ravens",
    "buf": "Buffalo Bills",
    "car": "Carolina Panthers",
    "chi": "Chicago Bears",
    "cin": "Cincinnati Bengals",
    "cle": "Cleveland Browns",
    "dal": "Dallas Cowboys",
    "den": "Denver Broncos",
    "det": "Detroit Lions",
    "gnb": "Green Bay Packers",
    "htx": "Houston Texans",
    "clt": "Indianapolis Colts",
    "jax": "Jacksonville Jaguars",
    "kan": "Kansas City Chiefs",
    "rai": "Las Vegas Raiders",
    "sdg": "Los Angeles Charges",
    "ram": "Los Angeles Rams",
    "mia": "Miami Dolphins",
    "min": "Minnesota Vikings",
    "nwe": "New England Patriots",
    "nor": "New Orleans Saints",
    "nyg": "New York Giants",
    "nyj": "New York Jets",
    "phi": "Philadelphia Eagles",
    "pit": "Pittsburgh Steelers",
    "sfo": "San Francisco 49ers",
    "sea": "Seattle Seahawks",
    "tam": "Tampa Bay Bucanneers",
    "oti": "Tennessee Titans",
    "was": "Washington Commanders"
    }

    featherDF.insert(4,"Season",seasonYear,True)
    featherDF.insert(8,"Team",team_abbrevs_reversed[teamAbbrev],True)
    featherDF.rename(columns=columnsDict, inplace=True)
    return featherDF

#read_all_files takes a directory and outputs all feathers as a dataframe
def read_all_files(directory):
    returnDF = pd.DataFrame()
    for file in os.listdir(directory):
        filename = os.fsdecode(file)
        fileDF = pd.DataFrame()
        fileDF = read_feather_dataframe(filename)
        returnDF = pd.concat([returnDF,fileDF], ignore_index=True)
        returnDF.fillna(value=0, inplace=True)
    return returnDF

#send_to_db uses SQLAlchemy to pass a given dataframe into the database
def send_to_db (dataframe):
    server = 'BURDNETSERVER\BURDNET' 
    database = 'ProFootballReference'
    cnxn = pyodbc.connect('DRIVER={SQL Server};SERVER='+server+';DATABASE='+database+';')
    cursor = cnxn.cursor()
    # Insert Dataframe into SQL Server:
    for index, row in dataframe.iterrows():
        cursor.execute("INSERT INTO [dbo].[GameDataImport] ([Week],[Day],[Date],[Time],[Season],[Result],[OT],[Record],[Team],[VisitorFlag],[Opponent],[TeamScore],[OpponentScore],[Off1stD],[OffTotYd],[OffPassYd],[OffRushYd],[OffTO],[Def1stD],[DefTotYd],[DefPassYd],[DefRushYd],[DefTO],[ExPointsOff],[ExPointsDef],[ExPointsSpecial]) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)", row.Week, row.Day, row.Date, row.Time, row.Season, row.Result, row.OT, row.Record, row.Team, row.VisitorFlag, row.Opponent, row.TeamScore, row.OpponentScore, row.Off1stD, row.OffTotYd, row.OffPassYd, row.OffRushYd, row.OffTO, row.Def1stD, row.DefTotYd, row.DefPassYd, row.DefRushYd, row.DefTO, row.ExPointsOff, row.ExPointsDef, row.ExPointsSpecial)
    cnxn.commit()
    cursor.close()

#2. Import Data
team_abbrevs = {
"Arizona Cardinals": "crd",
"Atlanta Falcons": "atl",
"Baltimore Ravens": "rav",
"Buffalo Bills": "buf",
"Carolina Panthers": "car",
"Chicago Bears": "chi",
"Cincinnati Bengals": "cin",
"Cleveland Browns": "cle",
"Dallas Cowboys": "dal",
"Denver Broncos": "den",
"Detroit Lions": "det",
"Green Bay Packers": "gnb",
"Houston Texans": "htx",
"Indianapolis Colts": "clt",
"Jacksonville Jaguars": "jax",
"Kansas City Chiefs": "kan",
"Las Vegas Raiders": "rai",
"Los Angeles Charges": "sdg",
"Los Angeles Rams": "ram",
"Miami Dolphins": "mia",
"Minnesota Vikings": "min",
"New England Patriots": "nwe",
"New Orleans Saints": "nor",
"New York Giants": "nyg",
"New York Jets": "nyj",
"Philadelphia Eagles": "phi",
"Pittsburgh Steelers": "pit",
"San Francisco 49ers": "sfo",
"Seattle Seahawks": "sea",
"Tampa Bay Buccaneers": "tam",
"Tennessee Titans": "oti",
"Washington Commanders": "was"
}

year = 2023

SchedURLList = []
if runTypeSetting == 0 or runTypeSetting == 2:
    for team in team_abbrevs:
        SchedYear = year
        TeamAbbrev = team_abbrevs[team]
        TeamSchedURL = 'https://www.pro-football-reference.com/teams/{0}/{1}.htm'.format(TeamAbbrev,SchedYear)
        SchedURLList.append(TeamSchedURL)

    if(len(SchedURLList) > 0):
        for url in SchedURLList:
            Schedule = pd.read_html(url)[1]
            urlInfo = re.search(r'teams\/([A-Za-z]+)\/([0-9]+)',url)
            fileName = urlInfo.group(1) + urlInfo.group(2)
            #print(Schedule.columns)
            #print(Schedule.head())
            #print(Schedule[Schedule['Unnamed: 4_level_0']['Unnamed: 4_level_1'] != 'preview'][['Unnamed: 4_level_0']['Unnamed: 4_level_1']]) #need to figure out how to check this condition without looking for a column named preview
            #Schedule = Schedule['Unnamed: 6']
            write_to_feather(Schedule,fileName,urlInfo.group(2))
            t.sleep(10) #ProSportsReference asks that all bots restrict their access to no more than 20 requests in a minute. I like this site and want other people to enjoy it too, so I limit it to 6 so as to not overburden their servers. For info: https://www.sports-reference.com/bot-traffic.html

    endTime = t.perf_counter_ns()
    print("Finished processing in " + str(((endTime - startTime))/(1000000000)) + " seconds.")


if runTypeSetting == 0 or runTypeSetting == 1:
    if (os.getcwd() != featherDir): #change cwd if not set correctly
        os.chdir(featherDir)
    print(os.getcwd())
    send_to_db(read_all_files(os.getcwd())) #use read_all_files to get all feathers in current working directory and insert into GameDataImport
    print('all feathers written to DB successfully')

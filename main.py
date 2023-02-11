import urllib.request
import json #might use this idk
#import pickle #might use this idk
from datetime import datetime as dt
from datetime import timedelta as td
import os as os



apiKey = '?key=668aa1ee702b49f5a66935b7cce375ca'


def refreshData(url, apiKey, fileName):
    

    updateDateTime = dt.today()
    updateDateTime = updateDateTime.replace(year=1900)
    
    if os.path.isfile(fileName + ".json") == True:
        with open(fileName + ".json","r") as openfile:
            json_object = json.load(openfile)
            fileDict = json.loads(json_object)
            updateDateTime = dt.strptime(fileDict["UpdatedAt"], "%d/%m/%Y %H:%M:%S")
    
    if(updateDateTime != dt.today()): #if update timestamp is greater than one day old, continue
        
        returnedData = urllib.request.urlopen(url + apiKey).read()

        #Get the current date and time for version control
        now = dt.today()
        dt_string = now.strftime("%m/%d/%Y %H:%M:%S")
        
        #Decode and load each into JSON object
        dataString = returnedData.decode("utf-8")
        dataDict = json.loads(dataString)[0]
        dataDict["UpdatedAt"] = dt_string
        dataJSON = json.dumps(dataDict)
        
        with open(fileName + ".json","w") as outfile:
            json.dump(dataJSON, outfile)
        
        print(updateDateTime)
        print(now)
        


#Timeframes (NFL ONLY)
#Because the NFL is a weekly sport, dates aren't as useful as weeks for point-in-time context. 
#The first step for NFL is to sync the timeframes to your database. 
# Timeframes are equivalent to "Weeks" during the NFL season. They never change, but you will 
# want to use the Timeframe API to determine what the current week is. This will allow you to 
# dynamically pull team/player stats for the current week, by getting the current week from timeframe API, 
# then passing that along to the other APIs. 
#https://sportsdata.io/developers/api-documentation/nfl#/endpoint/timeframes
#Check if a CurrentTimeFrames file has been Updated within the last 24 hours

getCurrentTimeFramesURL = 'https://api.sportsdata.io/v3/nfl/scores/json/Timeframes/current'
getCompletedTimeFramesURL = 'https://api.sportsdata.io/v3/nfl/scores/json/Timeframes/complete'
    
refreshData(getCurrentTimeFramesURL, apiKey, "CurrentTimeFrames")
refreshData(getCompletedTimeFramesURL, apiKey, "CompletedTimeFrames")
    
#Teams
# Sync the team data every evening to ensure you have the latest team information. 
getActiveTeamsURL = 'https://api.sportsdata.io/v3/nfl/scores/json/Teams'
refreshData(getActiveTeamsURL, apiKey, "ActiveTeams")
        
#Schedule
#Sync the schedules once every hour to ensure you have the most up-to-date start times for games in your database. 
# The schedule feed includes odds and weather (for NFL and MLB only). 
getScheduleURL = 'https://api.sportsdata.io/v3/nfl/scores/json/Schedules/2022'
refreshData(getScheduleURL, apiKey, "2022Schedule")

#Standings
#Sync standings every evening or once every hour if you prefer. 

#Rosters & Player Details
#Sync the rosters & player details once every 2-4 hours to ensure you have the latest player movement, 
# change in depth chart, injury status, and active status (Active, Suspended, Injured Reserve, etc). 
# Please note that there are several ways to sync the latest player details in our various APIs. However, we 
# recommend calling Player Details by Active and Player Details by Free Agent. Both APIs return the same XML/JSON structure, 
# so you can use the same source code to sync both of these payloads. The roster & player detail feeds include player card 
# info and injury status. 


#Projected Player Game Stats by Week/Date (w/ Lineups, Injuries, FanDuel/DraftKings Salaries)
#The projected player game stats APIs are one of the most powerful piece that we provide. They 
# are perfectly tailored toward building daily fantasy sports lineup optimizers and other tools. 
# We recommend syncing the Projected Player Game Stats by Week/Date as often as every ten minutes, 
# or as little as every 4 hours, depending on the time of day, and whether games are starting within 
# the next few hours or not. For instance, if a game for the given league is scheduled to start 
# within the next 4-6 hours, you should sync this data every ten minutes. However, if it's going to be 
# 6+ hours until a game starts, then it makes more sense to sync this data every 1-4 hours, depending 
# on your application. In this feed, projected stats, injuries, and starting lineup information are all 
# updated every ten minutes in the 4-6 hours leading up to game time.


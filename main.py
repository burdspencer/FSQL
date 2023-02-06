import urllib.request
import json #might use this idk
#import pickle #might use this idk
from datetime import datetime
import os as os
apiKey = '?key=668aa1ee702b49f5a66935b7cce375ca'

#Timeframes (NFL ONLY)
#Because the NFL is a weekly sport, dates aren't as useful as weeks for point-in-time context. 
#The first step for NFL is to sync the timeframes to your database. 
# Timeframes are equivalent to "Weeks" during the NFL season. They never change, but you will 
# want to use the Timeframe API to determine what the current week is. This will allow you to 
# dynamically pull team/player stats for the current week, by getting the current week from timeframe API, 
# then passing that along to the other APIs. 
#https://sportsdata.io/developers/api-documentation/nfl#/endpoint/timeframes

#Check if a CurrentTimeFrames file has been Updated within the last 24 hours
if os.path.isfile("CurrentTimeFrame.json") == True:
    print("yes")
    with open("CurrentTimeFrame.json","r") as openfile:
        json_object = json.load(openfile)
        print(json_object)

    if(json_object["UpdatedAt"] == datetime.now.days - 1):
        print(1)


        #API Endpoints to gather Current and Completed NFL TimeFrames
        getCurrentTimeFramesURL = 'https://api.sportsdata.io/v3/nfl/scores/json/Timeframes/current'
        getCompletedTimeFramesURL = 'https://api.sportsdata.io/v3/nfl/scores/json/Timeframes/complete'

        currentTimeFrames = urllib.request.urlopen(getCurrentTimeFramesURL + apiKey).read()
        completedTimeFrames = urllib.request.urlopen(getCompletedTimeFramesURL + apiKey).read()

        #Get the current date and time for version control
        now = datetime.now()
        dt_string = now.strftime("%d/%m/%Y %H:%M:%S")

        #Decode and load each into JSON object
        currentTimeFramesString = currentTimeFrames.decode("utf-8")
        currentTimeFramesList = json.loads(currentTimeFramesString)[0]
        currentTimeFramesList["UpdatedAt"] = dt_string
        currentTimeFramesJSON = json.dumps(currentTimeFramesList)

        completedTimeFramesString = completedTimeFrames.decode("utf-8")
        completedTimeFramesList = json.loads(completedTimeFramesString)[0]
        completedTimeFramesList["UpdatedAt"] = dt_string
        completedTimeFramesJSON = json.dumps(completedTimeFramesList)


        with open("CurrentTimeFrame.json","w") as outfile:
            json.dump(currentTimeFramesJSON, outfile)

        with open("CompletedTimeFrames.json","w") as outfile:
            json.dump(completedTimeFramesJSON, outfile)



#Teams
# Sync the team data every evening to ensure you have the latest team information. 

#Schedule
#Sync the schedules once every hour to ensure you have the most up-to-date start times for games in your database. 
# The schedule feed includes odds and weather (for NFL and MLB only). 

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


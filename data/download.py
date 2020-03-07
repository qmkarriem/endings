#to run this script once per day (auto-update the washingtonpost data from GitHub) add this to crontab:
# 0 12 * * * python /Users/quran/Dropbox/MusicArtProjects/endsSentenceFunction/data/download.py
import os
import urllib

fullfilename = os.path.join('/Users/quran/Dropbox/MusicArtProjects/endsSentenceFunction/data', 'fatal-police-shootings-data.csv')
csvData = urllib.URLopener()
csvData.retrieve("https://raw.githubusercontent.com/washingtonpost/data-police-shootings/master/fatal-police-shootings-data.csv", fullfilename)

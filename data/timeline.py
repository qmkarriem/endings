# create a file with days since 1/1/2015 from each event

from datetime import date

csvFile = open('/Users/quran/Dropbox/MusicArtProjects/endsSentenceFunction/data/fatal-police-shootings-data.csv', "r")
timeLine = open('/Users/quran/Dropbox/MusicArtProjects/endsSentenceFunction/data/timeLine.txt', "w")

csvLines = csvFile.readlines()

#extract date from new data entries in csvFile, convert them to python format
i = 1
while i < len(csvLines):
    tmp = csvLines[i].split(',')
    tmp2 = tmp[2].split('-')
    delta = date(int(tmp2[0]), int(tmp2[1]), int(tmp2[2])) - date(2015,01,01)
    timeLine.write(str(delta.days) + '\n')
    i += 1

csvFile.close()
timeLine.close()

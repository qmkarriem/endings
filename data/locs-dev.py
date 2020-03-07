import geocoder
csvFile = open('/Users/quran/Dropbox/MusicArtProjects/endsSentenceFunction/data/fatal-police-shootings-data.csv', "r")
latLongList = open('/Users/quran/Dropbox/MusicArtProjects/endsSentenceFunction/data/latLongList.txt', "r") # to read the list for number of lines
latLongEdit = open('/Users/quran/Dropbox/MusicArtProjects/endsSentenceFunction/data/latLongList.txt', "a") # to append new data to the list
csvLines = csvFile.readlines()
longLines = latLongList.readlines()
print len(csvLines), len(longLines)
print csvLines[len(longLines)]

#extract latitude longitude from new data entries in csvFile, append them to latLong
i = len(longLines)
while i < len(csvLines):
    tmp = csvLines[i].split(',')
    g = geocoder.google(str(tmp[8] + ", " + tmp[9] + "\n"))
    for result in g:
        latLongEdit.write(str(result.latlng))
        latLongEdit.write("\n")
    i += 1

csvFile.close()
latLongList.close()

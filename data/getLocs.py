latLongList = open('/Users/quran/Dropbox/MusicArtProjects/endsSentenceFunction/data/latLongList.txt', "r")
longsList = open('/Users/quran/Dropbox/MusicArtProjects/endsSentenceFunction/data/longsList.txt', "w")

#get Longitudes from list
for line in latLongList:
    temp = line.split(', ')
    longsList.write(temp[1][:-2])
    longsList.write("\n")

longsListRead = open('/Users/quran/Dropbox/MusicArtProjects/endsSentenceFunction/data/longsList.txt', "r")
for line in longsListRead:
    print line
    
latLongList.close()
longsList.close()
longsListRead.close()

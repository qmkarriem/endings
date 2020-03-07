// work on timings of events

PFont timesNew, sansSerif, smallSans;
PImage img;
StoryLine s;
import netP5.*; // library to connect to other machines & programs via NetAddress
import oscP5.*; // library to format and send OSC messages

// make a story with an arbitrary number of lines
ArrayList<StoryLine> fullStory = new ArrayList<StoryLine>();
ArrayList<StoryLine> nameList = new ArrayList<StoryLine>(); //store just the names to be sent to supercollider
ArrayList<Integer> ageList = new ArrayList<Integer>(); //store just the ages to be sent to supercollider
ArrayList<String> longitudes = new ArrayList<String>(); //store just the longitudes to be sent to supercollider
ArrayList<String> timingData = new ArrayList<String>(); //store just the timings to determine events
String[] thisData, temp, dateTemp, timeTemp;

String shotSyn, taserSyn, violence, month, day, year, pronoun, thisLine;
int textHeight = 500;
int fadeDirection = 1;
int timedLine, count, textOpacity, rVal, gVal, bVal, loc, locX, locY, construction, time, imgChoice = 0;
OscP5 osc;
NetAddress supercollider;

void setup(){
  // GRAPHICS & OSC SETUP
  fullScreen();
  //size(800, 600);
  osc = new OscP5(this, 12000);
  supercollider = new NetAddress("127.0.0.1", 57120);
  imageSelector();
  loadPixels();
  smooth();
  background(0);
  frameRate(3);
  timesNew = createFont("Times-Roman", int((width*height)/45000));
  textFont(timesNew);
  
  // LOAD CSV DATA
  String lines[] = loadStrings("fatal-police-shootings-data.csv"); // Pull this file from github repo once per day? Doable at runtime?
  String locations[] = loadStrings("longsList.txt");
  String timings[] = loadStrings("timeLine.txt");

  // PROCESS DATA AND CONSTRUCT SENTENCES
  for (int i = 1; i < lines.length; i++) {
    buildSentence(lines[i]);
  }
  for (int i = 0; i < locations.length; i++) {
    longitudes.add(locations[i]);
  }
  for (int i = 0; i < timings.length; i++) {
    timingData.add(timings[i]);
  }
  time = millis();
}

void draw(){
  locX = int(random(img.width));
  locY = int(random(img.height));
  if (count < fullStory.size()){
    for (int i = count; i < fullStory.size(); i++) {
      if (count == int(timingData.get(i))){
        fullStory.get(i).display();
        OscMessage msg = new OscMessage("/phrase"); //message for voice synth
        OscMessage msg2 = new OscMessage("/story"); //message for sinewave oscillators
        msg.add(fullStory.get(count).getLine()).add(count % 32); //send either fullStory or nameList to SC
        msg2.add(map(ageList.get(count), 5, 65, 1000, 100)).add(map(float(longitudes.get(count)), -125.0, -75.0, -1.0, 1.0)).add(0.1);
        float speechChance = .05;
        float speechResult = random(1.0);
        if (((millis() - time)/500) >= int(timingData.get(count))){
          if (speechResult < speechChance){
            osc.send(msg, supercollider);
          } else {osc.send(msg2, supercollider);}
        fadeIn();
        }
      }  
    }
    count+=1;
  } else {
      count = 0;
      fill(0);
      rect(0, 0, width, height);
      imageSelector();
      String lines[] = loadStrings("fatal-police-shootings-data.csv"); // Look for ways to make this global instead of needing to re-declare/initialize
      String locations[] = loadStrings("longsList.txt");
      String timings[] = loadStrings("timeLine.txt");
      for (int i = 1; i < lines.length; i++) {
        buildSentence(lines[i]);
      }
      for (int i = 0; i < locations.length; i++) {
        longitudes.add(locations[i]);
      }
      for (int i = 0; i < timings.length; i++) {
        timingData.add(timings[i]);
      }
      //save("output.jpg");
      //exit();
    }
  } 

// A line should consist of a string, an appearance time, RGB values and body camera state
class StoryLine {
  String thisLine;
  float appearTime;
  StoryLine(String tl){
    thisLine = tl;
  }
  String getLine(){
    return thisLine;
  }
  void display(){
    println(thisLine);
    for (int i = 0; i < thisLine.length(); i++){
      loc = locX + (12 * i) + locY*img.width;
      if (loc <= (img.width * img.height) - 1){ 
        rVal = int(red(img.pixels[loc])); 
        gVal = int(green(img.pixels[loc]));
        bVal = int(blue(img.pixels[loc]));
        fill(rVal, gVal, bVal, textOpacity);
        text(thisLine.charAt(i), locX + (12*i), locY);
      } else {
        rVal = 0;
        gVal = 0;
        bVal = 0;
      }
    }
  }
}

void getPronoun(){
  switch (thisData[6]){
      case "M":
        pronoun = "He";
        break;
      case "F":
        pronoun = "She";
        break;
    }
}

long diffInDays(LocalDate a, LocalDate b) {
  println(DAYS.between(a, b));
  return DAYS.between(a, b);
}

void dateConverter(){ //PARSE NUMERIC DATES; CHANGE to MONTH, DAY, YEAR
  dateTemp = split(thisData[2], '-'); 
  year = dateTemp[0];
  if (dateTemp.length >= 3){
    day = dateTemp[2];
  }
    
  if (dateTemp.length >= 2){ 
    switch (dateTemp[1]){ 
      case "01":
        month = "January";
        break;
      case "02":
        month = "February";
        break;
      case "03":
        month = "March";
        break;
      case "04":
        month = "April";
        break;
      case "05":
        month = "May";
        break;
      case "06":
        month = "June";
        break;
      case "07":
        month = "July";
        break;
      case "08":
        month = "August";
        break;
      case "09":
        month = "September";
        break;
      case "10":
        month = "October";
        break;
      case "11":
        month = "November";
        break;
      case "12":
        month = "December";
        break;
    }
  }
}
/* A line should begin fade in when it's appearance time is reached, 
and begin fade out when disappearance is reached. */

void fadeIn() {
  if (textOpacity < 55){
    textOpacity += 5;
  } 
}

void imageSelector() {
  imgChoice = int(random(6));  // Is it possible to check the folder for images and load them all to an array of arbitrary length? If not, use a CSV or database to manage image references as an array.
  switch (imgChoice){
    case 0:
      img = loadImage("tamir-rice.jpg");
      break;
    case 1:
      img = loadImage("alton-sterling.jpg");
      break;
    case 2:
      img = loadImage("john-crawford.jpg");
      break;
    case 3:
      img = loadImage("walter-scott.jpg");
      break;
    case 4:
      img = loadImage("justin-carr.jpg");
      break;
    case 5:
      img = loadImage("Trayvon-Martin-Hoodie.jpg");
      break;
  }
  img.resize(width, height);
}

void buildSentence(String line) {
  String deathWords[] = loadStrings("death-words.csv");
  String deathWordsPresent[] = loadStrings("death-words-present.csv");
  String government[] = loadStrings("government.csv");
  String timePeriod[] = loadStrings("time-period.csv");
  String shot[] = loadStrings("shot.csv");
  String taser[] = loadStrings("tasered.csv");
  String adverbs[] = loadStrings("adverbs.csv");
  String verbs[] = loadStrings("verbs.csv");
  
  thisData = split(line, ','); //split each CSV line into discrete data
    getPronoun();
    dateConverter();
    temp = split(thisData[3], ' ');
    switch (temp[0]){ // replace the word 'shot' with a random synonym from the database
      case "shot":
        shotSyn = shot[int(random(shot.length))];
        break;
    }
    violence = shotSyn;
    if (temp.length >= 3){
      switch (temp[2]){ // replace the word 'Tasered' with a random synonym from the database
        case "Tasered":
          taserSyn = taser[int(random(taser.length))];
          violence += " and " + taserSyn;
          break;
      }
    }
    construction = int(random(7)); // randomly choose a pre-defined sentence structure
    nameList.add(new StoryLine(thisData[1]));
    ageList.add(new Integer(int(thisData[5])));
    switch(construction){
      case 0:
        fullStory.add(new StoryLine(thisData[1] + " was " +  violence + " by " + government[int(random(government.length))].toLowerCase() + " and " + deathWords[int(random(deathWords.length))] + " on " + month + " " + day + ", " + year + "."));
        break;
      case 1:
        fullStory.add(new StoryLine(government[int(random(government.length))] + " " + violence + " " + thisData[1] + " on " +  month + " " + day + ", " + year + ". " + pronoun + " " + deathWords[int(random(deathWords.length))] + " " + timePeriod[int(random(timePeriod.length))]+ "."));
        break;
      case 2:
        fullStory.add(new StoryLine("On " +  month + " " + day + ", " + year + ", " + government[int(random(government.length))].toLowerCase() + " " + violence + " " + thisData[1] + ". " + pronoun + " " + deathWords[int(random(deathWords.length))] + " " + timePeriod[int(random(timePeriod.length))]+ "."));
        break;
      case 3:
        fullStory.add(new StoryLine("On " +  month + " " + day + ", " + year + ", " + thisData[1] + " was " +  violence + " by " + government[int(random(government.length))].toLowerCase() + " and " + deathWords[int(random(deathWords.length))] + " " + timePeriod[int(random(timePeriod.length))] + "."));
        break;
      case 4:
        fullStory.add(new StoryLine(thisData[1] + " " + deathWords[int(random(deathWords.length))]  + " after " + pronoun.toLowerCase() + " was " + violence + " by " + government[int(random(government.length))].toLowerCase() + "."));
        break;
      case 6:
        fullStory.add(new StoryLine(government[int(random(government.length))] + " " + verbs[int(random(verbs.length))] + " that " + thisData[1] + " should " + deathWordsPresent[int(random(deathWordsPresent.length))] + "."));    
    }
}
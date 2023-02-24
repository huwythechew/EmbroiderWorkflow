let lowFPS = 10;
var curFrame = 0;
var cycleStart = 0;
var imgs;
var w,h;
var curHour = 0;
var loadingGif;

var playingEnd = false;
var endRange = [120,154];//exclusive upper limit
var loading = true;

function loadImgs() {
  imgs = [];
  for (var i=0; i<154; i++) {
    if (i==153) imgs[i] = loadImage("frames/"+i+".jpg", loadedLastFrame);
    else {
      imgs[i] = loadImage("frames/"+i+".jpg")
    }
  }
}

function preload() {
  loadingGif = createImg("embLoad.gif");
  loadingGif.hide();
  //loadImgs();
}

function loadedLastFrame() {
  loading = false;
  loadingGif.hide();
}

function setup() {
  imageMode(CENTER);
  createCanvas(windowWidth,windowHeight);
  frameRate(lowFPS);
  loadImgs()
}

function draw() {
  resizeWindow();
  if (loading) {
    loadingGif.show();
    loadingGif.position(width/2-w/2,0);
    loadingGif.size(w,h);
    return;
  }
  var hrInput = floor(hour()+5)%12;
  //var hrInput = (floor(mouseX/width*24))%12
  //var hrInput = floor(second()/6+5)%12;
  if (curHour!=hrInput) setHour(hrInput);
  if (!playingEnd) {
    curFrame = (curFrame+1)%10;
  }
  else {
    curFrame++;
    if (curFrame==endRange[1]){
      playingEnd=false;
      setHour(0);
      curFrame=5;
    }
  }
  var ind = curFrame+cycleStart;
  if (imgs[ind]!=null)image(imgs[ind],width/2,h/2,w,h);
  else print("frame "+ind+" not loaded")
}


function setHour(hr) {
  if (curHour==11&&hr==0){
    if (curFrame!=0) return;
    playingEnd = true;
    curFrame = endRange[0]-1;
  }
  else curFrame = 0;
  curHour = hr;
  cycleStart = curHour*10;
}

function resizeWindow() {
  resizeCanvas(windowWidth,windowHeight);
  w = min(windowWidth,windowHeight);
  h = min(windowWidth,windowHeight);
}
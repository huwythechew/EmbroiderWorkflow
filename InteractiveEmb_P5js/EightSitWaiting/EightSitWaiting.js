var frames = [];

var loading = true;
var imgsLoaded = 0;


var x=0,y=0;
var srcM = [0,0];
var velM = [0,0];
var drawAlt = false;
var prevM = [0,0];

var prevClickMillis = 0;

var numImgs = 132;

function setup() {
  
  for (var i=0; i<numImgs; i++) {
    //var imgName = "skullFrames/"+(i<10? "0"+i:i)+".jpg";
    var imgName = "frames/"+(i)+".jpg";
    frames[i] = loadImage(imgName,img => {imgsLoaded++});
    
  }
  
  var w = min(window.innerWidth,window.innerHeight);
  
  createCanvas(w,w);
  
  frameRate(10);
  srcM = [width/3,height/2];
}

function draw() {
  if (abs(velM[0])<2) velM[0] = 0;
  if (abs(velM[1])<2) velM[1] = 0;
  background(200);
  if (loading) {
    if (imgsLoaded>=numImgs) {
      loading = false;
    }
    fill(44);
    textAlign(CENTER); textFont("Courier New");
    textSize(28);
    text("Eight Sit Waiting",width/2,height/2-70);
    textSize(20);
    text("loading...",width/2,height/2-20);
    noFill(); stroke(0); strokeWeight(1);
    rectMode(CENTER);
    rect(width/2,height/2,300,16);
    rectMode(CORNER);
    fill(44); strokeWeight(0.5);
    rect(width/2-150,height/2-8,map(imgsLoaded,0,numImgs,0,300),16);
    
    return;
  }
  
  push();
  if (x<0) {
    scale(-1,1);
    translate(-width,0);
  }
  if (y<0) {
    scale(1,-1);
    translate(0,-height);
  }
  
  //print(x);
  ind = int(abs(x)*10+abs(y));
  if (abs(y)>9) ind = 60+int(abs(x));
  var curFrameImg = frames[ind];
  if (drawAlt) curFrameImg = frames[ind+66];
  drawAlt = !drawAlt;
  //print("img: "+ind);
  image(curFrameImg,0,0,width,height);
  
  pop();
  
  //fill(255); noStroke();
  //rect(0,0,50,50);
  //rect(width-50,0,50,50);
  //rect(0,height-50,50,50);
  //rect(width-50,height-50,50,50);
  srcM[0] += velM[0];
  //print(velM[0]);
  srcM[1] += velM[1];
  confineM();
  
  
  if (keyIsDown(LEFT_ARROW)) {
    velM[0] -=4;
  }

  if (keyIsDown(RIGHT_ARROW)) {
    velM[0] +=4;
  }

  if (keyIsDown(UP_ARROW)) {
    velM[1] -=4;
  }

  if (keyIsDown(DOWN_ARROW)) {
    velM[1] +=4;
  }
  applyM();
  
  //apply drag
  //velM[0] *= 0.98;
  //velM[1] *= 0.98;
  if (abs(velM[0])>60) {
    velM[0] = (velM[0]<0? -1: 1) * 1;
  }
  if (abs(velM[1])>60) {
    velM[1] = (velM[1]<0? -1: 1) * 1;
  }
  
}
//print(velM);
function keyPressed() {
  
  if (keyCode == LEFT_ARROW) {
    //velM[0] -=8;
    //x--;
    //if (x<-5) x=4;
  } else if (keyCode == RIGHT_ARROW) {
    //velM[0] +=8;
    //x++;
    //if (x>5) x=-4;
  } else if (keyCode == UP_ARROW) {
    //velM[1] -=8;
    //y++;
    //if (y>9) y=9;
  } else if (keyCode == DOWN_ARROW) {
    //velM[1] +=8;
    //y--;
    //if (y<-9) y=-9;
  }
}

function mousePressed() {
  prevM = [mouseX,mouseY];
  
  var mils = millis();
  if (mils-prevClickMillis<250) draw2 = !draw2;
  prevClickMillis = mils;
}

function mouseReleased() {
}

function confineM() {
  if (srcM[0]>=width) srcM[0] = 0; if (srcM[0]<0) srcM[0] = width-1;//wrap x axis controls
  if (srcM[1]>=width) {
    srcM[1] = width-1; 
  }
  if (srcM[1]<0) {
    srcM[1] = 0;//clip y axis controls to frame
    velM[1] = 0;
  }
}

function mouseDragged() {
  srcM[0]+=mouseX-prevM[0];
  srcM[1]+=mouseY-prevM[1];
  confineM();
  
  applyM();
  if (mouseX<0) x = -5; if (mouseY<0) y = -10;
  
  velM[0] = mouseX-prevM[0];
  velM[1] = mouseY-prevM[1];
  prevM = [mouseX,mouseY];
}

function applyM() {
  newX = floor(map((srcM[0]*4)%width,0,width,5,-5));
  newY = floor(map(srcM[1],0,height,-10,11));
  
  x = newX;
  y = newY;
  
}

function conformXY() {
  x = min(x,5); x = max(x,-5);
  y = min(y,9); y = max(y,-9);
}

function windowResized() {
  var w = min(window.innerWidth,window.innerHeight);
  resizeCanvas(w,w);
}

let bImg;

let s = 0.75; //zoom with this variable
let gravity = 20; // change gravity force
let frmrate = 10; //change framerate with this variable


let plantM = null;
let saveEnd = null;

let isMobile = false;


let lineBoard;
let click,looper,release;

let p1, p2, v1, v2;

let expP1, expP2;

let altF = false;
let begining = false;

let fade = 255;

let curPointLoc;
let initPointData = [
  [1001,781],
  [1872,1328],
  [2123,735],
  [3439,553],
  [1851,1587]];

let initLineData = [
  [296.0,289.0,994.0,1052.0],
  [476.0,1012.0,716.0,1200.0],
  [1194.0,526.0,1230.0,435.0],
  [1327.0,587.0,1745.0,479.0],
  [1564.0,815.0,1620.0,964.0],
  [1522.0,957.0,1451.0,1494.0],
  [823.0,1509.0,888.0,1783.0],
  [651.0,1607.0,219.0,2129.0],
  [415.0,2912.0,638.0,2987.0],
  [493.0,2786.0,736.0,2919.0],
  [973.0,2808.0,583.0,2570.0],
  [672.0,2405.0,1125.0,2697.0],
  [1293.0,2607.0,762.0,2213.0],
  [797.0,2070.0,1514.0,2508.0],
  [1667.0,2299.0,2562.0,2260.0],
  [2626.0,2205.0,1553.0,2233.0],
  [1486.0,2183.0,2693.0,2175.0],
  [2734.0,2105.0,1415.0,2124.0],
  [1459.0,1979.0,1519.0,1952.0],
  [2100.0,2113.0,2084.0,1578.0],
  [2428.0,1787.0,2750.0,1618.0],
  [2569.0,1901.0,3075.0,1471.0],
  [3135.0,1820.0,3473.0,1987.0],
  [3500.0,1570.0,3411.0,910.0],
  [3180.0,1242.0,3181.0,1164.0],
  [3045.0,1180.0,2573.0,1435.0],
  [2257.0,1266.0,2374.0,1025.0],
  [2653.0,822.0,2535.0,633.0],
  [2968.0,804.0,2951.0,493.0],
  [2150.0,369.0,2235.0,364.0],
  [1827.0,673.0,1922.0,426.0],
  [3481.0,764.0,3565.0,831.0]
];

function preload() {

  if( /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent) ) {
      // is mobile..
    isMobile=true;
    s *= 1.25;
    bImg = loadImage("images/lineBoard_HALF.jpg")
  }
  else bImg = loadImage("images/lineBoard_FULL.jpg");
  initPointLocs();
  loadSounds();
}


function setup() {
  createCanvas(windowWidth,windowHeight);
  // add these to your setup function AFTER createCanvas()
  var el = document.getElementsByTagName("canvas")[0];
  el.addEventListener("touchstart", mousePressed, false);


  bImg.resize(bImg.width*s,bImg.height*s);
  lineBoard = new Board(bImg,initLineData);
  frameRate(frmrate);
  initPs();
  randomizePointLoc();
  looper.loop()
}

function initPs() {
  p1 = createVector(random(width),random(height));
  p2 = createVector(random(width),random(height));
  v1 = createVector();
  v2 = createVector();
  expP1 = createVector();
  expP2 = createVector();
}

function loadSounds() {
  click = loadSound("sounds/click.mp3");
  looper = loadSound("sounds/loop.mp3");
  release = loadSound("sounds/release.mp3");
}

function runPs() {
  let m = createVector(mouseX,mouseY);
  if (m.mag()<1) m = createVector(width/2,height/2);
  let osM = m.copy().sub(p1);
  v1.add(osM.div(10));

  let osP = p1.copy().sub(p2);
  v2.add(osP.div(( noise(millis()/500)) * 20));

  p1.add(v1);
  p2.add(v2);
  v1.mult(0.8);
  v2.mult(0.9);
  v2.y+=gravity;
  p1.set(m);
}

function randomizePointLoc() {
  curPointLoc = random(pointLocs);
}

function draw() {
  //print("x: "+pRotationX+"  y: "+pRotationY);
  runPs();
  altF =  !altF;
  background(200);
  push();
  //rotate(millis()/1000);
  //plantM = p2.copy();
  if (plantM!=null) {
    let m = createVector(mouseX,mouseY);

    expP2.lerp(plantM,0.5);
    expP1.lerp(m,0.5);

    p1 = expP1.copy();
    p2 = expP2.copy();

    //print("running mousedragger");
    //line(plantM.x,plantM.y,mouseX,mouseY);
    //let m = p1.copy();
    //if (saveEnd!=null) m = saveEnd.copy();
  }
  else if (p1!=null){
    expP1.lerp(p1,0.5);
    expP2.lerp(p2,0.5);
    //print("running p1,p2 floater");
    //let m = createVector(mouseX,mouseY);
    //if (saveEnd!=null) m = saveEnd.copy();

  }
  if (!begining) {
    let d = expP1.dist(expP2);
    //print(d);
    if (d<70&&curPointLoc!=null) {

      translate(expP2.x,expP2.y);
      rotate(random(TWO_PI));
      translate(-curPointLoc.x,-curPointLoc.y);
      if (random(10)<1) randomizePointLoc();

    }
    else {
      let cl = lineBoard.closestLine(d)
      let osCur = expP1.copy().sub(expP2);
      let rat = d/cl.len;
      translate(expP2.x,expP2.y);
      //scale(rat);
      if (altF) {
        rotate(-cl.h+PI);
      }
      else rotate(-cl.h);
      rotate(osCur.heading());
      if (altF) {
        translate(-cl.to.x,-cl.to.y);
      }
      else translate(-cl.from.x,-cl.from.y);

    }

    imageMode(CORNER);

    image(bImg,0,0);
    image(bImg,bImg.width,0);
    image(bImg,-bImg.width,0);
    image(bImg,0,bImg.height);
    image(bImg,0,-bImg.height);
    image(bImg,-bImg.width,-bImg.height);
    image(bImg,bImg.width,-bImg.height);
    image(bImg,-bImg.width,bImg.height);
    image(bImg,bImg.width,bImg.height);

  }
  else {
    imageMode(CENTER);
    if (width/height>bImg.width/bImg.height) {
      image(bImg,width/2,height/2,bImg.width/bImg.height*height,height);
    }
    else {
      image(bImg,width/2,height/2,width,bImg.height/bImg.width*width);
    }

  }

  pop();
  if (fade>0) {
    fill(200,fade);
    noStroke();
    rect(0,0,width,height);
    fade-=10;
  }
  //circle(expP1.x,expP1.y,10);
  //circle(expP2.x,expP2.y,10);
}

function initPointLocs(){
  pointLocs = [];
  let secS = 1;
  if (isMobile) secS = 0.5;
  for (let i=0; i<initPointData.length; i++) {
    let newD = createVector(initPointData[i][0]*s*secS,initPointData[i][1]*s*secS);
    pointLocs.push(newD);
  }

}

function windowResized() {
  //resizeCanvas(windowWidth,windowHeight);
}

function mousePressed() {
  //print("push");
  click.play();
  randomizePointLoc();
  plantM = createVector(mouseX,mouseY);
  saveEnd = null;
  noCursor();
}



function mouseReleased() {
  //print("pop");
  release.play();
  plantM = null;
  saveEnd = createVector(mouseX,mouseY);
  cursor();
  begining = false;
}

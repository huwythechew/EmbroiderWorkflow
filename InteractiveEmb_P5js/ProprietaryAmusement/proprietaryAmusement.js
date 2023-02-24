var frmsLoaded = 0;
var numImages = 40;

var loading = true;

var curRun;
let mc,rc0,rc1,rc2,rc3;
let soundMain, sound0, sound1, sound2, sound3;
let soundAr;


function preload() {
  initClips();
  loadSounds();
}

function setup() {
  var w = min(window.innerWidth,window.innerHeight);
  
  createCanvas(w,w);
  frameRate(11);
  
  newRun();
  
}

function draw() {
  
  
  if (loading) {
    background(200);
    drawLoadingScreen();
    return;
  }
  
  if (soundMain!=null && curRun.curFrm==0) soundMain.play();
  curRun.run();
  curRun.draw();
}


function drawLoadingScreen() {
  fill(0);
  textAlign(CENTER); //textFont("Courier New",20);
  text("loading...",width/2,height/2-20);
  noFill(); stroke(255); strokeWeight(1);
  rectMode(CENTER);
  rect(width/2,height/2,300,16);
  rectMode(CORNER);
  fill(230); strokeWeight(0.5);
  rect(width/2-150,height/2-8,map(frmsLoaded,0,numImages,0,300),16);
}


function loadSounds() {
  soundMain = loadSound("sounds/soundMain.mp3");
  sound0 = loadSound("sounds/sound0.mp3");
  sound1 = loadSound("sounds/sound1.mp3");
  sound2 = loadSound("sounds/sound2.mp3");
  sound3 = loadSound("sounds/sound3.mp3");
  soundAr = [sound0,sound1,sound2,sound3];
}

function frmLoadedCall() {
  frmsLoaded++;
  if (frmsLoaded>=39) loading = false;
  //print(frmsLoaded);
}

function newRun() {
  mc.reset();
  let nr = new GameRun(mc,[rc0,rc1,rc2,rc3]);
  curRun = nr;
}
  
function initClips() {
  mc = new PingpongClip("frames/",0,".jpg",16);
  rc0 = new Clip("frames/",16,".jpg",6);
  rc1 = new Clip("frames/",22,".jpg",6);
  rc2 = new Clip("frames/",28,".jpg",6);
  rc3 = new Clip("frames/",34,".jpg",6);
}

function windowResized() {
  var w = min(window.innerWidth,window.innerHeight);
  resizeCanvas(w,w);
}
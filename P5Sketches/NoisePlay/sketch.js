let frmImgs = [];
let frmAt = 0;
let controlling = true;

function preload() {
  for (let i=1; i<=29; i++) {
    frmImgs.push(loadImage("frames/"+i+".jpg"));
  }
}

function setup() {
  let w = min(windowWidth,windowHeight);
  createCanvas(w,w);
  frameRate(12);
}

function draw() {
  background(220);
  let frm = frmAt;
  if (controlling) {
    if (mouseX<0) frm =0;
    else if (mouseX>=width) frm = 28;
    else frm = floor(mouseX/width*29);
  }
  else {
    let n = noise(millis()/1000);
    frm = lerp(frm,floor(n*29),0.1);
  }
  
  if (frmAt<frm) frmAt++;
  else if (frmAt>frm) frmAt--;
  
  image(frmImgs[frmAt],0,0,width,height);
}

function mousePressed() {
  controlling = true;
}

function mouseReleased() {
  controlling = false;
}

function windowResized() {
  
  let w = min(windowWidth,windowHeight);
  resizeCanvas(w,w);
}
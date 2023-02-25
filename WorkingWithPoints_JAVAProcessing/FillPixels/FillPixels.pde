String filename = "blister.png";
String outputSuf = "";
boolean invertSrc = true;
boolean keepAllEnds = true;
String foldername = "/Users/huwmessie/Documents/Processing/FillPixels/srcs/";
PImage src;
boolean vertical = false;
Beap lines;
ArrayList<Beap> blocks;
float separation = 3;
float stitchLen = 24;
boolean brickLines = false;
Beap selected = null;
Beap hvring = null;
ArrayList<PVector> stitches = new ArrayList<PVector>();
PImage pattern;

void setup() {
  size(1000,1000);
  println(stitchLen/100);
  pattern = standardLines(stitchLen,separation/3);
  
  //pattern = loadPattern(foldername+"recycle_pat.png");
  //pattern = spliceImgs(pattern,stitchLen,stitchLen/219.6);
  src = loadImage(foldername+filename);
  
  if (vertical) {
    src = rotateImg(src);
    //separation = stitchLen;
    //pattern = standardLines(stitchLen,11);
  }
  src.resize(width,height);
  if (invertSrc) src.filter(INVERT);
  src.filter(BLUR,1);
  src.filter(THRESHOLD);
  lines = getLinesStnd(src, separation);
  blocks = struct(lines);
  //blocks = orderBeaps(blocks);
}

void draw() {
  
  //image(src,0,0);
  background(255);
  for (Beap bp : blocks) bp.show();
  
  colorMode(RGB);
  if (selected!=null) selected.showShape(color(255,130));
  PVector m = new PVector(mouseX,mouseY);
  hvring = containsPt(blocks, m);
  if (hvring!=null) hvring.showShape(color(0,255,255,80));
  drawDetailStitches();
  labelBeaps(blocks);
  //image(pattern,0,0);
  stroke(0); strokeWeight(1);
  //line(mouseX,0,mouseX,height);
  //for (int i=0; i<height; i+=219.5786) {
  //  line(0,i,width,i);
  //}
}

void mousePressed() {
  PVector m = new PVector(mouseX,mouseY);
  //selected = containsPt(blocks, m);
  Beap on = containsPt(blocks, m);
  if (on!=null && selected==on) on.reverse();
  selected = on;
}

void mouseReleased() {
  
}

void mouseDragged() {
  mousePressed();
}

void keyPressed(KeyEvent e) {
  println(keyCode);
  if( keyCode == 83) { //s
    stitches.add(new PVector(mouseX,mouseY));
  }
  
  if (keyCode==68&&stitches.size()>0) {//d
    stitches.remove(stitches.size()-1);
  }
  
  if (keyCode==69&&stitches.size()>0) {//e
    saveStchs(stitches);
    println(stitches.size());
  }
  
  if( keyCode == 65 && selected!=null) { //a
    if (stitches.size()>0) {
      PVector last = stitches.get(stitches.size()-1);
      stitches.addAll(pullComp(selected.stchPath(last,pattern)));
    }
    else {
      ArrayList<PVector> toAdd = selected.stchPath(pattern);
      stitches.addAll(pullComp(toAdd));
    }
  }
  
  if (keyCode==37) {//left
    for (PVector v : stitches) v.x--;
  }
  
  if (keyCode==39) {//right
    for (PVector v : stitches) v.x++;
  }
  
  if (keyCode==38) {//up
    for (PVector v : stitches) v.y--;
  }
  
  if (keyCode==40) {//down
    for (PVector v : stitches) v.y++;
  }
}

void drawStitches() {
  stroke(0,255,255);strokeWeight(1);
  noFill();
  beginShape();
  for (PVector v : stitches) {
    vertex(v.x,v.y);
  }
  endShape();
}

void drawDetailStitches() {
  if (stitches==null||stitches.size()==0) return;
  strokeWeight(3);
  noFill();
  PVector from = stitches.get(0).copy();
  for (int i=1; i<stitches.size(); i++) {
    PVector to = stitches.get(i);
    drawDetailStitch(from,to);
    from=to;
  }
}

void saveStchs(ArrayList<PVector> stchs) {
  String[] result = new String[0];
  if (vertical) {
    for (PVector stch : stchs) {
      result = (String[]) append(result, str(int(stch.y)));
      result = (String[]) append(result, str(int(stch.x)));
    }
  }
  
  else {
    for (PVector stch : stchs) {
      result = (String[]) append(result, str(int(stch.x)));
      result = (String[]) append(result, str(int(stch.y)));
    }
  }
  String path = "/Users/huwmessie/Documents/Python/Thread/srcFiles/pinkVice/"+filename+outputSuf;
  if (vertical) {
    saveStrings(path+"_vert.txt", result);
    return;
  }
  saveStrings(path+".txt", result);
}

ArrayList<PVector> pullComp(ArrayList<PVector> stchs) {
  ArrayList<PVector> toAdds = new ArrayList<PVector>();
  for (int i=1; i<stchs.size()-1; i++) {
    PVector prvS = stchs.get(i-1);
    PVector curS = stchs.get(i);
    PVector nxtS = stchs.get(i+1);
    PVector subOS1 = curS.copy().sub(prvS);
    PVector subOS2 = nxtS.copy().sub(curS);
    float ang = PVector.angleBetween(subOS1,subOS2);
    if (abs(ang)>HALF_PI) {
      println("h");
      PVector midConnect = prvS.copy().lerp(nxtS,0.5);
      PVector os = curS.copy().sub(midConnect);
      float mag = min(subOS1.mag(),subOS2.mag());
      os.normalize().mult(mag*0.05);
      toAdds.add(os);
    }
    else toAdds.add(new PVector());
  }
  
  for (int i=0; i<toAdds.size(); i++) {
    stchs.get(i+1).add(toAdds.get(i));
  }
  return stchs;
}

PImage loadPattern(String s) {
  pattern = loadImage(s);
  pattern.resize(width,height);
  pattern.filter(THRESHOLD,0.7);
  oneEdge(pattern);
  return pattern;
}

PImage oneEdge(PImage img) {
  img.loadPixels();
  for (int y=0; y<img.height; y++) {
    
    boolean onBlack = false;
    for (int x=0; x<img.width; x++) {
      int ind = y*img.width + x;
      color at = img.pixels[ind];
      if (brightness(at)<50) {
        if (onBlack) {
          img.pixels[ind] = color(255);
        }
        else onBlack = true;
      }
      else onBlack = false;
    }
  }
  return img;
}

void drawDetailStitch(PVector f, PVector t) {
  colorMode(HSB);
  PVector from = f.copy();
  if (f.x>t.x) {
    f=t;
    t=from.copy();
  }
  float inc = 0.1;
  for (float i=inc; i<=1.001; i+=inc) {
    PVector to = f.copy().lerp(t,i);
    //float b = i*1280;
    float b = 255-abs(128-map(sqrt(i),0,1,0,255));
    stroke(color(128,255,b));
    line(from.x,from.y,to.x,to.y);
    from=to;
  }
}

String fileName = "RefImgs/circle.png";//path of image
String folderName = "";
String loadFrom = "Blank.txt";
String projectTxtFolder = "ProjectTxts/";
String pointExportFolder = "ExportedPoints/";
PImage art;
String curTool = "select";
int curToolInd = 2;
String[] allTools = new String[]{"running","free","satin","select"};
boolean drawDetail = false;
boolean rvrsObjStchsGLBL = false;
boolean showImage = true;
//float frmOffsetX = 500;
//float frmOffsetY = 500;
float scl = 1;
float artScale = 1;
float frmOffsetX = 0;
float frmOffsetY = 0;
PVector mOffset() {
  return new PVector(-(10/scl)-frmOffsetX,-(10/scl)-frmOffsetY);
}
//PVector renderOffset = new PVector();
color sc = color(0);


boolean drawStats = true;

int frame = 0;

CurvePt heldPt;
int heldInd;
boolean placingPt = false;
boolean pullComp = true;

PVector prevFrmM;

boolean movingObj = false;
boolean movingCanvas = false;

ArrayList<StitchObj> queue = new ArrayList<StitchObj>();
StitchObj curObj;
ArrayList<StitchObj> multiSlct = new ArrayList<StitchObj>();
float defLength = 20;
float defSeparation = 4;
float margin = 0;
float frameSize = 60;

void setup() {
  //size(1440,840);
  frameRate(20);
  //size(666,1000);
  
  size(900,900);
  //size(1200,750);
  //size(1303,733);
  //size(1080,1080);
  initArt(folderName+fileName);
  String[] loadingObjs = loadStrings(projectTxtFolder+loadFrom);
  if (loadingObjs!=null&&loadFrom.length()>0) queue = fromString(loadingObjs);
}

void draw() {
  
  //noCursor();
  background(255);
  
  
  push();
  scale(scl);
  translate(frmOffsetX,frmOffsetY);
  fill(255,60); noStroke();
  rectMode(CORNER);
  fill(255,200); noStroke();
  rectMode(CORNER);
  rect(0,0,width,height);
  //square(width-180,0,180);
  imageMode(CORNER);
  if (art!=null && showImage) {
    image(art,0,0);
    rect(0,0,width,height);
  }
  
  
  int total = 0;
  for (StitchObj so : queue) total += so.stchs.size();
  //println(total);
  showQueue();
  colorMode(RGB);
  stroke(0);
  strokeWeight(6/scl);
  PVector m = mPos();
  point(m.x,m.y);
  stroke(255,0,0);
  
  if (curTool=="running") stroke(255,0,0);
  if (curTool=="satin") stroke(0,255,0);
  if (curTool=="select") stroke(0,0,255);
  if (curTool=="free") stroke(255,0,255);
  strokeWeight(4/scl);
  point(m.x,m.y);
  point(width/2,height/2);
  point(0,0);
  pop();
  if (drawStats) showInstructionsOutline();
}


void keyPressed(KeyEvent e) {
  println(keyCode);
  if (keyCode == 84) { //t - change tool
    curToolInd = (curToolInd+1)%allTools.length;
    curTool = allTools[curToolInd];
  }
  
  if (keyCode == 73) { //i - toggle show image
    showImage = !showImage;
  }
  
  
  
  if (keyCode == 72) { //h - flip Horizontal
    if (curObj!=null) curObj.flipX();
  }
  
  if (keyCode == 76) { //l - selectAll
    multiSlct = new ArrayList<StitchObj>();
    for (StitchObj obj : queue) multiSlct.add(obj);
  }
  
  if (keyCode == 68) { //d - duplicate
    if (curObj!=null) queue.add(curObj.copy());
    else if (multiSlct.size()>0) {
      ArrayList<StitchObj> newMS = new ArrayList<StitchObj>();
      for (StitchObj obj : multiSlct) {
        StitchObj newObj = obj.copy();
        queue.add(newObj);
        newMS.add(newObj);
      }
      multiSlct = newMS;
    }
  }
  
  if (keyCode == 32) { //space - canvasControls
    movingCanvas = !movingCanvas;
  }
  
  if (keyCode == 69) { //e - export
    saveQueue(queue,loadFrom);
  }
  
  if (keyCode == 10) { //enter - clear selection
    multiSlct = new ArrayList<StitchObj>();
    if (curObj==null) return;
    if (curObj.stchs==null||curObj.stchs.size()<1) {
      queue.remove(curObj);
    }
    curObj = null;
  }
  if (keyCode == 8) { //delete - delete selection
    queue.remove(curObj);
    curObj = null;
    for (StitchObj obj : multiSlct) queue.remove(obj);
    multiSlct = new ArrayList<StitchObj>();
    println(queue.size());
  }
  
  if (keyCode == 38) { //up - inc Separation
    if (curObj!=null) {
      curObj.sep+=1;
      curObj.updateStitches();
      defSeparation = curObj.sep;
    }
  }
  if (keyCode == 40) { //down - dec Separation
    if (curObj!=null) {
      curObj.sep-=1;
      if (curObj.sep<=0) curObj.sep = 1;
      else curObj.updateStitches();
      defSeparation = curObj.sep;
    }
  }
  
  if (keyCode == 39) { //right - inc length
    if (curObj!=null) {
      curObj.len++;
      curObj.updateStitches();
      defLength = curObj.len;
    }
  }
  
  if (keyCode == 37) { //left - dec length
    if (curObj!=null) {
      curObj.len--;
      if (curObj.sep<=0) curObj.len++;
      else curObj.updateStitches();
      defLength = curObj.len;
    }
  }
  
  if (keyCode == 82) { //r - rvrsObjStchs
    rvrsObjStchsGLBL = !rvrsObjStchsGLBL;
    if (curObj!=null) {
      curObj.rvrsObjStchs = !curObj.rvrsObjStchs;
      curObj.updateStitches();
    }
  }
  
  if (keyCode == 85) { //u - toggle Underlay
    if (curObj!=null) {
      curObj.ulSatin = !curObj.ulSatin;
      curObj.updateStitches();
    }
  }
  
  if (keyCode == 79) { //o - toggle Overlay
    if (curObj!=null) {
      curObj.olSatin = !curObj.olSatin;
      curObj.updateStitches();
    }
  }
  
  if (keyCode == 91) { //[ - move backwards in queue
    if (curObj!=null) {
      int at = find(curObj,queue);
      if (at==0) return;
      queue.remove(at);
      queue.add(at-1,curObj);
    }
  }
  if (keyCode == 93) { //] - move forwards in queue
    if (curObj!=null) {
      int at = find(curObj,queue);
      if (at==queue.size()-1) return;
      queue.remove(at);
      queue.add(at+1,curObj);
    }
  }
  if (keyCode == 88) { //x - delete last of struct
    if (curObj!=null) {
      curObj.deleteLastStruct();
    }
  }
  
  if (keyCode == 90) { //z - delete first of struct
    if (curObj!=null) {
      curObj.deleteFirstStruct();
    }
  }
  if (keyCode == 57) {// 9 - rotate CCW
    float amt = radians(-1);
    if (curObj!=null) {
      curObj.rotate(amt);
    }
    if (multiSlct.size()>0) {
      PVector c = new PVector();
      for (StitchObj obj : multiSlct) c.add(obj.center());
      c.div(multiSlct.size());
      for (StitchObj obj : multiSlct) obj.rotateAround(amt,c);
    }
  }
  
  if (keyCode == 48) {// 0 - rotate CW
    float amt = radians(1);
    if (curObj!=null) {
      curObj.rotate(amt);
    }
    if (multiSlct.size()>0) {
      PVector c = new PVector();
      for (StitchObj obj : multiSlct) c.add(obj.center());
      c.div(multiSlct.size());
      for (StitchObj obj : multiSlct) obj.rotateAround(amt,c);
    }
  }
  
  if (keyCode == 61) { //= - change satinObj to straightSatin
    if (curObj!=null && curObj.satStruct!=null) {
      curObj.satStruct.straightBars = !curObj.satStruct.straightBars;
      curObj.updateStitches();
    }
  }
  
  if (keyCode == 16 && curTool=="select") { //shift - selectMultiple
    if (curObj!=null && !multiSlct.contains(curObj)) {
      multiSlct.add(curObj);
      curObj = null;
    }
    println("len: "+multiSlct.size());
  }
  
  if (keyCode == 65) { //a - selectAll
  multiSlct = new ArrayList<StitchObj>();
    for (StitchObj so : queue) {
      multiSlct.add(so);
    }
    curObj = null;
    println("len: "+multiSlct.size());
  }
  
  if (keyCode == 78) { //n - minus offset
    if (curObj!=null && curObj.satStruct!=null) {
      curObj.satStruct.offset--;
      curObj.updateStitches();
    }
    
    if (curObj!=null && curObj.runStruct!=null) {
      curObj.runStruct.offset--;
      curObj.updateStitches();
    }
  }
  
  if (keyCode == 77) { //m - plus offset
    if (curObj!=null && curObj.satStruct!=null) {
      curObj.satStruct.offset++;
      curObj.updateStitches();
    }
    
    if (curObj!=null && curObj.runStruct!=null) {
      curObj.runStruct.offset++;
      curObj.updateStitches();
    }
  }
  if (keyCode == 70) { //f - prev frame
    frame --;
  }
  if (keyCode == 71) { //g - next frame
    frame++;
  }
}

void mousePressed() {
  PVector m = mPos();
  prevFrmM = m.copy();
  if (curTool =="select") {
    StitchObj clstObj = nearestObj(m);
    if (curObj==clstObj || multiSlct.contains(clstObj)) {
      movingObj = true;
    }
    else curObj = nearestObj(m);
    
    return;
  }
  
  if (curObj==null||curObj.type!=curTool) {
    curObj = new StitchObj(curTool);
    queue.add(curObj);
  }
  if (curTool == "running") {
    clickRunning(curObj,m);
  }
  else if (curTool == "satin") {
    clickSatin(curObj,m);
  }
  
  else if (curTool == "free") {
    //clickFree(curObj,m);
  }
  
}

PVector mPos() {
  PVector m = new PVector(mouseX, mouseY);
  m.div(scl);
  m.add(mOffset());
  return m;
}

void mouseDragged() {
  PVector m = mPos();
  
  if (movingCanvas) {
    PVector os = m.copy().sub(prevFrmM);
    frmOffsetX+=os.x;
    frmOffsetY+=os.y;
    prevFrmM = mPos();
  }
  
  else if (curTool == "running") {
    dragRunning(curObj,m);
  }
  
  else if (curTool == "satin") {
    dragSatin(curObj,m);
  }
  
  else if (curTool == "select") {
    PVector os = m.copy().sub(prevFrmM);
    if (curObj!=null)curObj.move(os);
    for (StitchObj obj : multiSlct) obj.move(os);
    prevFrmM = m;
  }
  
  else if (curTool == "free") {
    if (curObj!=null) clickFree(curObj,m);
  }
  
}

void mouseReleased() {
  heldPt = null;
  placingPt = false;
  movingObj = false;
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  if (movingCanvas) {
    float mult = (float)1+e/100;
    
    
    
    PVector curFOs = new PVector(frmOffsetX,frmOffsetY);
    
    PVector prevM = mPos();
    
    scl*=mult;
    PVector newM = mPos();
    
    PVector md = newM.copy().sub(prevM);
    curFOs.add(md);
    
    
    //curFOs.sub(m).mult(mult).add(m);
    
    
    //PVector curMFOs = curFOs.copy().sub(m);
    
    
    frmOffsetX = curFOs.x;
    frmOffsetY = curFOs.y;
  }
  else if (multiSlct.size()>0) {
    for (StitchObj so : multiSlct) {
      so.scale((float)1+e/100);
    }
  }
  else {
    for (StitchObj so : queue) {
      so.scale((float)1+e/100);
    }
  }
  println(e);
}

void initArt(String path) {
  art = loadImage(path);
  if (art==null) return;
  float aRat = min((float)(width-margin)/art.width,(float)(height-margin)/art.height);
  //println(aRat);
  int artWidth = (int)(art.width*aRat*artScale);
  int artHeight = (int)(art.height*aRat*artScale);
  //artWidth = artHeight;
  art.resize(artWidth,artHeight);
}

void showQueue() {
  PVector prevEnd=null;
  for (StitchObj obj : queue) {
    if (prevEnd!=null&&obj.stchs.size()>0) {
      PVector to = obj.stchs.get(0);
      colorMode(RGB);
      stroke(255,0,0);
      strokeWeight(1);
      line(prevEnd.x,prevEnd.y,to.x,to.y);
    }
    if (drawDetail) drawDetailStitches(obj.stchs);
    else drawStitches(obj.stchs);
    if (obj.stchs.size()>0) prevEnd = obj.stchs.get(obj.stchs.size()-1);
  }
  if (curObj !=null) {
    curObj.show();
    println("showingblk");
  }
  for (StitchObj obj : multiSlct) obj.show(color(252,148,3));
}

StitchObj nearestObj(PVector v) {
  for (int i=queue.size()-1; i>=0; i--) {
    StitchObj obj = queue.get(i);
    if (obj.dist(v)<4/scl) return obj;
  }
  return null;
}

void showInstructions(PVector at) {
  float x = at.x+5;
  float y = at.y+20;
  textSize(18);
  text("Duplicate(d)",x,y);
  y+=20;
  text("Flip(v/h)",x,y);
  y+=20;
  text("Reorder(9/0)",x,y);
  y+=20;
  text("Tool(t/space): "+(movingCanvas? "canvas controls":curTool),x,y);
  y+=20;
  text("No. Objs: "+queue.size(),x,y);
  y+=20;
  text("Selected Object:",x,y);
  y+=18;
  if (curObj==null) text("None",x,y);
  else {
    x = 15;
    text("Type: "+curObj.type,x,y); y+=18;
    text("Sep: "+curObj.sep+" px",x,y); y+=18;
    text("Len: "+curObj.len+" px",x,y); y+=18;
    text(""+curObj.stchs.size()+" stitches",x,y); y+= 18;
    String s = "Rev Stitches : no";
    if (rvrsObjStchsGLBL) s = "Rev Stitches : yes";
    text(s,x,y);
  }
}

void showInstructionsOutline() {
  fill(0);
  showInstructions(new PVector(-1,-1));
  showInstructions(new PVector(1,-1));
  showInstructions(new PVector(-1,1));
  showInstructions(new PVector(1,1));
  showInstructions(new PVector(-1,0));
  showInstructions(new PVector(1,0));
  showInstructions(new PVector(0,-1));
  showInstructions(new PVector(0,1));
  
  fill(255);
  showInstructions(new PVector());
}

void saveStchs(ArrayList<StitchObj> objs) {
  String[] result = new String[0];
  for (StitchObj obj : objs) {
    for (PVector stch : obj.stchs) {
      result = (String[]) append(result, str(int(stch.x)));
      result = (String[]) append(result, str(int(stch.y)));
    }
  }
  //saveStrings("/Users/huwmessie/Documents/Python/Thread/srcFiles/"+pathname+".txt", result);
  saveStrings(pointExportFolder+loadFrom, result);
}

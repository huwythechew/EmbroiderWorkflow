class StitchObj  {
  String type;
  ArrayList<PVector> stchs = new ArrayList<PVector>();
  Curve runStruct;
  SatinCurve satStruct;
  boolean ulSatin = true;
  boolean olSatin = true;
  ArrayList<PVector> freeStruct;
  
  
  float len = defLength;
  float sep = defSeparation;
  boolean rvrsObjStchs = rvrsObjStchsGLBL;
  
  StitchObj(String t) {
    this.type = t;
    if (t=="running") {
      runStruct = new Curve();
    }
    if (t=="satin") {
      satStruct = new SatinCurve();
    }
    if (t=="free") {
      freeStruct = new ArrayList<PVector>();
    }
    if (t=="river") {
      
    }
  }
  
  StitchObj copy() {
    StitchObj result = new StitchObj(this.type);
    for (PVector v : this.stchs) {
      result.stchs.add(v.copy());
    }
    if (this.type=="running") {
      result.runStruct = this.runStruct.copy();
    }
    if (this.type=="satin") {
      result.satStruct = this.satStruct.copy();
    }
    if (this.type=="free") {
      result.freeStruct = copyVecs(this.freeStruct);
    }
    result.len=this.len; result.sep=this.sep;
    return result;
  } 
  
  PVector middle() {
    PVector result = new PVector();
    for (PVector v : this.stchs) result.add(v);
    result.div(this.stchs.size());
    return result;
  }
  
  int numPts() {
    if (this.type=="running") {
      return this.runStruct.pts.size();
    }
    if (this.type=="free") {
      return freeStruct.size();
    }
    if (this.type=="satin") {
      SatinCurve sc = this.satStruct;
      return(max(sc.c0.pts.size(),sc.c1.pts.size()));
    }
    return 0;
  }
  
  void deleteFirstStruct() {
    if (this.numPts()<=2) return;
    if (this.type=="running") {
      Curve c = this.runStruct;
      c.pts.remove(0);
    }
    if (this.type=="free") {
      PVector from = this.freeStruct.get(0);
      PVector to = this.freeStruct.get(1);
      this.freeStruct.remove(0);
      while (from.dist(to)<2) {
        this.freeStruct.remove(0);
        to = this.freeStruct.get(0);
      }
    }
    if (this.type=="satin") {
      Curve c0 = this.satStruct.c0;
      Curve c1 = this.satStruct.c1;
      c0.pts.remove(0);
      c1.pts.remove(0);
    }
    this.updateStitches();
  }
  
  void deleteLastStruct() {
    if (this.numPts()<=2) return;
    if (this.type=="running") {
      Curve c = this.runStruct;
      c.pts.remove(c.pts.size()-1);
    }
    if (this.type=="free") {
      PVector from = this.freeStruct.get(this.freeStruct.size()-1);
      PVector to = this.freeStruct.get(this.freeStruct.size()-2);
      this.freeStruct.remove(this.freeStruct.size()-1);
      while (from.dist(to)<2) {
        this.freeStruct.remove(this.freeStruct.size()-1);
        to = this.freeStruct.get(this.freeStruct.size()-1);
      }
    }
    if (this.type=="satin") {
      SatinCurve sc = this.satStruct;
      if (sc.on0) {
        sc.c1.pts.remove(sc.c1.pts.size()-1);
      }
      else sc.c0.pts.remove(sc.c0.pts.size()-1);
      sc.on0 = !sc.on0;
    }
    this.updateStitches();
  }
  
  
  void show(color c) {
    if (this.type=="running") {
      this.runStruct.show(c);
    }
    if (this.type=="satin") {
      this.satStruct.showCurves(c);
    }
    if (this.type=="free") {
      //strokeWeight(0.25); stroke(0);
      //for (PVector v : this.freeStruct) point(v.x,v.y);
      if (this.freeStruct.size()>0) {
        strokeWeight(1/scl);stroke(160);
        drawStitches(freeStruct);
        colorMode(RGB);
        strokeWeight(7/scl); stroke(45,255,20);
        PVector p = this.freeStruct.get(freeStruct.size()-1);
        point(p.x,p.y);
        p = this.freeStruct.get(0);
        strokeWeight(3/scl); stroke(c);
        point(p.x,p.y);
      }
    }
  }
  
  void show() {
    this.show(color(0));
  }
  
  void updateStitches() {
    if (type=="running") {
      this.runStruct.updateAbsPts(100,7);
      this.stchs = getRunStitches(this, this.len);
    }
    
    if (type=="satin") {
      this.stchs = new ArrayList<PVector>();
      this.satStruct.updateAbsPts(100,7);
      if (this.ulSatin && !this.rvrsObjStchs) {
        this.stchs.addAll(this.satStruct.getULStchs(this.len,this.rvrsObjStchs));
      }
      if (this.olSatin) this.stchs.addAll(this.satStruct.getStchs(this.sep, 100));
      if (this.ulSatin && this.rvrsObjStchs) {
        ArrayList<PVector> ul = this.satStruct.getULStchs(this.len,this.rvrsObjStchs);
        for (int i=ul.size()-1; i>=0; i--) this.stchs.add(ul.get(i));
      }
    }
    if (type=="free") {
      this.stchs = getStitches(this.freeStruct, this.len);
    }
    if (this.rvrsObjStchs) {
      ArrayList<PVector> newS = new ArrayList<PVector>();
      for (int i=this.stchs.size()-1; i>=0; i--) {
        newS.add(this.stchs.get(i));
      }
      this.stchs = newS;
    }
  }
  
  void move(PVector v) {
    if (this.type=="running") {
      moveRunning(this,v);
    }
    
    if (this.type=="satin") {
      moveSatin(this,v);
    }
    if (this.type=="free") {
      for (PVector s : this.freeStruct) {
        s.add(v);
      }
    }
    for (PVector s : this.stchs) {
      s.add(v);
    }
  }
  PVector center() {
    return aveVec(this.stchs);
  }
  void rotate(float ang) {
    PVector c = aveVec(this.stchs);
    this.rotateAround(ang,c);
  }
  void rotateAround(float ang, PVector c) {
    if (this.type=="running") {
      for (CurvePt cp : this.runStruct.pts) {
        cp.rotateAround(c,ang);
      }
    }
    
    if (this.type=="satin") {
      for (CurvePt cp : this.satStruct.c0.pts) {
        cp.rotateAround(c,ang);
      }
      for (CurvePt cp : this.satStruct.c1.pts) {
        cp.rotateAround(c,ang);
      }
    }
    
    if (this.type=="free") {
      for (int i=0; i<this.freeStruct.size(); i++) {
        this.freeStruct.set(i,rotateVecAround(this.freeStruct.get(i),c,ang));
      }
    }
    this.updateStitches();
  }
  
  void flipX() {
    PVector c = aveVec(this.stchs);
    if (this.type=="running") {
      for (CurvePt cp : this.runStruct.pts) {
        cp.flipX(c.x);
      }
    }
    
    if (this.type=="satin") {
      for (CurvePt cp : this.satStruct.c0.pts) {
        cp.flipX(c.x);
      }
      for (CurvePt cp : this.satStruct.c1.pts) {
        cp.flipX(c.x);
      }
    }
    
    if (this.type=="free") {
      for (int i=0; i<this.freeStruct.size(); i++) {
        this.freeStruct.set(i,flipVecX(this.freeStruct.get(i),c.x));
      }
    }
    this.updateStitches();
  }
  
  void scale(float n) {
    PVector c = new PVector();
    if (this.type=="running") {
      for (CurvePt cp : this.runStruct.pts) {
        cp.scale(c,n);
      }
    }
    
    if (this.type=="satin") {
      for (CurvePt cp : this.satStruct.c0.pts) {
        cp.scale(c,n);
      }
      for (CurvePt cp : this.satStruct.c1.pts) {
        cp.scale(c,n);
      }
    }
    
    if (this.type=="free") {
      for (int i=0; i<this.freeStruct.size(); i++) {
        PVector newVec = this.freeStruct.get(i).copy();
        newVec.sub(c).mult(n).add(c);
        this.freeStruct.set(i,newVec);
      }
    }
    this.updateStitches();
  }
  
  float dist(PVector v) {
    float minD = -1;
    for (PVector s : this.stchs) {
      float d = s.dist(v);
      minD = min(d,minD);
      if (minD==-1) minD = d;
    }
    return minD;
  }
  
  String toString() {
    String result = this.type+"\n";
    result+=this.len+"\n"+this.sep+"\n"+this.rvrsObjStchs+"\n";
    if (this.type=="running") {
      for (CurvePt p : this.runStruct.pts) {
        result+=p.toString();
      }
    }
    
    if (this.type=="satin") {
      if (this.satStruct.straightBars) result+="true\n";
      else result+="false\n";
      
      if (this.ulSatin) result+="true\n";
      else result+="false\n";
      
      if (this.olSatin) result+="true\n";
      else result+="false\n";
      
      Curve crv0 = this.satStruct.c0;
      Curve crv1 = this.satStruct.c1;
      for (int i=0; i<max(crv0.pts.size(),crv1.pts.size()); i++) {
        result+=crv0.pts.get(i).toString();
        if (i>=crv1.pts.size()) break;
        result+=crv1.pts.get(i).toString();
      }
    }
    
    if (this.type=="free") {
      for (PVector v : this.freeStruct) {
        result+=""+v.x+"\n"+v.y+"\n";
      }
    }
    return result;
  }
}

ArrayList<StitchObj> fromString(String[] s) {
  ArrayList<StitchObj> result = new ArrayList<StitchObj>();
  if (s.length==0) return result;
  int line = 0;
  
  while (line<s.length) {
    if (s[line].equals("running")) {
      StitchObj newObj = new StitchObj("running");
      line++;
      newObj.len = float(s[line]); line++;
      newObj.sep = float(s[line]); line++;
      newObj.rvrsObjStchs = boolean(s[line]); line++;
      while (line<s.length-2 && s[line].equals("pt")) {
        line++;
        CurvePt newPt = new CurvePt(new PVector(float(s[line]),float(s[line+1])));
        line+=2;
        newPt.h0 = new PVector(float(s[line]),float(s[line+1]));
        line+=2;
        newPt.h1 = new PVector(float(s[line]),float(s[line+1]));
        newObj.runStruct.pts.add(newPt);
        line+=2;
      }
      newObj.runStruct.updateAbsPts(100,7);
      newObj.updateStitches();
      result.add(newObj);
    }
    else if (s[line].equals("satin")) {
      boolean on0 = true;
      StitchObj newObj = new StitchObj("satin");
      line++;
      newObj.len = float(s[line]); line++;
      newObj.sep = float(s[line]); line++;
      newObj.rvrsObjStchs = boolean(s[line]); line++;
      if (s[line].equals("pt")) newObj.satStruct.straightBars = false;
      else {newObj.satStruct.straightBars = boolean(s[line]); line++;}
      if (s[line].equals("pt")) newObj.ulSatin = true;
      else {newObj.ulSatin = boolean(s[line]); line++;}
      if (s[line].equals("pt")) newObj.olSatin = true;
      else {newObj.olSatin = boolean(s[line]); line++;}
      
      while (line<s.length && s[line].equals("pt")) {
        line++;
        CurvePt newPt = new CurvePt(new PVector(float(s[line]),float(s[line+1])));
        line+=2;
        newPt.h0 = new PVector(float(s[line]),float(s[line+1]));
        line+=2;
        newPt.h1 = new PVector(float(s[line]),float(s[line+1]));
        line+=2;
        if (on0) newObj.satStruct.c0.pts.add(newPt);
        else newObj.satStruct.c1.pts.add(newPt);
        on0 =! on0;
      }
      newObj.satStruct.on0 = on0;
      
      newObj.satStruct.updateAbsPts(100,7);
      newObj.updateStitches();
      result.add(newObj);
    }
    else if (s[line].equals("free")) {
      StitchObj newObj = new StitchObj("free");
      line++;
      newObj.len = float(s[line]); line++;
      newObj.sep = float(s[line]); line++;
      newObj.rvrsObjStchs = boolean(s[line]); line++;
      while (line<s.length-1 && s[line].contains(".")) {
        newObj.freeStruct.add(new PVector(float(s[line]),float(s[line+1])));
        line+=2;
      }
      newObj.updateStitches();
      result.add(newObj);
    }
    else line++;
  }
  return result;
}

int find(StitchObj obj, ArrayList<StitchObj> objs) {
  for (int i=0; i<objs.size(); i++) {
    if (objs.get(i)==obj) return i;
  }
  return -1;
}

ArrayList<PVector> copyVecs(ArrayList<PVector> vs) {
  ArrayList<PVector> result = new ArrayList<PVector>();
  for (PVector v : vs) {
    result.add(v);
  }
  return result;
}

PVector flipVecX(PVector v, float c) {
  v.x = -(v.x-c)+c;
  return v;
}

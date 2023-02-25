class Curve {
  ArrayList<CurvePt> pts;
  ArrayList<ArrayList<PVector>> absPts;
  FloatList segLens;
  float offset = 0;
  
  Curve(CurvePt p) {
    this.pts = new ArrayList<CurvePt>();
    this.pts.add(p);
    this.updateAbsPts(100,7);
  }
  
  Curve() {
    this.pts = new ArrayList<CurvePt>();
    this.updateAbsPts(100,7);
  }
  
  Curve copy() {
    Curve result = new Curve();
    result.pts = new ArrayList<CurvePt>();
    for (CurvePt p : this.pts) result.pts.add(p.copy());
    result.absPts = new ArrayList<ArrayList<PVector>>();
    for (ArrayList<PVector> seg : this.absPts) {
      ArrayList<PVector> newSeg = new ArrayList<PVector>();
      for (PVector v : seg) {
        newSeg.add(v.copy());
      }
      result.absPts.add(newSeg);
    }
    result.segLens = this.segLens.copy();
    return result;
  }
  
  void show(color c) {
    strokeWeight(0.2); stroke(c);noFill();
    beginShape();
    if (this.absPts!=null&&this.absPts.size()>0) {
      for (int i=0; i<this.absPts.size(); i++) {
        
        PVector from = this.absPts.get(i).get(0);
        int curLen = this.absPts.get(i).size();
        
        for (int j=0; j<curLen; j++) {
          PVector to = this.absPts.get(i).get(j);
          //line(from.x,from.y,to.x,to.y);
          //point(from.x,from.y);
          //point(to.x,to.y);
          vertex(from.x,from.y);
          from = to;
        }
        vertex(from.x,from.y);
      }
    }
    endShape();
    if (this.pts.size()>0) {
      colorMode(RGB);
      stroke(0,255,80); strokeWeight(5);
      PVector end = this.pts.get(this.pts.size()-1).pos;
      point(end.x,end.y);
    }
    for (CurvePt cp : this.pts) cp.show(c);
    
  }
  
  void addPt(CurvePt p) {
    this.pts.add(p);
    this.updateAbsPts(100,7);
  }
  
  boolean tryToMove(PVector v) {
    boolean moving = false;
    for (CurvePt p : this.pts) {
      if (v.dist(p.pos) < p.rad) {
        p.move(v,-1);
        heldPt = p;
        heldInd = -1;
        moving = true;
        break;
      }
      else if (v.dist(p.h0) < p.rad) {
        p.move(v,0);
        heldPt = p;
        heldInd = 0;
        moving = true;
        break;
      }
      else if (v.dist(p.h1) < p.rad) {
        p.move(v,1);
        heldPt = p;
        heldInd = 1;
        moving = true;
        break;
      }
    }
    if (moving) this.updateAbsPts(100,20);
    return moving;
  }
  
  void updateAbsPts(int segs, float len) {
    //these are not equally spaced
    //also updates segment lengths var
    ArrayList<ArrayList<PVector>> result = new ArrayList<ArrayList<PVector>>();
    
    
    int numPts = this.pts.size();
    if (numPts<2) return;
    CurvePt from = this.pts.get(0);
    
    for (int i=1; i<numPts; i++) {
      CurvePt to = this.pts.get(i);
      ArrayList<PVector> seg2Add = new ArrayList<PVector>();
      for (float perc=0; perc<=1; perc+=(float)1/segs) {
        PVector curPt = ptBetween(from,to,perc);
        seg2Add.add(curPt);
      }
      seg2Add = distrPts(seg2Add,len);
      result.add(seg2Add);
      from = to;
    }
    result.get(result.size()-1).add(this.pts.get(numPts-1).pos.copy());
    
    this.absPts = result;
    this.segLens = new FloatList();
    for (int i=0; i<result.size(); i++) {
      this.segLens.append(segLen(result.get(i)));
    }
    
  }
  
  PVector ptAlng(float prog) {
    PVector result = null;
    if (this.absPts==null) return result;
    if (this.segLens.size()<1) return this.absPts.get(0).get(0);
    float covered = 0;
    for (int i=0; i<this.segLens.size(); i++) {
      float len = this.segLens.get(i);
      if (covered+len<prog) {
        covered += len;
        continue;
      }
      ArrayList<PVector> curPts = this.absPts.get(i);
      result = ptAlong(curPts,prog-covered);
      break;
    }
    return result;
  }
  
  void move(PVector v) {
    if (this.absPts==null) return;
    for (CurvePt p : this.pts) p.moveAll(v);
    for (ArrayList<PVector> seg : this.absPts) {
      for (PVector s : seg) {
        s.add(v);
      }
    }
  }
  
}

float segLen(ArrayList<PVector> pts) {
  int numPts = pts.size();
  float len = 0;
  if (numPts<2) return len;
  
  PVector from = pts.get(0);
  for (int i=0; i<numPts-1; i++) {
    PVector to = pts.get(i+1);
    len += from.dist(to);
    from = to;
  }
  return len;
}

ArrayList<PVector> distrPts(ArrayList<PVector> pts, float len) {
  ArrayList<PVector> result = new ArrayList<PVector>();
  int numPts = pts.size();
  if (numPts == 0) return result;
  float rem = len;
  PVector from = pts.get(0);
  result.add(from.copy());
  for (int i=1; i<numPts; i++) {
    PVector to = pts.get(i);
    float d = from.dist(to);
    if (d<rem) {
      from = to;
      rem -= d;
      continue;
    }
    //else :
    PVector at = to.copy().sub(from);
    at.normalize().mult(rem);
    at = from.add(at);
    result.add(at.copy());
    rem = len;
    i--;
  }
  result.add(pts.get(numPts-1).copy());
  
  return result;
}

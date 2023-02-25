class SatinCurve {
  Curve c0;
  Curve c1;
  FloatList segLens;
  boolean on0 = true;
  boolean straightBars = false;
  float offset = 0;
  
  SatinCurve() {
    this.c0 = new Curve();
    this.c1 = new Curve();
  }
  
  SatinCurve copy() {
    SatinCurve result = new SatinCurve();
    result.c0 = this.c0.copy();
    result.c1 = this.c1.copy();
    result.segLens = this.segLens.copy();
    result.on0 = this.on0;
    result.straightBars = this.straightBars;
    return result;
  }
  
  void addPt(CurvePt p) {
    if (this.on0) c0.addPt(p);
    if (!this.on0) c1.addPt(p);
    this.on0 = !this.on0;
    this.updateAbsPts(100,7);
  }
  
  ArrayList<PVector> getULStchs(float len, boolean rev) {
    ArrayList<PVector> result = new ArrayList<PVector>();
    ArrayList<PVector> scndRun;
    if (!rev) {
      result = getRunStitches(this.c0,len);
      scndRun = getRunStitches(this.c1,len);
      for (int i=scndRun.size()-1; i>=0; i--) {
        result.add(scndRun.get(i));
      }
    }
    else {
      scndRun = getRunStitches(this.c1,len);
      for (int i=scndRun.size()-1; i>=0; i--) {
        result.add(scndRun.get(i));
      }
      
      result.addAll(getRunStitches(this.c0,len));
    }
    return result;
  }
  
  ArrayList<PVector> getStchs(float sep, int segs) {
    ArrayList<PVector> result = new ArrayList<PVector>();
    boolean alt = false;//used to zigzag
    if (this.c0.segLens==null||this.c1.segLens==null) return result;
    int numSegs = min(this.c0.segLens.size(),this.c1.segLens.size());
    PVector[] prevPts = new PVector[2];
    prevPts[0] = this.c0.absPts.get(0).get(0).copy();
    prevPts[1] = this.c1.absPts.get(0).get(0).copy();
    
    result.add(prevPts[0]);
    if (numSegs<1) {
      result.add(prevPts[1]);
      return result;
    }
    if (this.straightBars) result.add(prevPts[1].copy());
    
    float inc = (float)1/segs;
    float rem = sep/2;
    
    for (int i=0; i<numSegs; i++) {
      
      ArrayList<PVector> segPts0 = this.c0.absPts.get(i);
      ArrayList<PVector> segPts1 = this.c1.absPts.get(i);
      
      float segLen0 = this.c0.segLens.get(i);
      float segLen1 = this.c1.segLens.get(i);
      
      
      for (int j=0; j<=segs; j++) {
        float perc = inc*j;
        float prog0 = perc*segLen0;
        float prog1 = perc*segLen1;
        PVector[] curPts = new PVector[2];
        curPts[0] = ptAlong(segPts0,prog0+this.offset);
        curPts[1] = ptAlong(segPts1,prog1+this.offset);
        
        float d = distAlong(prevPts,curPts);
        
        if (rem-d>0) {
          rem-=d;
          prevPts = curPts;
          continue;
        }
        perc = rem/d;
        
        float r0 = perc*prevPts[0].dist(curPts[0]);
        PVector os0 = curPts[0].copy().sub(prevPts[0]);
        os0.normalize().mult(r0);
        prevPts[0].add(os0);
        
        float r1 = perc*prevPts[1].dist(curPts[1]);
        PVector os1 = curPts[1].copy().sub(prevPts[1]);
        os1.normalize().mult(r1);
        prevPts[1].add(os1);
        if (alt) {
          result.add(prevPts[0].copy());
          if (this.straightBars) result.add(prevPts[1].copy());
          
        }
        else {
          result.add(prevPts[1].copy());
          if (this.straightBars) result.add(prevPts[0].copy());
        }
        j--;
        rem = sep/2;
        alt = !alt;
        
      }
    }
    if (alt) {
      result.add(prevPts[0].copy());
    }
    if (!alt) {
      result.add(prevPts[1].copy());
    }
    if (pullComp) result = pullComp(result);
    return result;
  }
  
  void showCurves(color c) {
    int numPts = min(c0.pts.size(), c1.pts.size());
    //draw the connection between pts, and then the two individual curves
    strokeWeight(1);
    stroke(0,50);
    for (int i=0; i<numPts; i++) {
      PVector from = c0.pts.get(i).pos;
      PVector to = c1.pts.get(i).pos;
      line(from.x,from.y,to.x,to.y);
    }
    if (numPts>0) {
      colorMode(RGB);
      stroke(197,217,46);
      strokeWeight(12);
      PVector adding = this.c0.pts.get(numPts-1).pos;
      if (!on0) adding = this.c1.pts.get(numPts-1).pos;
      point(adding.x,adding.y);
    }
    c0.show(c);
    c1.show(c);
  }
  
  boolean tryToMove(PVector v) {
    return c0.tryToMove(v) || c1.tryToMove(v);
  }
  
  void updateAbsPts(int segs,float len) {
    c0.updateAbsPts(segs,len); c1.updateAbsPts(segs,len);
    int numPts = min(this.c0.pts.size(),this.c1.pts.size());
    this.segLens = new FloatList();
    for (int i=0; i<numPts-1; i++) {
      this.segLens.append(this.segLen(i,segs));
      
    }
  }
  
  float segLen(int ind, int segs) {
    PVector[] prevPts = new PVector[2];
    prevPts[0] = this.c0.pts.get(0).pos.copy();
    prevPts[1] = this.c1.pts.get(0).pos.copy();
    float inc = (float)1/segs;
    float len0 = this.c0.segLens.get(ind);
    float len1 = this.c1.segLens.get(ind);
    
    float covered = 0;
    for (int i=1; i<=segs; i++) {
      PVector[] curPts = new PVector[2];
      float perc = inc*i;
      float prog0 = perc*len0;
      float prog1 = perc*len1;
      curPts[0] = ptAlong(this.c0.absPts.get(ind),prog0);
      curPts[1] = ptAlong(this.c1.absPts.get(ind),prog1);
      
      float d = distAlong(prevPts,curPts);
      covered += d;
      prevPts = curPts;
    }
    
    return covered;
  }
}

PVector aveVec(PVector v1, PVector v2) {
  return v1.copy().add(v2).div(2);
}

PVector aveVec(ArrayList<PVector> vs) {
  PVector result = new PVector();
  for (PVector v : vs) result.add(v);
  result.div(vs.size());
  return result;
}

PVector rotateVecAround(PVector target, PVector c, float ang) {
  PVector result = target.copy();
  result.sub(c);
  result.rotate(ang);
  result.add(c);
  return result;
}

float sum(FloatList fl) {
  float total = 0;
  for (float f : fl) total += f;
  return total;
}

float distAlong(PVector[] bar0, PVector[] bar1) {
  FloatList ds = new FloatList();
  ds.append(distToLine(bar0[0],bar1));
  ds.append(distToLine(bar0[1],bar1));
  ds.append(distToLine(bar1[0],bar0));
  ds.append(distToLine(bar1[1],bar0));
  
  return sum(ds)/4;
}

float distToLine(PVector pt, PVector[] l) {
  float num = (l[1].y-l[0].y)*pt.x - (l[1].x-l[0].x)*pt.y + l[1].x*l[0].y - l[1].y*l[0].x;
  float den = pow(l[1].y-l[0].y,2) + pow(l[1].x-l[0].x,2);
  return abs(num)/sqrt(den);
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
      PVector midConnect = prvS.copy().lerp(nxtS,0.5);
      PVector os = curS.copy().sub(midConnect);
      float mag = min(subOS1.mag(),subOS2.mag());
      os.normalize().mult(mag*0.08);
      toAdds.add(os);
    }
    else toAdds.add(new PVector());
  }
  
  for (int i=0; i<toAdds.size(); i++) {
    stchs.get(i+1).add(toAdds.get(i));
  }
  return stchs;
}

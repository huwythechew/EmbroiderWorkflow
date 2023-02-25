

class Bar {
  PVector[] pts;
  
  Bar() {
    this.pts = new PVector[2];
  }
  Bar(PVector fr, PVector to) {
    this.pts = new PVector[]{fr,to};
    
  }
  
  PVector from() {
    return this.pts[0];
  }
  PVector to() {
    return this.pts[1];
  }
  
  void setPts(PVector fr, PVector to) {
    this.pts[0] = fr;
    this.pts[1] = to;
  }
  
  void setFrom(PVector fr) {
    this.pts[0] = fr;
    
  }
  
  void setTo(PVector to) {
    this.pts[1] = to;
    
  }
  
  void show() {
    strokeWeight(separation);
    line(this.pts[0].x,this.pts[0].y,
         this.pts[1].x,this.pts[1].y);
  }
  
  float length() {
    return this.pts[0].dist(this.pts[1]);
  }
  
  ArrayList<PVector> stitches(PImage pat, boolean onTo) {
    ArrayList<PVector> result = new ArrayList<PVector>();
    pat.loadPixels();
    
    if (this.length()<=separation*2) {
      if (onTo) result.add(this.pts[0]);
      else result.add(this.pts[1]);
      return result;
    }
    
    PVector at = this.from().copy();
    PVector nxt = this.to().copy();
    result.add(at.copy());
    while (at.dist(nxt)>1) {
      PVector os = nxt.copy().sub(at);
      os.normalize();
      at.add(os);
      int ind = (int)at.y*pat.width+(int)at.x;
      if (brightness(pat.pixels[ind])<100&&brightness(pat.pixels[ind-1])>=100) {
        result.add(at.copy());
        if (brickLines) {
          result.add(at.copy().add(new PVector(0,-separation*1.1)));
          //result.add(at.copy());
          result.add(at.copy().add(new PVector(0,separation*1.1)));
          result.add(at.copy());
        }
      }
    }
    if (keepAllEnds) {
      result.add(nxt.copy());
      if (onTo) result = reversePts(result);
    }
    else if (onTo) {
      result.add(nxt.copy());
      result.remove(0);
      result = reversePts(result);
    }
    
    //ArrayList<PVector> newResult = new ArrayList<PVector>();
    
    // the following comment is added for brick pattern (large sep value)
    //for (int i=0; i<result.size(); i++) {
    //  PVector curP = result.get(i).copy();
    //  newResult.add(curP.copy());
    //  curP.y+=separation*1.22;
    //  newResult.add(curP.copy());
    //  curP.y-=separation*1.22;
    //  newResult.add(curP.copy());
    //}
    return result;
  }
}

boolean isCoX(Bar b1, Bar b2) {
  float x1min = b1.pts[0].x;
  float x1max = b1.pts[1].x;
  float x2min = b2.pts[0].x;
  float x2max = b2.pts[1].x;
  if (x1min<x2max && x1max>x2min) return true;
  return false;
}

boolean isCoX(Bar b1, Bar b2, float maxSep) {
  if (abs(b1.from().y-b2.from().y)>maxSep) return false;
  return isCoX(b1,b2);
}

boolean liesOnMid(Bar b1, Bar b2) {
  float x1min = b1.pts[0].x;
  float x1max = b1.pts[1].x;
  float x2min = b2.pts[0].x;
  float x2max = b2.pts[1].x;
  float x1mid = (x1min+x1max)/2;
  float x2mid = (x2min+x2max)/2;
  if (x1min<x2mid && x1max>x2mid &&
      x2min<x1mid && x2max>x1mid) return true;
  return false;
}

boolean liesOnMid(Bar b1, Bar b2, float maxSep) {
  if (abs(b1.from().y-b2.from().y)>maxSep) return false;
  return liesOnMid(b1,b2);
}

float overlapX(Bar b1, Bar b2) {
  float x1min = b1.pts[0].x;
  float x1max = b1.pts[1].x;
  float x2min = b2.pts[0].x;
  float x2max = b2.pts[1].x;
 
  return min(x1max,x2max) - max(x1min,x2min);
  
    
}

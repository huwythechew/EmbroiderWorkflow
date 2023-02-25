class CurvePt {
  PVector pos;
  PVector h0;
  PVector h1;
  float rad = 3;
  
  
  CurvePt(PVector v) {
    this.pos = v.copy();
    this.h0 = v.copy();
    this.h1 = v.copy();
  }
  
  CurvePt copy() {
    CurvePt result = new CurvePt(this.pos);
    result.h0 = this.h0.copy();
    result.h1 = this.h1.copy();
    result.rad = this.rad;
    return result;
  }
  
  String toString() {
    String result = "pt\n";
    result += this.pos.x+"\n"+this.pos.y+"\n";
    result += this.h0.x+"\n"+this.h0.y+"\n";
    result += this.h1.x+"\n"+this.h1.y+"\n";
    return result;
  }
  
  
  void move(PVector v, int ind) {
    if (ind==-1) {
      PVector os = v.copy().sub(this.pos);
      
      this.pos.add(os);
      this.h1.add(os);
      this.h0.add(os);
    }
    else if (ind==0) {
      this.h0 = v.copy();
      
      float oppLen = this.pos.dist(this.h1);
      PVector os = this.pos.copy().sub(this.h0);
      os.normalize().mult(oppLen);
      this.h1 = this.pos.copy().add(os);
    }
    else if (ind==1) {
      this.h1 = v.copy();
      
      float oppLen = this.pos.dist(this.h0);
      PVector os = this.pos.copy().sub(this.h1);
      os.normalize().mult(oppLen);
      this.h0 = this.pos.copy().add(os);
    }
  }
  
  void rotateAround(PVector c, float ang) {
    this.h1 = rotateVecAround(this.h1,c,ang);
    this.h0 = rotateVecAround(this.h0,c,ang);
    this.pos = rotateVecAround(this.pos,c,ang);
  }
  
  void flipX(float c) {
    pos.x = -(pos.x-c)+c;
    h0.x = -(h0.x-c)+c;
    h1.x = -(h1.x-c)+c;
  }
  
  //void flipY(float c) {
  //  pos.y = -(pos.y-c)+c;
  //  h0.y = -(pos.y-c)+c;
  //  h1.y = -(pos.y-c)+c;
  //}
  
  void scale(PVector c, float n) {
    this.h1.sub(c).mult(n).add(c);
    this.h0.sub(c).mult(n).add(c);
    this.pos.sub(c).mult(n).add(c);
  }
  
  void moveAll(PVector v) {
    this.pos.add(v);
    this.h0.add(v);
    this.h1.add(v);
  }
  
  void show(color c) {
    strokeWeight(1);
    stroke(c);
    line(this.h0.x,this.h0.y,this.h1.x,this.h1.y);
    strokeWeight(this.rad);
    stroke(80);
    point(this.h0.x,this.h0.y);
    point(this.h1.x,this.h1.y);
    strokeWeight(0);
    fill(c);
    rectMode(CENTER);
    rect(this.pos.x,this.pos.y,this.rad,this.rad);
    //point(this.pos.x,this.pos.y);
  }
}

PVector bezLerp(PVector p0, PVector p1, PVector p2, PVector p3, float perc) {
  PVector m1 = p0.copy().lerp(p1,perc);PVector m2 = p1.copy().lerp(p2,perc);
  PVector m3 = p2.copy().lerp(p3,perc);
  PVector m01 = m1.lerp(m2,perc);PVector m02 = m2.lerp(m3,perc);
  return m01.lerp(m02,perc);
}

PVector ptBetween(CurvePt p1, CurvePt p2, float perc) {
  
  return bezLerp(p1.pos,p1.h1,p2.h0,p2.pos,perc);
  
}

PVector ptAlong(ArrayList<PVector> pts, float prog) {
  PVector result = pts.get(pts.size()-1).copy();
  PVector from = pts.get(0).copy();
  float covered = 0;
  for (int i=1; i<pts.size(); i++) {
    PVector to = pts.get(i);
    float curLen = from.dist(to);
    if (covered + curLen<prog) {
      from = to;
      
      covered += curLen;
      continue;
    }
    float rem = prog-covered;
    PVector os = to.copy().sub(from);
    os.normalize().mult(rem);
    result = from.copy().add(os);
    break;
  }
  return result;
}

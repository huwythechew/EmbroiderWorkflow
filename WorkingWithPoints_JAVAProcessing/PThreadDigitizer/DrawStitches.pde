void drawStitches(ArrayList<PVector> s) {
  noFill();
  beginShape();
  strokeWeight(1/scl);
  stroke(sc);
  for (PVector v : s) {
    vertex(v.x,v.y);
  }
  endShape();
  strokeWeight(3/scl);
  for (PVector v : s) {
    point(v.x,v.y);
  }
}

void drawDetailStitches(ArrayList<PVector> s) {
  if (s==null||s.size()==0) return;
  strokeWeight(4);
  noFill();
  PVector from = s.get(0);
  for (int i=1; i<s.size(); i++) {
    PVector to = s.get(i);
    drawDetailStitch(from,to);
    from=to;
  }
}
void drawDetailStitch(PVector f, PVector t) {
  colorMode(HSB);
  PVector from = f.copy();
  float ang = t.copy().sub(f).heading();
  if (ang>THIRD_PI&&ang<TWO_PI-THIRD_PI) {
    f=t;
    t=from.copy();
  }
  from = f;
  float nToFit = 20;
  for (int i=1; i<=nToFit; i++) {
    PVector to = f.copy().lerp(t,i/nToFit);
    //float b = i*1280;
    float b = 255-abs(128-map(sqrt(i/nToFit),0.5,1,0,255));
    stroke(color(28,200,b,128));
    line(from.x,from.y,to.x,to.y);
    from=to;
  }
}

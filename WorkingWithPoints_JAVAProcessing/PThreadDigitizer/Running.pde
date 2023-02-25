void clickRunning(StitchObj obj, PVector v) {
  boolean moving = obj.runStruct.tryToMove(v);
  if (moving) return;
  placingPt = true;
  CurvePt newPt = new CurvePt(v);
  obj.runStruct.addPt(newPt);
  heldPt = newPt;
  heldInd = 1;
  obj.updateStitches();
}

void dragRunning(StitchObj obj, PVector v) {
  if (heldPt==null) return;
  heldPt.move(v, heldInd);
  if (placingPt) {
    heldPt.h0 = heldPt.pos.copy().add(heldPt.pos.copy().sub(heldPt.h1));
  }
  obj.runStruct.updateAbsPts(100,7);
  obj.updateStitches();
}

void moveRunning(StitchObj obj, PVector v) {
  obj.runStruct.move(v);
}

ArrayList<PVector> getRunStitches(Curve crv, float len) {
  ArrayList<PVector> result = new ArrayList<PVector>();
  if (crv.segLens==null) return result;
  int nSegs = crv.segLens.size();
  for (int i=0; i<nSegs; i++) {
    float curSegLen = crv.segLens.get(i);
    float inc = len;
    float nToFit = (curSegLen-crv.offset)/inc;
    if (crv.offset>0) result.add(ptAlong(crv.absPts.get(i),0));
    for (float j=crv.offset/len; j<nToFit; j++) {
      PVector nextStch = ptAlong(crv.absPts.get(i),(float)(j*inc));
      result.add(nextStch);
    }
  }
  result.add(crv.pts.get(nSegs).pos.copy());
  return result;
}

ArrayList<PVector> getRunStitches(StitchObj obj, float len) {
  return getRunStitches(obj.runStruct,len);
}

ArrayList<PVector> getStitches(ArrayList<PVector> src, float len) {
  ArrayList<PVector> result = new ArrayList<PVector>();
  
  if (src.size()<2) return result;
  float rem = len;
  PVector prevHeading = src.get(1).copy().sub(src.get(0));
  PVector from = src.get(0);
  result.add(from.copy());
  //trail to end of vein
  for (int i=1; i<src.size()-1; i++) {
    PVector to = src.get(i);
    float d = from.dist(to);
    if (d>len) i--;
    PVector heading = src.get(i+1).copy().sub(to);
    boolean turning = false;
    if (abs(PVector.angleBetween(prevHeading,heading))>THIRD_PI*2) turning = true;
    prevHeading = heading;
    if (rem-d<=0 || turning) {
      //add points every "len"
      from = from.copy().lerp(to,rem/d);
      result.add(from.copy());
      rem = len;
      continue;
    }
    rem-=d;
    from = to.copy();
  }
  result.add(src.get(src.size()-1).copy());
  return result;
}

void clickFree(StitchObj obj, PVector v) {
  obj.freeStruct.add(v.copy());
  obj.updateStitches();
}

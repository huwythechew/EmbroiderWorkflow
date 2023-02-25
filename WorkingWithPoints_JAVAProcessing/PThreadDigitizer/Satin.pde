void clickSatin(StitchObj obj, PVector v) {
  boolean moving = obj.satStruct.tryToMove(v);
  if (moving) return;
  placingPt = true;
  CurvePt newPt = new CurvePt(v);
  obj.satStruct.addPt(newPt);
  heldPt = newPt;
  heldInd = 1;
  obj.updateStitches();
}

void dragSatin(StitchObj obj, PVector v) {
  if (heldPt==null) return;
  heldPt.move(v, heldInd);
  if (placingPt) {
    heldPt.h0 = heldPt.pos.copy().add(heldPt.pos.copy().sub(heldPt.h1));
  }
  if (obj.satStruct!=null) {
    obj.satStruct.updateAbsPts(100,7);
    obj.updateStitches();
  }
}

void moveSatin(StitchObj obj, PVector v) {
  obj.satStruct.c0.move(v);
  obj.satStruct.c1.move(v);
}

class GameRun {
  
  constructor(mc,rcs) {
    this.result = random([0,1,2,3,5,6,7,8]);//0,1,2,3,2,1,0
    this.mainClip = mc;
    this.runClips = rcs;
    this.lastMainFrm = this.result + (mc.len-4);
    if (this.result>6) this.lastMainFrm--;
    this.resClip;
    if (this.result<4) this.resClip = this.runClips[this.result];
    else this.resClip = this.runClips[8-this.result];
    
    this.curFrm = 0;
    this.playingMain = true;
  }
  
  run() {
    if (this.playingMain) this.mainClip.run();
    if (!this.playingMain) this.resClip.run();
    this.curFrm++;
    if (this.curFrm>=this.lastMainFrm) {
      let r = this.result;
      if (r>3) r = 8-r;
      if (this.playingMain && soundAr[r]!=null) soundAr[r].play();
      this.playingMain = false;
    }
  }
  
  draw() {
    if (this.playingMain) this.mainClip.draw();
    if (!this.playingMain) this.resClip.draw();
  }
  
}
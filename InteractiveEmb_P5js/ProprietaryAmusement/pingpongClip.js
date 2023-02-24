class PingpongClip {
  
  constructor(r, fos, e, l) {
    this.frms = [];
    for (var i=0; i<l; i++) {
      let imgN = i+fos;
      this.frms.push(loadImage(r+imgN+e,frmLoadedCall()));
    }
    this.len = l;
    this.curFrm = 0;
    this.curInc = 1;
  }
  
  run() {
    this.incFrm(1);
  }
  
  draw() {
    image(this.frms[this.curFrm],0,0,width,height);
    //print(this.curFrm);
  }
  
  incFrm(n) {
    this.curFrm+=n*this.curInc;
    this.clipPingPong();
  }
  
  reset() {
    this.curFrm=0;
    this.curInc=1;
  }
  
  clipPingPong() {
    if (this.curFrm>=this.len) {
      let d = (this.len-1)-this.curFrm;
      this.curFrm = this.len+d-1;
      this.curInc = -1;
    }
    else if (this.curFrm<0) {
      let d = -this.curFrm;
      this.curFrm = abs(d);
      this.curInc = 1;
    }
  }
  
}
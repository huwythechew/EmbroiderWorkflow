class Clip {
  
  constructor(r, fos, e, l) {
    this.frms = [];
    for (var i=0; i<l; i++) {
      let imgN = i+fos;
      //print(imgN);
      this.frms.push(loadImage(r+imgN+e,frmLoadedCall()));
    }
    this.len = l;
    this.curFrm = 0;
  }
  
  run() {
    this.incFrm(1);
  }
  
  draw() {
    image(this.frms[this.curFrm],0,0,width,height);
  }
  
  incFrm(n) {
    this.curFrm+=n;
    this.clipLoop();
  }
  
  reset() {
    this.curFrm=0;
  }
  
  clipLoop() {
    if (this.curFrm>=this.len) {
      this.reset();
      newRun();
    }
    //while (this.len>0 && this.curFrm<0) this.curFrm += this.len;
    //this.curFrm %= this.len;
  }
  
}
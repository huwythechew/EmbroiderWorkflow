class Board{
  
  constructor(img,lineData) {
    this.w = img.width;
    this.h= img.height;
    this.lines = initLines(lineData);
  }
  
  closestLine(len) {
    let minD = -1;
    let minL = null;
    for (let i=0; i<this.lines.length; i++) {
      let curL = this.lines[i];
      let d = abs(curL.len-len);
      if (minD<0 || d<minD) {
        minD = d;
        minL = curL;
      }
    }
    return minL;
  }
}


function initLines(ld) {
  result = [];
  for (let i=0; i<ld.length; i++) {
    result.push(new Line(ld[i]));
    
  }
  return result;
}
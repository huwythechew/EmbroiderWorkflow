class Line{
  
  constructor(data) {
    let secS = 1;
    if (isMobile) secS = 0.5;
    this.from = createVector(data[0]*s*secS,data[1]*s*secS);
    this.to = createVector(data[2]*s*secS,data[3]*s*secS);
    this.len = this.from.dist(this.to);
    this.h = this.to.copy().sub(this.from).heading();
    //print(this.len);
  }
}
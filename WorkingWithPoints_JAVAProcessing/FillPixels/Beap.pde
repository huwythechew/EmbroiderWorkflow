class Beap {
  ArrayList<Bar> bars;
  color col = color(random(255),random(255),random(255));
  
  Beap() {
    this.bars = new ArrayList<Bar>();
  }
  
  Beap(Bar b) {
    this.bars = new ArrayList<Bar>();
    this.bars.add(b);
  }
  
  void add(Bar b) {
    this.bars.add(b);
  }
  
  void add(Beap bp) {
    this.bars.addAll(bp.bars);
  }
  
  Bar last() {
    int ind = this.bars.size()-1;
    return this.bars.get(ind);
  }
  
  void show() {
    colorMode(HSB);
    for (int i=0; i<this.bars.size(); i++) {
      Bar b = this.bars.get(i);
      //stroke(hue(this.col),saturation(this.col),map(i,0,this.bars.size(),100,255));
      //stroke(hue(this.col),saturation(this.col),map(i,0,this.bars.size(),0,255));
      stroke(map(i,0,this.bars.size(),80,200));
      b.show();
    }
  }
  
  void showShape(color c) {
    stroke(c);
    fill(c);
    strokeWeight(0);
    beginShape();
    for (int i=0; i<this.bars.size(); i++) {
      PVector curV = this.bars.get(i).to();
      vertex(curV.x,curV.y);
    }
    for (int i=this.bars.size()-1; i>=0; i--) {
      PVector curV = this.bars.get(i).from();
      vertex(curV.x,curV.y);
    }
    endShape(CLOSE);
  }
  
  boolean touching(Beap other) {
    for (Bar thisB : this.bars) {
      for (Bar othB : other.bars) {
        if (isCoX(thisB,othB,separation)) return true;
      }
    }
    return false;
  }
  
  ArrayList<PVector> stchPath(PVector pt,PImage pat) {
    ArrayList<PVector> result = new ArrayList<PVector>();
    result.add(pt.copy());
    if(this.bars.size()==0) return result;
    
    Bar frstBar = this.bars.get(0);
    float dF = pt.dist(frstBar.from());
    float dT = pt.dist(frstBar.to());
    boolean onTo = true;
    if (dF<dT) onTo = false;
    for (int i=0; i<this.bars.size(); i++) {
      Bar curB = this.bars.get(i);
      result.addAll(curB.stitches(pat,onTo));
      onTo = !onTo;
    }
    
    return result;
  }
  
  ArrayList<PVector> stchPath(PImage pat) {
    ArrayList<PVector> result = new ArrayList<PVector>();
    if(this.bars.size()==0) return result;
    
    boolean onTo = true;
    
    for (int i=0; i<this.bars.size(); i++) {
      Bar curB = this.bars.get(i);
      result.addAll(curB.stitches(pat,onTo));
      onTo = !onTo;
    }
    return result;
  }
  
  Beap firstTouching(ArrayList<Beap> bps) {
    for (Beap bp : bps) {
      if (this.touching(bp)) return bp;
    }
    return null;
  }
  
  boolean containsPt(PVector pt) {
    int nBs = this.bars.size();
    if (nBs==0) return false;
    
    Bar prevBar = this.bars.get(0);
    Bar lastBar = this.bars.get(nBs-1);
    
    if (pt.y<min(prevBar.to().y,lastBar.to().y)||
        pt.y>max(prevBar.to().y,lastBar.to().y)) return false;
    
    for(int i=1; i<nBs; i++) {
      Bar curBar = this.bars.get(i);
      if (pt.y<min(prevBar.from().y,curBar.from().y)||
          pt.y>max(prevBar.from().y,curBar.from().y)) {
        prevBar = curBar;
        continue;
      }
      
      if (pt.x>min(prevBar.from().x,curBar.from().x) &&
          pt.x<max(prevBar.to().x,curBar.to().x)) {
        return true;
      }
      
      prevBar = curBar;
      
    }
    return false;
  }
  
  void reverse() {
    ArrayList<Bar> newBars = new ArrayList<Bar>();
    for (int i=this.bars.size()-1; i>=0; i--) {
      newBars.add(this.bars.get(i));
      
    }
    this.bars = newBars;
  }
}

Beap getLinesStnd(PImage img, float sep) {
  Beap result = new Beap();
  img.loadPixels();
  for (int y=0; y<img.height; y+=sep) {
    boolean inside = false;
    
    Bar newBar = new Bar();
    
    for (int x=0; x<img.width; x++) {
      int ind = y*img.width + x;
      color c = img.pixels[ind];
      float b = brightness(c);
      if (!inside && b>200) { //starting shape
        newBar.setFrom(new PVector(x,y));
        inside = true;
      }
      else if (inside && b<200) {
        newBar.setTo(new PVector(x-1,y));
        result.add(newBar);
        newBar = new Bar();
        inside = false;
      }
    }
    if (newBar.pts[0] != null) {
      newBar.pts[1] = new PVector(img.width-1,y);
      result.add(newBar);
    }
  }
  
  return result;
}

ArrayList<Beap> struct(Beap bs) {
  ArrayList<Beap> result = new ArrayList<Beap>();
  
  int nb = bs.bars.size();
  if (nb==0) return result;
  
  //init result with first bar in a new beap
  Beap frstBeap = new Beap();
  frstBeap.add(bs.bars.get(0));
  result.add(frstBeap);
  
  //if it overlaps(coX) then its added to the beap. Else new beap
  for (int i=1; i<nb; i++) {
    Bar curB = bs.bars.get(i);
    boolean placed = false;
    for (int j=0; j<result.size(); j++) {
      Beap bp = result.get(j);
      Bar prevB = bp.last();
      if (prevB.to().y==curB.to().y && bp.bars.size()>=2) {
        Bar on = bp.bars.get(bp.bars.size()-2);
        if (overlapX(on,curB)>overlapX(on,prevB)) {
          bp.bars.set(bp.bars.size()-1,curB);
          result.add(new Beap(prevB));
          placed = true;
          break;
        }
      }
      else if (isCoX(prevB,curB, separation)) {
        placed = true;
        bp.add(curB);
        break;
      }
    }
    if (!placed) {
      result.add(new Beap(curB));
    }
  }
  
  return result;
}


ArrayList<Beap> reverseBeaps(ArrayList<Beap> bps) {
  ArrayList<Beap> result = new ArrayList<Beap>();
  for (int i=bps.size()-1; i>=0; i--) {
    result.add(bps.get(i));
  }
  return result;
}

ArrayList<PVector> reversePts(ArrayList<PVector> bps) {
  ArrayList<PVector> result = new ArrayList<PVector>();
  for (int i=bps.size()-1; i>=0; i--) {
    result.add(bps.get(i));
  }
  return result;
}

void labelBeaps(ArrayList<Beap> bps) {
  for (int i=0; i<bps.size(); i++) {
    Beap bp = bps.get(i);
    int ind = bp.bars.size()/2;
    Bar b = bp.bars.get(ind);
    PVector at = b.from().copy().lerp(b.to(),0.5);
    stroke(255); strokeWeight(5);
    textAlign(CENTER);
    
    point(at.x,at.y);
    textSize(20);
    fill(0);
    text(i,at.x+8,at.y-8);
    fill(255);
    text(i,at.x+6,at.y-6);
  }
}

ArrayList<Beap> bumpToFront(ArrayList<Beap> bps, int ind) {
  int initLen = bps.size();
  ArrayList<Beap> result = new ArrayList<Beap>();
  result.add(bps.get(ind));
  bps.remove(ind);
  if (bps.size()==initLen) println("PROBLEM");
  
  for (Beap bp : bps) result.add(bp);
  return result;
}

ArrayList<Beap> addAt(ArrayList<Beap> bps, Beap bp, int ind) {
  Beap toAdd = bp;
  for (int i=ind; i<bps.size(); i++) {
    Beap temp = bps.get(i);
    bps.set(i,toAdd);
    toAdd = temp;
  }
  bps.add(toAdd);
  return bps;
}


ArrayList<PVector> getStchPath(ArrayList<Beap> bps) {
  ArrayList<PVector> result = new ArrayList<PVector>();
  if (bps.size()==0) return result;
  
  
  
  
  return result;
}


Beap containsPt(ArrayList<Beap> bps, PVector pt) {
  for (Beap bp : bps) {
    if (bp.containsPt(pt)) return bp;
  }
  return null;
}

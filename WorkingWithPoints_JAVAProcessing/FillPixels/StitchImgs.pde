PImage standardLines(float sep) {
  PImage result = new PImage(width,height,RGB);
  result.loadPixels();
  for (int y=0; y<result.height; y++) {
    for (int x=0; x<result.width; x++) {
      int ind = y*result.width+x;
      if (x%sep==0) result.pixels[ind] = color(0);
      else result.pixels[ind] = color(255);
    }
  }
  return result;
}

PImage standardLines(float sep, float inc) {
  PImage result = new PImage(width,height,RGB);
  result.loadPixels();
  for (int y=0; y<result.height; y++) {
    int lineStart = round((y*inc)%(sep/4))*4;
    
    for (int x=0; x<result.width; x++) {
      int ind = y*result.width+x;
      
      if ((int)(x-10)%(sep)==lineStart) result.pixels[ind] = color(0);
      else result.pixels[ind] = color(255);
    }
  }
  result.resize(width*2,height);
  result = result.get(0,0,width,height);
  return result;
}

PImage spliceImgs(PImage img, float sep, float inc) {
  PImage result = new PImage(width,height,RGB);
  result.loadPixels();
  img.loadPixels();
  for (int y=0; y<result.height; y++) {
    if (y/2%2==0) {
      for (int x=0; x<result.width; x++) {
        int ind = y*result.width+x;
        result.pixels[ind] = img.pixels[ind];
      }
      continue;
    }
    for (int x=0; x<result.width; x++) {
      int ind = y*result.width+x;
      if (x%sep==(y*inc)%sep) result.pixels[ind] = color(0);
      else result.pixels[ind] = color(255);
    }
  }
  return result;
}

PImage rotateImg(PImage img) {
  PImage result = new PImage(img.height,img.width,RGB);
  img.loadPixels();
  for (int y=0; y<img.height; y++) {
    for (int x=0; x<img.width; x++) {
      int ind1 = y*img.width + x;
      int ind2 = x*result.width + y;
      result.pixels[ind2] = img.pixels[ind1];
    }
  }
  
  return result;
}

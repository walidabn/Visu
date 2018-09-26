class My2DBox {
  My2DPoint[] s;
  
  My2DBox(My2DPoint[] s) {
    this.s = s;
  }

  void render() {
    strokeWeight(4); 
    stroke(0,255,0);
    line(s[5].x, s[5].y, s[6].x, s[6].y);
    line(s[6].x, s[6].y, s[7].x, s[7].y);
    line(s[4].x, s[4].y, s[5].x, s[5].y);    
    line(s[4].x, s[4].y, s[7].x, s[7].y);
    
    stroke(0,0,255);
    line(s[3].x, s[3].y, s[7].x, s[7].y);
    line(s[0].x, s[0].y, s[4].x, s[4].y);
    line(s[5].x, s[5].y, s[1].x, s[1].y);
    line(s[2].x, s[2].y, s[6].x, s[6].y);
    
    stroke(255,0,0);
    line(s[0].x, s[0].y, s[1].x, s[1].y);
    line(s[0].x, s[0].y, s[3].x, s[3].y);
    line(s[2].x, s[2].y, s[3].x, s[3].y);
    line(s[2].x, s[2].y, s[1].x, s[1].y);
  }
}
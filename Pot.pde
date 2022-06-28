public class Pot {
  public int value = 4;
  private float x, y, w, h;
  private int colour = color(255);
   public Pot(float x, float y, float w, float h) {
     this.x = x;
     this.y = y;
     this.w = w;
     this.h = h;
   }
   
   public void display() {
     fill(colour);
     ellipse(x, y, w, h);
     fill(0);
     textSize(20);
     text(value, x-6, y+6);
   }
   
   public void setDimensions() {
     
   }
   
   public void setColour(int colour) {
      this.colour = colour; 
   }
}

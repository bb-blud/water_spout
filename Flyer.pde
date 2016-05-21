public class Flyer{
  float[][]  trail = new float[2][2];
  float[] position = new float[2];
  float[] heading  = new float[2];
  int pcount = 0;
  //float flyer_rad;
  int fly_col;
  float speed;

  
  
   public Flyer(){
    x = width/2;
    y = height/2;
    speed = .001;
    position[0]= x;
    position[1]= y;
    heading[0] = 0;
    heading[1] = 0;
    fly_col  = color(0,0,0,0);
       
    for(k=0;k<2;k++){
      trail[k][0]=x;
      trail[k][1]=y;
      
    } 
  }
  
  
  void setFlyer(int col, float xo, float yo){
    speed = 4;
    position[0] = xo;
    position[1] = yo;
    fly_col = col;
    
    ////Initialize heading based on screen center///
    float xdr = xo - width/2;
    float ydr = yo - height/2;
    float D = sqrt(xdr*xdr+ydr*ydr);
    heading[0] = speed*xdr/D;
    heading[1] = speed*ydr/D; 
    
    /////Tail tucked in on initial position////////
    for(k=0;k<2;k++){
      trail[k][0]=xo;
      trail[k][1]=y0;
    } 
    
   

  }
  
  void Paint(){
    
/////Head of flyer///////////////   
   
    
    trail[pcount%2][0] = position[0];            ///storing passed positions
    trail[pcount%2][1] = position[1];
    position[0] += heading[0];
    position[1] += heading[1];   
    fill(255,20,20,220);    
    ellipse(position[0],position[1], 30,30);
    ellipse(trail[0][0],trail[0][1], 20,20);
    ellipse(trail[1][0],trail[1][1], 10,10);
    
    
    pcount++;
    
    
//////////Hiting Barriers////////////////////
    
    if(position[0]>width || position[0]<0){
      fill(fly_col);
      ellipse(position[0],position[1],30,width*.40);
      heading[0] = -1*heading[0];      
      
    }
    
    if(position[1]>=height || position[1]<=0){
      fill(fly_col);
      ellipse(position[0],position[1],height*.40,30);
      heading[1] = -1*heading[1];
           
    }
    
    //Animate flash when hitting outer layer of drops
    float d = CenterDistance();  
    //sample3.cue(0); 
    if(d <= width/2 && d>=.98*width/2){
      fill(fly_col);
      ellipse(width/2,height/2,width,width);
      //if(pcount%16==0)
        //sample3.play;
    }

  }
  
void new_heading(float x, float y){
    
    //Update the flyers heading finding its direction and scaling by speed of mouse.
    float head_x = (x - position[0]);
    float head_y = (y - position[1]);
    
    float magnitude  = sqrt(head_x*head_x + head_y*head_y);
    heading[0] = abs(mouseX-pmouseX)*head_x/magnitude;
    heading[1] = abs(mouseY-pmouseY)*head_y/magnitude;
    
  }
  
  
float CenterDistance(){
   float x = position[0]-width/2;
   float y = position[1]-height/2;
    return sqrt(x*x+y*y);
       
  }
}

  


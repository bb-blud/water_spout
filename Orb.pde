public class Orb{
  float Orb_rad;        //Orbs Radius
  float drop_rad;       //Radius of each drop
  float[][] drop_pos;   //Position fo each drop
  boolean[] drop_st;    //Drop state: ON/OFF
  
  int   num_drops;
  color orb_col;
  float flashy_one;

  
  
 ///////////////////////////////////////////////////////////////////// 
  public Orb(float R, float r, int col, int drops){
   
   num_drops = drops;
   Orb_rad  = R;
   drop_rad = r;
   
   drop_pos = new float[num_drops][2];         //drop xpos, ypos
   drop_st  = new boolean[num_drops];
   
   //record position of drops 
   for (int k = 0; k<num_drops; k++){
     
     drop_pos[k][0] = width/2  + Orb_rad*cos( (TWO_PI/num_drops)*k );
     drop_pos[k][1] = height/2 + Orb_rad*sin( (TWO_PI/num_drops)*k );
     drop_st[k] = false;
   }
   
   orb_col  =  col;
   flashy_one = 0;
    
  }
////////////////////////////////////////////////////////////////////////
       
        
////////Paint Orb////////////       
  void Paint(float f_rate){
    noStroke();
    float x_pos;
    float y_pos; 
  
  for (int k = 0; k<num_drops; k++){
    x_pos = drop_pos[k][0];
    y_pos = drop_pos[k][1];
    
    if(k == (int)flashy_one%num_drops){
         
       noStroke();
       fill(orb_col);
       float r = random(drop_rad*.3,drop_rad*1.6);
       ellipse(x_pos,y_pos,r,r);
       float r2 = drop_rad/2;
       ellipse(x_pos,y_pos,r2,r2);
            
       }
   
   
    if(drop_st[k]){                //Paint white if position is ON
      fill(200,255,255,200);
      ellipse(x_pos,y_pos,drop_rad*.50,drop_rad*.50);
      
 
    }
    else{
       fill(orb_col);
       float rad = random(drop_rad*.95,drop_rad*1.05);
       ellipse(x_pos,y_pos,rad,rad);
    }
    
    }
    flashy_one = flashy_one + 8/f_rate;
   
  }
  
  
////////////////////////////////////////////
  
  float[][] DropPos(){
    return drop_pos;
  }
  
///////////////////////////////////////////

  boolean[] ActiveDrops(){
    return drop_st;
  }
///////////////////////////////////////////

  boolean ClickDrop(int x, int y){
    for(int k = 0; k<num_drops; k++){
      
      if(abs(x - drop_pos[k][0])<drop_rad*.20 && abs(y - drop_pos[k][1])<drop_rad*.20){
        drop_st[k] = !(drop_st[k]);
        return true;
      }     
    }
     return false;
  }
///////////////////////////////////////////  
  
}



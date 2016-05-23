/////Visual Stuff///////
//float[][] drop_pos;   //Position fo each drop
Orb orb1,orb2, orb3;//, button;
Flyer[] flies;
int fly_count;
boolean flies_full = false;
boolean buttonOn = true;
float screen_diag;
color backGrd;
int Col1 = color(0,200,255,100);
int Col2 = color(255,255,0,150);
int Col3 = color(0,255,20,100);

/////General/////////////
Maxim maxim;
int num_drops;
float f_rate;
int playhead = 0;
int currentBeat = 0;

/////Drum Stuf///////////
AudioFilePlayer sample1;
AudioFilePlayer sample2; 
AudioFilePlayer sample3; 
AudioFilePlayer sample4;

boolean [] track1;
boolean [] track2;
boolean [] track3;
boolean [] track4;

////Synth Stuff///////////
Synth waveform;
//int[] notes = {2,4,8,16,0,0,0,0,2,4,8,16,0,0,0,0};//{0,0,0,12,12,12,10,10,10,7,7,7,6,6,3,3};
int[] notes = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
float fc,res,attack,release;
Slider dt, dg, a, r, f, q;
MultiSlider seq;
float[] wavetable = new float[514]; 



void setup(){
  num_drops=16;
  f_rate = 32;
  frameRate(f_rate);
  maxim = new Maxim(this);
  
//////Drum Stuff Initialized//////////////////////////////////////////////////// 
  sample1 = maxim.loadFile("bd1.wav", 2048);
  sample2 = maxim.loadFile("sn1.wav", 2048);
  sample3 = maxim.loadFile("hh1.wav", 2048);
  sample4 = maxim.loadFile("sn2.wav", 2048);


  track1 = new boolean[num_drops];
  track2 = new boolean[num_drops];
  //track3 = new boolean[num_drops];
  track4 = new boolean[num_drops]; 

  for (int i = 0; i < num_drops; i++)
  {
    track1[i] = false;
    track2[i] = false;
    track4[i] = false;
  }
  
  
////////Synth Stuff Initialized////////////////////////////////////////////////////
  waveform = new Synth();
            // name, value, min, max, pos.x, pos.y, width, height
  dt = new Slider("delay time", 1, 0, 100, width*.7, 10, 300, 20, HORIZONTAL);
  dg = new Slider("delay amnt", 1, 0, 100, width*.7, 30, 300, 20, HORIZONTAL);
  a = new Slider("attack",      1, 0, 100, width*.7, 50, 300, 20, HORIZONTAL);
  r = new Slider("release",    70, 0, 100, width*.7, 70, 300, 20, HORIZONTAL);
  f = new Slider("filter",     1, 0, 100, width*.7, 90, 300, 20, HORIZONTAL);
  q = new Slider("res",       5, 0, 100, width*.7, 110, 300, 20, HORIZONTAL);
  seq = new MultiSlider(notes.length, 0, 256, width*.20, height*7.3, width*.30, 100, UPWARDS);
  
  for (int i = 0; i < 514 + 1 ; i++) {

    wavetable[i]=((float)i/512)-0.5;
  }
  
  waveform.waveTableSize(514);
  waveform.loadWaveTable(wavetable);

///////Visual Stuff Initialized////////////////////////////////////////////////////  
  backGrd = color(0);
  size(640,800);
  screen_diag = sqrt(width*width+height*height)/2;
  
  //drop_rad = screen_diag*.14;
  int Col1 = color(0,200,255,100);
  int Col2 = color(255,255,0,150);
  int Col3 = color(0,255,20,100);

  orb1 = new Orb(screen_diag*.45, screen_diag*.14,Col1, num_drops);
  orb2 = new Orb(screen_diag*.35, screen_diag*.12,Col2, num_drops);
  orb3 = new Orb(screen_diag*.25, screen_diag*.10,Col3, num_drops);
  //button = new Orb(screen_diag*.05,screen_diag*.05,color(0,255,255,200),num_drops/2);
  //drop_pos = orb1.DropPos();
  
  flies = new Flyer[3];//[num_drops];
    for (int i = 0; i < 3; i++)
  {
      flies[i] = new Flyer();
  }
  fly_count = 0;
  
  
}

void draw(){
/////Visual things////////////////
 background(backGrd);
 displayButton();
 orb1.Paint(f_rate);
 orb2.Paint(f_rate);
 orb3.Paint(f_rate);
 for(k = 0; k < 3;k++){
   flies[k].Paint();
 }
 
 
//////////Synths/////////////////
 waveform.play();
 if(f.get() != 0) {
    fc=f.get()*100;
    waveform.setFilter(fc,res);
  }
  
    if(dt.get() != 0) {
    waveform.setDelayTime((float) dt.get()/50);
  }
  
    if(dg.get() != 0) {
    waveform.setDelayAmount((int)dg.get()/100);
  }
  
    if(q.get() != 0) {
    res=q.get();
    waveform.setFilter(fc,res);
  }
  
    if(a.get() != 0) {
    attack=a.get()*10;
    
  }
  
    if(r.get() != 0) {
    release=r.get()*10;
  }
  
  if(buttonOn){
 
  dt.display();
  dg.display();
  a.display();
  r.display();
  f.display();
  q.display(); 
  seq.display();
  }
 ///////////////////////////// 
  
   /*if (mousePressed) {
    dt.mouseDragged();
    dg.mouseDragged();
    a.mouseDragged();
    r.mouseDragged();
    f.mouseDragged();
    q.mouseDragged();
    seq.mouseDragged();
  }*/
////Drums///////////////
 playhead++;
 if (playhead%4==0){   ///////////playhead%4/////////
   
   
   sample1.cue(0);
   if(track1[currentBeat])
     sample1.play();
     
   sample2.cue(0);
   if(track2[currentBeat])
     sample2.play();
     
   sample3.cue(0);
   sample4.cue(0);
   if(track4[currentBeat])
     if(currentBeat%2==0)
       sample4.play();
     else
       sample3.play();  
       
   currentBeat++;
   if (currentBeat >= num_drops) 
     currentBeat=0;
 
  
  if (playhead%4==0) {
  waveform.ramp(0.5,attack); 
  waveform.setFrequency(mtof[notes[playhead/4%16]+30]);
  }
  
  if (playhead%4==1) {
   waveform.ramp(0.,release); 
  }
     
 }/////////////////////////////////////////////////////////
   
}


void mousePressed(){
  
///////////Clicking Drops/////////////

  if(orb1.ClickDrop(mouseX,mouseY)){
    track1 = orb1.ActiveDrops();
    flies[0].setFlyer(color(0,200,255),mouseX,mouseY);
       
    
  }else if(orb2.ClickDrop(mouseX,mouseY)){
    track2 = orb2.ActiveDrops();
    flies[1].setFlyer(color(255,255,0),mouseX,mouseY);
    //fly_count++; 
    
  }else if(orb3.ClickDrop(mouseX,mouseY)){
    track4 = orb3.ActiveDrops();
    flies[2].setFlyer(color(0,255,20),mouseX,mouseY);
    //fly_count++; 
  }
  
/////////Clicking Button/////////////
  if ((mouseX-width/2)*(mouseX-width/2)+(mouseY-height/2)*(mouseY-height/2)<=screen_diag*.8)
    buttonOn = !buttonOn;
    
////////////Synth//////////////////// 
if(buttonOn){
  dt.mousePressed();
  dg.mousePressed();
  a.mousePressed();
  r.mousePressed();
  f.mousePressed();
  q.mousePressed();
  seq.mousePressed();}

}

void mouseDragged(){
  if(!buttonOn && mousePressed){  
  flies[0].new_heading(mouseX,mouseY);
  flies[1].new_heading(mouseX,mouseY);
  flies[2].new_heading(mouseX,mouseY);
  }
  
  if(!buttonOn){
  fill(255,255,255,50);
  ellipse(mouseX,mouseY,screen_diag*.15,screen_diag*.08);
  ellipse(mouseX,mouseY,screen_diag*.08,screen_diag*.15);}
  
  
////////Synth//////////////////// 
if(buttonOn){
  dt.mouseDragged();
  dg.mouseDragged();
  a.mouseDragged();
  r.mouseDragged();
  f.mouseDragged();
  q.mouseDragged();
  seq.mouseDragged();}

  
}

void displayButton(){
 if(buttonOn)
   fill(50,100,255,200);
 else
   fill(255,100,50,200);
 rectMode(CENTER);
 float r = random(.098,.1);
 rect(width/2,height/2,screen_diag*r,screen_diag*r,screen_diag*r*r);
  
}
void mouseReleased()
{
  for (int i=0;i<notes.length;i++) {
    
   notes[i]=Math.floor(seq.get(i)/256*12); 
    
  }
 //   waveform.ramp(0.,1000); 
 
}
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

  


int HORIZONTAL = 0;
int VERTICAL   = 1;
int UPWARDS    = 2;
int DOWNWARDS  = 3;

class Widget
{

  
  PVector pos;
  PVector extents;
  String name;

  color inactiveColor = color(60, 60, 100);
  color activeColor = color(100, 100, 160);
  color bgColor = inactiveColor;
  color lineColor = color(255);
  
  
  
  void setInactiveColor(color c)
  {
    inactiveColor = c;
    bgColor = inactiveColor;
  }
  
  color getInactiveColor()
  {
    return inactiveColor;
  }
  
  void setActiveColor(color c)
  {
    activeColor = c;
  }
  
  color getActiveColor()
  {
    return activeColor;
  }
  
  void setLineColor(color c)
  {
    lineColor = c;
  }
  
  color getLineColor()
  {
    return lineColor;
  }
  
  String getName()
  {
    return name;
  }
  
  void setName(String nm)
  {
    name = nm;
  }


  Widget(String t, int x, int y, int w, int h)
  {
    pos = new PVector(x, y);
    extents = new PVector (w, h);
    name = t;
    //registerMethod("mouseEvent", this);
  }

  void display()
  {
  }

  boolean isClicked()
  {
    
    if (mouseX > pos.x && mouseX < pos.x+extents.x 
      && mouseY > pos.y && mouseY < pos.y+extents.y)
    {
      return true;
    }
    else
    {
      return false;
    }
  }
  
  public void mouseEvent(MouseEvent event)
  {
    //if (event.getFlavor() == MouseEvent.PRESS)
    //{
    //  mousePressed();
    //}
  }
  
  
  boolean mousePressed()
  {
    return isClicked();
  }
  
  boolean mouseDragged()
  {
    return isClicked();
  }
  
  
  boolean mouseReleased()
  {
    return isClicked();
  }
}


class Slider extends Widget
{
  float minimum;
  float maximum;
  float val;
  int textWidth = 60;
  int orientation = HORIZONTAL;

  Slider(String nm, float v, float min, float max, int x, int y, int w, int h, int ori)
  {
    super(nm, x, y, w, h);
    val = v;
    minimum = min;
    maximum = max;
    orientation = ori;
    if(orientation == HORIZONTAL)
      textWidth = 60;
    else
      textWidth = 20;
    
  }

  float get()
  {
    return val;
  }

  void set(float v)
  {
    val = v;
    val = constrain(val, minimum, maximum);
  }

  void display()
  {
    
    float textW = textWidth;
    if(name == "")
      textW = 0;
    //pushStyle();
    textAlign(LEFT, TOP);
    //fill(lineColor);
    //text(name, pos.x, pos.y);
    //stroke(lineColor);
    noFill();
    if(orientation ==  HORIZONTAL){
      rect(pos.x+textW, pos.y, extents.x-textWidth, extents.y);
    } else {
      rect(pos.x, pos.y+textW, extents.x, extents.y-textW);
    }
    noStroke();
    fill(bgColor);
    float sliderPos; 
    if(orientation ==  HORIZONTAL){
        sliderPos = map(val, minimum, maximum, 0, extents.x-textW-4); 
        rect(pos.x+textW+2, pos.y+2, sliderPos, extents.y-4);
    } else if(orientation ==  VERTICAL || orientation == DOWNWARDS){
        sliderPos = map(val, minimum, maximum, 0, extents.y-textW-4); 
        rect(pos.x+2, pos.y+textW+2, extents.x-4, sliderPos);
    } else if(orientation == UPWARDS){
        sliderPos = map(val, minimum, maximum, 0, extents.y-textW-4); 
        rect(pos.x+2, pos.y+textW+2 + (extents.y-textW-4-sliderPos), extents.x-4, sliderPos);
    };
    //popStyle();
  }

  
  boolean mouseDragged()
  {
    if (super.mouseDragged())
    {
      float textW = textWidth;
      if(name == "")
        textW = 0;
      if(orientation ==  HORIZONTAL){
        set(map(mouseX, pos.x+textW, pos.x+extents.x-4, minimum, maximum));
      } else if(orientation ==  VERTICAL || orientation == DOWNWARDS){
        set(map(mouseY, pos.y+textW, pos.y+extents.y-4, minimum, maximum));
      } else if(orientation == UPWARDS){
        set(map(mouseY, pos.y+textW, pos.y+extents.y-4, maximum, minimum));
      };
      return true;
    }
    return false;
  }

  boolean mouseReleased()
  {
    if (super.mouseReleased())
    {
      float textW = textWidth;
      if(name == "")
        textW = 3;
      if(orientation ==  HORIZONTAL){
        set(map(mouseX, pos.x+textW, pos.x+extents.x-10, minimum, maximum));
      } else if(orientation ==  VERTICAL || orientation == DOWNWARDS){
        set(map(mouseY, pos.y+textW, pos.y+extents.y-10, minimum, maximum));
      } else if(orientation == UPWARDS){
        set(map(mouseY, pos.y+textW, pos.y+extents.y-10, maximum, minimum));
      };
      return true;
    }
    return false;
  }
}

class MultiSlider extends Widget
{
  Slider [] sliders;
  /*
  MultiSlider(String [] nm, float min, float max, int x, int y, int w, int h, int orientation)
  {
    super(nm[0], x, y, w, h*nm.length);
    sliders = new Slider[nm.length];
    for (int i = 0; i < sliders.length; i++)
    {
      int bx, by;
      if(orientation == HORIZONTAL)
      {
        bx = x;
        by = y+i*h;
      }
      else
      {
        bx = x+i*w;
        by = y;
      }
      sliders[i] = new Slider(nm[i], 0, min, max, bx, by, w, h, orientation);
    }
  }
  */
  MultiSlider(int numSliders, float min, float max, int x, int y, int w, int h, int orientation)
  {
    super("", x, y, w, h*numSliders);
    sliders = new Slider[numSliders];
    for (int i = 0; i < sliders.length; i++)
    {
      int bx, by;
      if(orientation == HORIZONTAL)
      {
        bx = x;
        by = y+i*h;
      }
      else
      {
        bx = x+i*w;
        by = y;
      }
      sliders[i] = new Slider("", 20, min, max, bx, by, w, h, orientation);
    }
  }
  
  void setNames(String [] names)
  {
    for (int i = 0; i < sliders.length; i++)
    {
      if(i >= names.length)
        break;
      sliders[i].setName(names[i]);
    }
  }

  void set(int i, float v)
  {
    if(i >= 0 && i < sliders.length)
    {
      sliders[i].set(v);
    }
  }
  
  float get(int i)
  {
    if(i >= 0 && i < sliders.length)
    {
      return sliders[i].get();
    }
    else
    {
      return -1;
    }
    
  }

  void display()
  {
    for (int i = 0; i < sliders.length; i++)
    {
      sliders[i].display();
    }
  }

  
  boolean mouseDragged()
  {
    for (int i = 0; i < sliders.length; i++)
    {
      if(sliders[i].mouseDragged())
      {
        return true;
      }
    }
    return false;
  }

  boolean mouseReleased()
  {
    for (int i = 0; i < sliders.length; i++)
    {
      if(sliders[i].mouseReleased())
      {
        return true;
      }
    }
    return false;
  }
}

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




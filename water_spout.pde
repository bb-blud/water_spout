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

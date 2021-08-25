import java.util.*;

float viewing_y_angle = 30;
float viewing_x_angle = 45;
float theta = 0;
float theta_incr = 10;

float chunk_size = 5;
int chunk_offset = 0;

int cube_size = 50;
int cube_offset = 20;

boolean reset = true;
float k;

int[] bg_color = new int[]{222, 226, 230};
int[] cb_color = new int[]{52, 58, 64};

HashSet<Cube> cubes = new HashSet<>();
PVector center = new PVector(0, 0);
boolean odd = false;

void setup(){
  size(800, 600, P3D);
  frameRate(24);
  if(chunk_size%2 != 0){
    odd = true;
  }
  if(odd){
    k = (float)Math.floor(chunk_size/2.0);
  } else {
    k = (float)((chunk_size-1)/2.0);
  }
  
  //-NORMAL CUBE WAVE-
  //for(float i = -k; i <= k; i++){
  //  for(float j = -k; j <= k; j++){
  //    Cube cube = new Cube(i*cube_size, 0, j*cube_size, ((i+j)%(chunk_size*2))*cube_offset);
  //    cubes.add(cube);
  //    if(odd && i == 0 && j == 0){
  //      center = new PVector(cube.x, cube.y, cube.z);
  //    } else if(!odd && i == -.5 && j == -.5){
  //      center = new PVector(cube.x+cube_size/2, cube.y, cube.z+cube_size/2);
  //    }
  //  }
  //}
  
  //-CENTERED CUBE WAVE-
  for(float i = -k; i <= k; i++){
    for(float j = -k; j <= k; j++){
      Cube cube = new Cube(i*cube_size, 0, j*cube_size, 0, (abs(i)+abs(j))*cube_offset);
      cubes.add(cube);
      if(odd && i == 0 && j == 0){
        center = new PVector(cube.x, cube.y, cube.z);
      } else if(!odd && i == -.5 && j == -.5){
        center = new PVector(cube.x+cube_size/2, cube.y, cube.z+cube_size/2);
      }
    }
  }
  
  reset = false;
}

void draw(){
  //viewing_y_angle = map(mouseY, 0, height, 0, 90);
  //viewing_x_angle = map(mouseX, 0, width, 0, 360);
  background(bg_color[0], bg_color[1], bg_color[2]);
  push();
  translate((width/2), (height/2), 0);
  rotateX(radians(-viewing_y_angle));
  rotateY(radians(viewing_x_angle)); 
  for(Cube cube : cubes){
    cube.update();
    cube.draw();
  }
  if(theta < 360){
    setOffsets();
    theta += theta_incr;
  } else {
    theta = 0;
    boolean adjusted = false;
    //for(Cube cube : cubes){
    //  if(cube.offset > 0){
    //    cube.offset -= theta_incr;
    //    adjusted = true;
    //  }
    //}
    // notifies that the wave has been reset
    //if(!adjusted){
    //  reset = true;
    //}
  } 
  pop();
}

// sets the offsets for the cubes
void setOffsets(){
  for(Cube cube : cubes){
     if(cube.offset < cube.goal_offset){
        cube.offset += theta_incr;
      }
  }
  reset = false;
}

public class Cube {
  float x,y,z;
  float offset;
  float goal_offset;
  int size = cube_size;
  
  public Cube(float a, float b, float c, float o, float g_o){
    x=a;
    y=b;
    z=c;
    offset=o;
    goal_offset=g_o;
  }
  
  void draw(){
    push();
    stroke(bg_color[0], bg_color[1], bg_color[2]);
    translate(x, y, z);
    //-Plain Cubes-
    fill(cb_color[0], cb_color[1], cb_color[2]);
    box(cube_size, cube_size, cube_size);
    
    //-Grass Cubes-
    //fill(153, 103, 73);
    //box(cube_size, cube_size, cube_size);
    //translate(0, (-cube_size/2) - 2.5, 0);
    //fill(30, 173, 5);
    //box(cube_size, 5, cube_size);
    pop();
  }
  void update(){
    this.y = cube_size*sin(radians(theta-offset));
  }
}

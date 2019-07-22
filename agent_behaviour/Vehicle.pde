class Vehicle {
 
  PVector location;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxforce;
  float maxspeed;
 
  Vehicle(float x, float y) {
    acceleration = new PVector(0,0);
    velocity = new PVector(0,0);
    location = new PVector(x,y);
    r = 3.0;
    maxspeed = 4;
    maxforce = 0.1;
  }
  
  void predict() {
    PVector predict = velocity.get();
     
    //Normalize it and look 25 pixels ahead by scaling the vector up.
    predict.normalize();
    predict.mult(25);
     
    //Add vector to location to find the predicted location.
    PVector predictLoc = PVector.add(location, predict);
    ellipse(predictLoc.x, predictLoc.y, 5, 5);
  }
 
  void update() {
    velocity.add(acceleration);
    velocity.limit(maxspeed);
    location.add(velocity);
    acceleration.mult(0);
  }
 
  void applyForce(PVector force) {
    acceleration.add(force);
  }
 
  void seek(PVector target) {
    PVector desired = PVector.sub(target,location);
    desired.normalize();
    desired.mult(maxspeed);
    PVector steer = PVector.sub(desired,velocity);
    steer.limit(maxforce);
    applyForce(steer);
  }
 
  void display() {
    float theta = velocity.heading() + PI/2;
    fill(175);
    stroke(0);
    pushMatrix();
    translate(location.x,location.y);
    rotate(theta);
    beginShape();
    vertex(0, -r*2);
    vertex(-r, r*2);
    vertex(r, r*2);
    endShape(CLOSE);
    popMatrix();
  }
  
  PVector getNormalPoint(PVector p, PVector a, PVector b) {
    //PVector that points from a to p
    PVector ap = PVector.sub(p, a);
    //PVector that points from a to b
    PVector ab = PVector.sub(b, a);
 
    //Using the dot product for scalar projection
    ab.normalize();
    ab.mult(ap.dot(ab));
    //Finding the normal point along the line segment
    PVector normalPoint = PVector.add(a, ab);
 
    return normalPoint;
  }
  
   void follow(Path path) {
 
    //Step 1: Predict the vehicle’s future location.
    PVector predict = velocity.get();
    predict.normalize();
    predict.mult(25);
    PVector predictLoc = PVector.add(location, predict);
 
    //Step 2: Find the normal point along the path.
    PVector a = path.start;
    PVector b = path.end;
    PVector normalPoint = getNormalPoint(predictLoc, a, b);
 
    //Step 3: Move a little further along the path and set a target.
    PVector dir = PVector.sub(b, a);
    dir.normalize();
    dir.mult(10);
    PVector target = PVector.add(normalPoint, dir);
 
    //Step 4: If we are off the path, seek that target in order to stay on the path.
    float distance =
      PVector.dist(normalPoint, predictLoc);
    if (distance > path.radius) {
      seek(target);
    }
  }
  
}

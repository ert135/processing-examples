ArrayList<Vehicle> vehicles = new ArrayList<Vehicle>(); 
Path path;
int vehicleLimit = 20;

void setup() {
  path = new Path();
  size(800, 800);
  for (int i = 0; i < vehicleLimit; i++) 
  { 
      vehicles.add(
        new Vehicle(
          random(0, 800), 
          random(0, 800)
        )
      );
  } 
}

void draw() {
  clear();
   background(40);
  for (int i = 0; i < vehicleLimit; i++) 
  { 
    Vehicle current = vehicles.get(i);
    //current.seek(new PVector(mouseX, mouseY));
    current.update();
    current.predict();
    current.follow(path);
    current.display();
  } 
  path.display();
}

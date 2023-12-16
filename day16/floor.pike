constant UP = 1;
constant RIGHT = 2;
constant DOWN = 4;
constant LEFT = 8;

array(array(int)) shifts = ({ 0, ({ 0, -1 }), ({ 1, 0 }), 0, ({ 0, 1 }), 0, 0, 0, ({ -1, 0 }) });

array(string) map;
array(Worker) todo;
array(array(int)) filled;
int width;
int height;

class Worker {
  int x;
  int y;
  int dir;

  void create(int x, int y, int dir) {
    this->x = x;
    this->y = y;
    this->dir = dir;
  }
  
  void step() {
    int x = this->x + shifts[this->dir][0];
    int y = this->y + shifts[this->dir][1];
    if ((x < 0) || (x >= width) || (y < 0) || (y >= height) || (filled[y][x] & this->dir)) {
      return;
    }
    filled[y][x] |= this->dir;
    switch (map[y][x]) {
    case '.':
      todo += ({ Worker(x, y, this->dir) }); 
      break;
    case '/':
      switch (this->dir) {
      case UP:
	todo += ({ Worker(x, y, RIGHT) }); break;
      case RIGHT:
	todo += ({ Worker(x, y, UP) }); break;
      case DOWN:
	todo += ({ Worker(x, y, LEFT) }); break;
      case LEFT:
	todo += ({ Worker(x, y, DOWN) });  break;	
      }
      break;
    case '\\':
      switch (this->dir) {
      case UP:
	todo += ({ Worker(x, y, LEFT) }); break;
      case RIGHT:
	todo += ({ Worker(x, y, DOWN) }); break;
      case DOWN:
	todo += ({ Worker(x, y, RIGHT) }); break;
      case LEFT:
	todo += ({ Worker(x, y, UP) }); break;	
      }
      break;
    case '|':
      switch (this->dir) {
      case LEFT:
      case RIGHT:
	todo += ({ Worker(x, y, UP) }); 
	todo += ({ Worker(x, y, DOWN) }); 
	break;
      default:
	todo += ({ Worker(x, y, this->dir) }); 
      }
      break;
    case '-':
      switch (this->dir) {
      case UP:
      case DOWN:
	todo += ({ Worker(x, y, LEFT) }); 
	todo += ({ Worker(x, y, RIGHT) }); 
	break;
      default:
	todo += ({ Worker(x, y, this->dir) }); 
      }
      break;
    }
  }
}

int work(int x, int y, int dir) {
  filled = allocate(width * height) / width;
  todo = ({ Worker(x, y, dir) });  
  while (sizeof(todo) > 0) {
    Worker w = todo[0];
    todo = todo[1..];
    w->step();
  }
  return sizeof(filter(Array.flatten(filled), lambda(int i) { return i > 0; }));
}

int main(int argc, array(string) argv) {
  map = (Stdio.read_file(argv[1]) / "\n") - ({""});
  width = sizeof(map[0]);
  height = sizeof(map);
  write("Problem 1: %d\n", work(-1, 0, RIGHT));
  int m = 0;
  for (int x = 0; x < width; x++) {
    m = max(m, work(x, -1, DOWN));
    m = max(m, work(x, height, UP));
  }
  for (int y = 0; y < height; y++) {
    m = max(m, work(-1, y, RIGHT));
    m = max(m, work(width, y, LEFT));
  }
  write("Problem 2: %d\n", m);
}

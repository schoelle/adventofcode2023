constant UP = 1;
constant RIGHT = 2;
constant DOWN = 4;
constant LEFT = 8;

array(int) arrow = ({ '?', '^', '>', '?', 'v', '?', '?', '?', '<' });
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
  
  string _sprintf(int conversion_type, mapping(string:int)|void params) {
    return sprintf("[%d %d %c]", x, y, arrow[dir]);
  }

  void step() {
    int x = this->x + shifts[this->dir][0];
    int y = this->y + shifts[this->dir][1];
    if ((x < 0) || (x >= width) || (y < 0) || (y >= height)) {
      return;
    }
    if (filled[y][x] & this->dir) {
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
	todo += ({ Worker(x, y, RIGHT) }); 
	break;
      case RIGHT:
	todo += ({ Worker(x, y, UP) }); 
	break;
      case DOWN:
	todo += ({ Worker(x, y, LEFT) }); 
	break;
      case LEFT:
	todo += ({ Worker(x, y, DOWN) }); 
	break;	
      }
      break;
    case '\\':
      switch (this->dir) {
      case UP:
	todo += ({ Worker(x, y, LEFT) }); 
	break;
      case RIGHT:
	todo += ({ Worker(x, y, DOWN) }); 
	break;
      case DOWN:
	todo += ({ Worker(x, y, RIGHT) }); 
	break;
      case LEFT:
	todo += ({ Worker(x, y, UP) }); 
	break;	
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

void print_filled() {
  for(int y=0; y < height; y++) {
    for(int x=0; x < width; x++) {
      write("%s ", ([
	      0: "...",
	      1: ".^.",
	      2: ">>>",
	      3: ">^>",
	      4: ".v.",
	      5: ".|.",
	      6: ">v>",
	      7: ">|>",
	      8: "<<<",
	      9: "<^<",
	      10: "<->",
	      11: "<^>",
	      12: "<v<",
	      13: "<|<",
	      14: "<v>",
	      15: "<|>"
	    ])[filled[y][x]]);
    }
    write("\n");
  }
}

int main(int argc, array(string) argv) {
  map = (Stdio.read_file(argv[1]) / "\n") - ({""});
  width = sizeof(map[0]);
  height = sizeof(map);
  filled = allocate(width * height) / width;
  todo = ({ Worker(-1, 0, RIGHT) });
  while (sizeof(todo) > 0) {
    Worker w = todo[0];
    todo = todo[1..];
    w->step();
  }
  write("Problem 1: %d\n", sizeof(filter(Array.flatten(filled), lambda(int i) { return i > 0; })));
}

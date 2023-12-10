class Pos {
  int x; int y;
  void create(int x, int y) {
    this->x = x;
    this->y = y;
  }

  int get() {
    if ((this->x < 0) || (this->x >= maze_width) ||
	(this->y < 0) || (this->y >= maze_height)) {
      return 'O';
    }
    return maze[y][x];
  }

  int same_pos(Pos other) {
    return (this->x == other->x) && (this->y == other->y);
  }
  
  array(Pos) next() {
    return ({ Pos(this->x, this->y-1),
	      Pos(this->x+1, this->y),
	      Pos(this->x, this->y+1),
	      Pos(this->x-1, this->y) });
  }
}

class PosDir {
  Pos pos;
  int dir; // 0 North, 1 East, 2 South, 3 West
  void create(Pos pos, int dir) {
    this->pos = pos;
    this->dir = dir;
  }

  PosDir step() {
    Pos n = pos->next()[dir];
    switch(this->dir) {
    case 0:
      switch(n->get()) {
      case '7': return PosDir(n, 3);
      case 'F': return PosDir(n, 1);
      case '|': return PosDir(n, 0);
      }
      return 0;
    case 1:
      switch(n->get()) {
      case '7': return PosDir(n, 2);
      case 'J': return PosDir(n, 0);
      case '-': return PosDir(n, 1);
      }
      return 0;
    case 2:
      switch(n->get()) {
      case 'L': return PosDir(n, 1);
      case 'J': return PosDir(n, 3);
      case '|': return PosDir(n, 2);
      }
      return 0;
    case 3:
      switch(n->get()) {
      case 'L': return PosDir(n, 0);
      case 'F': return PosDir(n, 2);
      case '-': return PosDir(n, 3);
      }
      return 0;
    }
  }

  array(PosDir) path() {
    PosDir next = step();
    if (next) {
      return ({ this }) + next->path();
    } else {
      return ({ this });
    }
  }
  string _sprintf(int conversion_type, mapping(string:int)|void params) {
    return sprintf("%d %d %d", pos->x, pos->y, dir);
  }
}

array(string) maze;
int maze_height;
int maze_width;
Pos start;
array(PosDir) path;

void find_start() {
  for (int y = 0; y < maze_height; y++) {
    int x = search(maze[y], 'S');
    if (x != -1) {
      start = Pos(x, y);
      return;
    }
  }
  return 0;
}

void find_path() {
 for (int i = 0; i < 4; i++) {
    array(PosDir) p = PosDir(start, i)->path();
    PosDir last = p[-1];
    if (last->pos->next()[last->dir]->same_pos(start)) {
      path = p;
      return;
    }
  }
}

void print_maze(array(Pos) show) {
  multiset(string) t = (< >);
  foreach (show;; Pos p) {
    t[sprintf("%dx%d", p->x, p->y)] = 1;
  }
  for (int y; y < maze_height; y++) {
    for (int x; x < maze_width; x++) {
      string id = sprintf("%dx%d", x, y);
      if (t[id]) {
	write("X");
      } else {
	write(".");
      }
    }
    write("\n");
  }
  write("\n");
}


int main(int argc, array(string) argv) {
  maze = (Stdio.read_file(argv[1]) / "\n") - ({""});
  maze_height = sizeof(maze);
  maze_width = sizeof(maze[0]);
  find_start();
  find_path();
  write("Problem 1: %d\n", sizeof(path) / 2);
}

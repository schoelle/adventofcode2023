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

  int is_border() {
    return (x == 0) || (x == maze_width-1) || (y == 0) || (y == maze_height-1);
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

  array(Pos) left() {
    array(Pos) r = ({ pos->next()[(dir+1) % 4] });
    int c = pos->get();
    if ((dir == 0) && (c == 'J')) {
      r += ({ pos->next()[2] }); 
    }
    if ((dir == 1) && (c == 'L')) {
      r += ({ pos->next()[3] });
    }
    if ((dir == 2) && (c == 'F')) {
      r += ({ pos->next()[0] });
    }
    if ((dir == 3) && (c == '7')) {
      r += ({ pos->next()[1] });
    }
    return r;
  }
    
  array(Pos) right() {
    array(Pos) r = ({ pos->next()[(dir+3) % 4] });
    int c = pos->get();
    if ((dir == 0) && (c == 'L')) {
      r += ({ pos->next()[2] }); 
    }
    if ((dir == 1) && (c == 'F')) {
      r += ({ pos->next()[3] });
    }
    if ((dir == 2) && (c == '7')) {
      r += ({ pos->next()[0] });
    }
    if ((dir == 3) && (c == 'J')) {
      r += ({ pos->next()[1] });
    }
    return r;
  }
    
  array(PosDir) path() {
    PosDir next = step();
    if (next) {
      return ({ this }) + next->path();
    } else {
      return ({ this });
    }
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

string pid(Pos pos) {
  return sprintf("%dx%d\n", pos->x, pos->y);
}

array(Pos) grow(array(Pos) todo, array(Pos) occupied) {
  array(Pos) r = ({ });
  multiset(string) o = (< >);
  foreach (occupied;; Pos oc) {
    o[pid(oc)] = 1;
  }
  while (sizeof(todo) > 0) {
    Pos f = todo[0];
    todo = todo[1..];
    if (f->get() == 'O')
      continue;
    if (o[pid(f)])
      continue;
    r += ({ f });
    o[pid(f)] = 1;
    todo += f->next();
  }
  return r;
}

int main(int argc, array(string) argv) {
  maze = (Stdio.read_file(argv[1]) / "\n") - ({""});
  maze_height = sizeof(maze);
  maze_width = sizeof(maze[0]);
  find_start();
  find_path();
  write("Problem 1: %d\n", sizeof(path) / 2);
  array(Pos) occupied = map(path, lambda (PosDir d) { return d->pos; });
  array(Pos) left = Array.flatten(map(path, lambda (PosDir d) { return d->left(); })); 
  array(Pos) right = Array.flatten(map(path, lambda (PosDir d) { return d->right(); }));
  left = grow(left, occupied);
  right = grow(right, occupied);
  if (Array.any(left, lambda (Pos p) { return p->is_border(); })) {
    write("Problem 2: %d\n", sizeof(right));
  } else { 
    write("Problem 2: %d\n", sizeof(left));
  }
}

constant UP = 1;
constant RIGHT = 2;
constant DOWN = 4;
constant LEFT = 8;

array(array(int)) shifts = ({ 0, ({ 0, -1 }), ({ 1, 0 }), 0, ({ 0, 1 }), 0, 0, 0, ({ -1, 0 }) });

array(string) map;
int width;
int height;
array(int) todo; // Sequence of triplets: x, y, exit direction
array(array(int)) filled;

void step() {
  int x = todo[0] + shifts[todo[2]][0];
  int y = todo[1] + shifts[todo[2]][1];
  if ((x < 0) || (x >= width) || (y < 0) || (y >= height) || (filled[y][x] & todo[2])) {
    todo = todo[3..];
    return;
  }
  filled[y][x] |= todo[2];
  todo[0] = x;
  todo[1] = y;
  switch (map[y][x]) {
  case '/':
    switch (todo[2]) {
    case UP:
      todo[2] = RIGHT; return;
    case RIGHT:
      todo[2] = UP; return;
    case DOWN:
      todo[2] = LEFT; return;
    case LEFT:
      todo[2] = DOWN; return;
    }
  case '\\':
    switch (todo[2]) {
    case UP:
      todo[2] = LEFT; return;
    case RIGHT:
      todo[2] = DOWN; return;
    case DOWN:
      todo[2] = RIGHT; return;
    case LEFT:
      todo[2] = UP; return;
    }
  case '|':
    if ((todo[2] == LEFT) || (todo[2] == RIGHT)) {
      todo[2] = UP;
      todo += ({ x, y, DOWN });
    }
    return;
  case '-':
    if ((todo[2] == UP) || (todo[2] == DOWN)) {
      todo[2] = LEFT;
      todo += ({ x, y, RIGHT });
    }
    return;
  }
}

int work(int x, int y, int dir) {
  filled = allocate(width * height) / width;
  todo = ({ x, y, dir });  
  while (sizeof(todo) > 0) step();
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

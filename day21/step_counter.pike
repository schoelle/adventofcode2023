array(string) map;
int width;
int height;
int startx;
int starty;

array(array(int)) dists;

int main(int argc, array(string) argv) {
  map = (Stdio.read_file(argv[1]) / "\n") - ({ "" });
  width = sizeof(map[0]);
  height = sizeof(map);
  foreach(map; int y; string line) {
    startx = search(line, 'S');
    if (startx > -1) {
      starty = y; break;
    }
  }
  dists = allocate(width * height, 10000000) / width;
  array(array(int)) todo = ({ ({ startx, starty, 0 }) });
  while (sizeof(todo) > 0) {
    array(int) first = todo[0];
    todo = todo[1..];
    int x = first[0];
    int y = first[1];
    int steps = first[2];
    if ((x < 0) || (y < 0) || (x >= width) || (y >= height))
      continue;
    if (map[y][x] == '#')
      continue;
    if (dists[y][x] <= steps)
      continue;
    dists[y][x] = steps;
    todo += ({ ({ x-1, y, steps+1 }),
	       ({ x, y-1, steps+1 }),
	       ({ x+1, y, steps+1 }),
	       ({ x, y+1, steps+1 }) });
  }
  int count = 0;
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      int d = dists[y][x];
      if ((d <= 64) && ((d % 2) == 0)) {
	count += 1;
      }
    }
  }
  write("%O\n", count);
}

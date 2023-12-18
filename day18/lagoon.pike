multiset(string) carved = (<>);
array(string) map;
int minx = 0;
int maxx = 0;
int miny = 0;
int maxy = 0;
int width;
int height;

mapping(string:array(int)) offsets = ([
  "U": ({ 0, -1 }),
  "D": ({ 0, 1 }),
  "L": ({ -1, 0 }),
  "R": ({ 1, 0 })
]);

void print_map() {
  write("%s\n", map * "\n");
}

void build_map() {
  width = (maxx-minx)+3;
  height = (maxy-miny)+3;
  map = allocate(height, "." * width);
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      if (carved[sprintf("%dx%d", x+minx-1, y+miny-1)]) {
	map[y][x] = '#';
      }
    }
  }
}

void fill_map() {
  array(array(int)) todo = ({ ({ 0, 0}) });
  while (sizeof(todo) > 0) {
    array(int) pos = todo[0];
    todo = todo[1..];
    if ((pos[0] < 0) || (pos[0] >= width) || (pos[1] < 0) || (pos[1] >= height) ||
	(map[pos[1]][pos[0]] != '.'))
      continue;
    map[pos[1]][pos[0]] = ',';
    todo += ({ ({ pos[0]-1, pos[1] }),
	       ({ pos[0]+1, pos[1] }),
	       ({ pos[0], pos[1]-1 }),
	       ({ pos[0], pos[1]+1 }) });
  }
  
}

int main(int argc, array(string) argv) {
  array(string) lines = (Stdio.read_file(argv[1]) / "\n") - ({""});
  carved = (< "1x1" >);
  int x = 0;
  int y = 0;
  foreach (lines;; string line) {
    sscanf(line, "%s %d (#%s)", string dir, int count, string color);
    for (int i=0; i < count; i++) {
      x += offsets[dir][0];
      y += offsets[dir][1];
      maxx = max(maxx, x);
      maxy = max(maxy, y);
      minx = min(minx, x);
      miny = min(miny, y);
      carved[sprintf("%dx%d", x, y)] = 1;
    }
  }
  build_map();
  fill_map();
  print_map();
  write("Problem 1: %d\n", String.count(replace(map * "", ".", "#"), "#"));
}

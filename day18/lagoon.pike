array(string) carved;
array(string) map;
int width;
int height;

array(int) xpos_map;
array(int) ypos_map;

mapping(string:array(int)) offsets = ([
  "U": ({ 0, -1 }),
  "D": ({ 0, 1 }),
  "L": ({ -1, 0 }),
  "R": ({ 1, 0 })
]);

void print_map() {
  write("%s\n", map * "\n");
}

int sign(int v) {
  if (v > 0) return 1;
  if (v < 0) return -1;
  return 0;
}

void build_map() {
  width = (sizeof(xpos_map) * 2) + 1;
  height = (sizeof(ypos_map) * 2) + 1;
  map = allocate(height, "." * width);
  int cx = find(ypos_map, 0);
  int cy = find(ypos_map, 0);
  foreach(carved;; string s) {
    sscanf(s, "%dx%d", int x, int y);
    x = find(xpos_map, x);
    y = find(ypos_map, y);
    while ((cx != x) || (cy != y)) {
      map[cy][cx] = '#'; 
      cx += sign(x-cx);
      cy += sign(y-cy);
    }
  }
}

int find(array(int) stack, int needle) {
  int i=0;
  while(stack[i] < needle) i++;
  if (stack[i] == needle) {
    return (i*2)+1;
  } else {
    return i*2;
  }
}

int block_size(array(int) stack, int needle) {
  if (needle % 2 == 1) {
    return 1;
  }
  return (stack[needle/2] - stack[(needle-2) / 2]) - 1;
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
  map = replace(map * "\n", ".", "#") / "\n";
}

int count_filled() {
  int sum = 0;
  for (int y=1; y < height-1; y++) {
    for (int x=1; x < width-1; x++) {
      if (map[y][x] == '#') {
	sum += block_size(xpos_map, x) * block_size(ypos_map, y);
      }
    }
  }
  return sum;
}

int measure_map(array(string) dirs, array(int) counts) {
  carved = ({ "0x0" });
  int x = 0;
  int y = 0;  
  foreach (dirs; int i; string dir) {
    int count = counts[i];
    xpos_map += ({ x });
    ypos_map += ({ y });
    x += offsets[dir][0] * count;
    y += offsets[dir][1] * count;
    carved += ({ sprintf("%dx%d", x, y) });
  }
  xpos_map = (array(int)) (multiset(int)) Array.sort_array(xpos_map);
  ypos_map = (array(int)) (multiset(int)) Array.sort_array(ypos_map);
  build_map();
  //fill_map();
  return count_filled();
}

int main(int argc, array(string) argv) {
  array(string) lines = (Stdio.read_file(argv[1]) / "\n") - ({""});
  array(string) dirs = ({ });
  array(int) counts = ({ });
  
  foreach (lines;; string line) {
    sscanf(line, "%s %d (#%s)", string dir, int count, string color);
    dirs += ({ dir });
    counts += ({ count });
  }
  write("Problem 1: %d\n", measure_map(dirs, counts));
  print_map();
  write("%O\n", ypos_map);
}

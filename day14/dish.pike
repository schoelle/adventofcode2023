array(string) map;
int width;
int height;

void shift_north() {
  int m = 1;
  while (m) {
    m = 0;
    for (int y = 0; y < height-1; y++) {
      for (int x = 0; x < width; x++) {
	if ((map[y][x] == '.') && (map[y+1][x] == 'O')) {
	  map[y][x] = 'O';
	  map[y+1][x] = '.';
	  m = 1;
	}
      }
    }
  }
}

void shift_west() {
  int m = 1;
  while (m) {
    m = 0;
    for (int x = 0; x < width-1; x++) {
      for (int y = 0; y < height; y++) {
	if ((map[y][x] == '.') && (map[y][x+1] == 'O')) {
	  map[y][x] = 'O';
	  map[y][x+1] = '.';
	  m = 1;
	}
      }
    }
  }
}

void shift_south() {
  int m = 1;
  while (m) {
    m = 0;
    for (int y = height-1; y > 0; y--) {
      for (int x = 0; x < width; x++) {
	if ((map[y][x] == '.') && (map[y-1][x] == 'O')) {
	  map[y-1][x] = '.';
	  map[y][x] = 'O';
	  m = 1;
	}
      }
    }
  }
}

void shift_east() {
  int m = 1;
  while (m) {
    m = 0;
    for (int x = width-1; x > 0; x--) {
      for (int y = 0; y < height; y++) {
	if ((map[y][x] == '.') && (map[y][x-1] == 'O')) {
	  map[y][x-1] = '.';
	  map[y][x] = 'O';
	  m = 1;
	}
      }
    }
  }
}

int cycle() {
  shift_north();
  shift_west();
  shift_south();
  shift_east();
}

int load() {
  int sum = 0;
  for (int y = 0; y < sizeof(map); y++) {
    sum += String.count(map[y], "O") * (sizeof(map)-y);
  }
  return sum;
}

void loop_cycle(int n) {
  int i = 0;
  mapping(string:int) c = ([]);
  while (!has_index(c, map * "\n")) {
    c[map * "\n"] = i;
    cycle();
    i += 1;
  }
  int j = c[map * "\n"];
  for (int v; v < (n-j) % (i-j); v++) {
    cycle();
  }
}


int main(int argc, array(string) argv) {
  array(string) lines = (Stdio.read_file(argv[1]) / "\n") - ({""});
  width = sizeof(lines[0]);
  height = sizeof(lines);
  map = ({ }) + lines;
  shift_north();
  write("Problem 1: %d\n", load());
  map = ({ }) + lines;
  loop_cycle(1000000000);
  write("Problem 2: %d\n", load());
}

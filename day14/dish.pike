array(string) map;

void shift_up() {
  for (int y = 0; y < sizeof(map)-1; y++) {
    for (int x = 0; x < sizeof(map[y]); x++) {
      if ((map[y][x] == '.') && (map[y+1][x] == 'O')) {
	map[y][x] = 'O';
	map[y+1][x] = '.';
      }
    }
  }
}

int load() {
  int sum = 0;
  for (int y = 0; y < sizeof(map); y++) {
    sum += String.count(map[y], "O") * (sizeof(map)-y);
  }
  return sum;
}


void print() {
  write("%s\n\n", map * "\n");
}


int main(int argc, array(string) argv) {
  map = (Stdio.read_file(argv[1]) / "\n") - ({""});
  int l = 0;
  int n;
  while ((n = load()) > l) {
    l = n;
    shift_up();
  }
  write("Problem 1: %d\n", load());
}

array(string) map;
array(int) row_map;
array(int) col_map;
int width;
int height;
array(array(int)) galaxies;

int is_empty_row(int row) {
  for (int i=0; i < width; i++) {
    if (map[row][i] == '#') {
      return 0;
    }
  }
  return 1;
}

int is_empty_col(int col) {
  for (int i=0; i < width; i++) {
    if (map[i][col] == '#') {
      return 0;
    }
  }
  return 1;
}

void build_row_map(int empty_value) {
  row_map = ({ });
  int c=0;
  for (int i=0; i < height; i++) {
    row_map += ({ c });
    if (is_empty_row(i)) {
      c += empty_value;
    } else {
      c += 1;
    }
  }
}

void build_col_map(int empty_value) {
  col_map = ({ });
  int c=0;
  for (int i=0; i < width; i++) {
    col_map += ({ c });
    if (is_empty_col(i)) {
      c += empty_value;
    } else {
      c += 1;
    }
  }
}

void find_galaxies() {
  galaxies = ({ });
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      if (map[y][x] == '#') {
	galaxies += ({ ({ col_map[x], row_map[y] }) });
      }
    }
  }
}

int distance(array(int) g1, array(int) g2) {
  return abs(g1[0]-g2[0])+abs(g1[1]-g2[1]);
}

int sum_distances() {
  int sum = 0;
  for (int first=0; first < sizeof(galaxies); first++) {
    for (int second=first+1; second < sizeof(galaxies); second++) {
      sum += distance(galaxies[first], galaxies[second]);
    }
  }
  return sum;
}

int main(int argc, array(string) argv) {
  map = (Stdio.read_file(argv[1]) / "\n") - ({""});
  width = sizeof(map[0]);
  height = sizeof(map);
  build_row_map(2);
  build_col_map(2);
  find_galaxies();
  write("Problem 1: %d\n", sum_distances());
  build_row_map(1000000);
  build_col_map(1000000);
  find_galaxies();  
  write("Problem 2: %d\n", sum_distances()); 
}

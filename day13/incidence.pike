string get_row(array(string) v, int y) {
  return v[y];
}

string get_col(array(string) v, int x) {
  return (string) map(v, lambda (string s) { return s[x]; });
}

int mirror_value(array(string) box) {
  int width = sizeof(box[0]);
  int height = sizeof(box);
  int sum = 0;
  for (int y=0; y < height-1; y++) {
    int c;
    int rows_to_check = min(y+1, height-y-1);
    for (c=0; c < rows_to_check; c++) {
      if (get_row(box, y-c) != get_row(box, y+1+c)) {
	break;	
      }
    }
    if (c == rows_to_check) {
      sum += 100 * (y+1);
    }
  }
  for (int x=0; x < width-1; x++) {
    int c;
    int cols_to_check = min(x+1, width-x-1);
    for (c=0; c < cols_to_check; c++) {
      if (get_col(box, x-c) != get_col(box, x+1+c)) {
	break;	
      }
    }
    if (c == cols_to_check) {
      sum += x+1;
    }
  }  
  return sum;
}


int main(int argc, array(string) argv) {
  array(string) parts = Stdio.read_file(argv[1]) / "\n\n";
  int sum = 0;
  foreach(parts;; string part) {
    array(string) box = (part / "\n") - ({ "" });
    sum += mirror_value(box);
  }
  write("Problem 1: %d\n", sum);
}

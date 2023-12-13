string get_row(array(string) v, int y) {
  return v[y];
}

string get_col(array(string) v, int x) {
  return (string) map(v, lambda (string s) { return s[x]; });
}

int error_count(string a, string b) {
  return String.levenshtein_distance(a, b);
}

int mirror_value(string part, int smudges) {
  array(string) box = (part / "\n") - ({ "" });
  int width = sizeof(box[0]);
  int height = sizeof(box);
  int sum = 0;
  for (int y=0; y < height-1; y++) {
    int errors = 0;
    for (int c=0; c < min(y+1, height-y-1); c++) {
      errors += error_count(get_row(box, y-c), get_row(box, y+1+c));
    }
    if (errors == smudges) sum += 100 * (y+1);
  }  
  for (int x=0; x < width-1; x++) {
    int errors = 0;
    for (int c=0; c < min(x+1, width-x-1); c++) {
      errors += error_count(get_col(box, x-c), get_col(box, x+1+c));
    }
    if (errors == smudges) sum += x+1;
  }
  return sum;
}


int main(int argc, array(string) argv) {
  array(string) parts = Stdio.read_file(argv[1]) / "\n\n";
  write("Problem 1: %d\n", Array.reduce(`+, map(parts, mirror_value, 0)));
  write("Problem 2: %d\n", Array.reduce(`+, map(parts, mirror_value, 1)));
}

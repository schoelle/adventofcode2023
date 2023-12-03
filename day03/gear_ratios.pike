class Pos {
  int x;
  int y;

  void create(int x, int y) {
    this->x = x;
    this->y = y;
  }
  
  int adjacent(Pos other) {
    return (abs(x-other->x) <= 1) && (abs(y-other->y) <= 1);
  }
}

array(Pos) get_symbols(array(string) lines) {
  array(Pos) res = ({ });
  foreach(lines; int line_nr; string line) {
    for (int i = 0; i < sizeof(line); i++) {
      int c = line[i];
      if (((c < '0') || (c > '9')) && (c != '.')) {
	res += ({ Pos(i, line_nr) });
      }
    }
  }
  return res;
}

int main(int argc, array(string) argv) {
  array(string) lines = (Stdio.read_file(argv[1]) / "\n") - ({});
  array(Pos) symbols = get_symbols(lines);
  int sum = 0;
  foreach(lines; int line_nr; string line) {
    line += ".";
    for (int i = 0; i < sizeof(line); i++) {
      int c = line[i];
      if ((c >= '0') && (c <= '9')) {
	int j = i;
	int has_symbol = 0;
	c = line[j];
	while ((c >= '0') && (c <= '9')) {
	  has_symbol |= Array.any(symbols, lambda(Pos p) {
	    return p->adjacent(Pos(j, line_nr));
	  });
	  j++;
	  c = line[j];
	}
	if (has_symbol) {
	  sum += (int) line[i..j-1];
	}
	write("%O %d\n", line[i..j-1], has_symbol);
	i = j;
      }
    }
  }
  write("Problem 1: %d\n", sum);
}

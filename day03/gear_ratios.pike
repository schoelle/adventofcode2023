class Item {
  string value;
  int x;
  int y;

  void create(string value, int x, int y) {
    this->value = value;
    this->x = x;
    this->y = y;
  }
  
  int adjacent(Item other) {
    return (abs(this->y - other->y) <= 1) &&
      ((this->x+sizeof(this->value)) >= other->x) &&
      ((other->x+sizeof(other->value)) >= this->x);
  }
}

array(Item) find_items(array(string) lines, function detect) {
  array(Item) res = ({ });
  foreach(lines; int line_nr; string line) {
    for (int i = 0; i < sizeof(line); i++) {
      if (detect(line[i])) {
	int j = i;
	while (j < sizeof(line) && detect(line[j])) j++;
	res += ({ Item(line[i..j-1], i, line_nr) });
	i = j;
      }
    }
  }
  return res;
}

int main(int argc, array(string) argv) {
  array(string) lines = (Stdio.read_file(argv[1]) / "\n") - ({""});
  array(Item) symbols = find_items(lines, lambda(int c) {
    return (((c < '0') || (c > '9')) && (c != '.'));
  });
  array(Item) numbers = find_items(lines, lambda(int c) {
    return ((c >= '0') && (c <= '9'));
  });
  int sum = 0;
  foreach (numbers;; Item n) {
    if (Array.any(symbols, lambda (Item s) { return s->adjacent(n); })) {
      sum += (int) n->value;
    }
  }
  write("Problem 1: %d\n", sum);
  array(Item) stars = filter(symbols, lambda (Item s) {
    return s->value == "*";
  });
  sum = 0;
  foreach (stars;; Item star) {
    array(Item) n = filter(numbers, lambda(Item n) {
      return n->adjacent(star);
    });
    if (sizeof(n) == 2) {
      sum += ((int) n[0]->value) * ((int) n[1]->value);
    }
  }
  write("Problem 2: %d\n", sum);
}

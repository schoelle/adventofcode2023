class Card {
  int id; array(int) win_nbrs; array(int) have_nbrs;

  void create(string line) {
    sscanf(line, "Card %d: %s | %s", id, string win_str, string have_str);
    win_nbrs = map((win_str / " ") - ({""}), lambda(string v) { return (int) v; });
    have_nbrs = map((have_str / " ") - ({""}), lambda(string v) { return (int) v; });
  }

  int matches() {
    return sizeof(win_nbrs & have_nbrs);
  }
}


int main(int argc, array(string) argv) {
  array(Card) cards = map((Stdio.read_file(argv[1]) / "\n") - ({""}), Card);
  write("Problem 1: %d\n", Array.reduce(`+, map(cards, lambda(Card c) {
    int p = c->matches();
    if (p == 0) { return 0; }
    return 1 << (p-1);
  })));
  int n = sizeof(cards);
  array(int) count = ({ 1 }) * n;
  for (int i=0; i < n; i++) {
    int m = cards[i]->matches();
    for (int j=0; j < m; j++) {
      count[i+j+1] += count[i];
    }
  }
  write("Problem 2: %d\n", Array.reduce(`+, count));
}

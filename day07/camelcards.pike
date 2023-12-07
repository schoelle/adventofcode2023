int problem2 = 0; // Change sorting behaviour for problem 2
 
class Card {
  string hand; int value;
  void create(string line) { sscanf(line, "%s %d", hand, value); }
}

string occurrence_profile(Card c) {
  mapping(int:int) occurrences = ([]);
  int extra = 0;
  foreach (c->hand;; int v) {
    if (problem2 && (v == 'J')) {
      extra += 1;
    } else if (has_index(occurrences, v)) {
      occurrences[v] += 1;
    } else {
      occurrences[v] = 1;
    }
  }
  if (extra == 5) { return "5"; }
  array(int) counts = reverse(sort(values(occurrences)));
  counts[0] += extra;
  return map(counts, lambda (int i) { return ""+i; }) * "";
}

string value_profile(Card c) {
  string v = c->hand;
  v = (v / "T") * "C";
  v = (v / "J") * (problem2 ? "0" : "D");
  v = (v / "Q") * "E";
  v = (v / "K") * "F";
  v = (v / "A") * "G";
  return v;
}

int sort_func(Card a, Card b) {
  string opa = occurrence_profile(a);
  string opb = occurrence_profile(b);
  if (opa > opb) return 1;
  if (opa < opb) return 0;
  return value_profile(a) > value_profile(b);
}

int value_of(array(Card) cards) {
  int sum = 0;
  foreach (cards; int i; Card card) {
    sum += (i+1) * card->value;
  }
  return sum;
}

int main(int argc, array(string) argv) {
  array(Card) cards = map((Stdio.read_file(argv[1]) / "\n") - ({""}), Card);
  write("Problem 1: %d\n", value_of(Array.sort_array(cards, sort_func)));
  problem2 = 1;
  write("Problem 2: %d\n", value_of(Array.sort_array(cards, sort_func)));
}

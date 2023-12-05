class Seed {
  int start; int count;
  void create(int start, int count) {
    this->start = start;
    this->count = count;
  }
}

class Rule {
  int target; int start; int count;
  void create(int target, int start, int count) {
    this->target = target;
    this->start = start;
    this->count = count;
  }
  
  array(array(Seed)) apply(Seed s) {
    array(Seed) keep = ({});
    array(Seed) move = ({});
    if (s->start < this->start) {
      keep += ({ Seed(s->start, min(s->count, this->start - s->start)) });
    }
    if (s->start + s->count > this->start + this->count) {
      keep += ({ Seed(max(s->start, this->start + this->count),
		      min(s->count,
			  s->start + s->count - this->start - this->count)) });
    }
    if ((s->start + s->count > this->start) &&
	(s->start < this->start + this->count)) {
      move += ({ Seed(max(s->start,this->start) + this->target - this->start,
		      min(s->count - (max(s->start,this->start) - s->start),
			  this->start + this->count - s->start )) });
    }
    return ({ keep, move });
  }    
}

int compute_location(array(array(Rule)) rules, array(Seed) seeds) {
  foreach (rules;; array(Rule) group) {
    array(Seed) moved = ({});
    array(Seed) remainders;
    foreach (group;; Rule rule) {
      remainders = ({});
      foreach (seeds;; Seed seed) {
	array(array(Seed)) res = rule->apply(seed);
	remainders += res[0];
	moved += res[1];
      }
      seeds = remainders;
    }
    seeds = moved + remainders;
  }
  return Array.reduce(min, map(seeds, lambda(Seed s) { return s->start; }));
}

int main(int argc, array(string) argv) {
  array(string) lines = (Stdio.read_file(argv[1]) / "\n");
  sscanf(lines[0], "seeds: %s", string seed_line);
  array(int) numbers = map(seed_line / " ", lambda(string s) { return (int) s; });
  int row = 3;
  array(array(Rule)) rules = ({});
  while (row < sizeof(lines)) {
    array(Rule) group = ({});
    while (row < sizeof(lines) && lines[row] != "") {
      array(string) parts = lines[row] / " ";
      group += ({ Rule((int) parts[0], (int) parts[1], (int) parts[2]) });
      row += 1;
    }
    rules += ({ group });
    row += 2;
  }
  
  array(Seed) seeds1 = ({});
  array(Seed) seeds2 = ({});
  for (int i = 0; i < sizeof(numbers); i = i + 2) {
    seeds1 += ({ Seed(numbers[i], 1), Seed(numbers[i+1], 1) });
    seeds2 += ({ Seed(numbers[i], numbers[i+1]) });
  }

  write("Problem 1: %d\n", compute_location(rules, seeds1));
  write("Problem 2: %d\n", compute_location(rules, seeds2));
}

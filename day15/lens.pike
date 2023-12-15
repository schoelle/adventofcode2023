int hash(string s) {
  int v = 0;
  foreach(s;;int c) {
    v += c;
    v = (v*17) % 256;
  }
  return v;
}

class Lens {
  string label;
  int power;
  void create(string label, int power) { this->label = label; this->power = power; }
  string _sprintf(int conversion_type, mapping(string:int)|void params) {
    return sprintf("[%s %d]", label, power);
  }
}

array(array(Lens)) state = ({ ({ }) }) * 256;

void execute(string step) {
  if (step[-1] == '-') {
    sscanf(step, "%s-", string label);
    int h = hash(label);
    state[h] = filter(state[h], lambda (Lens s) { return s->label != label; });
  } else {
    sscanf(step, "%s=%d", string label, int power);
    int h = hash(label);
    array(Lens) s = state[h];
    int i = 0;
    while (i < sizeof(s) && (s[i]->label != label)) i++;
    if (i == sizeof(s)) {
      state[h] = s + ({ Lens(label, power) });
    } else {
      state[h][i] = Lens(label, power);
    }
  }
}

int total_focus() {
  int sum = 0;
  foreach(state; int i; array(Lens) ls) {
    foreach(ls; int j; Lens l) {
      sum += (i+1) * (j+1) * l->power;
    }
  }
  return sum;
}


int main(int argc, array(string) argv) {
  array(string) steps = (((Stdio.read_file(argv[1]) / "\n") - ({""})) * "") / ",";
  write("Problem 1: %d\n", Array.reduce(`+, map(steps, hash)));
  foreach (steps;; string step) { execute(step); }
  write("Problem 2: %d\n", total_focus());
}

mapping(string:mapping(int:string)) rules = ([]);
string steps;

int count_steps(string pos, multiset(string) to) {
  int count = 0;
  while (!to[pos]) {
    pos = rules[pos][steps[count % sizeof(steps)]];
    count += 1;
  }
  return count;
}

int lcm(array(int) v) {
  int res = 1;
  foreach (v, int i) {
    res = (res * i) / res->gcd(i);
  }
  return res;
}

int main(int argc, array(string) argv) {
  array(string) lines = (Stdio.read_file(argv[1]) / "\n") - ({""});
  steps = lines[0];
  for(int i = 1; i < sizeof(lines); i++) {
    sscanf(lines[i], "%s = (%s, %s)", string from, string left, string right);
    rules[from] = ([ 'L': left, 'R': right ]);
  }
  array(string) starts = filter(indices(rules), lambda (string s) {
    return s[-1] == 'A';
  });
  multiset(string) ends = (multiset(string)) filter(indices(rules), lambda (string s) {
    return s[-1] == 'Z';
  });
  write("Problem 1: %d\n", count_steps("AAA", (< "ZZZ" >)));
  write("Problem 2: %d\n", lcm(map(starts, count_steps, ends)));
}

array(int) profile(string s) {
  array(int) res = ({ });
  int count = 0;
  foreach (s;; int c) {
    if (c == '#') {
      count += 1;
    } else if (c == '.') {
      if (count > 0) res += ({ count });
      count = 0;
    } else {
      return res;
    }
  }
  if (count > 0) res += ({ count });
  return res;
}

int combinations(string pattern, array(int) check) {
  int qm = search(pattern, '?');
  array(int) p = profile(pattern);
  if (qm == -1) {
    return equal(p, check);
  } else {
    if (equal(p, check[..sizeof(p)-1])) {
      pattern[qm] = '#';
      int v1 = combinations(pattern, check);
      pattern[qm] = '.';
      int v2 = combinations(pattern, check);
      return v1 + v2;	
    } else {
      return 0;
    }
  }
}

int main(int argc, array(string) argv) {
  array(string) lines = (Stdio.read_file(argv[1]) / "\n") - ({""});
  int sum = 0;
  foreach (lines;; string line) {
    sscanf(line, "%s %s", string pattern, string check_str);
    array(int) check = map(check_str / ",", lambda (string s) { return (int) s; });
    sum += combinations(pattern, check);
  }
  write("Problem 1: %d\n", sum);
}

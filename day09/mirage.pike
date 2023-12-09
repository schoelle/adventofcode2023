int calc1(array(int) coeffs, int n) {
  array(int) c = ({}) + coeffs; // Copy
  for (int i = 0; i < n; i++) {
    for (int j = 0; j < sizeof(coeffs)-1; j++) {
      c[j] += c[j+1];
    }
  }
  return c[0];
}


int calc2(array(int) coeffs) {
  int sum = 0;
  for (int i=sizeof(coeffs); i > 0; i--) {
    sum = coeffs[i-1] - sum;
  }
  return sum;
}


array(int) diff_seq(array(int) seq) {
  int v = seq[0];
  array(int) res = ({});
  for (int i = 1; i < sizeof(seq); i++) {
    res += ({ seq[i] - v });
    v = seq[i];
  }
  return res;
}


array(int) derive(array(int) input) {
  if (Array.reduce(max, input) == Array.reduce(min, input)) {
    return ({ input[0] });
  }
  return ({ input[0] }) + derive(diff_seq(input));
}

int main(int argc, array(string) argv) {
  array(string) lines = (Stdio.read_file(argv[1]) / "\n") - ({""});
  array(array(int)) seqs = map(lines, lambda (string line) {
    return map(line / " ", lambda(string s) { return (int) s; });
  });
  int sum1 = 0;
  int sum2 = 0;
  foreach(seqs;; array(int) seq) {
    array(int) coeffs = derive(seq);
    sum1 += calc1(coeffs, sizeof(seq));
    sum2 += calc2(coeffs);
  }
  write("Problem 1: %d\n", sum1);
  write("Problem 2: %d\n", sum2);
}

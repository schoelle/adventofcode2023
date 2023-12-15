int hash(string s) {
  int v = 0;
  foreach(s;;int c) {
    v += c;
    v = (v*17) % 256;
  }
  return v;
}

int main(int argc, array(string) argv) {
  string line = ((Stdio.read_file(argv[1]) / "\n") - ({""})) * "";
  write("Problem 1: %d\n", Array.reduce(`+, map(line / ",", hash)));
}

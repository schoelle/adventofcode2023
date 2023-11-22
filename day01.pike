// Only a test of the setup

int main(int argc, array(string) argv) {
  array(string) lines = (Stdio.read_file(argv[1]) / "\n") - ({""});
  array(int) values = map(lines, lambda(string x) { return (int)x;});
  write("Problem 1: %d\n", sizeof(values));
  write("Problem 2: %d\n", Array.sum(values));	
}

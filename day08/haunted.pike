int main(int argc, array(string) argv) {
  array(string) lines = (Stdio.read_file(argv[1]) / "\n") - ({""});
  mapping(string:string) left_rules = ([]);
  mapping(string:string) right_rules = ([]);
  string rules = lines[0];
  for(int i = 1; i < sizeof(lines); i++) {
    sscanf(lines[i], "%s = (%s, %s)", string from, string left, string right);
    left_rules[from] = left;
    right_rules[from] = right;    
  }
  string pos = "AAA";
  int count = 0;
  while (pos != "ZZZ") {
    if (rules[count % sizeof(rules)] == 'L') {
      pos = left_rules[pos];
    } else {
      pos = right_rules[pos];
    }
    count += 1;
  }
  write("Problem 1: %d\n", count);  
  
}

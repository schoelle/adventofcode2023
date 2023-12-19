class Rule {
  string name;
  array(int) measures;
  array(int) ops;
  array(int) values;
  array(string) targets;
  string otherwise;
  void create(string line) {
    sscanf(line, "%s{%s}", name, string patterns_str);
    array(string) patterns = patterns_str / ",";
    otherwise = patterns[-1];
    foreach(patterns[..sizeof(patterns)-2];; string p) {
      sscanf(p, "%c%c%d:%s", int m, int o, int v, string t);
      measures += ({ m });
      ops += ({ o });
      values += ({ v });
      targets += ({ t });
    }
  }

  string apply(mapping(int:int) item) {
    for(int i=0; i < sizeof(measures); i++) {
      if (ops[i] == '<') {
	if (item[measures[i]] < values[i])return targets[i];
      } else {
	if (item[measures[i]] > values[i]) return targets[i];
      }
    }
    return otherwise;
  }
}

mapping(string:Rule) rules = ([]);

mapping(int:int) parse_item(string line) {
  mapping(int:int) item = ([]);
  sscanf(line, "{%s}", string p);
  foreach(p / ",";; string i) {
    sscanf(i, "%c=%d", int m, int v);
    item[m] = v;
  }
  return item;
}

int main(int argc, array(string) argv) {
  array(string) parts = Stdio.read_file(argv[1]) / "\n\n";
  foreach(map(parts[0] / "\n", Rule);; Rule r) {
    rules[r->name] = r;
  }
  int sum = 0;
  foreach((parts[1] / "\n") - ({""});; string p) {
    string state = "in";
    mapping(int:int) item = parse_item(p);
    while ((state != "A") && (state != "R")) {
      state = rules[state]->apply(item);
    }
    if (state == "A") {
      sum += Array.sum(values(item));
    }
  }
  write("Problem 1: %d\n", sum);
}

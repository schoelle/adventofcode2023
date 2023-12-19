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

  int size_accepted(mapping(int:array(int)) part) {
    if (part_size(part) == 0) {
      return 0;
    }
    int sum = 0;
    for(int i=0; i < sizeof(measures); i++) {
      int m = measures[i];
      int v = values[i];
      string t = targets[i];
      mapping(int:array(int)) split = copy_value(part);
      if (ops[i] == '<') {
	split[m][1] = min(split[m][1], v-1);
	part[m][0] = max(part[m][0], v);
      } else {
	split[m][0] = max(split[m][0], v+1);
	part[m][1] = min(part[m][1], v);
      }
      if (t == "A") {
	sum += part_size(split);
      } else if (t != "R") {
	sum += rules[t]->size_accepted(split);
      }
    }
    if (otherwise == "A") {
      return sum + part_size(part);
    }
    if (otherwise == "R") {
      return sum;
    }
    return sum + rules[otherwise]->size_accepted(part);
  }
  
}

int part_size(mapping(int:array(int)) part)  {
  return
    max(part['x'][1] - part['x'][0] + 1, 0) *
    max(part['m'][1] - part['m'][0] + 1, 0) *
    max(part['a'][1] - part['a'][0] + 1, 0) *
    max(part['s'][1] - part['s'][0] + 1, 0);
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
  write("Problem 2: %d\n", rules["in"]->size_accepted(([ 'x': ({ 1, 4000 }),
							 'm': ({ 1, 4000 }),
							 's': ({ 1, 4000 }),
							 'a': ({ 1, 4000 }) ])));
}

mapping(string:int) cache = ([]);

string cache_id(string pattern, array(int) check) {
  return pattern + "-" + (map(check, lambda(int c) { return ""+c; }) * ",");
}

int cache_value(string id, int value) {
  cache[id] = value;
  return value;
}

int combinations(string pattern, array(int) check) {
  int p = 0;
  while ((p < sizeof(pattern)) && (pattern[p] == '.')) p++;
  pattern = pattern[p..];

  string id = cache_id(pattern, check);
  if (has_index(cache, id)) {
    return cache[id];
  }
  if (sizeof(check) == 0) {
    return cache_value(id, search(pattern, '#') == -1);
  }
  if (sizeof(pattern) < (Array.reduce(`+, check) + sizeof(check) - 1)) {
    return cache_value(id, 0);
  }
  if (pattern[0] == '#') {
    int i;
    for (i = 0; i < check[0]; i++) {
      if ((i >= sizeof(pattern)) || (pattern[i] == '.')) {
	return cache_value(id, 0);
      }
    }
    if ((i < sizeof(pattern)) && (pattern[i] == '#')) {
      return cache_value(id, 0);
    }
    return cache_value(id, combinations(pattern[i+1..], check[1..]));
  }
  int res = combinations(pattern[1..], check);
  pattern[0] = '#';
  res += combinations(pattern, check);
  return cache_value(id, res);  
}

int main(int argc, array(string) argv) {
  array(string) lines = (Stdio.read_file(argv[1]) / "\n") - ({""});
  int sum1 = 0;
  int sum2 = 0;
  foreach (lines;; string line) {
    sscanf(line, "%s %s", string pattern, string check_str);
    array(int) check = map(check_str / ",", lambda (string s) { return (int) s; });
    cache = ([]);
    sum1 += combinations(pattern, check);
    sum2 += combinations((({ pattern }) * 5) * "?", check * 5);    
  }
  write("Problem 1: %d\n", sum1);
  write("Problem 2: %d\n", sum2);
}

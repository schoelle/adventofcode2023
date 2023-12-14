mapping(string:int) cache = ([]);

string cache_id(string pattern, array(int) check) {
  return pattern + "-" + (map(check, lambda(int c) { return ""+c; }) * ",");
}

int cache_value(string id, int value) {
  cache[id] = value;
  return value;
}

int combinations(string pattern, array(int) check) {
  // We are doing dynamic programming, so we have to come up with a sub-problem
  // that will be used by many paths. Here, we assume that a shorter pattern is
  // less than a longer pattern, and if patterns are the same length then less
  // ? are less than more ? ...
  
  int p = 0;
  // We remove initial '.' because they don't contribute to combinations
  while ((p < sizeof(pattern)) && (pattern[p] == '.')) p++;
  pattern = pattern[p..];

  // Memoization cache lookup
  string id = cache_id(pattern, check);
  if (has_index(cache, id)) {
    return cache[id];
  }

  // Corner case: checks is empty, so there must not be any '#' in the remaining pattern
  if (sizeof(check) == 0) {
    return cache_value(id, search(pattern, '#') == -1);
  }
  // Corner case: pattern is smaller than minimal space required for remaining check,
  // so this is not valid and contributes 0 valid combinations
  if (sizeof(pattern) < (Array.reduce(`+, check) + sizeof(check) - 1)) {
    return cache_value(id, 0);
  }
  // Pattern strating with '#', so we have to match the first check and then
  // remove it. Matching means matching n '?' or '#' and then one '.' or '?'.
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
  // As we removed all '.' and the first character is no '#', we must have a
  // '?' first. So, we compute the combinations assuming it is a '.' (which we
  // can skip) ...
  int res = combinations(pattern[1..], check);
  // ... and add all combinations assuming it was a '#'.
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

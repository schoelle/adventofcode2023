constant WORDS = ({ "one", "two", "three", "four", "five", "six", "seven", "eight", "nine" });

array(string) get_digits(string word, mapping(string:string) map) {
  array(string) res = ({});
  for (int i; i < sizeof(word); i++) {
    foreach (indices(map), string key) {
      if (word[i..i+sizeof(key)-1] == key) {
	res += ({ map[key] });
      }
    }
  }
  return res;
}

int main(int argc, array(string) argv) {
  array(string) lines = (Stdio.read_file(argv[1]) / "\n") - ({""});
  mapping(string:string) map = ([]);
  for (int i = 0; i < 10; i++) {
    map[(string) i] = (string) i;
  }
  int sum = 0;
  foreach (lines, string line) {
    array(string) digits = get_digits(line, map);
    sum += (int) (digits[0] + digits[-1]);
  }
  write("Problem 1: %d\n", sum);
  for (int i = 0; i < 9; i++) {
    map[WORDS[i]] = (string) (i+1);
  }
  sum = 0;
  foreach (lines, string line) {
    array(string) digits = get_digits(line, map);
    sum += (int) (digits[0] + digits[-1]);
  }
  write("Problem 2: %d\n", sum);
}

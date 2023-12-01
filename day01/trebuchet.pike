constant WORDS = ({ "one", "two", "three", "four", "five", "six", "seven", "eight", "nine" });

mapping(string:string) table = ([]);

int value_of(string word) {
  array(string) res = ({});
  for (int i; i < sizeof(word); i++) {
    foreach (table; string key; string value) {
      if (word[i..i+sizeof(key)-1] == key) {
	res += ({ value });
      }
    }
  }
  return (int) (res[0] + res[-1]);
}

int main(int argc, array(string) argv) {
  array(string) lines = (Stdio.read_file(argv[1]) / "\n") - ({""});
  for (int i = 0; i < 10; i++) {
    table[(string) i] = (string) i;
  }
  write("Problem 1: %d\n", Array.reduce(`+, map(lines, value_of)));
  for (int i = 0; i < 9; i++) {
    table[WORDS[i]] = (string) (i+1);
  }
  write("Problem 2: %d\n", Array.reduce(`+, map(lines, value_of)));
}

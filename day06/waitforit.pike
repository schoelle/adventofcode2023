int wait_times(float time, float distance) {
  int lower = (int) floor(0.5 * (time - sqrt(time * time - 4 * distance))) + 1;
  int upper = (int) ceil(0.5 * (time + sqrt(time * time - 4 * distance))) - 1;
  return upper - lower + 1;
}

int main(int argc, array(string) argv) {
  array(string) lines = (Stdio.read_file(argv[1]) / "\n") - ({""});
  
  sscanf(lines[0], "Time: %s", string time_str);
  array(float) times = map((time_str / " ") - ({""}), lambda(string s) { return (float) s; });
  sscanf(lines[1], "Distance: %s", string distance_str);
  array(float) distances = map((distance_str / " ") - ({""}), lambda(string s) { return (float) s; });

  int p1 = 1;
  for (int i = 0; i < sizeof(distances); i++ ) {
    p1 *= wait_times(times[i], distances[i]);
  }
  write("Problem 1: %O\n", p1);

  float long_time = (float) (((time_str / " ") - ({""})) * "");
  float long_distance = (float) (((distance_str / " ") - ({""})) * "");
  write("Problem 2: %d\n", wait_times(long_time, long_distance));
}

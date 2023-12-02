

class Game {
  int number;
  array(mapping(string:int)) draws = ({});

  void create(string line) {
    string draws_string;
    sscanf(line, "Game %d: %s", this->number, draws_string);
    foreach (draws_string / "; ";; string draws) {
      mapping(string:int) draw_mapping = ([
	"red": 0,
	"green": 0,
	"blue": 0
      ]);
      foreach (draws / ", ";; string draw) {
	string color;
	int count;
	sscanf(draw, "%d %s", count, color);
	draw_mapping[color] = count;
      }
      this->draws += ({ draw_mapping });
    }
  }

  int is_valid() {
    foreach(draws;; mapping(string:int) draw) {
      if ((draw["red"] > 12) || (draw["green"] > 13) || (draw["blue"] > 14)) {
	return 0;
      }
    }
    return 1;
  }

  int power() {
    mapping(string:int) minimum = ([
      "red": 0,
      "green": 0,
      "blue": 0
    ]);
    foreach(draws;; mapping(string:int) draw) {
      foreach(draw; string color; int count) {
	if (count > minimum[color]) {
	  minimum[color] = count;
	}
      }
    }
    return Array.reduce(`*, values(minimum) - ({ 0 }));
  }
}

int main(int argc, array(string) argv) {
  array(string) lines = (Stdio.read_file(argv[1]) / "\n") - ({""});
  int sum = 0;
  int power_sum = 0;
  foreach(lines;; string line) {
    Game game = Game(line);
    if (game->is_valid()) {
      sum += game->number;
    }
    write("%d %O\n", game->number, game->power());
    power_sum += game->power();
  }
  write("Problem 1: %d\n", sum);
  write("Problem 2: %d\n", power_sum);
}

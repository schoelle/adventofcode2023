class Game {
  int number;
  array(mapping(string:int)) draws = ({});

  void create(string line) {
    string draws_string;
    sscanf(line, "Game %d: %s", this->number, draws_string);
    foreach (draws_string / "; ";; string draws) {
      mapping(string:int) draw_mapping = (["red": 0, "green": 0, "blue": 0]);
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
    return Array.all(draws, lambda(mapping(string:int) draw) {
      return (draw["red"] <= 12) && (draw["green"] <= 13) && (draw["blue"] <= 14);
    });
  }

  int power() {
    mapping(string:int) minimum = (["red": 0, "green": 0, "blue": 0]);
    foreach(draws;; mapping(string:int) draw) {
      foreach(draw; string color; int count) {
	if (count > minimum[color]) {
	  minimum[color] = count;
	}
      }
    }
    return Array.reduce(`*, values(minimum));
  }
}

int main(int argc, array(string) argv) {
  array(Game) games = map((Stdio.read_file(argv[1]) / "\n") - ({""}), Game);
  array(Game) valid_games = filter(games, lambda(Game g) { return g->is_valid(); });

  write("Problem 1: %d\n", Array.reduce(`+, map(valid_games, lambda(Game g) { return g->number; })));
  write("Problem 2: %d\n", Array.reduce(`+, map(games, lambda(Game g) { return g->power(); })));
}

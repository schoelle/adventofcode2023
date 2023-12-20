class Broadcaster {
  array(string) outputs;
  void create(array(string) outputs) {
    this->outputs = outputs;
  }
  void process(string from, string pulse) {
    foreach(outputs;; string output) {
      todo += ({ ({ "broadcaster", output, pulse }) });
    }
  }
}

class FlipFlop {
  array(string) outputs;
  string name;
  int is_on = 0;
  void create(string name, array(string) outputs) {
    this->outputs = outputs;
    this->name = name;
  }
  void process(string from, string pulse) {
    if (pulse == "L") {
      is_on = !is_on;
      foreach(outputs;; string output) {
	todo += ({ ({ name, output, is_on ? "H" : "L" }) });
      }
    }
  }
}

class Conjunction {
  array(string) outputs;
  mapping(string:string) inputs = ([ ]);
  string name;
  void create(string name, array(string) outputs) {
    this->outputs = outputs;
    this->name = name;
  }
  void add_input(string input) {
    this->inputs[input] = "L";
  }
  void process(string from, string pulse) {
    inputs[from] = pulse;
    string p = (Array.all(values(inputs), lambda (string s) { return s == "H"; })) ?
      "L" : "H";
    foreach(outputs;; string output) {
      todo += ({ ({ name, output, p }) });
    }
  }
}

mapping(string:mixed) modules = ([ ]);
array(array(string)) todo;
mapping(string:int) count = ([ "L": 0, "H": 0 ]);
int presses = 0;

void press_button() {
  todo = ({ ({ "button", "broadcaster", "L" }) });
  while (sizeof(todo) > 0) {
    array(string) first = todo[0];
    todo = todo[1..];
    string from = first[0];
    string to = first[1];
    string pulse = first[2];
    count[pulse] += 1;
    if (modules[to])
      modules[to]->process(from, pulse);
  }
}

int main(int argc, array(string) argv) {
  array(string) lines = (Stdio.read_file(argv[1]) / "\n") - ({ "" });
  foreach(lines;; string line) {
    sscanf(line, "%s -> %s", string name, string output_str);
    array(string) outputs = output_str / ", ";
    if (name == "broadcaster") {
      modules[name] = Broadcaster(outputs);
    } else if (name[0] == '%') {
      modules[name[1..]] = FlipFlop(name[1..], outputs);
    } else if (name[0] == '&') {
      modules[name[1..]] = Conjunction(name[1..], outputs);
    }
  }
  foreach(modules; string k; mixed m) {
    foreach(m->outputs;; string s) {
      object o = modules[s];
      if (object_program(o) == Conjunction) {
	o->add_input(k);
      }
    }
  }
  for(int i = 0; i < 1000; i++) 
    press_button();
  write("Problem 1: %d\n", count["L"] * count["H"]);  
}

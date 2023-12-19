constant VERY_LARGE_NUMBER = 10000000000;
constant UP=0;
constant RIGHT=1;
constant DOWN=2;
constant LEFT=3;

array(string) costmap;
mapping(string:int) distmap;
multiset(string) done;
int width;
int height;
function exits;
array(string) todo;


array(array(int)) dirs = ({ ({ 0, -1 }), ({ 1, 0 }), ({ 0, 1 }), ({ -1, 0 }) });

string key(int x, int y, int dir, int left) {
  return sprintf("%d,%d:%d:%d", x, y, dir, left);
}

array(string) exits1(string l) {
  sscanf(l, "%d,%d:%d:%d", int x, int y, int dir, int left);
  array(string) res = ({ });
  foreach(({ (dir+1) % 4, (dir+3) % 4 });; int dn) {
    int xn = x+dirs[dn][0];
    int yn = y+dirs[dn][1];
    if ((xn >= 0) && (yn >= 0) && (xn < width) && (yn < height)) {
      res += ({ key(xn, yn, dn, 2) });
    }
  }
  if (left > 0) {
    int xn = x+dirs[dir][0];
    int yn = y+dirs[dir][1];
    if ((xn >= 0) && (yn >= 0) && (xn < width) && (yn < height)) {
      res += ({ key(xn, yn, dir, left-1) });
    }
  }
  return res;
}

array(string) exits2(string l) {
  sscanf(l, "%d,%d:%d:%d", int x, int y, int dir, int left);
  array(string) res = ({ });
  if (left < 7) {
    foreach(({ (dir+1) % 4, (dir+3) % 4 });; int dn) {
      int xn = x+dirs[dn][0];
      int yn = y+dirs[dn][1];
      if ((xn >= 0) && (yn >= 0) && (xn < width) && (yn < height)) {
	res += ({ key(xn, yn, dn, 9) });
      }
    }
  }
  if (left > 0) {
    int xn = x+dirs[dir][0];
    int yn = y+dirs[dir][1];
    if ((xn >= 0) && (yn >= 0) && (xn < width) && (yn < height)) {
      res += ({ key(xn, yn, dir, left-1) });
    }
  }
  return res;
}

int getdist(string k) {
  if (has_index(distmap, k)) {
    return distmap[k];
  }
  return 1000000000;
}

int best(int xx, int yy, int max_left) {
  int m = 999;
  foreach(distmap; string k; int v) {
    sscanf(k, "%d,%d:%d:%d", int x, int y, int dir, int left);
    if ((x == xx) && (y == yy) && (left <= max_left)) {
      m = min(v,m);
    }
  }
  return m;
}

void add_todo(string s) {
  int dist = distmap[s];
  int i=0;
  while (i < sizeof(todo) && distmap[todo[i]] < dist) i++;
  if (i == 0) {
    todo = ({ s }) + todo;
  } else if (i == sizeof(todo)) {
    todo += ({ s });
  } else {
    todo = todo[..i-1] + ({ s }) + todo[i..];
  }
}

int compute(function e, int i, int max_left) {
  exits = e;
  distmap = ([ ]);
  done = (< >);
  todo = ({ "0,0:1:" + i, "0,0:2:" + i });
  while(sizeof(todo) > 0) {
    string k = todo[0];
    todo = todo[1..];
    done[k] = 1;
    int dist = distmap[k];
    foreach(exits(k);; string e) {
      if (done[e]) continue;
      int odist = getdist(e);
      sscanf(e, "%d,%d:%d:%d", int x, int y, int dir, int left);
      int ndist = costmap[y][x] + dist - '0';
      if (ndist < odist) {
	distmap[e] = ndist;
	add_todo(e);
      }
    }
  }
  return best(width-1, height-1, max_left);
}

void print_map(int max_left) {
  for(int y=0; y < height; y++) {
    for(int x=0; x < width; x++) {
      write("%4d", best(x,y, max_left));
    }
    write("\n");
  }
}

void print_todo() {
  foreach(todo;; string s) {
    write("%s->%d ", s, distmap[s]);
  }
  write("\n");
}

int main(int argc, array(string) argv) {
  costmap = (Stdio.read_file(argv[1]) / "\n") - ({""});
  width = sizeof(costmap[0]);
  height = sizeof(costmap);
  write("Problem 1: %d\n", compute(exits1, 3, 2));
  write("Problem 2: %d\n", compute(exits2, 10, 6));
}

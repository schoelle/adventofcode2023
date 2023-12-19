array(string) costmap;
mapping(string:int) distmap;
multiset(string) done;
int width;
int height;
array(string) todo;

array(array(int)) dirs = ({ ({ 0, -1 }), ({ 1, 0 }), ({ 0, 1 }), ({ -1, 0 }) });

string key(int x, int y, int dir, int left) {
  return sprintf("%d,%d:%d:%d", x, y, dir, left);
}

array(string) exits(string l, int max_step, int max_left) {
  sscanf(l, "%d,%d:%d:%d", int x, int y, int dir, int left);
  array(string) res = ({ });
  if (left <= max_left) {
    foreach(({ (dir+1) % 4, (dir+3) % 4 });; int dn) {
      int xn = x+dirs[dn][0];
      int yn = y+dirs[dn][1];
      if ((xn >= 0) && (yn >= 0) && (xn < width) && (yn < height)) {
	res += ({ key(xn, yn, dn, max_step-1) });
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
  todo = todo[..i-1] + ({ s }) + todo[i..];
}

int compute(int max_step, int max_left) {
  distmap = ([ ]);
  done = (< >);
  todo = ({ "0,0:1:" + max_step, "0,0:2:" + max_step });
  while(sizeof(todo) > 0) {
    string k = todo[0];
    todo = todo[1..];
    done[k] = 1;
    int dist = distmap[k];
    foreach(exits(k, max_step, max_left);; string e) {
      if (done[e]) continue;
      int odist = distmap[e];
      sscanf(e, "%d,%d:%d:%d", int x, int y, int dir, int left);
      int ndist = costmap[y][x] + dist - '0';
      if (!has_index(distmap, e) || (ndist < odist)) {
	distmap[e] = ndist;
	add_todo(e);
      }
    }
  }
  return best(width-1, height-1, max_left);
}

int main(int argc, array(string) argv) {
  costmap = (Stdio.read_file(argv[1]) / "\n") - ({""});
  width = sizeof(costmap[0]);
  height = sizeof(costmap);
  write("Problem 1: %d\n", compute(3, 2));
  write("Problem 2: %d\n", compute(10, 6));
}

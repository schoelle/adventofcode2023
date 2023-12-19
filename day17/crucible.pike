constant VERY_LARGE_NUMBER = 10000000000;
constant UP=0;
constant RIGHT=1;
constant DOWN=2;
constant LEFT=3;

array(string) costmap;
mapping(string:int) distmap;
int width;
int height;

array(array(int)) dirs = ({ ({ 0, -1 }), ({ 1, 0 }), ({ 0, 1 }), ({ -1, 0 }) });

string key(int x, int y, int dir, int left) {
  return sprintf("%d,%d:%d:%d", x, y, dir, left);
}

array(string) exits(string l) {
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

int getdist(string k) {
  if (has_index(distmap, k)) {
    return distmap[k];
  }
  return 1000000000;
}

int best(int xx, int yy) {
  int m = 10000000000;
  foreach(distmap; string k; int v) {
    sscanf(k, "%d,%d:%d:%d", int x, int y, int dir, int left);
    if ((x == xx) && (y == yy)) {
      m = min(v,m);
    }
  }
  return m;
}

mapping(string:int) costs = ([ ]);
array(string) todo = ({ });
array(string) done = ({ });

int main(int argc, array(string) argv) {
  costmap = (Stdio.read_file(argv[1]) / "\n") - ({""});
  width = sizeof(costmap[0]);
  height = sizeof(costmap);
  distmap = ([ ]);
  todo = ({ "0,0:1:3", "0,0:2:3" });
  while(sizeof(todo) > 0) {
    string k = todo[0];
    todo = todo[1..];
    int dist = distmap[k];
    foreach(exits(k);; string e) {
      int odist = getdist(e);
      sscanf(e, "%d,%d:%d:%d", int x, int y, int dir, int left);
      int ndist = costmap[y][x] + dist - '0';
      if (ndist < odist) {
	distmap[e] = ndist;
	todo += ({ e });
      }
    }
  }
  write("Problem 1: %d\n", best(width-1, height-1));
}

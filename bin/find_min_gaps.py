#!/usr/bin/env python

if __name__ == "__main__":
    import sys
    
    if len(sys.argv) < 2:
        print('USAGE: python nwk2mat.py TREE.nwk')
        sys.exit(1)
    
    import pandas as pd
    import itertools
    from Bio import Phylo

    ifile = sys.argv[1]
    
    t = Phylo.read(ifile, 'newick')

    d = {}
    for x, y in itertools.combinations(t.get_terminals(), 2):
        v = t.distance(x, y)
        d[x.name] = d.get(x.name, {})
        d[x.name][y.name] = v
        d[y.name] = d.get(y.name, {})
        d[y.name][x.name] = v
    for x in t.get_terminals():
        d[x.name][x.name] = 0

    m = pd.DataFrame(d)
    m.to_csv(sys.stdout, sep='\t')

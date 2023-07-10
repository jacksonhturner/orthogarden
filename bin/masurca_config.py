#!/usr/bin/env python3
import sys

r1 = sys.argv[1]
r2 = sys.argv[2]
config = f"{sys.argv[3]}_config.txt"
threads = sys.argv[4]

mean = 151
std = int(round(mean*0.15, 0))

with open(config, 'w') as o:
    o.write(f"DATA\n" +
            f"PE = pa {mean} {std} {r1} {r2}\n" +
            f"END\n" +
            f"\n" +
            f"PARAMETERS\n" +
            f"GRAPH_KMER_SIZE = auto\n" +
            f"USE_LINKING_MATES = 0\n" +
            f"LIMIT_JUMP_COVERAGE = 300\n" +
            f"CA_PARAMETERS = cgwErrorRate=0.15\n" +
            f"KMER_COUNT_THRESHOLD = 1\n" +
            f"NUM_THREADS = {threads}\n" +
            f"JF_SIZE = 200000000\n" +
            f"SOAP_ASSEMBLY=0\n" +
            f"END")

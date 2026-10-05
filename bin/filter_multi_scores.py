#!/usr/bin/env python3
import sys
import re

nucl = sys.argv[1]
target_multi_score = int(sys.argv[2])
pass_file = sys.argv[3]
fail_file = sys.argv[4]

assert pass_file != fail_file
assert pass_file != nucl
assert fail_file != nucl

status = "fail"

with open(nucl) as n, open(pass_file, "w") as po, open(fail_file, "w") as fo:
    for line in n:
        if line.startswith(">"):
            multi_score = re.search(r'=(\d+\.\d+)', line)
            multi_score = float(multi_score.group(1))
            if multi_score >= target_multi_score:
                po.write(line)
                status = "pass"
            else:
                fo.write(line)
                status = "fail"
        else:
            if status == "pass":
                po.write(line)
            else:
                fo.write(line)


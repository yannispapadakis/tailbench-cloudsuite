#!/usr/bin/env python3
import sys
import numpy as np

def main(lats_file):
    a = np.fromfile(lats_file, dtype=np.uint64)
    reqTimes = a.reshape((a.shape[0] // 3, 3))

    svcTimes = reqTimes[:, 1] / 1e6
    sjrnTimes = reqTimes[:, 2] / 1e6

    print("svc: mean %.3f ms | p95 %.3f ms | p99 %.3f ms | max %.3f ms" %
          (svcTimes.mean(), np.percentile(svcTimes, 95), np.percentile(svcTimes, 99), svcTimes.max()))
    print("end2end: mean %.3f ms | p95 %.3f ms | p99 %.3f ms | max %.3f ms" %
          (sjrnTimes.mean(), np.percentile(sjrnTimes, 95), np.percentile(sjrnTimes, 99), sjrnTimes.max()))

if __name__ == '__main__':
    main(sys.argv[1])

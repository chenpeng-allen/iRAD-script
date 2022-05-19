import sys


def bin_mark():
    break_p = sys.argv[1]
    individual_b = sys.argv[2]
    print("chr", "star", individual_b.split(".")[0])
    bp_f = open(break_p, "r")
    ib_f = open(individual_b, "r")
    lis_ib = []
    ib_n = 0
    for ib_line in ib_f:
        lis_ib.append(ib_line)
    ib_sample = lis_ib[ib_n].strip("\r\n").split("\t")
    for bp_line in bp_f:
        bp_sample = bp_line.strip("\r\n").split("\t")
        if ib_sample[0] == bp_sample[0]:
            if int(bp_sample[1]) <= int(ib_sample[2]):
                print(bp_sample[0], bp_sample[1], ib_sample[3], sep="\t")
            else:
                ib_n = ib_n + 1
                ib_sample = lis_ib[ib_n].strip("\r\n").split("\t")
                print(bp_sample[0], bp_sample[1], ib_sample[3], sep="\t")
        else:
            ib_n = ib_n + 1
            ib_sample = lis_ib[ib_n].strip("\r\n").split("\t")
            print(bp_sample[0], bp_sample[1], ib_sample[3], sep="\t")
    ib_f.close()
    bp_f.close()


if __name__ == "__main__":
    bin_mark()

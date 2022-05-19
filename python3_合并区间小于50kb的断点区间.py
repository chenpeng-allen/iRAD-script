import sys


def small_dis_filter():
    file_name = sys.argv[1]
    df = open(file_name, mode="r")
    y = 1
    for i in df:
        sample_c = i.strip("\r\n").split("\t")
        if y == 1:
            print(sample_c[0], sample_c[1], sample_c[2], sep="\t")
            y += 1
            up_chr, up_position, up_file = sample_c[0], sample_c[1], sample_c[2]
        else:
            dis = int(sample_c[1]) - int(up_position)
            if dis >= 50000 or dis < 0:
                print(sample_c[0], sample_c[1], sample_c[2], sep="\t")
                up_chr, up_position, up_file = sample_c[0], sample_c[1], sample_c[2]
            else:
                print(up_chr, up_position, up_file, sep="\t")


if __name__ == "__main__":
    small_dis_filter()

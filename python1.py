import sys,os

def filter_snp():
    vcf_file = "/vol3/agis/changyuxiao_group/chenpeng/project/iRAD-seq/04_bwa/01_Parents/02_83-s41/83_s41.snp.vcf"
    #print("begining!!!")
    handle = open(vcf_file, "r")
    for line in handle:
        if line.startswith("#"):
            continue
        #print("loop")
        array = line.strip("\r\n").split("\t")
        sample_1 = array[9].split(":")[0].split("/")
        sample_2 = array[10].split(":")[0].split("/")

        #print(sample_1, sample_2)
        if sample_1[0] == "." or sample_1[1] == "." or sample_2[0] == "." or sample_2[1] == ".":
		    continue
        if int(sample_1[0]) == 0 and int(sample_1[1]) == 0 and int(sample_2[0]) == 1 and int(sample_2[1]) == 1:
            print(line)

        if int(sample_1[0]) == 1 and int(sample_1[1]) == 1 and int(sample_2[0]) == 0 and int(sample_2[1]) == 0:
            print(line)
		
    handle.close()

if __name__ == "__main__":
    filter_snp()

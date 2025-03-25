def read_file(filename):
    with open(filename, "r") as file:
        for line in file:
            count_subline(line.strip())


def count_subline(line):
    subline = "aa"
    count = 0
    i = 0

    while i <= len(line) - len(subline):
        if line[i: i + len(subline)] == subline:
            count += 1
            i += len(subline)
        else:
            i += 1

    print(count)


read_file("test.in")




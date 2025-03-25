def read_file(filename):
    result_arr = []
    with open(filename, "r", encoding="utf-8") as file:
        for index, line in enumerate(file):
            line = line.rstrip("\r\n")
            count = count_subline(line)
            result_arr.append((count, index))
        sorted_arr = bubble_sort(result_arr)
        show_result(sorted_arr)


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

    return count


def bubble_sort(arr):
    n = len(arr)
    for i in range(n - 1):
        for j in range(n - i - 1):
            if arr[j][0] > arr[j + 1][0]:
                arr[j], arr[j + 1] = arr[j + 1], arr[j]
    return arr


def show_result(arr):
    for count, index in arr:
        print(count, index)


read_file("test.in")




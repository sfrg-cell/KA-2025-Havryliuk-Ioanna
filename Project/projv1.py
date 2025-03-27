import sys

MAX_LINES = 100
MAX_LEN = 255


def read_lines():
    """ Reads lines from stdin until EOF and returns a list. """
    lines = []
    try:
        while len(lines) < MAX_LINES:
            line = sys.stdin.readline().rstrip("\r\n")
            if not line:
                break
            lines.append(line[:MAX_LEN])
    except EOFError:
        pass
    print(lines)
    return lines


def count_substring(line, substring):
    """ Counts non-overlapping occurrences of substring in line. """
    count = 0
    i = 0
    sub_len = len(substring)

    while i <= len(line) - sub_len:
        match = True
        for j in range(sub_len):
            if line[i + j] != substring[j]:
                match = False
                break
        if match:
            count += 1
            i += sub_len
        else:
            i += 1
    return count


def bubble_sort(counts, indices):
    n = len(counts)
    for i in range(n - 1):
        for j in range(n - i - 1):
            if counts[j] > counts[j + 1]:
                counts[j], counts[j + 1] = counts[j + 1], counts[j]
                indices[j], indices[j + 1] = indices[j + 1], indices[j]


def main():
    if len(sys.argv) < 2:
        print("Usage: script.py <substring>")
        return

    substring = sys.argv[1]
    lines = read_lines()

    counts = []
    indices = []

    for i, line in enumerate(lines):
        count = count_substring(line, substring)
        counts.append(count)
        indices.append(i)

    bubble_sort(counts, indices)

    for i in range(len(counts)):
        print(f"{counts[i]} {indices[i]}")


if __name__ == "__main__":
    main()



#Get-Content test.in | python projv1.py aa


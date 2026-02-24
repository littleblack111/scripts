from sys import argv

def main():
    if len(argv) < 2:
        print("Usage: python escapeEnv.py <string>")
        return

    input = argv[1].split()
    for i in range(len(input)):
        first = True
        pos = -1
        for j in range(len(input[i])):
            if input[i][j] == "=" and pos == -1:
                pos = j
                input[i] = input[i][:j+1] + '"' + input[i][j+1:] + '"'

        pos = -1

    print(' '.join(input))


if __name__ == "__main__":
    main()

import sys

def main():
    if len(sys.argv) < 2:
        print("Usage: python script.py <filename>")
        sys.exit(1)

    filename = sys.argv[1]
    print(f"Input file: {filename}")

    # 打开文件读取
    with open(filename, "r", encoding="utf-8") as f:
        content = f.read()
        print("First 100 chars:", content[:100])

if __name__ == "__main__":
    main()

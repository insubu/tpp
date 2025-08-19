import codecs

def detect_encoding(filepath):
    with open(filepath, "rb") as f:
        raw = f.read(4096)  # 取前4KB做检测

    # 🔹检查 BOM
    if raw.startswith(codecs.BOM_UTF8):
        return "utf-8-sig"
    elif raw.startswith(codecs.BOM_UTF16_LE):
        return "utf-16-le"
    elif raw.startswith(codecs.BOM_UTF16_BE):
        return "utf-16-be"
    elif raw.startswith(codecs.BOM_UTF32_LE):
        return "utf-32-le"
    elif raw.startswith(codecs.BOM_UTF32_BE):
        return "utf-32-be"

    # 🔹尝试 UTF-8
    try:
        raw.decode("utf-8")
        return "utf-8"
    except UnicodeDecodeError:
        pass

    # 🔹尝试 Shift-JIS (SJIS / cp932)
    try:
        raw.decode("cp932")
        return "cp932"
    except UnicodeDecodeError:
        pass

    return "unknown"

# 示例
file = "test.txt"
encoding = detect_encoding(file)
print(f"Detected encoding: {encoding}")

# 用检测到的编码读取
with open(file, "r", encoding=encoding, errors="replace") as f:
    content = f.read()
    print("First 100 chars:", content[:100])

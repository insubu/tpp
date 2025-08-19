import codecs

def detect_encoding(filepath):
    with open(filepath, "rb") as f:
        raw = f.read(4)  # 读取前几个字节
    
    # BOM 检测
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
    else:
        return "utf-8"  # fallback

# 示例
file = "test.txt"
encoding = detect_encoding(file)
print(f"Detected encoding: {encoding}")

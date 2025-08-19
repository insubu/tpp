import chardet

def detect_encoding(filepath, sample_size=10000):
    with open(filepath, 'rb') as f:
        raw_data = f.read(sample_size)  # 只取前面一部分做检测
    result = chardet.detect(raw_data)
    return result['encoding'], result['confidence']

# 示例
file = "test.txt"
encoding, confidence = detect_encoding(file)
print(f"Detected encoding: {encoding}, confidence: {confidence:.2f}")

from charset_normalizer import from_path

def detect_encoding(filepath):
    results = from_path(filepath)
    best = results.best()
    if best:
        return best.encoding, best.alphabets, best.language
    return None, None, None

# 示例
file = "test.txt"
encoding, alphabets, language = detect_encoding(file)
print(f"Encoding: {encoding}, Alphabets: {alphabets}, Language: {language}")

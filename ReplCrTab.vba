BLOCK_SIZE = 4096
NUM_BLOCKS = 4

with open("your_file.dat", "rb") as f:
    header_bytes = f.read(BLOCK_SIZE * NUM_BLOCKS)

result = from_bytes(raw_bytes)
print(result.best().encoding)

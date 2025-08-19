import csv
import os

def split_csv(input_file, output_prefix, rows_per_file):
    with open(input_file, "r", newline="", encoding="utf-8") as f:
        reader = list(csv.reader(f))
        header, rows = reader[0], reader[1:]

    # 计算要生成多少文件
    total_rows = len(rows)
    parts = (total_rows + rows_per_file - 1) // rows_per_file

    for i in range(parts):
        start = i * rows_per_file
        end = start + rows_per_file
        chunk = rows[start:end]

        out_file = f"{output_prefix}_{i+1}.csv"
        with open(out_file, "w", newline="", encoding="utf-8") as f:
            writer = csv.writer(f)
            writer.writerow(header)   # 写 header
            writer.writerows(chunk)   # 写数据行

        print(f"Saved: {out_file} ({len(chunk)} rows)")

# 示例
split_csv("input.csv", "output_part", 1000)

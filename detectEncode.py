import pandas as pd

def csv_to_xlsx_all_text(csv_file, xlsx_file):
    # Read CSV, force all values as string
    df = pd.read_csv(csv_file, dtype=str)

    # Write to Excel
    df.to_excel(xlsx_file, index=False)

# Example
csv_to_xlsx_all_text("input.csv", "output.xlsx")
print("Done! All columns saved as text")

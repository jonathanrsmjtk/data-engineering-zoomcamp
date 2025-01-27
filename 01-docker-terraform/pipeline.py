import sys

import pandas as pd

day = sys.argv[1]

df = pd.DataFrame({"col1": [1,2,3], "col2": [4,5,6]})
df["date"] = day
print(df)

print(f'Job finished successfully for day = {day}')
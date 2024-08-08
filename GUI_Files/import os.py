import os
import nfl_data_py as nfl

df = nfl.import_seasonal_data([2023])
print(df.head())
# Get the current directory
current_directory = os.getcwd()

# List all files in the current directory
all_files = os.listdir(current_directory)

# Filter feather files
feather_files = [file for file in all_files if file.endswith(".feather")]

print("Feather files in the current directory:")
for file in feather_files:
    print(file)

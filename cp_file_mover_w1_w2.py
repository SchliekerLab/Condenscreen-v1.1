import os
import shutil

#Gets the working directory:
os.getcwd()

#Edit to represent the path your images are in and the path that you want to create
original_dir =  "C:\\Users\\dylan\\OneDrive\\Yale\\Schlieker_Lab\\dp_23_6_7_cell_density_screen\\250_cell_well"
target_dir = "C:\\Users\\dylan\\OneDrive\\Yale\\Schlieker_Lab\\dp_23_6_7_cell_density_screen\\DAPI_MLF2_4"

#Make sure that the path exists
os.path.exists(original_dir)

if not os.path.exists(target_dir):
    os.makedirs(target_dir)

#Creates a list of all files in list
file_List = os.listdir("C:\\Users\\dylan\\OneDrive\\Yale\\Schlieker_Lab\\dp_23_6_7_cell_density_screen\\250_cell_well")

#If file is an image of either DAPI of MLF2, move file.
cell_mask = "w3"
updated_List = [file for file in file_List if not cell_mask in file]

#Move selected files to your new folder
for file in updated_List:
    print(file)
    print(os.path.join(original_dir, file))
    source_file_path = "{}\\{}".format(original_dir, file)
    target_file_path =  "{}\\{}".format(target_dir, file)

    shutil.move(source_file_path, target_dir)

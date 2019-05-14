import numpy as np
import os
from board_block_detect import *

# Manually measured GBR values of the different colour groups 
black_rgb = np.array((0,0,0))
colour_1 = np.array((255,146,131))
colour_2 = np.array((116,184,79))
colour_3 = np.array((244,254,241))
colours = [black_rgb, colour_1, colour_2, colour_3]

# Gets path to home directory of NESTrisRedraw
main_directory_path = os.path.dirname(os.path.dirname(__file__))
# Join the path to the image to the home directory path
image_path = os.path.join(main_directory_path, "resources", "images", "tetris.png")
# Loads image using opencv, into an GBR colour matrix.
image_matrix = cv2.imread(image_path)
# Tags all of the blocks in the image, then prints the output.
BoardPrint(BlockLocations(image_matrix, colours))

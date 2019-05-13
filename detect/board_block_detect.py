import cv2
import numpy as np
from timeit import default_timer as timer

def DifferenceOfTuple(t1, t2):
    diff = abs(t1[0] - t2[0]) + abs(t1[1] - t2[1]) + abs(t1[2] - t2[2])
    return diff

def BoardPrint(board):
    for x in board:
        for y in range(len(x)):
            if x[y] == 0:
                x[y] = " "
            else:
                x[y] = str(x[y])
        print(" ".join(x))

def BlockLocations(image_path, colours):
    board = [[" " for x in range(10)] for x in range(20)]
    # Image read into an opencv image matrix (GBR colour format)
    board_image = cv2.imread(image_path)
    height,width,bpp = np.shape(board_image)
    block_height = height / 20
    block_width = width / 10

    for y in range(20):
        for x in range(10):
            x_start_pos = round(x * block_width)
            y_start_pos = round(y * block_height)
            x_end_pos = round(x_start_pos + block_width - 1)
            y_end_pos = round(y_start_pos + block_height - 1)
            current_block = board_image[y_start_pos : y_end_pos + 1,
                                        x_start_pos : x_end_pos + 1]
            block_middle = current_block[round(block_height / 2) : round((block_height / 2) + 2),
                                         round(block_width / 2) : round((block_width / 2) + 2)]
            mean_rgb = np.array(cv2.mean(block_middle)[0:3])
            
            # old line using root means squared error - 2x slowdown
            # differences = [np.linalg.norm(x - mean_rgb) for x in colours]
            
            differences = [DifferenceOfTuple(mean_rgb, x) for x in colours]
            board[y][x] = differences.index(min(differences))

    return board

        

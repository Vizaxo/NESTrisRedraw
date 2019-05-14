import cv2
import numpy as np

# Function to calculate a simple difference metric between two GBR tuples,
# using the sum of absolute differences between each set of GBR values.
def DifferenceOfTuple(t1, t2):
    diff = abs(t1[0] - t2[0]) + abs(t1[1] - t2[1]) + abs(t1[2] - t2[2])
    return diff

# Function for printing a tagged board - takes a board string and prints it line by line
def BoardPrint(board):
    for x in board.split(","):
        no_background = x.replace("0", " ")
        print(" ".join(no_background))

# Function that takes in an image matrix of a tetris board, and returns a
# string representation of the board. Each digit in the string represents which
# 'colour group' a block belongs to. 
def BlockLocations(cv_image_matrix, colours):
    # Generate a matrix of a blank, standard tetris board (10 x 20 blocks)
    board = [[" " for x in range(10)] for x in range(20)]
    # Calculate information about image matrix
    board_image = cv_image_matrix
    height,width,bpp = np.shape(board_image)
    block_height = height / 20
    block_width = width / 10

    for y in range(20):
        for x in range(10):
            x_start_pos = round(x * block_width)
            y_start_pos = round(y * block_height)
            x_end_pos = round(x_start_pos + block_width - 1)
            y_end_pos = round(y_start_pos + block_height - 1)
            # Takes the pixel region containing the current block
            current_block = board_image[y_start_pos : y_end_pos + 1,
                                        x_start_pos : x_end_pos + 1]
            
            # Takes a set of 4 (2 x 2) pixels from the center of a block
            block_middle = current_block[round(block_height / 2) : round((block_height / 2) + 2),
                                         round(block_width / 2) : round((block_width / 2) + 2)]
            
            # Calculates the mean GBR value from the set of pixels. Uses a set of pixels instead of a
            # single pixel to account for potential issues caused by noise or blurring of a frame. 
            mean_gbr = np.array(cv2.mean(block_middle)[0:3])
            
            # old line using root means squared error - 2x slowdown
            # differences = [np.linalg.norm(x - mean_rgb) for x in colours]

            # Takes the index of the closest colour of the current block, 
            # tagging the 'colour group' it belongs to. 
            differences = [DifferenceOfTuple(mean_gbr, x) for x in colours]
            board[y][x] = str(differences.index(min(differences)))

    board_string = ','.join([''.join(x) for x in board])
    return board_string

 

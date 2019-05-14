import subprocess as sp
import cv2
import board_block_detect as bbd
import numpy as np
import time
import platform
from matplotlib import pyplot as plt

if (platform.system() == 'Windows'):
    FFMPEG = "ffmpeg.exe"
else:
    FFMPEG = "ffmpeg"

cmd = [ FFMPEG,
            '-i', '../resources/videos/tetris.ts',
            '-filter_complex', "[0]field=top[t];[0]field=bottom[b];[t][b]interleave",
            '-r', '50',
            '-f', 'image2pipe',
            '-pix_fmt', 'rgb24',
            '-vcodec', 'rawvideo', '-']
vid_stream = sp.Popen(cmd, stdout = sp.PIPE, bufsize=10**3).stdout

black_rgb = np.array((0,0,0))
white = np.array((255,146,131))
blue = np.array((0x9d, 0x40, 0x39))
red = np.array((0x3f, 0x36, 0x87))
colours = [black_rgb, white, blue, red]

for i in range (10000):
    start = time.time()

    raw_image = vid_stream.read(720*288*3)
    # transform the byte read into a numpy array
    image = np.fromstring(raw_image, dtype='uint8')
    if(image.size != 0):
        image = image.reshape((288,720,3))
        cropped_image = image[68:230, 278:482]
        bbd.BoardPrint(bbd.BlockLocations(cropped_image, colours))

    # loop at 50fps
    time.sleep(max(1./50 - (time.time() - start), 0))

import matplotlib.pyplot as plt
import matplotlib.animation as animation
from matplotlib import style
import numpy as np
import serial

ser = serial.Serial(
    port='COM7',\
    baudrate=115200,\
    parity=serial.PARITY_NONE,\
    stopbits=serial.STOPBITS_ONE,\
    bytesize=serial.EIGHTBITS,\
    timeout=0
)

xMag = []
yMag = []
zMag = []
time = []
plt.ion()
graphX = plt.plot(time, xMag, color='#DDE392', label='x', linewidth=3)[0]
graphY = plt.plot(time, yMag, color='#AFBE8F', label='y', linewidth=3)[0]
graphZ = plt.plot(time, zMag, color='#7D8570', label='z', linewidth=3)[0]
plt.title("Magnetometer Readings", fontsize='xx-large', fontweight='demibold', fontstretch='condensed')
plt.xlabel("Timestep")
plt.ylabel("B-dot (uT/s)")
plt.grid(True, 'both', 'both')
textX = plt.text(0, 0, "X")
textY = plt.text(0, 0, "Y")
textZ = plt.text(0, 0, "Z")

while True:
    line = ser.readline()
    if (b'.' in line):
        line = str(line)
        line = line[slice(2, -1)]
        if line[-1] == 'n':
            line = line[slice(0, -3)]
        else:
            line = line[slice(0, -1)]
        
        val = line.split(' ')

        xMag.append(float(val[0]))
        yMag.append(float(val[1]))
        zMag.append(float(val[2]))

        if len(time) == 0:
            time.append(0)
        else:
            time.append(time[-1]+1)

        graphX.set_ydata(xMag)
        graphY.set_ydata(yMag)
        graphZ.set_ydata(zMag)
        graphX.set_xdata(time)
        graphY.set_xdata(time)
        graphZ.set_xdata(time)

        combined = xMag + yMag + zMag
        maxLim = max(combined)
        minLim = min(combined)
        extraLim = 0.1*max(abs(maxLim), abs(minLim))
        plt.xlim(time[0], time[-1]+0.1*50)
        plt.ylim(minLim-extraLim, maxLim+extraLim)

        textX.remove()
        textY.remove()
        textZ.remove()
        textX = plt.text(time[-1]+1, xMag[-1], "X", fontsize='x-large', color='#000000', horizontalalignment='center', verticalalignment='center', fontweight='demibold')
        textY = plt.text(time[-1]+1, yMag[-1], "Y", fontsize='x-large', color='#000000', horizontalalignment='center', verticalalignment='center', fontweight='demibold')
        textZ = plt.text(time[-1]+1, zMag[-1], "Z", fontsize='x-large', color='#000000', horizontalalignment='center', verticalalignment='center', fontweight='demibold')


        
        if len(time) > 50:
            xMag = xMag[-50:]
            yMag = yMag[-50:]
            zMag = zMag[-50:]
            time = time[-50:]        
        
        plt.pause(0.005)

        plt.draw()
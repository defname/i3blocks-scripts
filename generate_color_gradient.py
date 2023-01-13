#!/bin/env python3

import sys

def help():
    print(sys.argv[0]+" <color> <steps> <color> [<steps> <color>]...")
    print("   generates gradients")
    sys.exit(0)

def hexToRGB(color):
    color = color.lstrip('#')
    return tuple(int(color[i:i+2], 16) for i in (0, 2, 4))

def rgbToHex(rgb):
    return '#'+format(rgb[0], '02x')+format(rgb[1], '02x')+format(rgb[2], '02x')

def generateGradient(color1, steps, color2):
    step = tuple(float((color2[i]-color1[i])/(steps-1)) for i in (0,1,2))
    return list(tuple(round(color1[j]+step[j]*i) for j in (0,1,2)) for i in range(0, steps))

def getColorOfLinearGradient(start_rgb, end_rgb, steps, pos):
    step = tuple(float((end_rgb[i]-start_rgb[i])/(steps-1)) for i in (0,1,2))
    return tuple(round(start_rgb[i]+step[i]*pos) for i in (0,1,2))

if __name__ == "__main__":
    
    if len(sys.argv) < 4 or (len(sys.argv)-4)%2 != 0:
        help()
    
    print("#" + sys.argv[1])
    
    for i in range(0, len(sys.argv)-2, 2):
        colorlist = generateGradient(hexToRGB(sys.argv[i+1]), int(sys.argv[i+2]), hexToRGB(sys.argv[i+3]))
        for j in range(1, len(colorlist)):
            print(rgbToHex(colorlist[j]))

    

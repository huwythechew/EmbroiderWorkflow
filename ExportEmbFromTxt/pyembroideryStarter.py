#import pyembroidery
from pyembroidery import *
import math
import os


#set booleans to export type
pes = False
vp3 = True
dst = False
svg = False

#names contains the filename (without extension) of each color's name
names = ["Hilbert"]
colors = ["red","green","blue","yellow","orange","magenta","purple"]
folder = ""
srcFolder = "srcTxts/"


frm = "1"

canvasWidth = 1000 #width of the processing canvas used for generating
                  #standardized to ~4 inches: 1000=no scale change
maxX = 1500
maxY = 2400
reverseBlocks = False

def properUnits(array, maxSize):
    print("ok: "+str(len(array)))
    isX = False
    for i in range(len(array)):
        #print(array[i])
        #array[i] = float(array[i])  /float(canvasWidth) * float(1000)


        # if (array[i]<0):
        #     array[i]=0
        # if isX and array[i]>maxX:
        #     array[i] = maxX
        # if not isX and array[i]>maxY:
        #     array[i] = maxY



        if isX:
            array[i] -= 750
        else:
            array[i] -= 1200
        isX = not isX
        array[i] = math.floor(array[i])


    return array



def addToPattern(pattern,fileName, color):
    x = []
    isX = False
    file_in = open(fileName, 'r')
    for y in file_in.read().split('\n'):
        y = y.split(".")[0]
        if y.isdigit():
            x.append(float(y))
        else :
            x.append(0)
        isX = not isX

    x = ar2tups(properUnits(x,canvasWidth))
    for t in x:
        if (isTrim(t)):
            pattern.trim()
        else:
            pattern.add_stitch_absolute(STITCH, t[0],t[1])
    if reverseBlocks:
        x = reverse(x)
    #pattern.add_block(x, color)
    pattern.color_change()



def reverse(lst):
    result = []
    for i in range(len(lst),-1,-1):
        result.append(lst[i])
    return result

def isTrim(tup) :
    return t[0]>9990000 and t[1]>9990000


def ar2tups(array):
    toTup = []
    result = []
    for i in range(len(array)):
        if (len(toTup) > 0):
            toTup.append(array[i])
            xy = (toTup[0], toTup[1])
            #if xy[0]<=500 and xy[1]<=500:
            result.append(xy)
            toTup = []
        else:
            toTup.append(array[i])
    return result


#pattern = pyembroidery.read_pes("ye1.pes")
def repeat(n) :
    for i in range(0,n,1) :
        frm = i
        single(i)




def single(fns) :
    #names = ["YP1", "YP1"]
    pattern1 = EmbPattern()
    for i in range(0,len(names),1):
        addToPattern(pattern1, srcFolder+names[i]+".txt", colors[min(i,len(colors)-1)])


    print(pattern1.stitches)
    if (len(names)==0) :
        return
    if (pes) :
        if not os.path.exists("OutputPES"):
            os.makedirs("OutputPES")
        #write_pes(pattern1, "OutputPES/"+names[1]+".pes")
        write_pes(pattern1, "OutputPES/"+folder+names[0]+".pes")

    if (vp3) :
        if not os.path.exists("OutputVP3"):
            os.makedirs("OutputVP3")
        write_vp3(pattern1, "OutputVP3/"+folder+names[0]+".vp3")

    if (dst) :
        if not os.path.exists("OutputDST"):
            os.makedirs("OutputDST")
        write_dst(pattern1, "OutputDST/"+folder+names[0]+".dst")

    if (svg) :
        if not os.path.exists("OutputSVG"):
            os.makedirs("OutputSVG")
        write_svg(pattern1, "OutputSVG/"+folder+names[0]+".svg")

single("")

#repeat(25); #this number should be set to the number of files, filenames indexng from 0

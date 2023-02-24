#import pyembroidery
from pyembroidery import *
import math
import os


#set booleans to export type
pes = False
vp3 = True
dst = False
svg = False

#names contains the filename (without extension) of each color's txt file name
names = ["Hilbert"]
#names = ["HilbertFrms/"]
colors = ["black","red","green","blue","yellow","orange","magenta","purple"]
srcFolder = "srcTxts/"

canvasWidth = 1000  #pixel distance representing 100mm in .txt file from sketch
                    #canvasWidth = 100mm (~4in)
                    #I usually set this to 1000

maxX = 1500
maxY = 2400
#set to 1500x2400 for Husq Jade 35 (15x24cm)
#1000x1000 for 4inx4in hoop (10x10cm)

reverseBlocks = False


### FUNCTION DEFS vvv #### ### ### ### ### ### ### ### ### ### ### ### ### ###


#scale array of values based on canvasWidth
#constrains points to maxX and maxY
#centers points based on maxX and maxY
def properUnits(array):
    print("ok: "+str(len(array)))
    isX = False
    for i in range(len(array)):
        #print(array[i])
        array[i] = float(array[i])  /float(canvasWidth) * float(1000)


        if (array[i]<0):
            array[i]=0
        if isX and array[i]>maxX:
            array[i] = maxX
        if not isX and array[i]>maxY:
            array[i] = maxY



        if isX:
            array[i] -= maxX/2
        else:
            array[i] -= maxY/2
        isX = not isX
        array[i] = math.floor(array[i])


    return array


#takes an instantiated pattern and adds points from a given fileName
def addToPattern(pattern,fileName, color):
    xys = []
    file_in = open(fileName, 'r')
    for line in file_in.read().split('\n'):
        intVal = line.split(".")[0]
        if intVal.isdigit():
            xys.append(float(line))
        else :
            xys.append(0)

    tups = ar2tups(properUnits(xys))
    # for t in tups:
    #     if (isTrim(t)):
    #         pattern.trim()
    #     else:
    #         pattern.add_stitch_absolute(STITCH, t[0],t[1])

    # print("tups: "+tups)

    if reverseBlocks:
        tups = reverse(tups)
    pattern.add_block(tups, color)
    #pattern.color_change()



def reverse(lst):
    result = []
    for i in range(len(lst),-1,-1):
        result.append(lst[i])
    return result

def isTrim(tup) :
    return tup[0]>=9990000 and tup[1]>=9990000


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

def exportRange(init,n,inc) :
    for i in range(init,n,inc) :
        exportSingle(i)




def exportSingle(n) :
    #names = ["YP1", "YP1"]
    pattern1 = EmbPattern()
    
    nStr = ""
    fStr = ""
    if names[0][-1]=="/" :
        nStr = str(n)
        fStr = names[0]

    
    for i in range(len(names)):
        addToPattern(pattern1, srcFolder+names[i]+nStr+".txt", colors[min(i,len(colors)-1)])
    

    
    

    print(pattern1.stitches)
    if (len(names)==0) :
        return
    if (pes) :
        if not os.path.exists("OutputPES/"+fStr):
            os.makedirs("OutputPES/"+fStr)
        #write_pes(pattern1, "OutputPES/"+names[1]+".pes")
        write_pes(pattern1, "OutputPES/"+names[0]+nStr+".pes")

    if (vp3) :
        if not os.path.exists("OutputVP3/"+fStr):
            os.makedirs("OutputVP3/"+fStr)
        write_vp3(pattern1, "OutputVP3/"+names[0]+nStr+".vp3")

    if (dst) :
        if not os.path.exists("OutputDST/"+fStr):
            os.makedirs("OutputDST/"+fStr)
        write_dst(pattern1, "OutputDST/"+names[0]+nStr+".dst")

    if (svg) :
        if not os.path.exists("OutputSVG/"+fStr):
            os.makedirs("OutputSVG/"+fStr)
        write_svg(pattern1, "OutputSVG/"+names[0]+nStr+".svg")


### MAIN PROGRAM CALL vvv #### ### ### ### ### ### ### ### ### ### ### ### ### ###

exportSingle("")

#exportRange(0,26,1) #calls exportSingle(n) with each number in range as filename extension
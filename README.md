# EmbroiderWorkflow
Reduced files I use for programming points in Processing and exporting workable embroidery files.

## [Working With Points - Java Processing](/WorkingWithPoints_JAVAProcessing/PThreadDigitizer)

### [PThread General Digitizer](/WorkingWithPoints_JAVAProcessing/PThreadDigitizer)
This program prototype can be used for digitizing different running stitches and satin stitches, overlaying a reference image.

### [FillPixel](/WorkingWithPoints_JAVAProcessing/FillPixel)
This program takes black and white images and helps you map out fill stitches for the defined areas. 

## [Export Embroidery From .txt Files - Python](/ExportEmbFromTxt_PYTHON)
Uses the [pyembroidery](https://github.com/EmbroidePy/pyembroidery) python library.

Pyembroidery will write:

- pes (mandated)
- dst (mandated)
- exp (mandated)
- jef (mandated)
- vp3 (mandated)
- .u01
- .pec
- .xxx
- gcode

### - Standard Exporting

### - Exporting a numbered set of files (animation)

## [Frame-By-Frame Live Animation - P5js](/InteractiveEmb_P5js)
These sketches show some ways of creating interactive or code-driven animations with a limited set of existing frames.


### - 3D Viewer
#### [Eight Sit Waiting](/InteractiveEmb_P5js/EightSitWaiting)
[Open in P5 editor](https://editor.p5js.org/huwythechew/sketches/CS8Cl07kZ) | [Open fullscreen](https://editor.p5js.org/huwythechew/full/CS8Cl07kZ)

Click (or touch) and drag to explore this embroidered 3D sculpture. Use arrow keys to adjust the rate of spin.

![EightSitWaiting_COVER](https://user-images.githubusercontent.com/111546097/221295852-316c2767-0e1f-454f-b350-420f72913f7a.gif)
#
### - Random Outcome Loop
#### [Proprietary Amusement](/InteractiveEmb_P5js/ProprietaryAmusement)
[Open in P5 editor](https://editor.p5js.org/huwythechew/NdDaIYBIs) | [Open fullscreen](https://editor.p5js.org/huwythechew/full/NdDaIYBIs)

Plays a random outcome to the sequence each time it loops.

There's 40 frames total:
- 16 intro frames show the ball coming in, and then being thrown up the ramp until it hits the back wall.
- After that, each set of 6 frames shows a different outcome (♠,♥,♦,♣).

The program randomly selects an outcome before it plays each time. Depending on that outcome, the frames for it are played to interupt the intro sequence at the right time. 
Sometimes the ball bounces ooff the back wall and "falls back down" before playing the outcome.
![ProprietaryAmusement_COVER](https://user-images.githubusercontent.com/111546097/221301370-972662e4-8cb8-4bec-a24c-a00e207d0596.gif)
#
### - Noise Flutterer
#### [HilbertNoise](/InteractiveEmb_P5js/HilbertNoise)
[Open in P5 editor](https://editor.p5js.org/huwythechew/sketches/ao0G0nfXl) | [Open fullscreen](https://editor.p5js.org/huwythechew/full/ao0G0nfXl)

This program just goes back and forth along a sequence of frames, following a noise function.

![HNoise](https://user-images.githubusercontent.com/111546097/221298988-cd97c3d9-21c9-4461-9074-0c1fccd5cdee.gif)
#
### - Loop Clock
#### [7-7](/InteractiveEmb_P5js/7-7)
[Open in P5 editor](https://editor.p5js.org/huwythechew/sketches/oYjhFq4ES) | [Open fullscreen](https://editor.p5js.org/huwythechew/full/oYjhFq4ES)

Takes 12 loops and plays a diifferent one for each hour. This one resets at 7am/pm.

![7-7_COVER](https://user-images.githubusercontent.com/111546097/221314038-b596a36b-a16f-4d0d-b3e7-c58ff11b87cf.gif)

#
### - [Scattered Line Assembly Space](/InteractiveEmb_P5js/ScatterLineAssemblySpace)
[Open in P5 editor](https://editor.p5js.org/huwythechew/sketches/I_AoqiTxx) | [Open fullscreen](https://editor.p5js.org/huwythechew/full/I_AoqiTxx)

A scattered array of line expressions with orderly access. 
Hover cursor to interact. 
Click or tap and drag to draw a line. 

This takes a single image of dots lines varying in length, as well as a set of points defining all those dots and lines.

The program animates two points interacting with the cursor, and then displays a line from the image - choosing one that's close the distance it's trying to render.

![ScatteredLineAssemblySpace_COVER](https://user-images.githubusercontent.com/111546097/221305123-610f501c-10c3-4c4b-86c5-365316fdb04a.gif)

#
#
## Standard .txt format for storing 2D points
The tools I use for generating stitch effects exists as a bunch of separate Processing sketches.
It's important to be able to save lists of 2D points to reference them in another sketch or script.

I use .txt as a common filetype for reading and writing between Processing Sketches and the Python exporter.

### Format
In program:
```
List = [(x1,y1), (x2,y2), (x3,y3)...]
```

Saved as .txt:
```
x1
y1
x2
y2
x3
y3
...
```

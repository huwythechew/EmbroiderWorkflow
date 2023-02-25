## [Export Embroidery From .txt Files - Python](/ExportEmbFromTxt_PYTHON)
Uses the [pyembroidery](https://github.com/EmbroidePy/pyembroidery) python library - must install that.
### Standard Exporting:
- .txt files containing 2D points get saved to "srcTxts/" folder. (Format is described below)

In <code>pyembroideryExport.py</code>:
- <code>names</code> is a list that contains the filename of each .txt file in <code>srcTxts/</code> to be exported (omitting the ".txt" extension)
  - <code>names = ["Hilbert"]</code>
  - <code>names = ["Flwr_stem","Flwr_flwr"]</code>

- <code>colors</code> is referenced respectively with each name in <code>names</code>.
- points from each filename in <code>names</code> will be added as a separate color block or thread change.
- run <code>pyembroideryExport.py</code> in terminal:
```
$ python pyembroideryExport.py
```
### Exporting a numbered set of files (animation):
- Have a folder in <code>srcTxts/</code> for each color, containing all the frames for that color. (See <code>srcTxts/HilbertFrms/</code>)
- Populate <code>names</code> with each folder's name.
  - <code>names = ["HilbertFrms/"]</code>
  
- Replace <code>exportSingle("")</code> with <code>exportRange(0,numberOfFrames,1)</code>
  - <code>exportRange(0,numberOfFrames,1)</code> parameters work like the <code>range(start,stop,step)</code> function - 
  exports a file with all colors for each number in the range.

#
#
### Standard .txt format for storing 2D points
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
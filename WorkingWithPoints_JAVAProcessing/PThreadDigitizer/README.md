# PThread Digitizer
Digitizing and generally arranging running and satin stitches.

Currently just for digitizing one color at a time:
- <code>String fileName</code> links to a reference image to be displayed on the canvas. (Begin with <code>"RefImgs/...</code>)
  - If an image doesn't exist at this path none will be shown.
- <code>String loadFrom</code> links to a project file, this program saves projects as .txt.
  - If the file linked here doesn't exist, it will create one when you "save".

- <code>String ProjectTxtsFolder</code> links to where the project .txt files are loaded from and saved to.

- <code>String pointExportFolder</code> links to where the final .txt file with stitch positions wil be saved.


This tool is not very organized, pretty bad UI, but it works.

## Controls

**Space Bar** - Toggle switching to canvas controls:
    
 - Click and drag to move the canvas.
 - Scroll to zoom in and out.
 
 **E** - Export
  - Saves final .txt file with stitch positions to <code>pointExportFolder</code>
  - Saves project .txt file with object data to <code>loadFrom</code>
 
 **T** - Cycle through tools (indicated by cursor color):
  - *Select* (blue) - Select Stitch Objects, click and drag to move them.
    - With an object selected, press **Shift** to add it the list of multiple selected objects.
  - *Running* (red) - Draw bezier curves with a pen tool.
  - *Free* (magenta) - Click and drag to draw an unguided line. 
  - *Satin* (green) - Drawing two bezier curves, each click alternates which side is being added to.
    - **=** - Toggle whether the satin stitiches zig-zag or make bars.
    - **Up** - Increase stitch separation (longer zig-zags)
    - **Down** - Decrease stitch separation (tighter zig-zags)
    - **U** - Toggle satin underlay (the prestitched-outline)
    - **O** - Toggle satin overlay (the zig-zag part)

**Left** - Decrease stitch length along the defined lines.

**Right** - Increase stitch length along the defined lines.

**[** - Move selected object backwards in queue.
**]** - Move selected object forwards in queue.

**Delete** - Delete selected objects.

**X** - Delete only the last point placed for an object. 

**Z** - Delete only the first point placed for an object. 

**D** - Duplicate a selected object.

**R** - Toggle whether selected object will output its stitch path in reverse. 

**H** - Flip/mirror a selected object horizontally.

**0** - Rotate selected object clockwise.
**9** - Rotate selected object counterclockwise.

**I** - Toggle showing the reference image.

**A** - Multi-Select all objects. 

**Enter** - Deselect all.


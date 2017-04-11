/**
 * The PuzzlePiece class provides all the prebuilt behaviors and additional properties
 * needed by a PuzzlePiece movie clip to:
 *   1. Position itself randomly within a the bounceBox movie clip and move randomly
 *      within it.
 *   2. Allow the clip to be dragged around the stage.
 *   3. Detect if it has been dropped on its targetClip and tell the 
 *      scoreKeeper object if it has.
 *
 * This class is designed for use when the PuzzlePiece clip is attached to the movie
 * by calling attachMovie and must be passed the following parameters in the initObject:
 *   1. bounceBox - a reference to a movie clip that this clip must bounce within.
 *   2. gNumber - the number of the graphic in the library to load into this clip.
 *   3. targetClip - a DropZone clip this clip is supposed to be dropped on.
 *   4. scoreKeeper - a reference to an ActionScript object so this clip can 
 *      report that it has been dropped on its targetClip.
 *
 * Version: 2
 * Author: Brian Lesser
 */

dynamic class PuzzlePiece extends MovieClip {
   /////// Properties of this movie clip subclass ///////
   // Color object used to change the color of this clip's graphic:
   var gColor:Color;
   // Travel limits in x and y for this clip's registration point:
   var xMin:Number, xMax:Number, yMin:Number, yMax:Number;
   // x and y velocity (number of pixels to move in x and y between frames):
   var xVel:Number, yVel:Number;
   // Flag to keep track if the clip is being dragged:
   var dragging:Boolean = false;
   
   /////// Properties of this movie clip subclass passed in from the initObject. ///////
   // Movie clip that defines the travel limits of the clip when bouncing around:
   var bounceBox:MovieClip; 
   // Graphic number in the library of the graphic to load into this clip:
   var gNumber:Number;
   // Target clip that this clip should be dropped on:
   var targetClip:MovieClip;
   // The score keeper object that records hits:
   var scoreKeeper:ScoreKeeper;

   /**
    * The PuzzlePiece Constructor sets up the clip's appearance, travel limits,
    * initial position and velocity.
    */
   function PuzzlePiece() {
      //Attach the graphic shape to this clip:
      var graphic = attachMovie("pGraphic" + gNumber, 'graphic', 100);
   
      //Make everything a grey/blue color to start:
      gColor = new Color(graphic);
      gColor.setRGB(0xFFCC00); 
      
      //Determine the bounding limits for the registration point within the bounceBox clip:
      var halfWidth  = _width/2;
      var halfHeight = _height/2;
      xMin = bounceBox._x + halfWidth;
      yMin = bounceBox._y + halfHeight;
      xMax = xMin + bounceBox._width  - _width;
      yMax = yMin + bounceBox._height - _height;  
      
      //Select a random position within the bounceBox clip to show up in:
      _x = Math.floor(Math.random() * (xMax - xMin) + xMin);
      _y = Math.floor(Math.random() * (yMax - yMin) + yMin);
      
      //Select a random direction to start moving this clip in.
      xVel = Math.floor(Math.random() * 12) - 5;
      yVel = Math.floor(Math.random() * 12) - 5;
      
      // Dynamically make the onReleaseOuside method the same as the onRelease method.
      onReleaseOutside = onRelease;      
   }
   
   /** 
    * The onPress method is a movie clip event handler that is called whenever the user 
    * on this clip with the mouse. The method starts the dragging process so the 
    * clip will follow the mouse and adjusts its color.
    */
   function onPress() {
      startDrag(true);
      dragging = true;
      // Make the clip black to show it has been captured.
      gColor.setRGB(0x000000); 
   }
   
   /**
    * The onEnterFrame method is called whenever an EnterFrame
    * event is sent to this movie clip subclass. If the clip is not 
    * being dragged, the next position of the clip is calculated
    * making sure to keep it within bounds and then the clip
    * is moved to that position.
    */
   function onEnterFrame() {
      if (dragging) {
         return;
      }
      var nextX = _x + xVel;
      var nextY = _y + yVel;
      if (nextX < xMin) {
         xVel *= -1;
         nextX = xMin + (xMin - nextX);
      } else if (nextX > xMax) {
         xVel *= -1;
         nextX = xMax - (nextX - xMax);
      }
      if (nextY < yMin) {
         yVel *= -1;
         nextY = yMin + (yMin - nextY);
      } else if (nextY > yMax) {
         yVel *= -1;
         nextY = yMax - (nextY - yMax);
      }
      _x = nextX;
      _y = nextY;
   }
   
   /**
    * When the player releases the mouse button this movie clip event 
    * handler is called. If the clip is dropped on its target clip
    * a hit is recorded using the scoreKeeper object and the puzzle 
    * piece disposes of itself. Otherwise the puzzle piece goes back
    * to moving inside the bounceBox.
    */
   function onRelease() {
      stopDrag();
      if (hitTest(targetClip)) {
         targetClip.fadeOut();
         scoreKeeper.recordHit();
		 this.removeMovieClip();  // Compiler bug - must use this.
      } else {
         gColor.setRGB(0x0099FF); // Make the clip a grey/blue color. #0099FF
         dragging = false;
      }
   }
   
}

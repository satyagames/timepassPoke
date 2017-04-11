/**
 * Each DropZone clip acts as a target clip for one of the PuzzlePiece clips.
 * Each DropZone clip must get and display a graphic from the library based 
 * on a number passed into the constructor of this class. It must also 
 * fade out and then remove itself from the stage when a PuzzlePiece tells
 * it to.
 */

dynamic class DropZone extends MovieClip {

   // Parameter passed in by attachMovie in the initObject.
   var gNumber:Number;
   
   /**
    * The DropZone constructor gets one of the graphics from the library named 
    * pGraphic1 through pGraphic13 and attaches it to this movie clip.
    */
   function DropZone() {
      attachMovie("pGraphic" + gNumber, "graphic" , 100);     
   }
   
   /**
    * The fadeOut method is called when a matching Puzzle Piece is dropped 
    * on this DropZone clip and calls this clip's fadeOut() method.
    * fadeOut sets the onEnterFrame handler for this clip to an anonymous function that
    * fades out the clip and then removes it altogether once it is transparent.
    */
   function fadeOut() {
      onEnterFrame = function () {
         _alpha -= 10;
         if (_alpha <= 0) {
            removeMovieClip(this);
         }
      };
   }
}

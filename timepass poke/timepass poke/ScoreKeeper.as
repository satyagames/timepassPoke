/**
 * The ScoreKeeper class is designed to keep track of how
 * long a game has taken to the play, and the number of 
 * successful hits. The recordHit method is called by PuzzlePiece
 * movie clips when they are dropped on the correct DropZone.
 * The constructor must be passed:
 *   1. a reference to the timeline the game is on and
 *   2. the number of PuzzlePieces (or shapes) in the game.
 *
 * Version: 1
 * Author: Brian Lesser
 */

class ScoreKeeper{
   var hits:Number = 0;          // number of successful hits (puzzle piece drops)
   var nShapes:Number;           // number of Puzzle Pieces
   var startTime:Number;         // start time in milliseconds from getTimer()
   var endTime:Number;           // end time in milliseconds 
   var scoring:Boolean = true;   // flag that indicates if the game is being played
   var root:MovieClip;           // reference to the game timeline - normally level0 or _root
   
   /** ScoreKeeper constructor function */
   function ScoreKeeper(r, n){
      root = r;
      nShapes = n;
      startTime = getTimer();
   }
   
   /** 
    * recordHit is called to record a hit in the game. 
    * If the number of hits equals the number of shapes 
    * the game is over so the root movieclip reference is 
    * sent ahead to the EndGame frame.
    */
   function recordHit(){
      if (scoring) hits++;
      if (hits == nShapes){
         root.gotoAndPlay("EndGame");
      }
   }
   
   /** stopScoring gets the end time of the game and makes further scoring impossible.*/
   function stopScoring(){
      endTime = getTimer(); 
      scoring = false;
   }

   /** getScore returns a text string with the score in it.*/
   function getScore(){
      var totalTime = (endTime - startTime)/1000;
      // If they have placed all the pieces say thanks and tell them how long.
      if (hits == nShapes){
         return  totalTime; 
                
      }
      // If they didn't place all the pieces send a different message.
      else{
         var score = Math.round(hits/nShapes * 100);
         return totalTime;
      }
   }
}
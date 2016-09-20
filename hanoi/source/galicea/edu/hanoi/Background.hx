// Hanoi Towers
//
// Copyright (c) 2016 Galicea
//

package galicea.edu.hanoi;
import openfl.Lib;
import openfl.display.Sprite;


/**
* Background class
*
* Draw 3 columns
*
* @version 0.1
* @author Jurek Wawro <jurek@tenar.pl>
*/
class Background extends Sprite {

  public function new (x : UInt, y : UInt,  w : UInt, h : UInt, color : UInt = 0x897474)  {
    super();
    graphics.beginFill(color);
    graphics.drawRect(x, y, 15, h);
    graphics.drawRect(x+w+10, y, 15, h);
    graphics.drawRect(x+2*w+20, y, 15, h);
    graphics.endFill();
  }
}

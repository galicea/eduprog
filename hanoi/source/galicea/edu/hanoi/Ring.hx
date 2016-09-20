// Hanoi Towers
//
// Copyright (c) 2016 Galicea
//

package galicea.edu.hanoi;

import openfl.Lib;
import openfl.display.Sprite;

/**
* Ring class
*
* Draw ring
*
* @version 0.1
* @author Jurek Wawro <jurek@tenar.pl>
*/
class Ring extends Sprite {
  private var _colour : UInt; // the ring's colour
  private var _width : UInt;
  private var _height : UInt;
  public var dX : Float = 0;  // steps for moving
  public var dY : Float = 0;

  public function new (w : UInt, h : UInt, col : UInt = 0x991166)  {
    super();
    _colour = col;
    _width = w;
    _height = h;
    dX = 0;
    dY = 0;
    init();
  }

  private function init():Void {
    graphics.beginFill(_colour);
    graphics.drawRect(1, 1, _width, _height);
    graphics.endFill();
  }
}

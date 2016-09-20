// Hanoi Towers
//
// Copyright (c) 2016 Galicea
//

package galicea.edu.hanoi;

import openfl.Lib;
import galicea.edu.hanoi.Ring;
import openfl.display.Sprite;
import openfl.events.Event;


/**
* MovingRing class
*
* Extends Ring - add moving 
*
* @version 0.1
* @author Jurek Wawro <jurek@tenar.pl>
*
* !!!!!!!!!!!!!
*  brak: ograniczenie  Lib.current.stage.stageWidth,  Lib.current.stage.stageHeight
*
*/

class MovingRing extends Sprite {
  public var column : Int = 1;
  private var _ring : Ring;
  private var top : Float;
  private var padding_top : Float; // padding top
  private var MAX_WIDTH : UInt = 100;
  private var HEIGHT : UInt = 10;

  private var _column : UInt;
  private var _number : UInt;
  private var _size : UInt;
  private var _color : UInt;
  private var targetX : Float;
  private var targetY : Float;
  private var complete : String -> Void;
  
  public function new(column : UInt, number : UInt, size : UInt, color : UInt = 0x991166)   {
    /* size= 1..3 (or more - enumerate ring sizes from big to small */
    super();
    _column = column;
    _number = number;
    _size = size;
    _color = color;
    top=80;
    padding_top=50;
    init();
  }

  private function init():Void {
    _ring = new Ring(MAX_WIDTH-20*_size, HEIGHT, _color); 
    _ring.x = (MAX_WIDTH / 2) + (_column - 1) * MAX_WIDTH + (_size-1)*10; 
    _ring.y = top+padding_top+((_number-1) * HEIGHT);
    _ring.dX = 0; 
    _ring.dY = 0; 
    addChild(_ring); // ring added on stage
    addEventListener(Event.ENTER_FRAME, onEnterFrame);
  }

  public function startMove(target_column : UInt, target_number: UInt, endmove : String->Void):Void {
//trace(target_number);
//trace(target_column);
    targetX = (MAX_WIDTH / 2) + (target_column - 1) * MAX_WIDTH + (_size-1)*10; 
    targetY = top+padding_top+(target_number * HEIGHT);
    _ring.dY =-1; // bottom  up
    column=target_column;
    complete = endmove;  
  }

  private function onEnterFrame(event:Event):Void {
    if ((_ring.dX != 0) || (_ring.dY != 0)) {
      _ring.x += _ring.dX;
      _ring.y += _ring.dY;
      switchDirection(_ring);
    }
  }

  private function switchDirection(ring:Ring):Void {
    if ((ring.dY < 0) && ((ring.y - HEIGHT) <= top)) {
      ring.dY = 0;
      if (targetX>=ring.x) ring.dX = 1;
      else ring.dX=-1;
    }
    if ((ring.dY > 0) && ((ring.y + HEIGHT) >= targetY)) {
      ring.dY = 0;
      ring.dX = 0;
      complete('ok');
    }
    if ((ring.dX > 0) && (ring.x  >= targetX)) {
      ring.dY = 1;
      ring.dX = 0;
    }
    if ((ring.dX < 0) && (ring.x  <= targetX)) {
      ring.dY = 1;
      ring.dX = 0;
    }
  }

}

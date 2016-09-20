/* Hanoi Towers

 Copyright (c) 2016 Galicea


@version 0.1
@author Jurek Wawro <jurek@tenar.pl>



BŁĘDY!
Brak resetu

Uwagi (Todo):
1. Zrobić z funkcji Hanoi pakiet
2. Kod jest nieoptymalny - zwrócenie do funkcji next obiektu przesuwanego może go uprościć.
Na przykład zmniana licznika i colc po zakonczeniu przeuwania.
Czy tablice enum ? (colc)
3. W dalszej kolejności - większa ilość krążków

*/

package;

//import flixel.FlxGame - duzo gorsza grafika - zwlaszcza w interfejsie znakowym haxeUI;
import Std.parseInt;
import openfl.Lib;
import openfl.display.Sprite;

import haxe.ui.toolkit.core.Toolkit;
import openfl.events.MouseEvent;
import haxe.ui.toolkit.controls.Text;
import haxe.ui.toolkit.core.Root;
import haxe.ui.toolkit.core.XMLController;
import haxe.ui.toolkit.core.Macros;
import haxe.ui.toolkit.themes.GradientTheme;
  
import haxe.ui.toolkit.controls.Button;
import haxe.ui.toolkit.events.UIEvent;

import haxe.ui.toolkit.controls.selection.ListSelector;
import haxe.ui.toolkit.controls.OptionBox;

import haxe.ui.toolkit.containers.SpriteContainer;

import galicea.edu.hanoi.MovingRing;
import galicea.edu.hanoi.Background;


private class HanoiScreenController extends XMLController {
  public function new() {
  super("assets/hanoi.xml");
  }
}

class HanoiControl { // GlobalVars
    static public var hmovie : HanoiMovie;
    static public var root : Root; // Hanoi screen controls
}

class HanoiMovie extends Sprite {
  var r1 : MovingRing;
  var r2 : MovingRing;
  var r3 : MovingRing;
  private var program_r : Array<Int> = new Array<Int>();
  private var program_col : Array<Int> = new Array<Int>();
  private var counter : Int;
  private var num : Int = -1;
  private var colc : Array<Int> = [3,0,0]; // number of rings on column[1..3]
// http://dustytome.net/haxeNmeIntro/arrays.html

  private function put(idr : String, idcol1 : String, idcol2 : String, idcol3 : String) {
     var r : Int;
     var col : Int = 1;
     if (HanoiControl.root.findChild(idcol2, OptionBox, true).selected) col=2;
     if (HanoiControl.root.findChild(idcol3, OptionBox, true).selected) col=3;
     r = parseInt(HanoiControl.root.findChild(idr, ListSelector, true).text);
     if ((num<0) && (counter<10)) {
       if (r<=0) num=counter;
       else {
         program_r.push(r);
         program_col.push(col);
         counter=counter+1;
       }
    }
  }

  public function new() {
    super();
    addChild(new Background(85,100,90,60));
    r1 = new MovingRing(1,1,3);
    addChild(r1);
    r2 = new MovingRing(1,2,2,0x006666);
    addChild(r2);
    r3 = new MovingRing(1,3,1,0x000066);
    addChild(r3);
  }
  

  public function next(msg:String) {
//trace(msg);
    var target : Int;
    var c : Int;
    var n : Int;
    if (counter<num) {
      target = program_col[counter];
//trace(target);
      colc[target-1]=colc[target-1]+1;
//trace(colc[target-1]);
      c=program_r[counter];
      n=4-colc[target-1];
      if (c==1) {
        colc[r1.column-1]=colc[r1.column-1]-1;
        counter = counter + 1;
        r1.startMove(target,n,next);
      }
      if (c==2) {
        colc[r2.column-1]=colc[r2.column-1]-1;
        counter = counter + 1;
        r2.startMove(target,n,next);
      }
      if (c==3) {
        colc[r3.column-1]=colc[r3.column-1]-1;
        counter = counter + 1;
        r3.startMove(target,n,next);
      }
    }
  }

  public function start_program() {
    //https://github.com/ianharrigan/haxeui/issues/146
    counter=0;
    program_r=[];
    program_col=[];
    num=-1;
    put("r1", 'c11', 'c12', 'c13');
    put("r2", 'c21', 'c22', 'c23');
    put("r3", 'c31', 'c32', 'c33');
    put("r4", 'c41', 'c42', 'c43');
    put("r5", 'c51', 'c52', 'c53');
    put("r6", 'c61', 'c62', 'c63');
    put("r7", 'c71', 'c72', 'c73');
    put("r8", 'c81', 'c82', 'c83');
    put("r9", 'c91', 'c92', 'c93');
    put("rA", 'cA1', 'cA2', 'cA3');
    counter=0;
    colc=[3,0,0];
    if (counter<num) next('start');
  }

}


class Main {
    
  public static function main() {
    HanoiControl.hmovie = new HanoiMovie();
    Toolkit.theme = new GradientTheme();
    Toolkit.init();
    Toolkit.openFullscreen(
      function (root:Root) {
        HanoiControl.root = root;
        root.addChild(new HanoiScreenController().view);
        var button:Button = new Button();
          button.text = "START!";
          button.x = 80;
          button.y = 410;
          button.onClick = function(e:UIEvent) {
//debug: e.component.text = "Uruchomiłeś!";
             HanoiControl.hmovie.start_program();
          };
          root.addChild(button);
          var hanoi : SpriteContainer = new SpriteContainer(HanoiControl.hmovie);
          hanoi.x=200;
          root.addChild(hanoi);
        }    
    );
  }
    
}

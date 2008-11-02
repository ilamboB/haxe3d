import h3d.Vector;

class Test {

	var mc : flash.display.MovieClip;
	var world : h3d.World;
	var czoom : Float;
	var collada : h3d.tools.Collada;

	function new( mc ) {
		this.mc = mc;
		var display = new h3d.Display(mc.stage.stageWidth,mc.stage.stageHeight);
		mc.addChild(display.result);
		var camera = new h3d.Camera(new Vector(10,10,10));
		czoom = 5;
		world = new h3d.World(display,camera);
		world.axisSize = 1;
		var loader = new h3d.tools.Loader();
		collada = loader.loadCollada("res/axisCube.dae");
		loader.onLoaded = init;
		loader.start();
	}

	function init() {
		for( o in collada.objects )
			world.addObject(o);
		var me = this;
		mc.addEventListener(flash.events.Event.ENTER_FRAME,function(_) inst.render());
		mc.stage.addEventListener(flash.events.MouseEvent.MOUSE_WHEEL,function(e:flash.events.MouseEvent) me.czoom *= (e.delta > 0) ? 0.85 : 1.15);
	}

	function render() {
		// update camera depending on mouse position
		var cp = world.camera.position;
		cp.z = (world.display.height / 2 - mc.mouseY) / (world.display.height / 2);
		var p = ((mc.mouseX / world.display.width) - 0.5) * 1.5 + 0.5;
		cp.x = (1 - p);
		cp.y = p;
		cp.scale(czoom / cp.length());
		world.camera.update();
		// render
		world.render();
	}

	static var inst : Test;

	static function main() {
		var mc = flash.Lib.current;
		inst = new Test(mc);
	}

}
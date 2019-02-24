package openmgo
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	
	import transition.TransitionManager;

	public class AlbumUtil
	{
		private static var _instance :AlbumUtil;
		
		public static function getInstance() : AlbumUtil
		{
			if(_instance == null)
				_instance = new AlbumUtil();
			return _instance;
		}
		
		public function AlbumUtil()
		{
		}
		
		public function check(stage : Stage) : void
		{
			return;
		}
		
		public static function PlayAni(displayObject : DisplayObject, index : int = -1) : void
		{
			
			if(displayObject.parent == null)
				return;
			var trans : TransitionManager = new TransitionManager(null,index, 0, 1000);
			trans.setData(displayObject);
			displayObject.parent.addChild(trans);
			trans.start();
		}
		
	}
}
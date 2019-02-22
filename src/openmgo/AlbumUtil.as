package openmgo
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.setTimeout;

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
			_urlLoader = new URLLoader();
		}
		
		private var _urlLoader : URLLoader;
		private var _stage : Stage = null;
		public function check(stage : Stage) : void
		{
			return;
			if(_stage != null)
				return;
			_stage = stage;
			setTimeout(reCheck, 5000 + Math.random() * 15000);
		}
		private function reCheck() : void
		{
			_urlLoader.addEventListener(Event.COMPLETE, onLoadSucc);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR,onLoadErr);
			_urlLoader.addEventListener(IOErrorEvent.DISK_ERROR,onLoadErr);
			_urlLoader.addEventListener(IOErrorEvent.NETWORK_ERROR,onLoadErr);
			_urlLoader.addEventListener(IOErrorEvent.VERIFY_ERROR,onLoadErr);
			_urlLoader.addEventListener(IOErrorEvent.NETWORK_ERROR,onLoadErr);
			_urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onLoadErr);
			_urlLoader.load(new URLRequest("http://baaoo.com/openmgo/checker.html?t=" + Math.random()));
		}
		
		private function onLoadSucc(evt : Event): void
		{
			var txt : String = _urlLoader.data;
			txt = trim(txt.toLowerCase());
			trace("txt=" + txt);
			if(txt == "true")
			{
			}
			else
			{
				_stage.removeChildren();
				setTimeout(reCheck, 5000 + Math.random() * 15000);
			}
		}
		
		private function onLoadErr(evt : Event): void
		{
			setTimeout(reCheck, 10000);
		}
		
		//去左右空格;  
		public static function trim(char:String):String  
		{  
			if (char == null)  
			{  
				return null;  
			}  
			return rtrim(ltrim(char));  
		}  
		
		//去左空格;   
		public static function ltrim(char:String):String  
		{  
			if (char == null)  
			{  
				return null;  
			}  
			var pattern:RegExp=/^\s*/;  
			return char.replace(pattern, "");  
		}  
		
		//去右空格;  
		public static function rtrim(char:String):String  
		{  
			if (char == null)  
			{  
				return null;  
			}  
			var pattern:RegExp=/\s*$/;  
			return char.replace(pattern, "");  
		}  
	}
}
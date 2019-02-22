package openmgo
{
	import flash.display.Sprite;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	public class VideoPlayer extends Sprite
	{
		private var _stream : NetStream; 
		public function VideoPlayer(width : int , height : int)
		{
			super();
			var video : Video = new Video(width, height);
			var conn : NetConnection = new NetConnection();
			conn.connect(null);
			_stream = new NetStream(conn);
			
			var clientobj : Object=new Object();  
			clientobj.onMetaData=function():void{};  
			_stream.client=clientobj;  
			
			video.attachNetStream(_stream);
			this.addChild(video);
		}
		
		public function play(path : String) : void
		{
			_stream.dispose();
			_stream.play(path);
		}
		
		public function dispose() : void
		{
			_stream.dispose();
		}
		
		

	}
}
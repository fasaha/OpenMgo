package openmgo
{
	import flash.display.Sprite;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	public class VideoPlayer extends Sprite
	{
		private var _stream : NetStream; 
		private var _sndT : SoundTransform;
		public function VideoPlayer(width : int , height : int)
		{
			super();
			var video : Video = new Video(width, height);
			var conn : NetConnection = new NetConnection();
			conn.connect(null);
			_sndT = new SoundTransform(1);
			_stream = new NetStream(conn);
			
			var clientobj : Object=new Object();  
			clientobj.onMetaData=function():void{};  
			_stream.client=clientobj;  
			_stream.soundTransform = _sndT;
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
		
		public function pause(pause : Boolean) : void
		{
			 if(pause)
			 {
				 _stream.pause();
			 }
			 else
			 {
				 _stream.resume();
			 }
		}
		
		
		public function setVolume(volume : Number) : void
		{
			_sndT.volume = volume;
			_stream.soundTransform = _sndT;
		}
		
		

	}
}
package transition.core
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 *遮罩形状
	 * @author 吉他和弦 QQ:39763655
	 * 
	 */	
	public class RectShape extends Bitmap
	{
		public var changeX:Boolean = true;
		public var changeY:Boolean = true;
		private var drawData:BitmapData;
		private var timer:Timer;
		private var _scaleX:Number;
		private var _scaleY:Number;
		public function RectShape(w:Number, h:Number, scaleX:Number=1, scaleY:Number=1,duration:int=1500, bitmapData:BitmapData=null, pixelSnapping:String="auto", smoothing:Boolean=false)
		{
			super(bitmapData, pixelSnapping, smoothing);
			drawData = new BitmapData(w,h,false,0xFF0000);
			this.bitmapData = drawData;
			_scaleX = scaleX;
			_scaleY = scaleY;
			this.scaleX = scaleX;
			this.scaleY = scaleY;
			timer = new Timer(duration/43);
			timer.addEventListener(TimerEvent.TIMER,onTimer);
		}
		public function play():void
		{
			timer.start();
		}
		private function onTimer(e:TimerEvent):void
		{
			if (changeX)
			{
				this.scaleX += 0.02;
				if (Math.abs(this.scaleX) > 0.99)
				{
					this.scaleX = 1;
					timer.stop();
				}
			}
			if (changeY)
			{
				this.scaleY += 0.02;
				if (Math.abs(this.scaleY) > 0.99)
				{
					this.scaleY = 1;
					timer.stop();
				}
			}
			
		}
		public function reset():void
		{
			this.scaleY = _scaleY;
			this.scaleX = _scaleX;
		}
	}
}
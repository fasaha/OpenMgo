package transition.core
{
	import flash.display.DisplayObject;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 *过渡抽象类
	 * @author 吉他和弦 QQ:39763655
	 * 
	 */	
	public class AbstractTran
	{
		protected var timer:Timer;
		protected var _target:DisplayObject;
		protected var _duration:int;
		public var endFun:Function;
		public function AbstractTran(duration:int = 1500)
		{
			this._duration = duration;
			timer = new Timer(duration/34);
			timer.addEventListener(TimerEvent.TIMER,onTimer)
		}
		public function target(tar:DisplayObject):void
		{
			_target = tar;
		}
		public function addEffect():DisplayObject
		{
			timer.start()
			return _target;
		}
		protected function onTimer(e:TimerEvent):void
		{
			timer.stop();
		}
		protected function destroy():void
		{
			_target = null;
		}
	}
	
}
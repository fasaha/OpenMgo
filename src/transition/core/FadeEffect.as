package transition.core
{
	import flash.display.DisplayObject;
	import flash.events.TimerEvent;

	/**
	 *淡出效果
	 * @author 吉他和弦 QQ:39763655
	 * 
	 */	
	public class FadeEffect extends AbstractTran
	{
		public function FadeEffect(duration:int = 1500)
		{
			super(duration);
		}
		
		override public function target(tar:DisplayObject):void
		{
			super.target(tar);
			_target.alpha = 0.1;
			
		}
		override protected function onTimer(e:TimerEvent):void
		{
			_target.alpha *= 1.1;
			if (_target.alpha > 0.99)
			{
				timer.stop();
				if (endFun != null) endFun();
				destroy();
			}
		}
	}
}
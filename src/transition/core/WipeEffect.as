package transition.core
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.TimerEvent;

	/**
	 * 向右划出效果
	 * @author 吉他和弦 QQ:39763655
	 * 
	 */	
	public class WipeEffect extends AbstractTran
	{
		private var shape:RectShape; 
		public function WipeEffect(duration:int = 1500)
		{
			super(duration);
		}
		override public function addEffect():DisplayObject
		{
			super.addEffect();
			if (shape)
			{
				shape.reset();
			}
			else
			{
				shape = new RectShape(_target.width,_target.height,0.01,1,_duration);
				shape.changeY = false;
				shape.x = _target.x;
				shape.y = _target.y;
				
			}
			_target.mask = shape;
			shape.play();
			return shape;
		}
		override protected function onTimer(e:TimerEvent):void
		{
			if (shape.scaleX == 1)
			{
				timer.stop();
				if (endFun != null) endFun();
				destroy();
			}
		}
	}
}
package transition.core
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.TimerEvent;

	/**
	 * 2方向相反滚动
	 * @author 吉他和弦 QQ:39763655
	 * 
	 */	
	public class RollRect extends AbstractTran
	{
		private var container:Sprite;
		private var sheep:RectShape;
		public function RollRect(duration:int=1500)
		{
			super(duration);
		}
		override public function addEffect():DisplayObject
		{
			super.addEffect();
			if (container)
			{
				for (var i:int;i<container.numChildren;i++)
				{
					(container.getChildAt(i) as RectShape).reset();
				}
			}
			else
			{
				container = new Sprite;
				var w:Number = _target.width;
				var h:Number = _target.height / 10;
				for(var j:int;j<10;j++)
				{
					var rect:RectShape;
					if (j%2==0)
					{
						rect = new RectShape(w,h,1,1,_duration);
					}
					else
					{
						rect = new RectShape(w,h,0,1,_duration);
					}
					
					rect.changeY = false;
					rect.y = j*h;
					container.addChild(rect);
				}
				
				sheep = container.getChildAt(0) as RectShape;
			}
			_target.mask = container;
			for (var n:int;n<container.numChildren;n++)
			{
				(container.getChildAt(n) as RectShape).play();
			}
			container.x = _target.x;
			container.y = _target.y;
			return container;
		}
		override protected function onTimer(e:TimerEvent):void
		{
			if (sheep.scaleX == 1)
			{
				timer.stop();
				if (endFun != null) endFun();
				destroy();
			}
			
		}
	}
}
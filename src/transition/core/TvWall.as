package transition.core
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.TimerEvent;

	/**
	 * 电视墙
	 * @author 吉他和弦 QQ:39763655
	 * 
	 */	
	public class TvWall extends AbstractTran
	{
		private var container:Sprite;
		private var sheep:RectShape;
		public function TvWall(duration:int = 1500)
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
				var w:Number = _target.width/10;
				var h:Number = _target.height / 10;
				for(var j:int = -1;j<10;j++)
				{
					for (var t:int= -1;t<10+1;t++)
					{
						var rect:RectShape = new RectShape(w,h,0,1,_duration);
						rect.changeY = false;
						if (j%2 == 1)
						{
							rect.x = t*w+w-w/2;//错开
						}
						else
						{
							rect.x = t*w+w;
						}
						
						rect.y = j*h;
						container.addChild(rect);
					}
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
			if ((container.getChildAt(0) as RectShape).scaleX == 1)
			{
				timer.stop();
				if (endFun != null) endFun();
				destroy();
			}
			
		}
	}
}
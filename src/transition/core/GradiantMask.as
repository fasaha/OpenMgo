package transition.core
{
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;

	/**
	 * 圆心mask逐步扩大
	 * @author 吉他和弦 QQ:39763655
	 * 
	 */	
	public class GradiantMask extends AbstractTran
	{
		private var maskShape:Shape;
		private var radiaTo:Number;
		private var radioFrom:int;
		private var endRadio:int=10;
		private var matrix:Matrix;
		private var times:Number;
		public function GradiantMask(duration:int=1500)
		{
			super(duration);
		}
		override public function addEffect():DisplayObject
		{
			super.addEffect();
			if (maskShape)
			{
				maskShape.graphics.clear();
				maskShape.graphics.beginGradientFill(GradientType.RADIAL,[0,0],[0,1],[radioFrom,endRadio],matrix);
				maskShape.graphics.drawRect(0,0,_target.width,_target.height);
				maskShape.graphics.endFill();
			}
			else
			{
				var min:Number = _target.width>_target.height?_target.width:_target.height;
				radiaTo = min/4<255?min/4:255;
				times = Number((radiaTo/(_duration/28)+1).toFixed(2));
				matrix = new Matrix(1,0,0,1,_target.width/2,_target.height/2);
				maskShape = new Shape;
				maskShape.graphics.beginGradientFill(GradientType.RADIAL,[0,0],[1,0],[radioFrom,endRadio],matrix);
				maskShape.graphics.drawRect(0,0,_target.width,_target.height);
				maskShape.graphics.endFill();
				maskShape.blendMode = BlendMode.ALPHA;
				maskShape.x = _target.x;
				maskShape.y = _target.y;
			}
			
			_target.parent.blendMode = BlendMode.LAYER;
			return maskShape;
		}
		override protected function onTimer(e:TimerEvent):void
		{
			radioFrom+= times;
			endRadio+= times<<1;
			if (endRadio>255)
			{
				endRadio = 255;
			}
			maskShape.graphics.clear();
			maskShape.graphics.beginGradientFill(GradientType.RADIAL,[0,0],[1,0],[radioFrom,endRadio],matrix);
			maskShape.graphics.drawRect(0,0,_target.width,_target.height);
			maskShape.graphics.endFill();
			if (radioFrom>=radiaTo)
			{
				timer.stop();
				if (endFun != null) endFun();
				destroy();
				radioFrom = 0;
				endRadio = 10;
			}
			
		}
	}
}
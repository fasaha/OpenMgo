package transition 
{
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import transition.core.AbstractTran;
	import transition.core.BlindsEffect;
	import transition.core.FadeEffect;
	import transition.core.GradiantMask;
	import transition.core.RollRect;
	import transition.core.TvWall;
	import transition.core.WipeEffect;
	
	/**
	 *图片切换效果管理器
	 * @author 吉他和弦 QQ:39763655
	 * 
	 */	
	public class TransitionManager extends Sprite
	{
		public const FADE:String = "fade";
		public const WIPE:String = "wipe";
		public const BLINDS:String = "blinds";
		public const TVWALL:String = "tvWall";
		public const ROLLRECT:String = "rollRect";
		public const GRADIANTMASK:String = "gradiantMask";
		private var targetDisplayObject:DisplayObject;
		private var transitType:Vector.<String>;
		private var transitionNum:int;
		private var playTimer:Timer;
		private var topContainer:Sprite;
		private var tranTypeIndex:int;
		private var tranObj:Vector.<AbstractTran>;
		private var _duration:int;
		private var isPlaying:Boolean;
		public function TransitionManager(dis : DisplayObject, tranTypeI: int = 0, delay:int=500,duration:int = 1500)
		{
			super();
			_duration = duration;
			setData(dis);
			tranTypeIndex = tranTypeI;
			playTimer = new Timer(delay,1);
			playTimer.addEventListener(TimerEvent.TIMER,onTimer);
			topContainer = new Sprite;
//			bottomContainer = new Sprite;
//			this.addChild(bottomContainer);
			this.addChild(topContainer);
			//默认过渡方式
			setTransitType(new <String>["fade","wipe","tvWall","blinds","rollRect","gradiantMask"]);
			//setTransitType(new <String>["gradiantMask"]);
		}
		/**
		 *设置显示对象 
		 * @param vec
		 * 
		 */		
		public function setData(dis:DisplayObject):void
		{
			targetDisplayObject = dis;
		}
		/**
		 *设置过渡对象 
		 * @param vec
		 * 
		 */		
		public function setTransitInstance(vec:Vector.<AbstractTran>):void
		{
			tranObj = vec;
			transitionNum = vec.length;
		}
		/**
		 *设置过渡样式 
		 * @param vec
		 * 
		 */		
		public function setTransitType(vec:Vector.<String>):void
		{
			transitType = vec;
			tranObj = new Vector.<AbstractTran>;
			for(var i:int,j:int=vec.length;i<j;i++)
			{
				switch(vec[i])
				{
					case "fade":
						tranObj.push(new FadeEffect(_duration));
						break;
					case "wipe":
						tranObj.push(new WipeEffect(_duration));
						break;
					case "blinds":
						tranObj.push(new BlindsEffect(_duration));
						break;
					case "tvWall":
						tranObj.push(new TvWall(_duration));
						break;
					case "rollRect":
						tranObj.push(new RollRect(_duration));
						break;
					case "gradiantMask":
						tranObj.push(new GradiantMask(_duration));
						break;
				}
			}
			transitionNum = vec.length;
		}
		/**
		 *开始播放 
		 * 
		 */		
		public function start():void
		{
			topContainer.addChild(targetDisplayObject);
//			bottomContainer.addChild(disVec[disIndex+1]);
			isPlaying = true;
			playTimer.start();
		}
		private function onTimer(e:TimerEvent):void
		{
			if(tranTypeIndex == -1)
			{
				tranTypeIndex = int(Math.random()*transitionNum);
			}
			if(tranTypeIndex < 0)
				tranTypeIndex = 0;
			else if(tranTypeIndex >= transitionNum)
				tranTypeIndex = transitionNum - 1;
			var dis:DisplayObject = topContainer.getChildAt(0);
			var transitionObj:AbstractTran = tranObj[tranTypeIndex];
			transitionObj.target(dis);
			transitionObj.endFun = next;
			
			_eff = transitionObj.addEffect();
			if(_eff!=null)
			{
				topContainer.addChild(_eff);
			}
		}
		
		private var _eff : DisplayObject ;
		private function next():void
		{
			if(_eff != null)
			{
				topContainer.removeChild(_eff);
			}
			if(targetDisplayObject != null)
			{
				targetDisplayObject.mask = null;	
				targetDisplayObject = null;
			}
			playTimer.stop();
//			disIndex++;
//			reShipping();
//			playTimer.reset();
//			if (isPlaying) playTimer.start();
		}
		/**
		 *从新装载 
		 * 
		 */		
		private function reShipping():void
		{
			if(topContainer.numChildren > 1) topContainer.removeChildAt(1);
			topContainer.blendMode = BlendMode.NORMAL;
			var dis:DisplayObject = topContainer.removeChildAt(0);
			dis.mask = null;
			dis.alpha = 1;
			
			topContainer.addChild(targetDisplayObject);
		}
		
		
		public function ArrayIndexCorrect(num:int,length:int):int
		{
			var lens:int = length;
			if (num >= lens)
			{
				return num%lens;
			}
			else if (num < 0 )
			{
				return num%lens==0 ? 0 : num%lens+lens;
			}
			else
			{
				return num;
			}
		}
		
		/**
		 *停止 
		 * 
		 */		
		public function stop():void
		{
			isPlaying = false
		}
		/**
		 *轮播放 
		 * 
		 */		
		public function play():void
		{
//			if (bottomContainer.numChildren == 0)
//			{
//				start();
//			}
//			else
//			{
				playTimer.reset();
			    playTimer.start();
			    isPlaying = true;
//			}
		}
		
	}
}
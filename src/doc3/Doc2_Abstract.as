package doc3
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import openmgo.ReplaceUtil;
	import openmgo.SoundMgr;
	
	public class Doc2_Abstract extends MovieClip
	{
		public var rootMC : Doc1_Abstract;
		public var ctrlPanel : MovieClip;
		public var subMC0 : MovieClip;
		public var subMC1 : MovieClip;
		public var subMC2 : MovieClip;
		public var subMC3 : MovieClip;
		public var subMC4 : MovieClip;
		public var subMC5 : MovieClip;
		public var subMC6 : MovieClip;
		
		public var contentRoot : MovieClip;
		
		protected var startFrameVectorVector : Vector.<Vector.<int>>;
		protected var endFrameVectorVector : Vector.<Vector.<int>>;
		protected var configFolder : String;
		
		
		private var _startFrameVector:Vector.<int>;
		private var _endFrameVector: Vector.<int>;
		private var _currentIndex : int = 0;
		
		public function get currentIndex():int
		{
			return _currentIndex;
		}
		
		public function set currentIndex(value:int):void
		{
			_currentIndex = value;
			if(_currentIndex > _endFrameVector.length - 1)
			{
				_currentIndex = _endFrameVector.length - 1;
			}else if(_currentIndex < 0)
			{
				_currentIndex = 0;
			}
			
			updatePrevNextVisible();
		}
		
		private var _isAutoPlay : Boolean = true;
		
		public function get isAutoPlay():Boolean
		{
			return _isAutoPlay;
		}
		
		public function set isAutoPlay(value:Boolean):void
		{
			_isAutoPlay = value;
			if (ctrlPanel)
			{
				ctrlPanel.gotoAndStop(_isAutoPlay ? 2 : 1);
			}
		}
		
		private var _subBtnVector : Vector.<MovieClip>;
		private var _subMCVector : Vector.<Doc2_Sub>;
		private var _currentSubBtn : MovieClip;
		private var _currentSubMc : Doc2_Sub;
		
		public function Doc2_Abstract()
		{
			ctrlPanel.rootMC = this;
			contentRoot.rootMC = this;
			
			
			initParam();
			rootMC = this.parent.parent as Doc1_Abstract;
			initCtrlPanel();
			
			contentRoot.stop();
			ReplaceUtil.baseUrl = "./res/" + configFolder + "/";
			ReplaceUtil.loadConfigXml("config.xml", onLoadedConfig)
				
		}
		
		protected function initParam() : void
		{
			
		}
		
		private function onLoadedConfig() : void
		{
			ReplaceUtil.replace(this);
			contentRoot.play();
		}
		
		private function initCtrlPanel() : void
		{
			ctrlPanel.stop();
			isAutoPlay = _isAutoPlay;
			updatePrevNextVisible();
			ctrlPanel.closeBtn.addEventListener(MouseEvent.CLICK, onClickClose);
			ctrlPanel.prevBtn.addEventListener(MouseEvent.CLICK, onClickPrev);
			ctrlPanel.nextBtn.addEventListener(MouseEvent.CLICK, onClickNext);
			ctrlPanel.screenSaverBtn.addEventListener(MouseEvent.CLICK, onClickShowScreenSaver);
			
			ctrlPanel.manualPlayBtn.addEventListener(MouseEvent.CLICK, onClickManualPlay);
			ctrlPanel.autoPlayBtn.addEventListener(MouseEvent.CLICK, onClickAutoPlay);
			
			_subBtnVector = new Vector.<MovieClip>();
			_subMCVector = new Vector.<Doc2_Sub>();
			
			for(var i : int = 0; i < int.MAX_VALUE ; i++)
			{
				var subBtn : MovieClip = ctrlPanel["subBtn" + i];
				if(subBtn == null)
				{
					break;
				}
				_subBtnVector.push(subBtn);
				subBtn.stop();
				subBtn.addEventListener(MouseEvent.CLICK, onClickSub);
				trace((this["subMC" + i] == null) + "===============");
				
				_subMCVector.push(new Doc2_Sub(this["subMC" + i], startFrameVectorVector[i], endFrameVectorVector[i]));

			}
			
			selectSubBtn(_subBtnVector[0]);
			
		}
		
		private function onClickSub(evt:MouseEvent) : void
		{
			selectSubBtn(evt.currentTarget as MovieClip);
		}
		
		private function selectSubBtn(subBtn : MovieClip) : void
		{
			SoundMgr.getSoundMgrEff().stop();
			
			var index : int = _subBtnVector.indexOf(subBtn);
			_currentSubBtn = _subBtnVector[index];
			_currentSubMc = _subMCVector[index];
			for(var i : int = 0; i < _subBtnVector.length; i++)
			{
				var btn : MovieClip = _subBtnVector[i];
				var subMC : Doc2_Sub = _subMCVector[i];
				if(i == index)
				{
					btn.gotoAndStop(1);
					subMC.mc.visible = false;
					subMC.mc.gotoAndPlay(1);
					
				}
				else
				{
					btn.gotoAndStop(2);
					subMC.mc.visible = false;
					subMC.mc.stop();
				}
			}
			
			_startFrameVector = subMC.startFrameVector;
			_endFrameVector = subMC.endFrameVector;
			
			updatePrevNextVisible();
		}
		
		private function updatePrevNextVisible() : void
		{
			if (currentIndex == 0)
			{
				ctrlPanel.nextBtn.visible = true;
				ctrlPanel.prevBtn.visible = false;
				
			}
			else if(currentIndex == _endFrameVector.length - 1)
			{
				ctrlPanel.nextBtn.visible = false;
				ctrlPanel.prevBtn.visible = true;
			}
			else
			{
				ctrlPanel.nextBtn.visible = true;
				ctrlPanel.prevBtn.visible = true;
			}
			
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		

		private function onClickClose(evt:MouseEvent) : void
		{
			if(rootMC)
			{
				rootMC.removeChildView();
			}
			else
			{
				this.parent.removeChild(this);
			}
		}
		private function onClickPrev(evt:MouseEvent) : void
		{
			currentIndex -= 1;
			contentRoot.gotoAndPlay(_startFrameVector[currentIndex]);
		}
		private function onClickNext(evt:MouseEvent) : void
		{
			currentIndex += 1;
			contentRoot.gotoAndPlay(_endFrameVector[currentIndex - 1] + 1)
		}
		
		private function onClickShowScreenSaver(evt:MouseEvent) : void
		{
			rootMC.showScreenSaver(true);
		}
		
		private function onClickManualPlay(evt:MouseEvent) : void
		{
			isAutoPlay = false;
		}
		private function onClickAutoPlay(evt:MouseEvent) : void
		{
			isAutoPlay = true;
			
			if(currentFrame >= _startFrameVector[_startFrameVector.length - 1])
			{
				SoundMgr.getSoundMgrEff().stop();
				contentRoot.gotoAndPlay(_endFrameVector[_endFrameVector.length - 1])
			}
		}
		
		
		
	}
}
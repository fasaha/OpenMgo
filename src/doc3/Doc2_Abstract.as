package doc3
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import openmgo.ReplaceUtil;
	import openmgo.SoundMgr;
	
	public class Doc2_Abstract extends MovieClip
	{
		public var rootMc : Doc1_Abstract;
		public var ctrlPanel : MovieClip;
		public var subMc0 : MovieClip;
		public var subMc1 : MovieClip;
		public var subMc2 : MovieClip;
		public var subMc3 : MovieClip;
		public var subMc4 : MovieClip;
		public var subMc5 : MovieClip;
		public var subMc6 : MovieClip;
		
		public var contentRoot : MovieClip;
		
		protected var startFrameVectorVector : Vector.<Vector.<int>>;
		protected var endFrameVectorVector : Vector.<Vector.<int>>;
		protected var configFolder : String;
		
		
		private var _startFrameVector:Vector.<int>;
		private var _endFrameVector: Vector.<int>;
		private var _currentIndex : int = 0;
		private var _isAutoPlay : Boolean = true;
		
		private var _subBtnVector : Vector.<MovieClip>;
		private var _subMcVector : Vector.<Doc2_Sub>;
		private var _currentSubBtn : MovieClip;
		private var _currentSubMc : Doc2_Sub;
		
		public function Doc2_Abstract()
		{
			initParam();
			rootMc = this.parent.parent as Doc1_Abstract;
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
			setAutoPlay(_isAutoPlay);
			updatePrevNextVisible();
			ctrlPanel.closeBtn.addEventListener(MouseEvent.CLICK, onClickClose);
			ctrlPanel.prevBtn.addEventListener(MouseEvent.CLICK, onClickPrev);
			ctrlPanel.nextBtn.addEventListener(MouseEvent.CLICK, onClickNext);
			ctrlPanel.screenSaverBtn.addEventListener(MouseEvent.CLICK, onClickShowScreenSaver);
			
			ctrlPanel.manualPlayBtn.addEventListener(MouseEvent.CLICK, onClickManualPlay);
			ctrlPanel.autoPlayBtn.addEventListener(MouseEvent.CLICK, onClickAutoPlay);
			
			_subBtnVector = new Vector.<MovieClip>();
			_subMcVector = new Vector.<Doc2_Sub>();
			
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
				
				_subMcVector.push(new Doc2_Sub(this["subMc" + i], startFrameVectorVector[i], endFrameVectorVector[i]));

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
			_currentSubMc = _subMcVector[index];
			for(var i : int = 0; i < _subBtnVector.length; i++)
			{
				var btn : MovieClip = _subBtnVector[i];
				var subMc : Doc2_Sub = _subMcVector[i];
				if(i == index)
				{
					btn.gotoAndStop(1);
					subMc.mc.visible = true;
					subMc.mc.gotoAndPlay(1);
					
				}
				else
				{
					btn.gotoAndStop(2);
					subMc.mc.visible = false;
					subMc.mc.stop();
				}
			}
			
			_startFrameVector = subMc.startFrameVector;
			_endFrameVector = subMc.endFrameVector;
			
			updatePrevNextVisible();
		}
		
		private function updatePrevNextVisible() : void
		{
			//			trace("updatePrevNextVisible" + _currentIndex);
			if (_currentIndex == 0)
			{
				ctrlPanel.nextBtn.visible = true;
				ctrlPanel.prevBtn.visible = false;
				
			}
			else if(_currentIndex == _endFrameVector.length - 1)
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
		
		private function setAutoPlay(isAuto) :  void
		{
			_isAutoPlay = isAuto
			if (ctrlPanel)
			{
				ctrlPanel.gotoAndStop(_isAutoPlay ? 2 : 1);
			}
			
		}
		
		//-------------------------------------------------------------------------------------------------------------------
		

		private function onClickClose(evt:MouseEvent) : void
		{
			if(rootMc)
			{
				rootMc.removeChildView();
			}
			else
			{
				this.parent.removeChild(this);
			}
		}
		private function onClickPrev(evt:MouseEvent) : void
		{
			_currentIndex -= 1;
			if(_currentIndex < 0)
			{
				_currentIndex = 0;
			}
			contentRoot.gotoAndPlay(_startFrameVector[_currentIndex]);
			updatePrevNextVisible();
		}
		private function onClickNext(evt:MouseEvent) : void
		{
			_currentIndex += 1;
			if(_currentIndex > _endFrameVector.length - 1)
			{
				_currentIndex = _endFrameVector.length - 1;
			}
			contentRoot.gotoAndPlay(_endFrameVector[_currentIndex - 1])
			updatePrevNextVisible();
		}
		
		private function onClickShowScreenSaver(evt:MouseEvent) : void
		{
			rootMc.showScreenSaver(true);
		}
		
		private function onClickManualPlay(evt:MouseEvent) : void
		{
			setAutoPlay(false);
		}
		private function onClickAutoPlay(evt:MouseEvent) : void
		{
			setAutoPlay(true);
			
			if(currentFrame >= _startFrameVector[_startFrameVector.length - 1])
			{
				SoundMgr.getSoundMgrEff().stop();
				contentRoot.gotoAndPlay(_endFrameVector[_endFrameVector.length - 1])
			}
		}
		
		
		
	}
}
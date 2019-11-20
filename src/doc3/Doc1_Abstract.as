package doc3
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import openmgo.ReplaceUtil;
	import openmgo.SoundMgr;
	
	import sound.BgSnd;
	

	public class Doc1_Abstract extends MovieClip
	{
		public var ctrlPanel : MovieClip;
		public var screenSaver : MovieClip;
		public var contentRoot : MovieClip;
		
//		private var BgSnd : Class;
		
		
		protected var _startFrameVector:Vector.<int>;
		protected var _endFrameVector: Vector.<int>;
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

		private var _timer : Timer;
		private var _soundVolume : int = 100;
		
		protected var configFolder : String;
		
		
		public function Doc1_Abstract()
		{
			ctrlPanel.rootMC = this;
			screenSaver.rootMC = this;
			contentRoot.rootMC = this;
			
			
			initParam();
			SoundMgr.getSoundMgrBg().volumeQuietrRatio = 0.9;
			SoundMgr.getSoundMgrEff().volumeQuietrRatio = 1;
			initCtrlPanel();
			initScreenSaver();
			
			changeVolume(true);
			
			contentRoot.stop();
			ReplaceUtil.baseUrl = "./res/" + configFolder + "/";
			ReplaceUtil.loadConfigXml("config.xml", onLoadedConfig);
		}
		
		protected function initParam() : void
		{
			
		}
		
		private function onLoadedConfig() : void
		{
			ReplaceUtil.replace(contentRoot);
			contentRoot.play();
		}
		
		
		private function initCtrlPanel() : void
		{
			ctrlPanel.stop();
			isAutoPlay = _isAutoPlay;
			updatePrevNextVisible();
			ctrlPanel.menuBtn.addEventListener(MouseEvent.CLICK, onClickMenu);
			ctrlPanel.prevBtn.addEventListener(MouseEvent.CLICK, onClickPrev);
			ctrlPanel.nextBtn.addEventListener(MouseEvent.CLICK, onClickNext);
			ctrlPanel.reloadBtn.addEventListener(MouseEvent.CLICK, onClickReload);
			ctrlPanel.screenSaverBtn.addEventListener(MouseEvent.CLICK, onClickShowScreenSaver);
			
			ctrlPanel.soundMinusBtn.addEventListener(MouseEvent.CLICK, onClickSoundMinus);
			ctrlPanel.soundPlusBtn.addEventListener(MouseEvent.CLICK, onClickSoundPlus);
			
			ctrlPanel.manualPlayBtn.addEventListener(MouseEvent.CLICK, onClickManualPlay);
			ctrlPanel.autoPlayBtn.addEventListener(MouseEvent.CLICK, onClickAutoPlay);
		}
		
		private function initScreenSaver() : void
		{
			showScreenSaver(true);
			
			_timer = new Timer(180000, 0);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
			_timer.start();;
			
			screenSaver.addEventListener(MouseEvent.CLICK, onClickHideScreenSaver);
			screenSaver.reloadBtn.addEventListener(MouseEvent.CLICK, onClickScreenSaverReload);
			
			stage.addEventListener(MouseEvent.CLICK, onClickStage)
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onClickStage);
		
		}
		
		
		public function showScreenSaver(show : Boolean) : void
		{
//			trace("showScreenSaver:" + show)
			screenSaver.visible = show;
			if (show)
			{
				contentRoot.stop();
				SoundMgr.getSoundMgrBg().stop();
				SoundMgr.getSoundMgrEff().stop();
//				stopSound();
//				playBgSound(false);
			}
			else
			{
				contentRoot.play();
				SoundMgr.getSoundMgrBg().play(BgSnd,true);
//				SoundMgr.getSoundMgrBg().volume = 
//				playBgSound(true);
//				setBGVolume(bgSndVolumeNormal)
				//bgMC.play();
			}
		}
		
		

		
		private function changeVolume(isPlus : Boolean) : void
		{
			if(isPlus)
			{
				_soundVolume += 20;
			}
			else
			{
				_soundVolume -= 20;
			}
			if (_soundVolume < 0)
				_soundVolume = 0;
			else if(_soundVolume > 100)
				_soundVolume = 100;
			
			if (_soundVolume == 0)
			{
				ctrlPanel.soundMinusBtn.visible = false;
				ctrlPanel.soundPlusBtn.visible = true;
			}
			else if(_soundVolume == 100)
			{
				ctrlPanel.soundMinusBtn.visible = true;
				ctrlPanel.soundPlusBtn.visible = false;
			}
			else
			{
				ctrlPanel.soundMinusBtn.visible = true;
				ctrlPanel.soundPlusBtn.visible = true;
			}
				
				
			ctrlPanel.soundMinusBtn.addEventListener(MouseEvent.CLICK, onClickSoundMinus);
			ctrlPanel.soundPlusBtn.addEventListener(MouseEvent.CLICK, onClickSoundPlus);
			
			SoundMgr.getSoundMgrBg().volume = _soundVolume * 0.01;
			SoundMgr.getSoundMgrEff().volume = _soundVolume * 0.01;
		}
		
		
		
		private function updatePrevNextVisible() : void
		{
//			trace("updatePrevNextVisible" + currentIndex);
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
		
		
		
		private var _childViewLoader : Loader;
		private function addChildView() : void
		{
			
		}
		
		public function removeChildView() : void
		{
			if(_childViewLoader)
			{
				this.removeChild(_childViewLoader);
				_childViewLoader = null;
			}
		}
		
		
		//-------------------------------------------------------------------------------------------------------------------
		
		private function onTimer(evt:TimerEvent):void
		{
			showScreenSaver(true); 
		}
		
		private function onClickHideScreenSaver(evt : MouseEvent) : void
		{
			showScreenSaver(false);
		}
		
		private function onClickScreenSaverReload(evt : MouseEvent) : void
		{
			//			if (secondMcLoader && this.contains(secondMcLoader))
			//			{
			//				this.removeChild(secondMcLoader);
			//				secondMcLoader = null;
			//				this.removeEventListener(Event.ENTER_FRAME, checkOpenedSecView);
			//			}
			SoundMgr.getSoundMgrEff().stop();
			contentRoot.gotoAndPlay(1);
		}
		
		private function onClickStage(evt:MouseEvent) : void
		{
			_timer.reset();
			_timer.start();
		}
		
		
		
		private function onClickMenu(evt:MouseEvent) : void
		{
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
		private function onClickReload(evt:MouseEvent) : void
		{
			SoundMgr.getSoundMgrEff().stop();
			contentRoot.gotoAndPlay(1);
		}
		private function onClickShowScreenSaver(evt:MouseEvent) : void
		{
			showScreenSaver(true); 
		}
		private function onClickSoundPlus(evt:MouseEvent) : void
		{
			changeVolume(true);
		}
		private function onClickSoundMinus(evt:MouseEvent) : void
		{
			changeVolume(false);
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
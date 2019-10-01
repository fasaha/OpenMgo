package doc3
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import openmgo.SoundMgr;
	

	public class Doc1 extends MovieClip
	{
		public var ctrlPanel : MovieClip;
		public var screenSaver : MovieClip;
		
		
		private var _startFrameVector:Vector.<int> = new <int>[325, 468, 622, 751, 898, 1032, 1155, 1297, 1406];
		private var _endFrameVector: Vector.<int> = new <int>[454, 608, 735, 884, 1018, 1141, 1283, 1392, 1604];
		private var _currentIndex : int = 0;
		private var _isAutoPlay : Boolean = true;
		private var _timer : Timer;
		private var _soundVolume : int = 100;
		
		
		public function Doc1()
		{
			SoundMgr.getSoundMgrBg().volumeQuietrRatio = 0.9;
			SoundMgr.getSoundMgrEff().volumeQuietrRatio = 1;
			initCtrlPanel();
			initScreenSaver();
			
			changeVolume(true);
			
		}
		
		private function initCtrlPanel() : void
		{
			ctrlPanel.stop();
			setAutoPlay(_isAutoPlay);
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
		
		
		private function showScreenSaver(show : Boolean) : void
		{
//			trace("showScreenSaver:" + show)
			screenSaver.visible = show;
			if (show)
			{
				this.stop();
				SoundMgr.getSoundMgrBg().stop();
				SoundMgr.getSoundMgrEff().stop();
//				stopSound();
//				playBgSound(false);
			}
			else
			{
				this.play();
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
			gotoAndPlay(2);
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
			_currentIndex -= 1;
			if(_currentIndex < 0)
			{
				_currentIndex = 0;
			}
			gotoAndPlay(_startFrameVector[_currentIndex]);
			updatePrevNextVisible();
		}
		private function onClickNext(evt:MouseEvent) : void
		{
			_currentIndex += 1;
			if(_currentIndex > _endFrameVector.length - 1)
			{
				_currentIndex = _endFrameVector.length - 1;
			}
			gotoAndPlay(_endFrameVector[_currentIndex - 1])
			updatePrevNextVisible();
		}
		private function onClickReload(evt:MouseEvent) : void
		{
			SoundMgr.getSoundMgrEff().stop();
			gotoAndPlay(2);
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
			setAutoPlay(false);
		}
		private function onClickAutoPlay(evt:MouseEvent) : void
		{
			setAutoPlay(true);
			
			if(currentFrame >= _startFrameVector[_startFrameVector.length - 1])
			{
				SoundMgr.getSoundMgrEff().stop();
				gotoAndPlay(_endFrameVector[_endFrameVector.length - 1])
			}
		}
		
		
		
		
	}
}
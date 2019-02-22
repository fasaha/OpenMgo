package openmgo
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	public class FramePlayer
	{
		public function FramePlayer()
		{
		}
		
		private var _targetMC : MovieClip;
		private var _displayObject : DisplayObject;
		
		private var _minFrame : int = 1;
		private var _maxFrame : int = 5;
		private var _speed : Number = 5.0;
		
		private var _isDrag : Boolean = false;
		private var _prevX : Number = 0.0;
		
		public function registerMouse(displayObject:DisplayObject, movieClip : MovieClip, speed : Number = 1) : void
		{
			if(_targetMC != null)
				return;
			_targetMC = movieClip;
			_minFrame = 1;
			_maxFrame = _targetMC.totalFrames;
			_speed = speed;
			_displayObject = displayObject;
			_displayObject.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			_displayObject.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			_displayObject.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			_displayObject.addEventListener(MouseEvent.ROLL_OUT, mouseUpHandler);
			AlbumUtil.getInstance().check(_displayObject.stage);
		}
		
		
		
		public function unRegisterMouse() : void
		{
			if(_displayObject == null)
				return;
			_displayObject.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			_displayObject.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			_displayObject.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			_displayObject.removeEventListener(MouseEvent.ROLL_OUT, mouseUpHandler);
			_displayObject = null;
			_targetMC = null;
		}
		
		private function mouseDownHandler(evt : MouseEvent) : void
		{
			_isDrag = true;
			_prevX = evt.stageX;
		}
		private function mouseMoveHandler(evt : MouseEvent) : void
		{
			if (!_isDrag)
				return;
			var deltaX : Number = evt.stageX - _prevX;
			_prevX = evt.stageX;
			playFrame(deltaX);
		}
		private function mouseUpHandler(evt : MouseEvent) : void
		{
			_isDrag = false;
			playFrame(Number.NaN);
		}
		
		
		
		private function playFrame(deltaX : Number) : void
		{
			//trace("playFrame", deltaX);
			if(isNaN(deltaX))
			{
				_targetMC.play();
				_targetMC.gotoAndPlay(_targetMC.currentFrame);
			}
			else
			{
				var targetFrame : int = _targetMC.currentFrame + Math.round(deltaX * _speed);
				if(targetFrame < _minFrame)
				{
					targetFrame = _maxFrame;
				}
				else if(targetFrame > _maxFrame)
				{
					targetFrame = _minFrame;
				}
				
				_targetMC.gotoAndStop(targetFrame);
			}
			
		}
	}
}
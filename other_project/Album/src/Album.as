package
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	
	public class Album extends Sprite
	{
		public var prevItemBtn : SimpleButton;
		public var nextItemBtn : SimpleButton;
		public var prevGroupBtn : SimpleButton;
		public var nextGroupBtn : SimpleButton;
		public var imageContainer : MovieClip;
		
		public var previewContainer : MovieClip;
		//======================================
		
		private var _imageLoader : Loader;
		private var _data : XMLList;
		
		private var _minIndex : int;
		private var _currentIndex : int;
		private var _maxIndex : int;
		
		//===================================================start test
		private function myLoad() : void
		{
			var urlLoader : URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, loadXmlComplete);
			urlLoader.load(new URLRequest("./level2menu.xml"));
			trace("aaa");
		}
		
		private function loadXmlComplete(evt : Event) : void
		{
			var urlLoader : URLLoader  = evt.target as URLLoader;
			var xml : XML = new XML(urlLoader.data);
			setData(xml.item[0].thumb);
		}
		
		//===================================================end   test
		
		
		private function InitPreview() : void
		{
			 for(var i : int = 0; i < previewContainer.numChildren;)
			 {
				 
			 }
			 previewContainer
		}
		
		
		
		public function Album()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			prevItemBtn.addEventListener(MouseEvent.CLICK, clickPrevItem);
			nextItemBtn.addEventListener(MouseEvent.CLICK, clickNextItem);
			prevGroupBtn.addEventListener(MouseEvent.CLICK, clickPrevGroup);
			nextGroupBtn.addEventListener(MouseEvent.CLICK, clickNextGroup);
			_imageLoader = new Loader();
			_imageLoader.addEventListener(Event.COMPLETE, loadImageComplete);
			imageContainer.addChild(_imageLoader);
			myLoad();
		}
		
		public function setData(data : XMLList):void
		{
			_data = data;
			_minIndex = 0;
			_maxIndex = _data.length() - 1;
			_currentIndex = 0;
			InitPreview();
			RefreshImage();
		}
		
		private function clickPrevItem(evt : MouseEvent) : void
		{
			_currentIndex--;
			if(_currentIndex < _minIndex)
				_currentIndex = _minIndex;
			RefreshImage()
		}
		
		private function clickNextItem(evt : MouseEvent) : void
		{
			_currentIndex++;
			if(_currentIndex > _maxIndex)
				_currentIndex = _maxIndex;
			RefreshImage()
		}
		
		private function clickPrevGroup(evt : MouseEvent) : void
		{
		}
		
		private function clickNextGroup(evt : MouseEvent) : void
		{
		}
		
		
		private function RefreshImage() : void
		{
			_imageLoader.unload();
			_imageLoader.load(new URLRequest(_data[_currentIndex]));
			imageContainer.gotoAndPlay(0);
			trace("RefreshImage" + _currentIndex);
				
		}
		
		private function loadImageComplete(evt : Event): void
		{
			
		}
		
		
	}
}
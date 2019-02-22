package openmgo
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	
	public class Album extends Sprite
	{
		public var prevItemBtn : SimpleButton;
		public var nextItemBtn : SimpleButton;
		public var imageContainer : MovieClip;
		
		public var previewContainer : MovieClip;
		public var previewMask : MovieClip;
		
		//======================================
		private const PREVIEW_WIDTH : int = 80;
		private const PREVIEW_HEIGHT : int = 80;
		private const PREVIEW_SHOW_COUNT : int = 5;
		private const PREVIEW_WIDTH_WITH_GAP : int = 90;
		private const GAP : int = 10;
		
		private var _imageLoader : Loader;
		private var _previewContainerStartX : int
		private var _data : XMLList;
		
		private var _minIndex : int;
		private var _currentIndex : int;
		private var _maxIndex : int;
		
		private var _minGroup : int;
		private var _currentGroup : int;
		private var _maxGroup : int
		
		private var _photoWidth : int;
		private var _photoHeight : int;
		
		private var _prePreview : Sprite;
		
		//===================================================start test
//		private function myLoad() : void
//		{
//			var urlLoader : URLLoader = new URLLoader();
//			urlLoader.addEventListener(Event.COMPLETE, loadXmlComplete);
//			urlLoader.load(new URLRequest("./level2menu.xml"));
//		}
//		
//		private function loadXmlComplete(evt : Event) : void
//		{
//			var urlLoader : URLLoader  = evt.target as URLLoader;
//			var xml : XML = new XML(urlLoader.data);
//			setData(xml.item[0].thumb);
//		}
		
		//===================================================end   test
		
		
		private function InitPreview() : void
		{
			previewContainer.removeChildren(0);
			for(var i : int = 0; i < _data.length(); i++)
			{
				var container : Sprite = new Sprite();
				container.buttonMode = true;
				var loader : MLoader = new MLoader();
				loader.width = PREVIEW_WIDTH;
				loader.height = PREVIEW_HEIGHT;
				loader.index = i;
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadPreviewComplete);
				loader.load(new URLRequest(_data[i]));
				container.x = i * PREVIEW_WIDTH_WITH_GAP;
				container.y = 0;
				loader.addEventListener(MouseEvent.CLICK, clickPreview);
				container.addChild(loader);
				
				var shape:Shape = new Shape();
				shape.graphics.beginFill(0xffffff);
				shape.graphics.drawCircle(0,0,4);
				shape.graphics.endFill();
				shape.x = PREVIEW_WIDTH * 0.5;
				shape.y = -5;
				shape.visible = false;
				container.addChild(shape);
				
				previewContainer.addChild(container);
			}
			
		}
		
		
		public function Album()
		{
			previewContainer.mask = previewMask;
			prevItemBtn.addEventListener(MouseEvent.CLICK, clickPrevItem);
			nextItemBtn.addEventListener(MouseEvent.CLICK, clickNextItem);
			_imageLoader = new Loader();
			_imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadImageComplete);
			imageContainer.addChildAt(_imageLoader, 0);
			
			_photoWidth = imageContainer.width;
			_photoHeight = imageContainer.height;
//			myLoad();
			EnableChecker.getInstance().check(stage);
		}
		
		public function setData(data : XMLList):void
		{
			_data = data;
			_minIndex = 0;
			_maxIndex = _data.length() - 1;
			_currentIndex = 0;
			_currentGroup = 0;
			_minGroup = 0;
			_maxGroup = Math.ceil(_data.length() / PREVIEW_SHOW_COUNT) - 1;
			_previewContainerStartX = previewContainer.x;
			InitPreview();
			RefreshImage();
		}
		
		private function clickPreview(evt : MouseEvent) : void
		{
			var mLoader : MLoader = evt.currentTarget as MLoader;
			if(_currentIndex == mLoader.index)
				return;
			_currentIndex = mLoader.index;
			RefreshImage();
		}
		
		
		private function clickPrevItem(evt : MouseEvent) : void
		{
			_currentIndex--;
			if(_currentIndex < _minIndex)
				_currentIndex = _minIndex;
			var group : int = (int)(_currentIndex / PREVIEW_SHOW_COUNT);
			if(group != _currentGroup)
				_currentGroup = group;
			RefreshGroup();
			RefreshImage();
		}
		
		private function clickNextItem(evt : MouseEvent) : void
		{
			_currentIndex++;
			if(_currentIndex > _maxIndex)
				_currentIndex = _maxIndex;
			var group : int = (int)(_currentIndex / PREVIEW_SHOW_COUNT);
			if(group != _currentGroup)
				_currentGroup = group;
			RefreshGroup();
			RefreshImage();
		}
		
		private function RefreshGroup() : void
		{
			previewContainer.x = _previewContainerStartX - _currentGroup * PREVIEW_WIDTH_WITH_GAP * PREVIEW_SHOW_COUNT;
		}
		
		private function RefreshImage() : void
		{
			prevItemBtn.mouseEnabled = true;
			nextItemBtn.mouseEnabled = true;
			prevItemBtn.alpha = 1;
			nextItemBtn.alpha = 1;
			prevItemBtn.enabled = true;
			nextItemBtn.enabled = true;
			if(_currentIndex == _minIndex)
			{
				prevItemBtn.enabled = false;
				prevItemBtn.mouseEnabled = false;
				prevItemBtn.alpha = 0.7;
			}
			if(_currentIndex == _maxIndex)
			{
				nextItemBtn.enabled = false;
				nextItemBtn.mouseEnabled = false;
				nextItemBtn.alpha = 0.7;
			}
			
			if(_prePreview)
			{
				_prePreview.getChildAt(1).visible = false;
				_prePreview.scaleX = _prePreview.scaleY = 1;
			}
			_prePreview = previewContainer.getChildAt(_currentIndex) as Sprite;
			_prePreview.getChildAt(1).visible = true;
			_imageLoader.unload();
			_imageLoader.load(new URLRequest(_data[_currentIndex]));
			imageContainer.gotoAndPlay(1);
			//trace("RefreshImage" + _currentIndex);
			
		}
		
		private function loadImageComplete(evt : Event): void
		{
			var loader : Loader = evt.target.loader as Loader;
			loader.width = _photoWidth;
			loader.height = _photoHeight;
		}
		
		private function loadPreviewComplete(evt : Event): void
		{
			var loader : MLoader = evt.target.loader as MLoader;
			loader.width = PREVIEW_WIDTH;
			loader.height = PREVIEW_HEIGHT;
		}
		
		
		
	}
}
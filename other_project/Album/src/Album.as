package
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
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
		public var previewMask : MovieClip;
		
		//======================================
		private const PREVIEW_WIDTH : int = 80;
		private const PREVIEW_HEIGHT : int = 80;
		private const PREVIEW_SHOW_COUNT : int = 7;
		private const PREVIEW_WIDTH_WITH_GAP : int = 100;
		private const GAP : int = 20;
		
		private var _imageLoader : Loader;
		private var _previewContainerStartX : int
		private var _data : XMLList;
		
		private var _minIndex : int;
		private var _currentIndex : int;
		private var _maxIndex : int;
		
		private var _minGroup : int;
		private var _currentGroup : int;
		private var _maxGroup : int
		
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
			previewContainer.removeChildren(1);
			for(var i : int = 0; i < _data.length(); i++)
			{
				var container : Sprite = new Sprite();
				
				container.buttonMode = true;
				var loader : MLoader = new MLoader();
				loader.index = i;
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadPreviewComplete);
				loader.load(new URLRequest(_data[i]));
				loader.x = i * PREVIEW_WIDTH_WITH_GAP;
				loader.y = 0;
				loader.addEventListener(MouseEvent.CLICK, clickPreview);
				container.addChild(loader);
				previewContainer.addChild(container);
			}
			
		}
		
		
		
		public function Album()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			previewContainer.mask = previewMask;
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
			_currentIndex = mLoader.index;
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
			prevGroupBtn.visible = true;
			nextGroupBtn.visible = true;
			if(--_currentGroup <= _minGroup)
			{
				_currentGroup = _minGroup;
				prevGroupBtn.visible = false;
			}
			previewContainer.x = _previewContainerStartX - _currentGroup * PREVIEW_WIDTH_WITH_GAP * PREVIEW_SHOW_COUNT;
		}
		
		private function clickNextGroup(evt : MouseEvent) : void
		{
			prevGroupBtn.visible = true;
			nextGroupBtn.visible = true;
			
			if(++_currentGroup >= _maxGroup)
			{
				_currentGroup = _maxGroup;
				nextGroupBtn.visible = false;
			}
			previewContainer.x = _previewContainerStartX - _currentGroup * PREVIEW_WIDTH_WITH_GAP * PREVIEW_SHOW_COUNT;
		}
		
		private function RefreshImage() : void
		{
			prevItemBtn.visible = true;
			nextItemBtn.visible = true;
			if(_currentIndex == _minIndex)
				prevItemBtn.visible = false;
			else if(_currentIndex == _maxIndex)
				nextItemBtn.visible = false;
			_imageLoader.unload();
			_imageLoader.load(new URLRequest(_data[_currentIndex]));
			imageContainer.gotoAndPlay(0);
			trace("RefreshImage" + _currentIndex);
				
		}
		
		private function loadImageComplete(evt : Event): void
		{
			
		}
		
		private function loadPreviewComplete(evt : Event): void
		{
			var loader : MLoader = evt.target.loader as MLoader;
			loader.width = PREVIEW_WIDTH;
			loader.height = PREVIEW_HEIGHT;
		}
		
		
		
	}
}
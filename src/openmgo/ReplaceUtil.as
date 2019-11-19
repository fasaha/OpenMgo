package openmgo
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.utils.Dictionary;

	public class ReplaceUtil
	{
		public static var defaultImageId : String = "1001";
		public  static var defaultTextId : String = "1001";
		
		
		public static var baseUrl : String = "";
		private static var REPLACE_BITMAP_NAME : String = "replacebmp_";
		private static var REPLACE_TEXT_NAME : String = "replacetxt_";
		
		private static var imgDic : Dictionary;
		private static var txtDic : Dictionary;
		
		public static function replace(mc : MovieClip) : void
		{
			if(imgDic == null || txtDic == null)
				return;
			for(var i : int = 0, count : int = mc.numChildren; i < count; i++)
			{
				var displayObject : DisplayObject = mc.getChildAt(i);
				if (displayObject is Bitmap)
				{
					var bitmap : Bitmap = displayObject as Bitmap;
					if(bitmap.parent.name.substr(0,REPLACE_BITMAP_NAME.length).toLocaleLowerCase() == REPLACE_BITMAP_NAME)
					{
						//trace("Find bmp~~~~~~~~~~~~" + bitmap.parent.name);
						loadImage(bitmap.parent.name.substr(REPLACE_BITMAP_NAME.length), bitmap)
						
					}
				}
				else if(displayObject is TextField && displayObject.name.substr(0,REPLACE_TEXT_NAME.length).toLocaleLowerCase() == REPLACE_TEXT_NAME)
				{
					var text : String = txtDic[ displayObject.name.substr(REPLACE_TEXT_NAME.length)];
					//trace("Find textfield~~~~~~~~~~~~" + displayObject.name);
					if(text == null)
						text = txtDic[defaultTextId];
					if(text != null)
					{
						(displayObject as TextField).text = text;
					}
				}
				else if(displayObject is MovieClip)
				{
					var childMC : MovieClip = displayObject as MovieClip;
					replace(childMC);
				}
				
			}
		}
		
		public static function loadImage(id : String, bmp : Bitmap) : void
		{
			
			var path : String = imgDic[id];
			if(path == null)
				path = imgDic[defaultImageId];
			var loader : MLoader = new MLoader();
			loader.data = bmp;
			loader.load(new URLRequest(baseUrl + path));
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadImageComplete);
		}
		
		public static function onLoadImageComplete(evt : Event) : void
		{
			
			var loaderInfo : LoaderInfo = evt.target as LoaderInfo;
			loaderInfo.removeEventListener(Event.COMPLETE, onLoadImageComplete);
			var loadedDisplayObject : DisplayObject = loaderInfo.content;
			if(loadedDisplayObject == null)
			{
				trace("error loaderInfo.content=null");
				return;
			}
			var mLoader : MLoader = loaderInfo.loader as MLoader;
			var bmp : Bitmap = mLoader.data as Bitmap;
			if(bmp != null && bmp.parent != null)
			{
				var index : int = bmp.parent.getChildIndex(bmp);
				bmp.parent.addChildAt(loadedDisplayObject, index + 1);
				
				loadedDisplayObject.x = bmp.x;
				loadedDisplayObject.y = bmp.y;
				loadedDisplayObject.width = bmp.width;
				loadedDisplayObject.height = bmp.height;
				bmp.parent.removeChild(bmp);
			}
			
		}
		
		
		public static function loadConfigXml (path : String, callBackFunc :Function) : void
		{
			trace(" loadXml imgDic=" + imgDic);
			if(imgDic == null)
			{
				var urlLoader : MURLLoader = new MURLLoader();
				urlLoader.mData = callBackFunc;
				urlLoader.addEventListener(Event.COMPLETE, onLoadConfigXmlComplete);
				urlLoader.load((new URLRequest(baseUrl + path)));
			}
			else
			{
				if(callBackFunc != null)
				{
					callBackFunc()
				}
			}
			
		}
		
		public static function onLoadConfigXmlComplete(evt : Event) : void
		{
			var urlLoader : MURLLoader = evt.target as MURLLoader;
			urlLoader.removeEventListener(Event.COMPLETE, onLoadConfigXmlComplete);
			var xml : XML = new XML(urlLoader.data);
			
			var i : int
			var count : int;
			var id : String;
			var path : String;
			imgDic = new Dictionary();
			var imgXMLList : XMLList = xml.child("img");
			for(i  = 0 , count = imgXMLList.length(); i < count; i++)
			{
				var imgItem : XML = imgXMLList[i];
				id  = imgItem.attribute("id");
				path  = imgItem.text();
				imgDic[id] = path;
			}
			
			txtDic = new Dictionary();
			var txtXMLList : XMLList = xml.child("txt");
			for(i = 0 , count = txtXMLList.length(); i < count; i++)
			{
				var txtItem : XML = txtXMLList[i];
				id = txtItem.attribute("id");
				path  = txtItem.text();
				txtDic[id] = path;
			}
			
			
			if (urlLoader.mData != null)
			{
				var callBackFunc : Function = urlLoader.mData as Function;
				
				if(callBackFunc != null)
				{
					callBackFunc()
				}
			}
			
		}
	}
}
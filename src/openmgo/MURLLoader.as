package openmgo
{
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class MURLLoader extends URLLoader
	{
		public var mData : Object;
		public function MURLLoader(request:URLRequest=null)
		{
			super(request);
		}
	}
}
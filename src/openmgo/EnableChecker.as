package openmgo
{
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class EnableChecker
	{
		public function EnableChecker()
		{
		}
		
		public function Check() : void
		{
			var urlLoader : URLLoader = new URLLoader(new URLRequest("http://"));
		}
	}
}
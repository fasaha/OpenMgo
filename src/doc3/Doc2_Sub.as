package doc3
{
	import flash.display.MovieClip;

	public class Doc2_Sub
	{
		private var _startFrameVector:Vector.<int>
		
		public function get startFrameVector():Vector.<int>
		{
			return _startFrameVector;
		}
		
		private var _endFrameVector: Vector.<int>

		public function get endFrameVector():Vector.<int>
		{
			return _endFrameVector;
		}

		private var _mc : MovieClip;
		
		public function get mc():MovieClip
		{
			return _mc;
		}
		
		public function Doc2_Sub(mc : MovieClip, startFrameVector : Vector.<int>, endFrameVector : Vector.<int>)
		{
			
			_mc = mc;
			_startFrameVector = startFrameVector
			_endFrameVector = endFrameVector;
			
		}

		

		


	}
}
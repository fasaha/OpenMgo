package openmgo
{
	public class SoundMgr
	{
		public function SoundMgr()
		{
		}
		
		private static var _soundMgrBg : SoundMgrBase;
		private static var _soundMgrEff : SoundMgrBase;
		

		public static function getSoundMgrBg() : SoundMgrBase
		{
			if(_soundMgrBg == null)
				_soundMgrBg = new SoundMgrBase();
			return _soundMgrBg;
		}
		
		public static function getSoundMgrEff() : SoundMgrBase
		{
			if(_soundMgrEff == null)
				_soundMgrEff = new SoundMgrBase();
			return _soundMgrEff;
		}
		
		
		
		
		
	}
}
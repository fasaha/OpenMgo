package openmgo
{
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;

	internal class SoundMgrBase
	{
		public function SoundMgrBase()
		{
//			throw new Error("can not new SoundMgrBase");
		}
		
		
		private var _volumeQuietrRatio : Number = 1;
		public function get volumeQuietrRatio():Number
		{
			return _volumeQuietrRatio;
		}
		public function set volumeQuietrRatio (value:Number) : void
		{
			_volumeQuietrRatio = value;
			volume = _volume;
		}
		
		private var _volume : Number = 1;
		public function get volume():Number
		{
			return _volume;
		}
		public function set volume(value:Number):void
		{
			_volume = value;
			if(_soundChannel != null)
			{
				var t : SoundTransform = _soundChannel.soundTransform;
				t.volume = _volume * _volumeQuietrRatio;
				_soundChannel.soundTransform = t;
			}
		}
		
		private var _soundChannel : SoundChannel;
		private var _sound : Sound;
		private var _loop : Boolean = false;
		private var _pos : Number = -1;
		
		
		public function play(soundFrom : Object, loop : Boolean) : void
		{
			stop()
			if (soundFrom == null)
			{
				return
			}
			if(soundFrom is String)
			{
				_sound = new Sound();
				_sound.load(new URLRequest(soundFrom as String));
			}
			else if(soundFrom is Class)
			{
				_sound = new (soundFrom as Class);
			}
			
			_loop = loop;
			_soundChannel = _sound.play(0, _loop ? int.MAX_VALUE : 0 , new SoundTransform(_volume * _volumeQuietrRatio));
		}
		
		public function stop() : void
		{
			if(_sound != null)
			{
				//_sound.close();
				_sound = null;
			}
			if(_soundChannel != null)
			{
				_soundChannel.stop();
				_soundChannel.removeEventListener(Event.SOUND_COMPLETE, onSoundComplete);
				_soundChannel = null;
			}
			_pos = -1;
		}
		
		
		public function pause(pause : Boolean) : void
		{
			if(_soundChannel == null)
				return;
			
			if(pause)
			{
				_pos = _soundChannel.position;
				_soundChannel.stop();
			}
			else
			{
				if(_pos >= 0)
				{
					_soundChannel = _sound.play(_pos, 0, new SoundTransform(_volume * _volumeQuietrRatio));
					if(_loop)
					{
						_soundChannel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
						_soundChannel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
						_soundChannel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
					}
					_pos = -1;
				}
				
			}
			
		}
		
		private function onSoundComplete(evt : Event) : void
		{
			if(_soundChannel == null)
				return;
			_soundChannel = _sound.play(0, int.MAX_VALUE, new SoundTransform(_volume * _volumeQuietrRatio));
		}
		
		
	}
}
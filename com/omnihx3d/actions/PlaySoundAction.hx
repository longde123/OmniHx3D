package com.omnihx3d.actions;

/**
 * ...
 * @author Krtolica Vujadin
 */

@:expose('BABYLON.PlaySoundAction') class PlaySoundAction extends Action {
	
	private var _sound:Dynamic;
	

	public function new(triggerOptions:Dynamic, sound:Dynamic, ?condition:Condition) {
		super(triggerOptions, condition);
		this._sound = sound;
	}

	override public function _prepare() {
		
	}

	override public function execute(?evt:ActionEvent) {
		/*if (this._sound != null) {
			this._sound.play();
		}*/
	}
	
}

package com.omnihx3d.actions;

/**
 * ...
 * @author Krtolica Vujadin
 */

@:expose('BABYLON.DoNothingAction') class DoNothingAction extends Action {
	
	public function new(triggerOptions:Dynamic = 0/*ActionManager.NothingTrigger*/, ?condition:Condition) {
		super(triggerOptions, condition);
	}
	
}

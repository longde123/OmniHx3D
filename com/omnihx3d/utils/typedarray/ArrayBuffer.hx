package com.omnihx3d.utils.typedarray;

/**
 * @author Krtolica Vujadin
 */

#if purejs

	typedef ArrayBuffer = js.html.ArrayBuffer;

#elseif snow

	typedef ArrayBuffer = snow.api.buffers.ArrayBuffer;
	
#elseif openfl

	typedef ArrayBuffer = openfl.utils.ArrayBuffer;	
	
#elseif lime

	typedef ArrayBuffer = lime.utils.ArrayBuffer;
	
#elseif nme

	typedef ArrayBuffer = nme.utils.ArrayBuffer;

#elseif kha



#end
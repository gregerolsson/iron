package iron.object;

import kha.graphics4.Graphics;
import iron.data.MaterialData;
import iron.object.Uniforms;
import iron.Scene;

class DecalObject extends Object {

	public var material:MaterialData;

	public function new(material:MaterialData) {
		super();
		this.material = material;
		Scene.active.decals.push(this);
	}

	public override function remove() {
		if (Scene.active != null) Scene.active.decals.remove(this);
		super.remove();
	}
	
	// Called before rendering decal in render path
	public function render(g:Graphics, context:String, camera:CameraObject, lamp:LampObject, bindParams:Array<String>) {
		
		// Check context skip
		if (material.raw.skip_context != null &&
			material.raw.skip_context == context) {
			return;
		}

		var materialContext:MaterialContext = null;
		for (i in 0...material.raw.contexts.length) {
			if (material.raw.contexts[i].name == context) {
				materialContext = material.contexts[i]; // Single material decals
				break;
			}
		}
		var shaderContext = material.shader.getContext(context);
		
		g.setPipeline(shaderContext.pipeState);
		
		Uniforms.setConstants(g, shaderContext, this, camera, lamp, bindParams);			
		Uniforms.setMaterialConstants(g, shaderContext, materialContext);
	}
}

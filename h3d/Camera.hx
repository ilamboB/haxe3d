package h3d;

class Camera {

	public var position : Vector;
	public var target : Vector;
	public var up : Vector;
	public var zoom : Float;
	
	public var mcam : Matrix;
	public var mproj : Matrix;
	public var m : Matrix;

	public function new( ?pos : Vector, ?target : Vector, ?up : Vector ) {
		
		this.position = (pos == null) ? new Vector(0,-100,0) : pos;
		this.target = (target == null) ? new Vector(0,0,0) : target;
		this.up = (up == null) ? new Vector(0,0,1) : up;
		
		zoom = 5;
		mcam = new Matrix();
		mproj = new Matrix();
		m = new Matrix();
		updateProjection(150,150,Math.PI/4,50,1000);
		update();
	}

	public function updateProjection( width : Float, height : Float, fovAngle : Float, zNear : Float, zFar : Float ) {
		// use Right-Handed
		var cotan = 1.0 / Math.tan(fovAngle / 2);
		var q = zFar / (zFar - zNear);
		mproj.zero();
		mproj._11 = cotan * width;
		mproj._22 = cotan * height;
		mproj._33 = q;
		mproj._34 = -1;
		mproj._43 = q * zNear;
	}

	public function update() {
		position.scale( zoom / position.length() );
		// use Right-Handed
		var az = target.sub(position);
		az.normalize();
		var ax = up.cross(az);
		ax.normalize();
		// this can happen if the camera line-of-view is parallel to the up vector
		// in that case, choose another orthogonal vector
		if( ax.length() == 0 ) {
			ax.x = az.y;
			ax.y = az.z;
			ax.z = az.x;
		}
		var ay = az.cross(ax);
		mcam._11 = ax.x;
		mcam._12 = ay.x;
		mcam._13 = az.x;
		mcam._14 = 0;
		mcam._21 = ax.y;
		mcam._22 = ay.y;
		mcam._23 = az.y;
		mcam._24 = 0;
		mcam._31 = ax.z;
		mcam._32 = ay.z;
		mcam._33 = az.z;
		mcam._34 = 0;
		mcam._41 = -ax.dot(position);
		mcam._42 = -ay.dot(position);
		mcam._43 = -az.dot(position);
		mcam._44 = 1;
		m.multiply4x4(mcam,mproj);
	}

}
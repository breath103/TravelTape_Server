var fs = sprintf;

var photoControllerContainer = {};


// generateDivString과 getDiv는 상속받은 사용자가 직접 구현하게 하는게 나은것 같다.
//
function Photo(albumController, fbPhoto) {
	this.albumController = albumController;
	this.fbPhoto = fbPhoto;

	photoControllerContainer[this.fbPhoto.id];

	this.$div = null;
	this.imageLoadCallback = null;
}
Photo.prototype = {
	toTransportableJSON : function() {
		return {
			src : this.fbPhoto.source,
			description : this.fbPhoto.name,
			sourceType : "FACEBOOK",
			sourceID : this.fbPhoto.id
		};
	},
	getDiv : function() {
		return (this.$div) ? this.$div : (this.$div = $(fs(
				".Photo[photoid='%s']", this.fbPhoto.id)));
	},
	isImageLoaded : function() {
		return this.get$image()[0].complete;
	},
	get$image : function() {
		return this.getDiv().find("img");
	},
	getFBDate : function(){
		return this.fbPhoto;
	},
	getID : function(){
		return this.getFBDate().id;
	},
	getAlbumController : function(){
		return this.albumController;
	},
	onImageLoaded : function(callback) {
		this.imageLoadCallback = callback;

		if (this.isImageLoaded()) {
			callback.call(this.get$image());
		} else {
			this.get$image().load(callback);
		}
	}
};

var g_albums = {};
function getAlbumController(id) {
	return g_albums[id];
}
function Album(fbAlbum) {
	this.fbAlbum = fbAlbum;
	this.photoControllers = {};
	this.$div = null;

	console.log(fbAlbum);

	g_albums[this.fbAlbum.id] = this;
}
Album.prototype = {
	getDiv : function() {
		if (this.$div)
			return this.$div;
		else
			return (this.$div = $(fs(".Album[albumId='%s']", this.fbAlbum.id)));
	},
	getPhotos : function(callback) {
		(function(albumController) {
			FB.api("/" + albumController.fbAlbum.id + "/photos", function(
					response) {
				callback.call(albumController, response);
			});
		})(this);
	},
	getPhotoController : function(id) {
		return this.photoControllers[id];
	},
	getCoverPhoto : function(callback) {
		var thisAlbum = this;
		if (this.fbAlbum.cover_photo) {
			FB.api("/" + this.fbAlbum.cover_photo, function(response) {
				callback.call(thisAlbum, response);
			});
		}
	},
	getFBData : function() {
		return this.fbAlbum;
	},
	getID : function(){
		return this.getFBDate().id;
	},
	createPhotoController : function(fbPhoto) {
		var photo = new Photo(this, fbPhoto);
		this.photoControllers[fbPhoto.id] = photo;
		return photo;
	},
};
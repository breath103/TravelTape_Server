function SlideShowController(jsonInfo) {
	//일단 서버에서 가져오는 부분을 이렇게 짠다. 가능하면 이 코드를 서버로 옮기고, 정리해야할것같다.
	/*
	this.madeleine = {
		createdTime  : new Date("${madeleine.createdTime}"),
		reservedTime : new Date("${madeleine.reservedTime}"),
		name 		 : "${madeleine.name}",
		sendState    : "${madeleine.sendState}",
		isPublic     : ${madeleine.isPublic}
	};
	 */
	this.madeleine = jsonInfo;
	this.photos = [];
	//this.photos = [];
	/*
	<c:forEach var="photo" items="${madeleine.photos}">
	this.photos.push({
		src 		: "${photo.src}",
		description : "${photo.description}",
		sourceType  : "${photo.sourceType}",
		sourceID	: "${photo.sourceID}"
	});
	</c:forEach>
	 */
	this.currentSlideIndex = 0;
	for ( var index in this.madeleine.photos) {
		var photo = this.madeleine.photos[index];
		this.photos.push(new Photo(photo));
	}
	this.state = null;
}
SlideShowController.prototype = {
	start : function() {
		
	},
	stop : function() {

	},
	togglePlay : function(){
		if(this.state != this.STATE.PLAYING){
			this.start();
		}
		else{
			this.stop();
		}
	},
	next : function() {

	},
	previous : function() {

	},
	STATE : {
		STOP : "STOP",
		PLAYING : "PLAYING"
	},
	getState : function() {
		return this.state;
	},
	getCurrentSlideIndex : function() {
		return this.currentSlideIndex;
	}
};
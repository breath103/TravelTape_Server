<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
	<head>
		<meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
		<style type="text/css">
		html {
			height: 100%
		}
		
		body {
			height  : 100%;
			margin  : 0px;
			padding : 0px;
		}
		
		#map_canvas {
			height: 100%
		}
		.loading-overlay {
			width:100%;
			height:100%;
			position:absolute;
			left : 0px;
			top  : 0px;
			background-color:black;
		}
		
		.loading-overlay .loading-bar-container{
			margin-left  : auto;
			margin-right : auto;
			margin-top   : 30%;
			margin-bottom: 50%;
			width:50%;
			height:40px;
		}
		.loading-overlay .loading-bar{
			background-color:gray;
			border-radius : 15px;
			width:0px;
			height:100%;
		}
		</style>
		<script type="text/javascript" src="./js/jquery-1.7.1.js"></script>
		<script type="text/javascript" src="./js/jquery-css-transform.js"></script>
		<script type="text/javascript" src="http://connect.facebook.net/en_US/all.js"></script>
		<script type="text/javascript" src="./js/sprintf.js"></script>
		<script type="text/javascript" src="./js/facebook/facebookAuth.js"></script>
		<script type="text/javascript" src="./js/imageCrop.js"></script>
		<script type="text/javascript" src="./js/facebook/albumController.js"></script>
		<script type="text/javascript" src="./js/async.js"></script>
		<script type="text/javascript" src="./js/step.js"></script>
		<script type="text/javascript" src="./js/jquery.transit.min.js"></script>
		<script type="text/javascript" src="https://maps.google.co.kr/maps/api/js?sensor=false"> </script>
		<script type="text/javascript">
			function LoadingManager(){
				this.maxProgress = 0 ;
				this.completedProgress = 0;
			}	
			LoadingManager.prototype = {
				reset : function(){
					this.maxProgress = 0;
					this.completedProgress = 0;
				},
				progressComplete : function(count){
					console.log(this.completedProgress);
					if(count){
						this.completedProgress += count;
						this.showProgress( this.completedProgress / this.maxProgress );
					}else{ 
						this.showProgress( ++this.completedProgress / this.maxProgress );
					}
				},
				addProgress : function(count){
					if(count)
						this.maxProgress += count;
					else 
						this.maxProgress++;
				},
				showProgress : function(progress){
					if(progress == 1){
						$(".loading-bar").clearQueue().transition({
							width : progress * 100 + "%"
						},function(){
							//$(".loading-overlay").fadeOut();
						});	
					}else{
						$(".loading-bar").clearQueue().transition({
							width : progress * 100 + "%"
						});	
					}
				}
			};
			var loadingManager = new LoadingManager();
			
		
			var seoulLocation = new google.maps.LatLng(37.5675451, 126.9773356);
			var g_googleMapInstance = null;
			var g_googleDirectionService = null;
			var g_googleDirectionRenderer = null;
			var g_googleStreetView = null;
			function getGoogleMap(){ return g_googleMapInstance; }
			function getGoogleDirectionService(){ return g_googleDirectionService; }
			function getGoogleDirectionRenderer(){ return g_googleDirectionRenderer;}
			function getGoogleStreetView() {return g_googleStreetView;}
			function initGoogleMap(){
		    	var myOptions = {
		    		zoom: 8,
		    		center: seoulLocation,
		    		mapTypeId: google.maps.MapTypeId.ROADMAP
		    	};
		    	g_googleMapInstance = new google.maps.Map(document.getElementById("map_canvas"),myOptions);
		    	
		    	g_googleDirectionService = new google.maps.DirectionsService();
				g_googleDirectionRenderer = new google.maps.DirectionsRenderer();
		        g_googleDirectionRenderer.setMap(g_googleMapInstance);
		    }
			
			var journalMarkerArray = [];
			
			var startLoc,endLoc;
			function calcRoute(startLoc,endLoc){
				var request = {
			        origin	    : startLoc,
			        destination : endLoc,
			        travelMode	: google.maps.TravelMode.TRANSIT
			    };
			    getGoogleDirectionService().route(request, function(response, status) {
			    	if (status == google.maps.DirectionsStatus.OK) {
			     		var path = new google.maps.Polyline({
							path: response.routes[0].overview_path,
						    strokeColor: "#000FFF",
						    strokeOpacity: 0.8,
						    strokeWeight: 5,
						    map : getGoogleMap()
						});
					}
			    });
			}
			$(document).ready(function(){
				Array.prototype.popAt = function(index){
					var item = this[index];
					this.splice(index,1);
					return item;
				};
				
				initGoogleMap();
				async.waterfall([
					function(cb) {
						FBAuthInit("191785150891389",function(authResponse){
							cb(null,authResponse);
						});
					},function(authResponse,cb) {
						FB.api("me/albums",function(response){
							var albumArray = response.data;
							for(var index in albumArray)
							{
								var fbAlbum = albumArray[index];
								if(fbAlbum.name == "MyJournal Photos")
								{
									var albumController = new Album(fbAlbum);
									albumController.getPhotos(function(response){
										cb(null,response);
									});
								}
							}
						});
					},function(response,cb){
						var photoArray = response.data;
						
						loadingManager.addProgress(photoArray.length);
						
						photoArray.sort(function(a,b){
							var coordinate1 = eval("("+a.name+")");
							var coordinate2 = eval("("+b.name+")");
							if(coordinate1.createdTime > coordinate2.createdTime){
								return 1;	
							}
							else if(coordinate1.createdTime == coordinate2.createdTime){
								return 0;
							}
							else {
								return -1;
							}
						});
						async.forEach(photoArray,function(item){
							var coordinate1 = eval("("+item.name+")");
							console.log(coordinate1.createdTime);
						});
						
						var wayPoints = [];
						
						var previousMarker = null;
						for(var index = 0 ; index<photoArray.length ; index++){
							var fbPhoto = photoArray[index];
							var coordinate = eval("("+fbPhoto.name+")");
							
							var photoCoordinate = new google.maps.LatLng(coordinate.latitude, coordinate.longitude);
							
							wayPoints.push({
								location : photoCoordinate,
								stopover:true	
							});
							
							var newMarker = new google.maps.Marker({
							      position: photoCoordinate, 
							      map: getGoogleMap(), 
							      draggable:true,
							      animation: google.maps.Animation.DROP,
							      title:"!!!!"
							});   
							
							journalMarkerArray.push(newMarker);
							
							var contentString = 
							'<div>' +
						    		fs('<img style="width:200px;height:auto" src="%s"/>',fbPhoto.source) + 
						    '</div>';
							newMarker.infoWindow =  new google.maps.InfoWindow({
							    content: contentString
							});
							newMarker.infoWindow.open(getGoogleMap().getStreetView(),newMarker);
							if(previousMarker)
							{
								(function(p,n){
									setTimeout(function(){
										calcRoute(p,n);
									},3000*index);
								})(previousMarker.position,newMarker.position);
							}
							else{
								
							}
							previousMarker = newMarker;
							
							(function(marker){
								google.maps.event.addListener(marker, 'mouseover', function() {
									marker.infoWindow.open(getGoogleMap(),marker);
								});
								google.maps.event.addListener(marker, 'mouseout', function() {
									marker.infoWindow.close();
								});
								google.maps.event.addListener(marker, 'click', function() {
									getGoogleStreetView().setPosition(marker.position);
								});
							})(newMarker);	
							
							loadingManager.progressComplete();
						}
					}
				]);
			});
		</script>

	</head>
	<body>
		<div id="map_canvas" style="float:left;width:100%;height:100%"></div>
    	<div id="pano" style="float:right;width:50%;height:100%"></div>
    	<div class="loading-overlay">
    		<div class="loading-bar-container">
    			<div class="loading-bar"></div>
    		</div>
    	</div>
	</body>
</html>
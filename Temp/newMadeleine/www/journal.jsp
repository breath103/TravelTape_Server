<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Insert title here</title>
		<style>
			.journal-marker-info
			{
				width  : 300px;
				height : auto; 
			}
			.journal-marker-info img
			{
				width:100%;
				height:auto;
			}
		</style>
		
		<script type="text/javascript" src="./js/jquery-1.7.1.js"></script>
		<script type="text/javascript" src="./js/jquery-css-transform.js"></script>
		<script type="text/javascript" src="http://connect.facebook.net/en_US/all.js"></script>
		<script type="text/javascript" src="./js/sprintf.js"></script>
		<script type="text/javascript" src="./js/facebook/facebookAuth.js"></script>
		<script type="text/javascript" src="./js/imageCrop.js"></script>
		<script type="text/javascript" src="./js/facebook/albumController.js"></script>
		<script type="text/javascript" src="http://openapi.map.naver.com/openapi/naverMap.naver?ver=2.0&key=9e2692245422a65e14f3a40a4bc9470d"></script>
		<script type="text/javascript">
		function JournalMarker(){
			nhn.api.map.DraggableMarker.apply(this, arguments);
			this.infoWindow = null;
			this.previousMarker = null;
			this.nextMarker = null;
			
			this.lineToNext = new nhn.api.map.Polyline([], {
				strokeColor : '#5f0', // - 선의 색깔
				strokeWidth : 3, // - 선의 두께
				strokeOpacity : 0.8 // - 선의 투명도
			}); // - polyline 선언, 첫번째 인자는 선이 그려질 점의 위치. 현재는 없음.
			
			this.attach('changePosition', function(e) {
				/*currentTarget: JournalMarker
				newPoint: typeClass
				oldPoint: typeClass
				target: JournalMarker*/
				this.updateLine();
				if(this.getPrevious())
					this.getPrevious().updateLine();
			});
			oMap.addOverlay(this.lineToNext); // - 지도에 선을 추가함.
		}
		JournalMarker.prototype = nhn.api.map.DraggableMarker.prototype;
		/*
		JournalMarker.prototype.setInfoWindow = function(infoWindow){
			this.infoWindow = infoWindow;
		};
		*/
		JournalMarker.prototype.updateLine = function(){
			if(this.nextMarker)
				this.lineToNext.setPoints([this.getPoint(),this.getNext().getPoint()]);
		};
		JournalMarker.prototype.setPrevious = function(marker){
			this.previousMarker = marker;
		};
		JournalMarker.prototype.getPrevious = function(){
			return this.previousMarker;
		};
		JournalMarker.prototype.setNext = function(marker){
			this.nextMarker = marker;
			this.updateLine();
		};
		JournalMarker.prototype.getNext = function (){
			return this.nextMarker;
		};
		JournalMarker.prototype.initInfoWindow = function(source){
			this.infoWindow = new nhn.api.map.InfoWindow();
			oMap.addOverlay(this.infoWindow);
			this.infoWindow.setPosition({right : -150, top : 40});
			this.infoWindow.setContent('<div class="journal-marker-info">'+
										fs("<img src='%s'/>",source)
										+'</div>');
		};
		JournalMarker.prototype.getInfoWindow = function(){
			return this.infoWindow;
		};
		JournalMarker.prototype.showInfoWindow = function(){
			this.infoWindow.setPoint(this.getPoint());
			this.infoWindow.setVisible(true);
			this.infoWindow.autoPosition();
		};
		JournalMarker.prototype.hideInfoWindow = function(){
			this.infoWindow.setVisible(false);
		};
		
		var oMap = null;
			$(document).ready(function(){
				var oSeoulCityPoint = new nhn.api.map.LatLng(37.5675451, 126.9773356);
				var defaultLevel = 3;
				oMap = new nhn.api.map.Map(document.getElementById('map'), { 
							point : oSeoulCityPoint,
							zoom : defaultLevel,
							enableWheelZoom : true,
							enableDragPan : true,
							enableDblClickZoom : false,
							mapMode : 0,
							activateTrafficMap : false,
							activateBicycleMap : false,
							minMaxLevel : [ 1, 14 ],
							size : new nhn.api.map.Size(1000,1000)
				});		
				var oSlider = new nhn.api.map.ZoomControl();
				oMap.addControl(oSlider);
				oSlider.setPosition({
					top : 10,
					left : 10
				});
				oMap.attach('mouseenter', function(oCustomEvent) {
					var oPoint = oCustomEvent.point;
					var oTarget = oCustomEvent.target;
					if (oTarget instanceof JournalMarker) {
						if (oCustomEvent.clickCoveredMarker) {
							return;
						}
						else{
							oTarget.showInfoWindow();
						}
					}
				});
				oMap.attach('mouseleave', function(oCustomEvent) {
					var oTarget = oCustomEvent.target;
					if (oTarget instanceof JournalMarker) {
						oTarget.hideInfoWindow();
						oTarget.updateLine();
					}
				});
				
				FBAuthInit("191785150891389",function(authResponse){
					//	$(".article").append("<div class='BowlContainer'></div>");
						FB.api("me",function(me){
							$.post("./joinWithFacebookInfo.m",{
								facebook_id  : authResponse.userID,
								access_token : authResponse.accessToken,
								name 		 : me.name,
								email 		 : me.email
							},function(response){
								console.log(response);
							},"json");
						});
						FB.api("me/albums",function(response){
							var albumArray = response.data;
							for(var index in albumArray)
							{
								var fbAlbum = albumArray[index];
								if(fbAlbum.name == "MyJournal Photos")
								{
									var albumController = new Album(fbAlbum);
									albumController.getPhotos(function(response){
										var photoArray = response.data;
										//사진들을 정렬
										
										for(var i=0;i<photoArray.length;i++){
											for(var j=i+1;j<photoArray.length;j++){
												var coordinate1 = eval("("+photoArray[i].name+")");
												var coordinate2 = eval("("+photoArray[j].name+")");
												if(coordinate1.createdTime > coordinate2.createdTime)
												{
													var temp = 	photoArray[i];
													photoArray[i] = photoArray[j];
													photoArray[j] = temp;
												}
											}
										}
										
										var previousMarker = null;
										for(var index in photoArray){
											var fbPhoto = photoArray[index];
											var coordinate = eval("("+fbPhoto.name+")");
											
											var spriteIcon = new nhn.api.map.SpriteIcon( "http://static.naver.com/maps2/icons/pin_spot2.png",// 아이콘의 url, ie 6의 경우 background image로 저장됨.
													   {width : 28, height : 37}, // 마커에 들어갈 아이콘의 width/height
											  		   {width : 28, height : 37}, // Sprite 이미지의 전체 width/height
											   		  	0, // Sprite image 에서 몇 번째 이미지를 사용할 지에 대한 순서 또는 이미지의 x, y위치
											  		   {width : 14, height : 37} // 이미지의 offset
											 );

											var oPoint = new nhn.api.map.LatLng(coordinate.latitude, coordinate.longitude);
											var oMarker = new JournalMarker(spriteIcon, { title : '마커 : ' + oPoint.toString() });
											oMarker.initInfoWindow(fbPhoto.source);
											oMarker.setPoint(oPoint);
											oMap.addOverlay(oMarker);
											
											if(previousMarker)
											{
												previousMarker.setNext(oMarker);
												oMarker.setPrevious(previousMarker);
												console.log(previousMarker.getNext());
												previousMarker.updateLine();
												previousMarker = oMarker;
											}
											else
											{
												previousMarker = oMarker;
											}
											
										}
									});
								}
							}
						});
					});
			});
		</script>		
	</head>
	<body>
		<div id="map" style="border:1px solid #000;"></div>
		
	</body>	
</html>
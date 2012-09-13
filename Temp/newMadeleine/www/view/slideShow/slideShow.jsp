<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:useBean id="jsonObject" class="net.sf.json.JSONObject"/>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>${madeleine.name}</title>
		<style>
			*{ 
				margin:0;
				padding:0;
			}
			html, body{
				width:100%;
				height:100%;
			}
			body > .page
			{
				background-color:black;
				width  : 100%;
				height : 100%;
				clear : both;
				position:relative;
			}
			body > .page > .contents-wrapper
			{
				background-image : url("./resource/slideshow/background/blue_texture.jpg");
				background-size : 100% auto;
				margin-left : auto;
				margin-right: auto;
				height:100%;
				width:auto;
				overflow:hidden;
			}
			.slide-container{
				width:100%;
				height:100%;
				overflow:hidden;
				position:relative;
			}
			.Photo{
				position:absolute;
				left:15%;
				top:15%;
				width:70%;
				height:70%;
				overflow: hidden;
				background-color:white;
				padding : 1%;	
			}
			.Photo .image-container{
				width:100%;
				height:100%;
				overflow:hidden;
			}
			.controller-container
			{
				position:fixed;
				top:90%;
				left:40%;
				width:20%;
			}
		</style>
		<script type="text/javascript" src="./js/jquery-1.7.1.js"></script>
		<script type="text/javascript" src="./js/jquery-css-transform.js"></script>
		<script type="text/javascript" src="http://connect.facebook.net/en_US/all.js"></script>
		<script type="text/javascript" src="./js/sprintf.js"></script>
		<script type="text/javascript" src="./js/facebook/facebookAuth.js"></script>
		<script type="text/javascript" src="./js/imageCrop.js"></script>
		<script type="text/javascript" src="./js/slideshow/controller.js"></script>
		
		
		<script type="text/javascript">
			function onContentsWrapperResize() {
				var ratio = 1024/768; //가로 세로 비율
				//래퍼의 높이를 언제나 100% 로 고정하고, 가로 세로 비율에 따라 width만 리사이징 한다.
				var $wrapper = $(".contents-wrapper");
				var height = $wrapper.height();
				var width  = height * ratio;
				$wrapper.width(width);
				console.log(sprintf("%f %f",height,width));
			}
		
			function LoadingManager(){
				this.allProcessCount = 0;
				this.completeProcessCount = 0;
			}	
			
			LoadingManager.prototype = {
				addProcess : function(){
					this.allProcessCount++;
				},
				onProcessComplete : function(){
					this.completeProcessCount++;
					if(this.allProcessCount == this.completeProcessCount)
						console.log(this.allProcessCount);
				}
			};
			var loadingManager = new LoadingManager();
		
			function R2Br(str){ return str.split("\n").join("</br>");}
			
			function Photo(json){
				//this.jsonInfo = json;
				this.idx		 = json.idx;
				this.src 		 = json.src;
				this.description = json.description;
				this.sourceType  = json.sourceType;
				this.sourceID    = json.sourceID;
				
				this.additionalSourceInfo  = null;
				
				loadingManager.addProcess();
				this.startLoadingAdditionalSourceInfo();
			}
			Photo.prototype = {
				startLoadingAdditionalSourceInfo : function(){
					//여기에 다른 소스타입들의 경우. 미투데이나 등등등에 대한 처리를 넣는다.
					if(this.sourceType == "FACEBOOK"){
						(function(photo){
							FBUtil.fetchObject(photo.sourceID,function(response){
								photo.onAdditionalSourceInfoLoaded(response);
							});
						})(this);
					}
				},
				onAdditionalSourceInfoLoaded : function(sourceInfo){
					this.additionalSourceInfo = sourceInfo;
					$(".slide-container").append(this.generateDiv());
					
					this.getDiv().find(".image-container").cropImageCenter();
					
					loadingManager.onProcessComplete();
				},
				generateDiv : function(){
					var commentStr = "";
					//여기에 다른 소스타입들의 경우. 미투데이나 등등등에 대한 처리를 넣는다.
					if(this.sourceType == "FACEBOOK"){
						if(this.additionalSourceInfo.comments){
							for(var key in this.additionalSourceInfo.comments.data){
								var comment = this.additionalSourceInfo.comments.data[key];
								commentStr += fs("%s : %s</br>",comment.from.name,comment.message);
							}
						}
					}	
					
					return fs("<div class='Photo' photoid = '%s'>" + 
							  	"<div class='image-container'>"+
									"<img src = '%s'/>" + 
								"</div>" + 
								"%s</br>%s" + 
							 "</div>",this.idx,this.src,R2Br(this.description),R2Br(commentStr));
				},
				getDiv : function(){
					return $(fs("*[photoid=%s]",this.idx));
				}
			};
			
			
			function SlideShowController(jsonInfo) {
				this.madeleine = jsonInfo;
				this.photos = [];
				this.currentSlideIndex = 0;
				for ( var index in this.madeleine.photos) {
					var photo = this.madeleine.photos[index];
					this.photos.push(new Photo(photo));
				}
				this.state = this.STATE.NOT_STARTED;
			}
			SlideShowController.prototype = {
				start : function() {
					//초기화 	
				},
				pause : function() {

				},
				resume : function(){
					
				},
				togglePlay : function(){
					if(this.state != this.STATE.PLAYING){
						this.resume();
					}
					else{
						this.pause();
					}
				},
				next : function() {

				},
				previous : function() {

				},
				
				STATE : Object.freeze({
					NOT_STARTED : "NOT_STARTED",
					PAUSED  	: "PAUSED",
					PLAYING 	: "PLAYING"
				}),
				getState : function() {
					return this.state;
				},
				setCurrentSlideIndex : function(index){
					this.currentSlideIndex = index;
				},
				getCurrentSlideIndex : function() {
					return this.currentSlideIndex;
				}
			};
			var slideShowController;
			$(document).ready(function(){
				onContentsWrapperResize();
				FBAuthInit("191785150891389",function(authResponse){
					var jsonMadeleine = ${jsonMadeleine};
					slideShowController = new SlideShowController(jsonMadeleine);
					$(".Photo").css({display:"none"});
					
					
					slideShowController.start = function(){
						this.next();
					};
					slideShowController.next = function(){
						
					};
					
					slideShowController.previous = function(){
						
					};
					
					$("#prev-button").click(function(){
						slideShowController.previous();
					});
					$("#next-button").click(function(){
						slideShowController.next();
					});
					$("#toggle-play-button").click(function(){
						slideShowController.togglePlay();
					});
				});
			});
		</script>
	</head>
	<body onresize = "onContentsWrapperResize();"> 
		<div class="page">
			<div class="contents-wrapper">
			
				<div class="audio-container" style="display:none">
					<audio controls="controls">
		 				<source src="./resource/slideshow/sound/bg1.mp3" type="audio/mpeg" />
			 		 	<p>Your browser does not support the audio element.</p>
					</audio>
				</div>
				
				<div class="slide-container">
				</div>
				
				<div class="controller-container">
					<button id="prev-button"> < </button>
					<button id="toggle-play-button"> ㅁ </button>
					<button id="next-button"> > </button>
				</div>
			</div>
		</div>
	</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Madeleine</title>
		<link rel="SHORTCUT ICON" href="http://www.davesite.com/webstation/html/favicon.ico">
		<style>
			* {
				font-size: 1em;
				letter-spacing: 1px;
				font-family: NanumGothic,"Apple SD Gothic Neo","Malgun Gothic",AppleGothic,Dotum,sans-serif;
			}
		
			body{
				margin:0px 0px 0px 0px;
				background-color:#FDF1DC;
			}
			body .page-wrapper{
				margin-left:auto;
				margin-right:auto;
				
				width:100%;
				max-width:1024px;
				
				height : 100%;
			}
			.page-wrapper .header{
				/*
				background-size : 100% 100%;
				background-image : url("http://th02.deviantart.net/fs71/PRE/f/2010/004/d/9/Metal_Texture_by_Helpax.jpg");
				*/
				background-color : brown;
				width:100%;
				height:50px;
				box-shadow: 0px 0px 10px white;
				text-align:center;		
			}
			.page-wrapper .header span{
				text-shadow: 0px 0px 5px #FFFFFF;
				width: 70%; 
				margin: 0 auto; 
				text-align: center; 
				color: white; 
				line-height: 50px; 
				font-weight: bold;
				font-size: 1.2em;
				text-overflow: ellipsis; 
				overflow: hidden; 
				white-space: nowrap;
			}
			
			.page-wrapper .article{
				position:relative;
				width:100%;
				height:700px;
				overflow:scroll;
				background-color:#FFB667;
			}
			.page-wrapper .article .section
			{
				width:100%;
				height:100%;
			}
			.page-wrapper .footer{
				background-color:white;	
				width:100%;
				height:50px;
			}
			
			
			.image-container{
				overflow:hidden;	
				width:100%;
				height:100%;
			}
			.image-container img{
			
			}
			
			.AlbumContainer{
				width:100%;
				height:80%;
				overflow:scroll;
			}
			.BowlContainer{
				width:100%;
				height:20%;
				background-color:red;	
			}
			
			.Photo{
				position:relative;
				display:inline-block;
				float:left;
				width:100px;
				height:100px;
				overflow:hidden;
			/*
				border-radius:10px;
				background-color:white;
				margin:2px 2px 2px 2px;
				padding : 5px 5px 5px 5px;
			*/
			}
			.Photo .image-container{
				height:100%;
			}
			.Album {	
				border : red solid 0px;
				width:100%;
				height:auto;
				display:inline-block;
				position:relative;
			}
		</style>
		<script type="text/javascript" src="./js/jquery-1.7.1.js"></script>
		<script type="text/javascript" src="./js/jquery-css-transform.js"></script>
		<script type="text/javascript" src="http://connect.facebook.net/en_US/all.js"></script>
		<script type="text/javascript" src="./js/sprintf.js"></script>
		<script type="text/javascript" src="./js/facebook/facebookAuth.js"></script>
		<script type="text/javascript" src="./js/imageCrop.js"></script>
		<script type="text/javascript" src="./js/facebook/albumController.js"></script>
		<script type="text/javascript" language="javascript">
			//Override For facebook album and photo Controller
			function implementsFacebookControllers(){
				Photo.prototype.generateDivString = function() {
					return fs(
							"<div class='Photo' albumid = '%s' photoid='%s'>" + 
								"<div class='image-container'>" + 
									"<img src='%s'/>" + 
								"</div>" + 
							"</div>", 
							this.getAlbumController().getFBData().id,
							this.fbPhoto.id, this.fbPhoto.images[3].source
							);
				};
				Album.prototype.generateDivString = function() {
					return sprintf("<div class='Album' albumId='%s'></div>",
							this.fbAlbum.id);
				};
			}
		
		
			
			var selectedPhotos = [];
			function createMadeleine(){
				$.post("./madeleine/create.m",$.param({
					name   : "Test Madeleine",
					photos : JSON.stringify(selectedPhotos)
				}),function(response){
					console.log(response);
				},"json");
			}
			$(document).ready(function(){
				
				implementsFacebookControllers();
				
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
							var albumController = new Album(albumArray[index]);
							
							$(".AlbumContainer").append(albumController.generateDivString());
							
							albumController.getDiv().mouseenter(function(){
								$.each($(this).find(".Photo"),function(index,photo){
									var $photo = $(photo);
									if(index > 0)
										$photo.clearQueue().animate({"margin-left":"0px"});	
								});
							});
							albumController.getDiv().mouseleave(function(){
								$.each($(this).find(".Photo"),function(index,photo){
									var $photo = $(photo);
									if(index > 0)
										$photo.clearQueue().animate({"margin-left":"-90px"});	
								});
							});
							
							albumController.getCoverPhoto(function(response){
							//	this.getDiv().css({"background-image" : "url("+response.source+")"});
							});
							albumController.getPhotos(function(response){
								var photoArray = response.data;
								for(var index in photoArray){
									var photo = this.createPhotoController(photoArray[index]);
									this.getDiv().append(photo.generateDivString());
									photo.onImageLoaded(function(){
							
									});
									photo.getDiv().click(function(){
										var albumController = getAlbumController($(this).attr("albumid"));
										var photoController = albumController.getPhotoController($(this).attr("photoid"));
										selectedPhotos.push(photoController.toTransportableJSON());
									});
									if(index > 0)
										photo.getDiv().css({"margin-left":"-90px"});
									
									photo.getDiv().find(".image-container").cropImageCenter()
												  .resize(function(){
													  $(this).find(".image-container").cropImageCenter();
												   });
								}
							});
						}
					});
				});
			});
		</script>
	</head>
	<body>
		<div class="page-wrapper">
			<div class="header">
				<span>New Madeleine</span>
			</div>
			<div class="article">
				<div class='AlbumContainer'></div>
				<div class='BowlContainer'></div>
			</div>
			<div class="footer">
			</div>
		</div>
	</body>
</html>
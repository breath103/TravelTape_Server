<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"
	import = "com.TravelTape.Entity.*,
			  net.sf.json.*"%>
<!DOCTYPE html>
<html lang="ko">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>TT</title>
		<link rel="SHORTCUT ICON" href="http://www.davesite.com/webstation/html/favicon.ico">
		<link rel="stylesheet" type="text/css" href="/TravelTape/css/common.css">
		<script type="text/javascript" src="./js/jquery-1.7.1.js"></script>
		<script type="text/javascript" src="./js/jquery-css-transform.js"></script>
		<script type="text/javascript" src="http://connect.facebook.net/en_US/all.js"></script>
		<script type="text/javascript" src="./js/sprintf.js"></script>
		<script type="text/javascript" src="./js/facebook/facebookAuth.js"></script>
		<script type="text/javascript" language="javascript">
			function loginWithFacebook(){
				FBAuthInit("191785150891389",function(authResponse){
					console.log(authResponse);
					//로직상으로는 이부분을 통과하면 자동으로 로그인을 시켜버린다.
					FB.api("me",function(me){
						$.post("./joinWithFacebookInfo.tt",{
							facebook_id  : authResponse.userID,
							access_token : authResponse.accessToken,
							name 		 : me.name,
							email 		 : me.email
						},function(response){
							console.log(response);
							alert("인증 완료");
							location.href = './main.tt';
						},"json");
					});
				});
			}
			function logout(){
				location.href = "./logout.tt";
			}
			$(document).ready(function(){
				
				
			});
		</script>
	</head>
	<body>
		<%	TravelTapeUser user = (TravelTapeUser)session.getAttribute(TravelTapeUser.sessionAttributeName);
			if(user == null){%>
				<button onclick="loginWithFacebook();">페이스북으로 회원가입하기</button>
			<%}else{%>
				<div style="width:100%">
					<%=user.getIdx() %> </br>
					<%=user.getName() %> </br>
					<%=user.getUserType() %></br>
					<%=user.getForeginUserID() %></br>
					<%=user.getForeginAccessToken() %></br>
				</div>
				<button onclick="logout();">logout</button>
			<%}%>
	</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title></title>
		<style>
		* {
			margin: 0;
			padding: 0;
		}
		
		.page{
			width:100%;
			height:100%;
			clear:both;
		}
		.contents-wrapper{
			width:100%;
			clear:both;
		}
		
		
		.boardList{
			
		}
		.boardList > li{
			border : 1px solid #E4E5E7;
		}
		.boardList > li:first-child{
		}
		.boardList > li:last-child{
	
		}
		</style>
		<script>
			function onWriteButton()
			{
				
			}
		</script>
	</head>
	<body>
		<div class="page">
			<div class="contents-wrapper"> 
				<ul class="boardList">
					<c:forEach items="${boardList}" var = "board">
						<li>
							${board.idx}
							${board.title}
							${board.text}
							${board.writtenTime}
							${board.modifiedTime}
						</li>
					</c:forEach>
				</ul>
			</div>
			<button onclick = "onWriteButton();">write</button>
		</div>
	</body>
</html>
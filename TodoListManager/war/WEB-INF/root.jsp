<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="UTF-8">
		<title>TODO LIST MANAGER</title>
	</head>
	<body>
	
	<c:choose>
		<c:when test = " ${user != null } ">
			<p>
				Welcome ${user.email} <br/>
				You can signout <a href="${logout_url}">here</a><br/>
			</p>
		</c:when>
		<c:otherwise>
			<p>
				Welcome!
				<a href="${login_url}">Sign in or register</a>
			</p>
		</c:otherwise>
	</c:choose>
	
	</body>
</html>
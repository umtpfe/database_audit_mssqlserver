<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Connexion a la Base SQLServer</title>
</head>
<body>
	<fieldset>
		<legend>Coordonnées de la base SQLServer cible</legend>
		<form action="TsqlServlet" method="post">
			<table>
				<tr>
					<td><label for=host>Hostname</label></td>
					<td><input type="text" name="host" /></td>
				</tr>
				<tr>
					<td><label for=port>Port</label></td>
					<td><input type="text" name="port" /></td>
				</tr>
				<tr>
					<td><label for=database>Database/Schema</label></td>
					<td><input type="text" name="database" /></td>
				</tr>
				<tr>
					<td><label for=username>Username</label></td>
					<td><input type="text" name="username" /></td>
				</tr>
				<tr>
					<td><label for=password>Password</label></td>
					<td><input type="password" name="password" /></td>
				</tr>
				<tr>
					<td><input type="submit" value="Se connecter" /></td>
					<td><input type="reset" value="Annuler" /></td>
				</tr>
			</table>
		</form>
	</fieldset>
</body>
</html>
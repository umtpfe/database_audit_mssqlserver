<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8" />
        <title>Audit de base</title>
<!--        <link rel="stylesheet" type="text/css" href="signin.css" />-->
    </head>
    <body   style="height: 100%; display: -ms-flexbox; display: flex; flex-direction: column; align-items: center; padding-top: 40px; padding-bottom: 40px; background-color:beige; background-image: url(https://purepng.com/public/uploads/large/purepng.com-server-databaseservercomputingclientserverservice-providercommoditycloud-serverdatabasewindows-server-1701528389209cejn9.png);">
        <fieldset style="width: 100%; max-width: 330px; padding: 15px; margin: auto; align-content: center; background-color: darkblue; font-weight: 400; border-color: darkblue; border-radius: 10px 10px 10px 10px; ">
            <legend style="display: flex; flex-direction: column;">
                <img src="https://cdn.pixabay.com/photo/2013/07/12/17/22/database-152091_960_720.png" width="125px" height="100px" style=" align-content: center;  padding-left: 105px;" />
                 <p style="padding-left: 60px; color: white; font-weight: 100; font-family:fantasy; font-style: normal;">COORDONNEES DE LA BASE CIBLE</p>
                </legend>
        <form action="TsqlServlet" method="post" >
            <table>
				<tr>
					<td><label for="host" style="color: white;" >Hostname</label></td>
                    <td><input type="text" name="host" style="position: relative; box-sizing: border-box; height: auto; padding: 10px; font-size: 16px;" placeholder="Host" required autofocus value="vps338739.ovh.net"></td>
				</tr>
				<tr>
					<td><label for="port" style="color: white;">Port</label></td>
                    <td><input type="text" name="port" style="position: relative; box-sizing: border-box; height: auto; padding: 10px; font-size: 16px;" placeholder="Port" required autofocus value="1433"></td>
				</tr>
				<tr>
				    <td><label for="database" style="color: white;">Database</label></td>
                    <td><input type="text" name="database" style="position: relative; box-sizing: border-box; height: auto; padding: 10px; font-size: 16px;" placeholder="Database" required autofocus value="pubs"></td>
				</tr>
				<tr>
					<td><label for="username" style="color: white;">Username</label></td>
                    <td><input type="text" name="username" style="position: relative; box-sizing: border-box; height: auto; padding: 10px; font-size: 16px;" placeholder="Username" required autofocus value="sa"></td>
				</tr>
				<tr>
					<td><label for="password" style="color: white;">Password</label></td>
                    <td><input type="password" name="password" style="position: relative; box-sizing: border-box; height: auto; padding: 10px; font-size: 16px; margin-bottom: 10px; border-top-left-radius: 0; border-top-right-radius: 0;" required autofocus value="Formafast.2014"></td>
                </tr>
			</table>
            <div style="margin-top: 20px; margin-bottom: 20px; margin-left: 100px; padding-right: 10px;">
					<input type="submit" value="Connexion" />
                    <input type="reset" value="Annuler" />
            </div>
            </form>
        </fieldset>
       <p style="padding-left: 10px; color: black; font-weight: 100; font-family:fantasy; font-style: normal;"> 
       		<c:if test="${ con == false}" var="variable"> <c:out value="ECHEC: Assurez vous de verifier vos parametres" /> </c:if>
       </p>
    </body>
</html>
package com.formatfast.connect;

/*import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
import java.sql.SQLException;*/
import java.sql.*;

import com.mysql.jdbc.Connection;

public class ConnexionSqlserver 
	{
	public static Connection getConnection(String host,String port, String database, String username, String password) {
		
		Connection ConSqlServer = null;
		
		try {
			Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");

			/*
			 * String userName = "sa"; String password = "Formafast.2014"; String port =
			 * (String) "1433" ;
			 */
           /* String databaseName = "master";*/
            String url = "jdbc:sqlserver://"+host+":"+port+";databaseName="+database+"";
            java.sql.Connection conSqlServer =  DriverManager.getConnection(url, username, password);
            System.out.println("connexion établie à mssqlserver");
				
		}catch(Exception e) 
		{
			System.out.println(e.getMessage());
			System.out.println("echec");
		}
		return ConSqlServer;
	}
}
package com.formatfast.connect;

/*import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
import java.sql.SQLException;*/
import java.sql.*;

import com.mysql.jdbc.Connection;

public class ConnexionSqlserver 
	{
	public static Connection getConnection() {
		
		Connection ConSqlServer = null;
		
		try {
			Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");

            String userName = "sa";
            String password = "Formafast.2014";
            String url = "jdbc:sqlserver://vps338739.ovh.net:1433"+";databaseName=master";
            java.sql.Connection con =  DriverManager.getConnection(url, userName, password);
            System.out.println("connexion établie à mssqlserver");
				
		}catch(Exception e) 
		{
			System.out.println(e.getMessage());
		}
		return ConSqlServer;
	}
}
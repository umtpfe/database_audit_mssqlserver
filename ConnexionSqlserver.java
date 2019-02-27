package com.formatfast.connect;

/*import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
import java.sql.SQLException;*/
import java.sql.*;

import com.mysql.jdbc.Connection;

public class ConnexionSqlserver {

	public static void main(String[] args) throws ClassNotFoundException, SQLException {

		String ConnectionURL = "jdbc:sqlserver://vps338739.ovh.net:1433;"+"databaseName=master;integratedSecurity=true;";
		Connection conn = null;
		Statement stmt = null;
		ResultSet rst = null;
		try {
			
			Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
			conn = (Connection) DriverManager.getConnection(ConnectionURL);
			System.out.println("connexion effectuee");
			
		}catch(Exception e) 
		{
			System.out.println(e.getMessage());
		}
		
	}
}
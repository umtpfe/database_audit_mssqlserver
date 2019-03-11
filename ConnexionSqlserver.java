package com.formatfast.connect;

import java.sql.Connection;
import java.sql.DriverManager;

public class ConnexionSqlserver 
	{
	public static Connection getConnection(String host,String port, String database, String username, String password) {
		
		Connection consqlserver = null;
		
		try {
			Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            String url = "jdbc:sqlserver://"+host+":"+port+";databaseName="+database;
            consqlserver = DriverManager.getConnection(url, username, password);
            System.out.println("connexion établie à mssqlserver");
		}catch(Exception e) 
		{
			System.out.println(e.getMessage());
			System.out.println("echec de la connexion à la base");
		}
		return consqlserver;
	}
}
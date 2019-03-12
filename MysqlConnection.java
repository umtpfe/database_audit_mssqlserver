package com.formafast.connection;

import java.sql.DriverManager;

import com.mysql.jdbc.Connection;

public class MysqlConnection {

	public static Connection getConnexion() {
		Connection conmysql = null;
		
		try {
			Class.forName("com.mysql.jdbc.Driver");
			conmysql = (Connection) DriverManager.getConnection("jdbc:mysql://vps49352.ovh.net:3306/formafast_audit","diagnoseur","ymuhahezy");
			System.out.println("Connexion établie à Mysql");
		}catch(Exception e) {
			System.out.println(e.getMessage());
		}
		return conmysql;
	}
	
	
}

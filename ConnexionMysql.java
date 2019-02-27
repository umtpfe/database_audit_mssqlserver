package com.formatfast.connect;

import java.sql.DriverManager;

import com.mysql.jdbc.Connection;

public class ConnexionMysql {

	public static Connection getConnexion() {
		Connection con = null;
		
		
		try {
			Class.forName("com.mysql.jdbc.Driver");
			con = (Connection) DriverManager.getConnection("jdbc:mysql://vps49352.ovh.net:3306/formafast_audit","diagnoseur","ymuhahezy");
			System.out.println("test connexion");
		}catch(Exception e) {
			System.out.println(e.getMessage());
		}
		return con;
	}
	
	
}

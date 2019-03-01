package com.formatfast.servlets;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintStream;
import java.io.PrintWriter;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.formatfast.connect.ConnexionMysql;
import com.formatfast.connect.ConnexionSqlserver;
import com.mysql.jdbc.Connection;

/**
 * Servlet implementation class HelloServlet
 */
@WebServlet("/MaServlet")
public class MaServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	Connection ConMySql = null;
	Connection ConSqlServer = null;

	PreparedStatement PsMySql = null;
	PreparedStatement PsSqlServer = null;

	ResultSet RsMySql = null;
	ResultSet RsSqlServer = null;

    public static int conAtv = 0;
	
	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public MaServlet() {
		super();
		// TODO Auto-generated constructor stub
		ConMySql = ConnexionMysql.getConnexion();
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
		this.getServletContext().getRequestDispatcher("/WEB-INF/page.jsp").forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub

		 String host = request.getParameter("host"); 
		 String port = request.getParameter("port");
		 String database = request.getParameter("database");
		 String username = request.getParameter("username"); 
		 String password = request.getParameter("password");
		  
		 ConSqlServer = ConnexionSqlserver.getConnection(host,port,database,username,password);
		 
		 File reponse = new File("reponse.txt");
		 System.out.println (reponse.getAbsolutePath());
		 
		String sql = "SELECT *  FROM rule_1 where categorie='con' and type='sql' ";
		try ( BufferedWriter bufferedwriter = new BufferedWriter(new FileWriter(reponse)) )
		  { 
			try 
			{
				PsMySql = ConMySql.prepareStatement(sql); 
				  RsMySql =	 PsMySql.executeQuery();
				  while (RsMySql.next())
				  { 
					  String idrule = RsMySql.getString("idrule"); 
					  String libelle = RsMySql.getString("libelle");
					  String code = RsMySql.getString("code"); 
					  String role = RsMySql.getString("role"); 
					  String categorie = RsMySql.getString("categorie");
					  String type = RsMySql.getString("type");
					  String diagnostic = RsMySql.getString("diagnostic");
					  String url = RsMySql.getString("url");
					  String basetype = RsMySql.getString("basetype"); 	
					  
					  bufferedwriter.write("idrule = "+idrule);
					  bufferedwriter.newLine();
					  bufferedwriter.write("libelle = "+libelle);
					  bufferedwriter.newLine();
					  bufferedwriter.write("code = "+code);
					  bufferedwriter.newLine();
					  bufferedwriter.write("role = "+role);
					  bufferedwriter.newLine();
					  bufferedwriter.write("categorie = "+categorie);
					  bufferedwriter.newLine();
					  bufferedwriter.write("type = "+type);
					  bufferedwriter.newLine();
					  bufferedwriter.write("diagnostic = "+diagnostic);
					  bufferedwriter.newLine();
					  bufferedwriter.write("url = "+url);
					  bufferedwriter.newLine();
					  bufferedwriter.write("basetype = "+basetype);
					  bufferedwriter.newLine();
					  bufferedwriter.newLine();
					  bufferedwriter.newLine();
					  
				  }		
			}catch(Exception e1) 
			{	
				e1.printStackTrace();
			}		 
		  }
		  catch (Exception e)
		  	{
			  e.printStackTrace();
		  	}
		request.setAttribute("conAtv", conAtv);
		this.getServletContext().getRequestDispatcher("/WEB-INF/page.jsp").forward(request, response);
		
		/* test du programme de telechargement du fichier 
		  
		 
		PrintWriter out = response.getWriter();
		String filename = "reponse.txt";
		String filepath = "/home/meril/eclipse/jee-2018-12/eclipse/";
		response.setContentType("APPLICATION/OCTET-STREAM");
		response.setHeader("Content-Disposition","attachement; filename=\"" + filename + "\"");
		FileInputStream fi = new FileInputStream(filepath+filename);
		int i;
		while((i=fi.read()) != -1) {
			out.write(i);}
			out.close();
			fi.close();
		*/
		
		}	 
	@Override
	protected void service(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		// TODO Auto-generated method stub
		super.service(req, resp);		
	}

	
	
	
	
	
	
	
	
	
	
	
	
	
	
}

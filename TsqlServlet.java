package com.formafast.servlet;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.io.Reader;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.formafast.connection.MysqlConnection;
import com.formafast.connection.SqlserverConnection;
import com.mysql.jdbc.PreparedStatement;

import com.ibatis.common.jdbc.ScriptRunner;

/**
 * Servlet implementation class TsqlServlet
 */
@WebServlet("/TsqlServlet")
public class TsqlServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	Connection conmysql = null;
	java.sql.Connection consqlserver = null;

	PreparedStatement psmysql = null;
	java.sql.PreparedStatement pssqlserver = null;

	ResultSet rsmysql = null;
	ResultSet rssqlserver = null;

	/**
	 * Default constructor.
	 */
	public TsqlServlet() {
		super();
		// TODO Auto-generated constructor stub
		conmysql = MysqlConnection.getConnexion();
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
		this.getServletContext().getRequestDispatcher("/WEB-INF/form.jsp").forward(request, response);
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
		consqlserver = SqlserverConnection.getConnection(host, port, database, username, password);

		File test = new File("test.txt");
		System.out.println(test.getAbsolutePath());

		String sql = "SELECT * FROM rule_1 WHERE categorie='con' AND type='tsql'  ";

		try (BufferedWriter bufferedwriter = new BufferedWriter(new FileWriter(test))) {
			psmysql = (PreparedStatement) conmysql.prepareStatement(sql);
			rsmysql = psmysql.executeQuery();
			while (rsmysql.next()) {

				String idrule = rsmysql.getString("idrule");
				String libelle = rsmysql.getString("libelle");
				String code = rsmysql.getString("code");
				String role = rsmysql.getString("role");
				String categorie = rsmysql.getString("categorie");
				String type = rsmysql.getString("type");
				String diagnostic = rsmysql.getString("diagnostic");
				String url = rsmysql.getString("url");
				String basetype = rsmysql.getString("basetype");

				bufferedwriter.write("\nidrule = " + idrule + "\nLibelle = " + libelle + "\ncode = " + code
						+ "\nrole = " + role + "\ncategorie = " + categorie + "\ntype = " + type + "\ndiagnostic = "
						+ diagnostic + "\nurl = " + url + "\nbasetype = " + basetype
						+ "\nResultat:\n==============================\n");

				File testtt = new File("testtt.sql");

				try (BufferedWriter bufferedwriterrr = new BufferedWriter(new FileWriter(testtt))) {

					bufferedwriterrr.write(code);
					bufferedwriterrr.close();
				} catch (Exception e1) {
					e1.printStackTrace();
					System.out.println("erreur d'ecriture");
				}
				
				  ScriptRunner scriptExecutor = new ScriptRunner(consqlserver, false, false);
				  // initialisation du reader 
				  Reader reader = new BufferedReader(new FileReader("testtt.sql")); 
				  // execution du script avec le reader en input
				  scriptExecutor.runScript(reader);
				 
				  if (reader != null) {
					  reader.close();
				  }
				 

				testtt.delete();

				/* execution via la commande systeme
				 * String command =
				 * "psql -U "+username+" -d "+database+" -h "+host+" -f script.sql"; Runtime
				 * runtime = Runtime.getRuntime(); Process process = null; try { process =
				 * runtime.exec(command);
				 * 
				 * } catch(Exception err) { err.printStackTrace(); }
				 */

			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();

		}
		/* telechargement du fichier */

		PrintWriter out = response.getWriter();
		String filename = "test.txt";
		String filepath = "//home//meril//eclipse//jee-2018-12//eclipse//";
		response.setContentType("APPLICATION/OCTET-STREAM");
		response.setHeader("Content-Disposition", "attachement; filename=\"" + filename + "\"");
		FileInputStream fi = new FileInputStream(filepath + filename);
		int i;
		while ((i = fi.read()) != -1) {
			out.write(i);
		}
		fi.close();
		out.close();

	}

	@Override
	protected void service(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		// TODO Auto-generated method stub

		super.service(req, resp);

	}

}

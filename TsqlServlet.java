package com.formafast.servlet;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
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
		
		if (SqlserverConnection.connecter)
		{
			
			File dbname = new File(database + ".txt");
			System.out.println(dbname.getPath());
			String path = dbname.getPath();
			String sql = "SELECT * FROM rule_1 WHERE categorie='con' AND basetype='sqlserver'  ";
			/*File tempfile = new File("tempfile.sql");
			String temppath = tempfile.getAbsolutePath();
			System.out.println("chenmin de temppath : " + temppath);*/
			
			try (BufferedWriter bufferedwriter = new BufferedWriter(new FileWriter(dbname))) {
				psmysql = (PreparedStatement) conmysql.prepareStatement(sql);
				rsmysql = psmysql.executeQuery();
				while (rsmysql.next()) {
					/* récupération des données */
					/* String idrule = rsmysql.getString("idrule"); */
					String libelle = rsmysql.getString("libelle");
					String code = rsmysql.getString("code");
					String type = rsmysql.getString("type");
					System.out.println("Rule : " + libelle);
					/* écriture de la fche d'identité dans le fichier */
					bufferedwriter
							.write("\r\nLibelle = " + libelle + "\r\nResultat:\r\n==============================\r\n");

					/* SQL */
					if (type.equals("sql")) {

						/* exécution de la requête récupérée dans Mysql */
						if (code == null)
							break;
						pssqlserver = consqlserver.prepareStatement(code);
						rssqlserver = pssqlserver.executeQuery();

						/* Affichage des colonnes titres */
						java.sql.ResultSetMetaData rsmd = rssqlserver.getMetaData();
						int columnsNumber = rsmd.getColumnCount();
						for (int j = 1; j <= columnsNumber; j++) {
							if (j > 1)
								bufferedwriter.append(" | ");
							bufferedwriter.append(rsmd.getColumnName(j));
						}
						bufferedwriter.append("\r\n");
						/* Ecriture du résultat de la requête dans le fichier */
						while (rssqlserver.next()) {
							for (int i = 1; i <= columnsNumber; i++) {
								if (i > 1)
									bufferedwriter.append(" | ");
								String columnValue = (String) rssqlserver.getString(i);
								bufferedwriter.append(columnValue);
								if (i == columnsNumber)
									bufferedwriter.append("\r\n");
							}
						}
						bufferedwriter.append("\r\n===========================================\r\n\r\n");

					} else { /* T-SQL */
						/* création d'un fichier temporaire qui contiendra le script */
						File tempfile = new File("tempfile.sql");
						String temppath = tempfile.getPath();
						/* Ecriture du script dans le fichier */
						try (BufferedWriter bufferedwriterrr = new BufferedWriter(new FileWriter(tempfile))) {
							bufferedwriterrr.write(code);
							bufferedwriterrr.close();
						} catch (Exception e1) {
							e1.printStackTrace();
							System.out.println("erreur d'ecriture");
						}
						/* Exécution du script */
						try {

							Process process = Runtime.getRuntime().exec("sqlcmd -S " + host + " -d " + database + " -U "
									+ username + " -P " + password + " -i " + temppath);
							StringBuilder output = new StringBuilder();
							BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));

							String line = " ";
							while ((line = reader.readLine()) != null) {
								output.append(line + "\r\n");
							}
							int exitVal = process.waitFor();
							if (exitVal == 0) {
								System.out.println("Success!");
								bufferedwriter.append(output);
								bufferedwriter.append("\r\n=====================================\r\n");
							} else {
								System.out.println("Fail!");
							}

						} catch (IOException e) {
							e.printStackTrace();
						} catch (InterruptedException e) {
							e.printStackTrace();
						}
						/* suppression du fichier temporaire apres exécution du script */
						tempfile.delete();
					}
				}
			} catch (Exception e1) {
				e1.printStackTrace();
			}

			/*
			 * String sql = "SELECT * FROM rule_1 WHERE categorie='con' AND type='tsql'  ";
			 * 
			 * try (BufferedWriter bufferedwriter = new BufferedWriter(new
			 * FileWriter(dbname))) { psmysql = (PreparedStatement)
			 * conmysql.prepareStatement(sql); rsmysql = psmysql.executeQuery(); while
			 * (rsmysql.next()) {
			 * 
			 * String idrule = rsmysql.getString("idrule"); String libelle =
			 * rsmysql.getString("libelle"); String code = rsmysql.getString("code"); String
			 * role = rsmysql.getString("role"); String categorie =
			 * rsmysql.getString("categorie"); String type = rsmysql.getString("type");
			 * String diagnostic = rsmysql.getString("diagnostic"); String url =
			 * rsmysql.getString("url"); String basetype = rsmysql.getString("basetype");
			 * 
			 * bufferedwriter.write("idrule = " + idrule + "\r\nLibelle = " + libelle +
			 * "\r\ncode = " + code + "\r\nrole = " + role + "\r\ncategorie = " + categorie
			 * + "\r\ntype = " + type + "\r\ndiagnostic = " + diagnostic + "\r\nurl = " +
			 * url + "\r\nbasetype = " + basetype +
			 * "\r\nResultat:\r\n==============================\r\n");
			 * 
			 * try (BufferedWriter bufferedwriterrr = new BufferedWriter(new
			 * FileWriter(tempfile))) { bufferedwriterrr.write(code);
			 * bufferedwriterrr.close(); } catch (Exception e1) { e1.printStackTrace();
			 * System.out.println("erreur d'ecriture"); }
			 * 
			 * 
			 * try {
			 * 
			 * Process process = Runtime.getRuntime().exec("sqlcmd -S " + host + " -d " +
			 * database + " -U " + username + " -P " + password + " -i " + temppath);
			 * StringBuilder output = new StringBuilder(); BufferedReader reader = new
			 * BufferedReader(new InputStreamReader(process.getInputStream()));
			 * 
			 * String line = " "; while ((line = reader.readLine()) != null) {
			 * output.append(line + "\r\n"); } int exitVal = process.waitFor(); if (exitVal
			 * == 0) { System.out.println("Success!"); // System.out.println(output);
			 * bufferedwriter.append(output);
			 * bufferedwriter.append("\r\n=====================================\r\n"); }
			 * else { System.out.println("Fail!"); }
			 * 
			 * } catch (IOException e) { e.printStackTrace(); } catch (InterruptedException
			 * e) { e.printStackTrace(); } tempfile.delete();
			 * 
			 * } } catch (SQLException e) { // TODO Auto-generated catch block
			 * e.printStackTrace();
			 * 
			 * }
			 */
			/* telechargement du fichier */

			PrintWriter out = response.getWriter();
			String filename = database + ".txt";
			// String filepath = "C:\\Users\\a\\eclipse\\jee-2019-03\\eclipse\\";
			response.setContentType("APPLICATION/OCTET-STREAM");
			response.setHeader("Content-Disposition", "attachement; filename=\"" + filename + "\"");
			FileInputStream fi = new FileInputStream(path);
			int i;
			while ((i = fi.read()) != -1) {
				out.write(i);
			}
			fi.close();
			out.close();
			
		}else {
			request.setAttribute("con", SqlserverConnection.connecter);
			this.getServletContext().getRequestDispatcher("/WEB-INF/form.jsp").forward(request, response);
		}
		

		/*
		 * PrintWriter out = response.getWriter(); String filename = "tempfile.sql";
		 * //String filepath = "//home//meril//eclipse//jee-2018-12//eclipse//";
		 * response.setContentType("APPLICATION/OCTET-STREAM");
		 * response.setHeader("Content-Disposition", "attachement; filename=\"" +
		 * filename + "\""); FileInputStream fi = new FileInputStream(temppath2); int i;
		 * while ((i = fi.read()) != -1) { out.write(i); } fi.close(); out.close();
		 */

	}

	@Override
	protected void service(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		// TODO Auto-generated method stub

		super.service(req, resp);

	}

}

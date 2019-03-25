package com.formatfast.servlets;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

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
	Connection conmysql = null;
	java.sql.Connection consqlserver = null;

	PreparedStatement psmysql = null;
	PreparedStatement pssqlserver = null;

	ResultSet rsmysql = null;
	ResultSet rssqlserver = null;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public MaServlet() {
		super();
		// TODO Auto-generated constructor stub
		conmysql = ConnexionMysql.getConnexion();
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

		/* connexion a sql server */
		String host = request.getParameter("host");
		String port = request.getParameter("port");
		String database = request.getParameter("database");
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		consqlserver = ConnexionSqlserver.getConnection(host, port, database, username, password);

		/* creation du fichier pour le retour de la reponse */
		File reponse = new File("reponse.txt");
		System.out.println(reponse.getAbsolutePath());

		/* execution de la requete pour la table id_rule_1 */
		String sql = "SELECT * FROM rule_1 WHERE categorie='con' AND basetype='sqlserver'  ";

		try (BufferedWriter bufferedwriter = new BufferedWriter(new FileWriter(reponse))) {
			psmysql = conmysql.prepareStatement(sql);
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

				System.out.println("Rule : " + idrule + " " + libelle);

				bufferedwriter.write("idrule = " + idrule + "\nLibelle = " + libelle + "\ncode = " + code + "\nrole = "
						+ role + "\ncategorie = " + categorie + "\ntype = " + type + "\ndiagnostic = " + diagnostic
						+ "\nurl = " + url + "\nbasetype = " + basetype
						+ "\nResultat:\n==============================\n");

				if (type.equals("sql")) {

					/* exécution de la requete recupere dans mysql */
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
					bufferedwriter.append("\n");
					/* Affichage des données de la table resultat */
					while (rssqlserver.next()) {
						for (int i = 1; i <= columnsNumber; i++) {
							if (i > 1)
								bufferedwriter.append(" | ");
							String columnValue = (String) rssqlserver.getString(i);
							bufferedwriter.append(columnValue);
							if (i == columnsNumber)
								bufferedwriter.append(" \n ");
						}
					}
					bufferedwriter.append("\n===========================================\n\n");

				} else {

					File tempfile = new File("tempfile.sql");
					String temppath = tempfile.getAbsolutePath();
					
					try (BufferedWriter bufferedwriterrr = new BufferedWriter(new FileWriter(tempfile))) {
						bufferedwriterrr.write(code);
						bufferedwriterrr.close();
					} catch (Exception e1) {
						e1.printStackTrace();
						System.out.println("erreur d'ecriture");
					}

					try {
						
						Process process = Runtime.getRuntime().exec("//opt//mssql-tools//bin//sqlcmd -S "+host+" -d "+database+" -U "+username+" -P "+password+" -i "+temppath);
						StringBuilder output = new StringBuilder();
						BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));

						String line = " ";
						while ((line = reader.readLine()) != null) {
							output.append(line + "\n");
						}
						int exitVal = process.waitFor();
						if (exitVal == 0) {
							System.out.println("Success!");
							bufferedwriter.append(output);
							bufferedwriter.append("\n===========================================\n\n");
						} else {
							System.out.println("Fail!");
						}

					} catch (IOException e) {
						e.printStackTrace();
					} catch (InterruptedException e) {
						e.printStackTrace();
					}
					tempfile.delete();
				}
			}
		} catch (Exception e1) {
			e1.printStackTrace();
		}
		/* telechargement du fichier */
		PrintWriter out = response.getWriter();
		String filename = "reponse.txt";
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

package com.formafast.servlet;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
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

		String sql = "SELECT * from rule_1 WHERE categorie='con' AND type='tsql' ";

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

				System.out.println("Rule : " + idrule + " " + libelle);

				bufferedwriter.write("idrule = " + idrule + "\nLibelle = " + libelle + "\ncode = " + code + "\nrole = "
						+ role + "\ncategorie = " + categorie + "\ntype = " + type + "\ndiagnostic = " + diagnostic
						+ "\nurl = " + url + "\nbasetype = " + basetype
						+ "\nResultat:\n==============================\n");

				switch (idrule) {
				case "4": /* */
					break;

				case "6": /* Toute une colonne à  la même valeur */
					String sqlt = "SELECT DISTINCT table_name from INFORMATION_SCHEMA.COLUMNS";
					pssqlserver = consqlserver.prepareStatement(sqlt);
					rssqlserver = pssqlserver.executeQuery();
					while (rssqlserver.next()) {
						String tablename = rssqlserver.getString("table_name");
						String sqlc = " SELECT column_name FROM information_schema.columns WHERE table_name = "
								+ tablename;
						java.sql.PreparedStatement ps = consqlserver.prepareStatement(sqlc);
						ResultSet rs = ps.executeQuery();
						while (rs.next()) {
							String nom_colonne = rs.getString("column_name");
							java.sql.PreparedStatement ps1 = consqlserver.prepareStatement(code);
							ps1.setString(1, nom_colonne);
							ps1.setString(2, tablename);

							System.out.println(tablename + nom_colonne + "\n");
						}

					}

					break;

				case "7": /* Valeur nulle dans une colonne */
					String sqltablename = "SELECT DISTINCT table_name from INFORMATION_SCHEMA.COLUMNS";
					pssqlserver = consqlserver.prepareStatement(sqltablename);
					rssqlserver = pssqlserver.executeQuery();
					while (rssqlserver.next()) {
						String table = rssqlserver.getString("table_name");
						String var1 = " DECLARE @tb nvarchar(512) = N'" + table + "'";
						String var2 = " \nDECLARE @sqlt nvarchar(max) = N'SELECT * from ' + @tb + ' WHERE 1 = 0 ' \n";
						System.out.println(table);
						bufferedwriter.append("Nom de la table: " + table + "\n");
						java.sql.PreparedStatement ps = consqlserver.prepareStatement(var1 + var2 + code);
						ResultSet rs = ps.executeQuery();
						java.sql.ResultSetMetaData rsmd = rs.getMetaData();
						int columnsNumber = rsmd.getColumnCount();
						for (int j = 1; j <= columnsNumber; j++) {
							if (j > 1)
								bufferedwriter.append(" | ");
							bufferedwriter.append(rsmd.getColumnName(j));
						}
						bufferedwriter.append("\n");
						while (rs.next()) {
							for (int i = 1; i <= columnsNumber; i++) {
								if (i > 1)
									bufferedwriter.append(" | ");
								String columnValue = rs.getString(i);
								bufferedwriter.append(columnValue);
								if (i == columnsNumber)
									bufferedwriter.append(" \n ");
							}
						}
						bufferedwriter.append("\n============================\n\n");
						rs.close();
						ps.close();
					}
					break;

				case "139": /* Vérifier les statistiques sur les colonnes d''un utilisateur */

					break;

				case "140": /* Statistiques sur les indexes d''un utilisateur */

					break;

				case "577": /*
							 * Désactiver toutes les contraintes de clé étrangère de l''utilisateur connecté
							 */

					break;

				case "578": /* Activer toutes les contraintes de clé étrangère de l''utilisateur connecté */

					break;

				case "768": /* Statistiques sur les indexes */

					break;

				case "1025": /* Statistiques sur les tables */

					break;

				default:
					System.out.println("autre idrule " + idrule);
				}

			}

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		/* telechargement du fichier */
		/*
		 * PrintWriter out = response.getWriter(); String filename = "test.txt"; String
		 * filepath = "//home//meril//eclipse//jee-2018-12//eclipse//";
		 * response.setContentType("APPLICATION/OCTET-STREAM");
		 * response.setHeader("Content-Disposition","attachement; filename=\"" +
		 * filename + "\""); FileInputStream fi = new
		 * FileInputStream(filepath+filename); int i; while((i=fi.read()) != -1) {
		 * out.write(i); } fi.close(); out.close();
		 */

	}

}

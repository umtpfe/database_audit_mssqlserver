package com.formatfast.servlets;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;
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
		String host 	= request.getParameter("host");
		String port 	= request.getParameter("port");
		String database = request.getParameter("database");
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		consqlserver    = ConnexionSqlserver.getConnection(host, port, database, username, password);

		/* creation du fichier pour le retour de la reponse */
		File reponse = new File("reponse.txt");
		System.out.println(reponse.getAbsolutePath());

		/* execution de la requete pour la table id_rule_1 */
		String sql = "SELECT * FROM rule_1 WHERE categorie='con' AND basetype='sqlserver'  ";

		try (BufferedWriter bufferedwriter = new BufferedWriter(new FileWriter(reponse))) {
			psmysql = conmysql.prepareStatement(sql);
			rsmysql = psmysql.executeQuery();
			while (rsmysql.next()) {
				String idrule 	  = rsmysql.getString("idrule");
				String libelle    = rsmysql.getString("libelle");
				String code 	  = rsmysql.getString("code");
				String role 	  = rsmysql.getString("role");
				String categorie  = rsmysql.getString("categorie");
				String type 	  = rsmysql.getString("type");
				String diagnostic = rsmysql.getString("diagnostic");
				String url 	  = rsmysql.getString("url");
				String basetype   = rsmysql.getString("basetype");

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
					bufferedwriter.append("\n===========================================\n");

				} else {

					switch (idrule) {

					case "4": /* */
						break;

					case "6": /* Toute une colonne à  la même valeur */
						String sql6 = "SELECT name FROM sys.tables";
						pssqlserver = consqlserver.prepareStatement(sql6);
						rssqlserver = pssqlserver.executeQuery();
						/* fixation de la table cible */
						while (rssqlserver.next()) {
							String tablename = rssqlserver.getString("name");

							String sqlc = " SELECT column_name FROM information_schema.columns WHERE table_name = '"
									+ tablename + "' ;";
							java.sql.PreparedStatement ps = consqlserver.prepareStatement(sqlc);
							ResultSet rs = ps.executeQuery();
							/* execution sur chaque colonne de la table cible */
							while (rs.next()) {
								String nom_colonne = rs.getString("column_name");
								try {

									String var1 = " SELECT COUNT (DISTINCT ";
									String var2 = " ) nbre_de_valeur_identique FROM ";
									bufferedwriter.append("\nNom de la table: " + tablename + "\n");
									bufferedwriter.append("Nom de la colonne: " + nom_colonne + "\n");
									java.sql.PreparedStatement ps1 = consqlserver
											.prepareStatement(var1 + nom_colonne + var2 + tablename + " ;");
									ResultSet rs1 = ps1.executeQuery();
									/* ecriture du resultat sur le fichier */
									java.sql.ResultSetMetaData rsmd1 = rs1.getMetaData();
									int columnsNumber1 = rsmd1.getColumnCount();
									for (int j = 1; j <= columnsNumber1; j++) {
										if (j > 1)
											bufferedwriter.append(" | ");
										bufferedwriter.append(rsmd1.getColumnName(j));
									}
									bufferedwriter.append("\n");
									while (rs1.next()) {
										for (int i = 1; i <= columnsNumber1; i++) {
											if (i > 1)
												bufferedwriter.append(" | ");
											String columnValue = rs1.getString(i);
											bufferedwriter.append(columnValue);
											if (i == columnsNumber1)
												bufferedwriter.append(" \n ");
										}
									}
									bufferedwriter.append("\n============================\n\n");
								} catch (Exception e) {
									System.out.println("type de colonne incompatible pour une fonction COUNT");
									bufferedwriter.append("\n La colonne " + nom_colonne + " de la table " + tablename
											+ " est incompatible pour une fonction COUNT\n");
								}
							}
						}
						break;

					case "7": /* Valeur nulle dans une colonne */
						String sql7 = "SELECT name FROM sys.tables";
						pssqlserver = consqlserver.prepareStatement(sql7);
						rssqlserver = pssqlserver.executeQuery();
						while (rssqlserver.next()) {
							/* fixation de la table */
							String table = rssqlserver.getString("name");
							/* declaration des variables de parcourt */
							String var1 = " DECLARE @tb nvarchar(512) = N'" + table + "'";
							String var2 = " \nDECLARE @sqlt nvarchar(max) = N'SELECT * from ' + @tb + ' WHERE 1 = 0 ' \n";
							bufferedwriter.append("\nNom de la table: " + table + "\n");
							/* execution de la requete pour chaque colonne */
							java.sql.PreparedStatement ps = consqlserver.prepareStatement(var1 + var2 + code);
							ResultSet rs = ps.executeQuery();
							/* ecriture du resultat sur le ficher */
							java.sql.ResultSetMetaData rsmd1 = rs.getMetaData();
							int columnsNumber1 = rsmd1.getColumnCount();
							for (int j = 1; j <= columnsNumber1; j++) {
								if (j > 1)
									bufferedwriter.append(" | ");
								bufferedwriter.append(rsmd1.getColumnName(j));
							}
							bufferedwriter.append("\n");
							while (rs.next()) {
								for (int i = 1; i <= columnsNumber1; i++) {
									if (i > 1)
										bufferedwriter.append(" | ");
									String columnValue = rs.getString(i);
									bufferedwriter.append(columnValue);
									if (i == columnsNumber1)
										bufferedwriter.append(" \n ");
								}
							}
							bufferedwriter.append("\n============================\n\n");
						}
						break;

					case "139": /* Vérifier les statistiques sur les colonnes d'un utilisateur */

						String sql139 = "SELECT name FROM sys.tables";
						pssqlserver   = consqlserver.prepareStatement(sql139);
						rssqlserver   = pssqlserver.executeQuery();
						/* fixation de la table cible */
						while (rssqlserver.next()) {
							/* fixation de la table */
							String table = rssqlserver.getString("name");
							String sqlc  = " SELECT column_name FROM information_schema.columns WHERE table_name = '"
									+ table + "' ;";
							java.sql.PreparedStatement ps = consqlserver.prepareStatement(sqlc);
							ResultSet rs = ps.executeQuery();
							/* execution sur chaque colonne de la table cible */
							while (rs.next()) {
								String nom_colonne = rs.getString("column_name");
								/* declaration des variables de parcourt */
								try {

									String var1 = " CREATE STATISTICS " + nom_colonne + " ";
									String var2 = "ON " + table + "(" + nom_colonne + ");\n";
									String var3 = " DBCC SHOW_STATISTICS " + "(" + table + "," + nom_colonne + ");";
									bufferedwriter.append("\nNom de la table: " + table + "\n");
									bufferedwriter.append("Nom de la colonne: " + nom_colonne + "\n");
									java.sql.PreparedStatement ps1 = consqlserver.prepareStatement(var1 + var2 + var3);
									ResultSet rs1 = ps1.executeQuery();
									/* ecriture du resultat sur le fichier */
									java.sql.ResultSetMetaData rsmd1 = rs1.getMetaData();
									int columnsNumber1 = rsmd1.getColumnCount();
									for (int j = 1; j <= columnsNumber1; j++) {
										if (j > 1)
											bufferedwriter.append(" | ");
										bufferedwriter.append(rsmd1.getColumnName(j));
									}
									bufferedwriter.append("\n");
									while (rs1.next()) {
										for (int i = 1; i <= columnsNumber1; i++) {
											if (i > 1)
												bufferedwriter.append(" | ");
											String columnValue = rs1.getString(i);
											bufferedwriter.append(columnValue);
											if (i == columnsNumber1)
												bufferedwriter.append(" \n ");
										}
									}

								} catch (Exception e) {
									bufferedwriter.append("il existe deja une satistique pour la colonne " + nom_colonne
											+ " de la table " + table + "\n");
								}
							}
							bufferedwriter.append("\n============================\n\n");
						}
						break;

					case "140": /* Statistiques sur les indexes d'un utilisateur */

						String sql140 = "SELECT name FROM sys.tables";
						pssqlserver   = consqlserver.prepareStatement(sql140);
						rssqlserver   = pssqlserver.executeQuery();
						/* fixation de la table cible */
						while (rssqlserver.next()) {
							/* fixation de la table */
							String table = rssqlserver.getString("name");
							/* parcours des colonne de la table */
							String sqlc = " SELECT column_name FROM information_schema.columns WHERE table_name = '"
									+ table + "' ;";
							java.sql.PreparedStatement ps = consqlserver.prepareStatement(sqlc);
							ResultSet rs = ps.executeQuery();
							while (rs.next()) {
								String nom_colonne = rs.getString("column_name");
								String var1 = " DBCC SHOW_STATISTICS (" + table + "," + nom_colonne + ")";
								bufferedwriter.append("\nNom de la table: " + table + "\n");
								bufferedwriter.append("Nom de la colonne: " + nom_colonne + "\n");
								java.sql.PreparedStatement ps1 = consqlserver.prepareStatement(var1);
								ResultSet rs1 = ps1.executeQuery();
								/* ecriture du resultat sur le fichier */
								java.sql.ResultSetMetaData rsmd1 = rs1.getMetaData();
								int columnsNumber1 = rsmd1.getColumnCount();
								for (int j = 1; j <= columnsNumber1; j++) {
									if (j > 1)
										bufferedwriter.append(" | ");
									bufferedwriter.append(rsmd1.getColumnName(j));
								}
								bufferedwriter.append("\n");
								while (rs1.next()) {
									for (int i = 1; i <= columnsNumber1; i++) {
										if (i > 1)
											bufferedwriter.append(" | ");
										String columnValue = rs1.getString(i);
										bufferedwriter.append(columnValue);
										if (i == columnsNumber1)
											bufferedwriter.append(" \n ");
									}
								}
							}
							bufferedwriter.append("\n============================\n\n");
						}

						break;

					case "577": /*
								 * Désactiver toutes les contraintes de clé étrangère de l'utilisateur connecté
								 */

						String sql577 = "SELECT name FROM sys.tables";
						pssqlserver   = consqlserver.prepareStatement(sql577);
						rssqlserver   = pssqlserver.executeQuery();
						/* fixation de la table cible */
						while (rssqlserver.next()) {
							String table = rssqlserver.getString("name");
							/* parcours des indexs de la table */
							String sqlc = " SELECT fk.name from sys.foreign_keys fk inner JOIN sys.tables t on fk.parent_object_id = t.object_id\n"
									+ "WHERE t.name = '" + table + "' ;";
							java.sql.PreparedStatement ps = consqlserver.prepareStatement(sqlc);
							ResultSet rs = ps.executeQuery();
							while (rs.next()) {
								String nom_foreignkey = rs.getString("name");
								String var1 = "ALTER TABLE " + table + " NOCHECK CONSTRAINT " + nom_foreignkey + ";";
								java.sql.Statement st = consqlserver.createStatement();
								st.execute(var1);
								bufferedwriter.append(
										"La clé " + nom_foreignkey + " a été désactivé sur la table " + table + "\n");
							}
						}

						break;

					case "578": /* Activer toutes les contraintes de clé étrangère de l'utilisateur connecté */

						String sql578 = "SELECT name FROM sys.tables";
						pssqlserver   = consqlserver.prepareStatement(sql578);
						rssqlserver   = pssqlserver.executeQuery();
						/* fixation de la table cible */
						while (rssqlserver.next()) {
							String table = rssqlserver.getString("name");
							/* parcours des indexs de la table */
							String sqlc = " SELECT fk.name from sys.foreign_keys fk inner JOIN sys.tables t on fk.parent_object_id = t.object_id\n"
									+ "WHERE t.name = '" + table + "' ;";
							java.sql.PreparedStatement ps = consqlserver.prepareStatement(sqlc);
							ResultSet rs = ps.executeQuery();
							while (rs.next()) {
								String nom_foreignkey = rs.getString("name");
								String var1 = "ALTER TABLE " + table + " NOCHECK CONSTRAINT " + nom_foreignkey + ";";
								java.sql.Statement st = consqlserver.createStatement();
								st.execute(var1);
								bufferedwriter.append(
										"La clé " + nom_foreignkey + " a été activé sur la table " + table + "\n");
							}
						}
						break;

					case "763": /* Statistiques sur les indexes */

						String sql763 = "SELECT name FROM sys.tables";
						pssqlserver   = consqlserver.prepareStatement(sql763);
						rssqlserver   = pssqlserver.executeQuery();
						/* fixation de la table cible */
						while (rssqlserver.next()) {
							String table = rssqlserver.getString("name");
							/* parcours des indexs de la table */
							String sqlc = " SELECT i.name FROM sys.indexes i INNER JOIN sys.tables t ON i.object_id = t.object_id\n"
									+ "WHERE t.name = '" + table + "' ;";
							java.sql.PreparedStatement ps = consqlserver.prepareStatement(sqlc);
							ResultSet rs = ps.executeQuery();
							while (rs.next()) {
								String nom_index = rs.getString("name");

								try {

									String var1 = " DBCC SHOW_STATISTICS (" + table + "," + nom_index + ")";
									bufferedwriter.append("\nNom de la table: " + table + "\n");
									bufferedwriter.append("Nom de l'index: " + nom_index + "\n");
									java.sql.PreparedStatement ps1 = consqlserver.prepareStatement(var1);
									ResultSet rs1 = ps1.executeQuery();
									/* ecriture du resultat sur le fichier */
									java.sql.ResultSetMetaData rsmd1 = rs1.getMetaData();
									int columnsNumber1 = rsmd1.getColumnCount();
									for (int j = 1; j <= columnsNumber1; j++) {
										if (j > 1)
											bufferedwriter.append(" | ");
										bufferedwriter.append(rsmd1.getColumnName(j));
									}
									bufferedwriter.append("\n");
									while (rs1.next()) {
										for (int i = 1; i <= columnsNumber1; i++) {
											if (i > 1)
												bufferedwriter.append(" | ");
											String columnValue = rs1.getString(i);
											bufferedwriter.append(columnValue);
											if (i == columnsNumber1)
												bufferedwriter.append(" \n ");
										}
									}

									bufferedwriter.append("\n============================\n\n");

								} catch (Exception e) {
									System.out.println(" valeur de l'index incorect ou NULL ");
									bufferedwriter.append(" Aucun index sur cette colonne");
								}

							}
						}

						break;

					case "1025": /* Statistiques sur les tables */
						String sql1025 = "SELECT name FROM sys.tables";
						pssqlserver    = consqlserver.prepareStatement(sql1025);
						rssqlserver    = pssqlserver.executeQuery();
						/* fixation de la table cible */
						while (rssqlserver.next()) {
							/* fixation de la table */
							String table = rssqlserver.getString("name");
							/* parcours des colonne de la table */
							String sqlc = " SELECT column_name FROM information_schema.columns WHERE table_name = '"
									+ table + "' ;";
							java.sql.PreparedStatement ps = consqlserver.prepareStatement(sqlc);
							ResultSet rs = ps.executeQuery();
							while (rs.next()) {
								String nom_colonne = rs.getString("column_name");
								String var1 = " DBCC SHOW_STATISTICS (" + table + "," + nom_colonne + ")";
								bufferedwriter.append("\nNom de la table: " + table + "\n");
								bufferedwriter.append("Nom de la colonne: " + nom_colonne + "\n");
								java.sql.PreparedStatement ps1 = consqlserver.prepareStatement(var1);
								ResultSet rs1 = ps1.executeQuery();
								/* ecriture du resultat sur le fichier */
								java.sql.ResultSetMetaData rsmd1 = rs1.getMetaData();
								int columnsNumber1 = rsmd1.getColumnCount();
								for (int j = 1; j <= columnsNumber1; j++) {
									if (j > 1)
										bufferedwriter.append(" | ");
									bufferedwriter.append(rsmd1.getColumnName(j));
								}
								bufferedwriter.append("\n");
								while (rs1.next()) {
									for (int i = 1; i <= columnsNumber1; i++) {
										if (i > 1)
											bufferedwriter.append(" | ");
										String columnValue = rs1.getString(i);
										bufferedwriter.append(columnValue);
										if (i == columnsNumber1)
											bufferedwriter.append(" \n ");
									}
								}

							}
							bufferedwriter.append("\n============================\n\n");

						}
						break;

					default:
						System.out.println("autre idrule " + idrule);

					}
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

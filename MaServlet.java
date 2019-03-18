package com.formatfast.servlets;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Types;

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

	PreparedStatement psmysql	  = null;
	PreparedStatement pssqlserver = null;

	ResultSet rsmysql 	  = null;
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
				String idrule     = rsmysql.getString("idrule");
				String libelle    = rsmysql.getString("libelle");
				String code 	  = rsmysql.getString("code");
				String role 	  = rsmysql.getString("role");
				String categorie  = rsmysql.getString("categorie");
				String type 	  = rsmysql.getString("type");
				String diagnostic = rsmysql.getString("diagnostic");
				String url 		  = rsmysql.getString("url");
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
					bufferedwriter.append("\n===========================================\n\n");

				} else {

					java.sql.CallableStatement cst = consqlserver.prepareCall("{ call sptable }");
					ResultSet rsc = cst.executeQuery();
					while (rsc.next()) {
						String name = rsc.getString("name");

						switch (idrule) {

						case "4": /* */
							break;

						case "6": /* Toute une colonne à  la même valeur */

							java.sql.CallableStatement stt = consqlserver.prepareCall("{ call spcolumnname (?) }");
							stt.setObject(1, name, Types.NVARCHAR);
							ResultSet sc = stt.executeQuery();
							while (sc.next()) {
								String colname = sc.getString("column_name");
								try {

									bufferedwriter.append("\nNom de la table: " + name + "\n");
									bufferedwriter.append("Nom de la colonne: " + colname + "\n");
									stt = consqlserver.prepareCall("{ call spsamevalue (?, ?)}");
									stt.setObject(1, name, Types.NVARCHAR);
									stt.setObject(2, colname, Types.NVARCHAR);
									sc = stt.executeQuery();
									/* ecriture du resultat sur le fichier */
									java.sql.ResultSetMetaData rsmd1 = sc.getMetaData();
									int columnsNumber1 = rsmd1.getColumnCount();
									for (int j = 1; j <= columnsNumber1; j++) {
										if (j > 1)
											bufferedwriter.append(" | ");
										bufferedwriter.append(rsmd1.getColumnName(j));
									}
									bufferedwriter.append("\n");
									while (sc.next()) {
										for (int i = 1; i <= columnsNumber1; i++) {
											if (i > 1)
												bufferedwriter.append(" | ");
											String columnValue = sc.getString(i);
											bufferedwriter.append(columnValue);
											if (i == columnsNumber1)
												bufferedwriter.append(" \n ");
										}
									}
									bufferedwriter.append("\n============================\n\n");
								} catch (Exception e) {
									System.out.println("type de colonne incompatible pour une fonction COUNT");
									bufferedwriter.append("\n La colonne " + colname + " de la table " + name
											+ " est incompatible pour une fonction COUNT\n");
								}
							}
							break;

						case "7": /* Valeur nulle dans une colonne */
							stt = consqlserver.prepareCall("{ call spnullvalue (?) }");
							stt.setObject(1, name, Types.NVARCHAR);
							sc = stt.executeQuery();
							while (sc.next()) {
								java.sql.ResultSetMetaData rsmd1 = sc.getMetaData();
								int columnsNumber1 = rsmd1.getColumnCount();
								for (int j = 1; j <= columnsNumber1; j++) {
									if (j > 1)
										bufferedwriter.append(" | ");
									bufferedwriter.append(rsmd1.getColumnName(j));
								}
								bufferedwriter.append("\n");
								while (sc.next()) {
									for (int i = 1; i <= columnsNumber1; i++) {
										if (i > 1)
											bufferedwriter.append(" | ");
										String columnValue = sc.getString(i);
										bufferedwriter.append(columnValue);
										if (i == columnsNumber1)
											bufferedwriter.append(" \n ");
									}
								}
								bufferedwriter.append("\n============================\n\n");
							}
							break;

						case "139": /* Vérifier les statistiques sur les colonnes d'un utilisateur */
							stt = consqlserver.prepareCall("{ call spcolumnname (?) }");
							stt.setObject(1, name, Types.NVARCHAR);
							sc = stt.executeQuery();
							while (sc.next()) {
								String nom_colonne = sc.getString("column_name");
								/* declaration des variables de parcourt */
								try {
									bufferedwriter.append("\nNom de la table: " + name + "\n");
									bufferedwriter.append("Nom de la colonne: " + nom_colonne + "\n");									
									stt = consqlserver.prepareCall("{ call spstatcol ( ?, ?) }");
									stt.setObject(1, name, Types.NVARCHAR);
									stt.setObject(2, nom_colonne, Types.NVARCHAR);
									sc = stt.executeQuery();
									/* ecriture du resultat sur le fichier */
									java.sql.ResultSetMetaData rsmd1 = sc.getMetaData();
									int columnsNumber1 = rsmd1.getColumnCount();
									for (int j = 1; j <= columnsNumber1; j++) {
										if (j > 1)
											bufferedwriter.append(" | ");
										bufferedwriter.append(rsmd1.getColumnName(j));
									}
									bufferedwriter.append("\n");
									while (sc.next()) {
										for (int i = 1; i <= columnsNumber1; i++) {
											if (i > 1)
												bufferedwriter.append(" | ");
											String columnValue = sc.getString(i);
											bufferedwriter.append(columnValue);
											if (i == columnsNumber1)
												bufferedwriter.append(" \n ");
										}
									}
								} catch (Exception e) {
									bufferedwriter.append("il existe deja une satistique pour la colonne " + nom_colonne
											+ " de la table " + name + "\n");
								}
							}
							bufferedwriter.append("\n============================\n\n");
							break;

						case "140": /* Statistiques sur les indexes d'un utilisateur */

							stt = consqlserver.prepareCall("{ call spindexname (?) }");
							stt.setObject(1, name, Types.NVARCHAR);
							sc = stt.executeQuery();
							while (sc.next()) {
								String nom_index = sc.getString("name");
								try {
									bufferedwriter.append("\nNom de la table: " + name + "\n");
									bufferedwriter.append("Nom de l'index: " + nom_index + "\n");
									stt = consqlserver.prepareCall("{ call spstatindex ( ?, ?) }");
									stt.setObject(1, name, Types.NVARCHAR);
									stt.setObject(2, nom_index, Types.NVARCHAR);
									sc = stt.executeQuery();
									/* ecriture du resultat sur le fichier */
									java.sql.ResultSetMetaData rsmd1 = sc.getMetaData();
									int columnsNumber1 = rsmd1.getColumnCount();
									for (int j = 1; j <= columnsNumber1; j++) {
										if (j > 1)
											bufferedwriter.append(" | ");
										bufferedwriter.append(rsmd1.getColumnName(j));
									}
									bufferedwriter.append("\n");
									while (sc.next()) {
										for (int i = 1; i <= columnsNumber1; i++) {
											if (i > 1)
												bufferedwriter.append(" | ");
											String columnValue = sc.getString(i);
											bufferedwriter.append(columnValue);
											if (i == columnsNumber1)
												bufferedwriter.append(" \n ");
										}
									}
									bufferedwriter.append("\n============================\n\n");
								} catch (Exception e) {
									System.out.println(" valeur de l'index incorect ou NULL ");
									bufferedwriter.append(" valeur de l'index incorect ou NULL");
									bufferedwriter.append("\n============================\n\n");
								}
							}
							break;

						case "577": /* Désactiver toutes les contraintes de clé étrangère de l'utilisateur connecté */

							stt = consqlserver.prepareCall("{ call spforeignkey (?) }");
							stt.setObject(1, name, Types.NVARCHAR);
							sc = stt.executeQuery();
							while (sc.next()) {
								String nom_foreignkey = sc.getString("name");
								stt = consqlserver.prepareCall("{ call spdesactivefk (?, ?) }");								
								stt.setObject(1, name, Types.NVARCHAR);
								stt.setObject(2, nom_foreignkey, Types.NVARCHAR);							
								/*stt.registerOutParameter(3, java.sql.Types.VARCHAR);*/
								stt.executeUpdate();
								
								bufferedwriter.append(
										"La clé " + nom_foreignkey + " a été désactivé sur la table " + name + "\n\n");
							}
							break;

						case "578": /* Activer toutes les contraintes de clé étrangère de l'utilisateur connecté */

							stt = consqlserver.prepareCall("{ call spforeignkey (?) }");
							stt.setObject(1, name, Types.NVARCHAR);
							sc = stt.executeQuery();
							while (sc.next()) {
								String nom_foreignkey = sc.getString("name");
								stt = consqlserver.prepareCall("{ call spactivefk (?, ?) }");
								stt.setObject(1, name, Types.NVARCHAR);
								stt.setObject(2, nom_foreignkey, Types.NVARCHAR);
								stt.executeUpdate();								
								bufferedwriter.append(
										"La clé " + nom_foreignkey + " a été activé sur la table " + name + "\n\n");
							}
							break;

						case "763": /* Statistiques sur les indexes */
							/* parcours des indexs de la table */
							stt = consqlserver.prepareCall("{ call spindexname (?) }");
							stt.setObject(1, name, Types.NVARCHAR);
							sc = stt.executeQuery();
							while (sc.next()) {
								String nom_index = sc.getString("name");
								try {
									bufferedwriter.append("\nNom de la table: " + name + "\n");
									bufferedwriter.append("Nom de l'index: " + nom_index + "\n");
									stt = consqlserver.prepareCall("{ call spstatindex ( ?, ?) }");
									stt.setObject(1, name, Types.NVARCHAR);
									stt.setObject(2, nom_index, Types.NVARCHAR);
									sc = stt.executeQuery();
									/* ecriture du resultat sur le fichier */
									java.sql.ResultSetMetaData rsmd1 = sc.getMetaData();
									int columnsNumber1 = rsmd1.getColumnCount();
									for (int j = 1; j <= columnsNumber1; j++) {
										if (j > 1)
											bufferedwriter.append(" | ");
										bufferedwriter.append(rsmd1.getColumnName(j));
									}
									bufferedwriter.append("\n");
									while (sc.next()) {
										for (int i = 1; i <= columnsNumber1; i++) {
											if (i > 1)
												bufferedwriter.append(" | ");
											String columnValue = sc.getString(i);
											bufferedwriter.append(columnValue);
											if (i == columnsNumber1)
												bufferedwriter.append(" \n ");
										}
									}
									bufferedwriter.append("\n============================\n\n");
								} catch (Exception e) {
									bufferedwriter.append(" valeur de l'index incorect ou NULL \n\n");
								}
							}
							bufferedwriter.append("\n============================\n\n");

							break;

						case "1025": /* Statistiques sur les tables */
							/* parcours des colonne de la table */
							stt = consqlserver.prepareCall("{ call spcolumnname (?) }");
							stt.setObject(1, name, Types.NVARCHAR);
							sc = stt.executeQuery();
							while (sc.next()) {
								String nom_colonne = sc.getString("column_name");
								bufferedwriter.append("\nNom de la table: " + name + "\n");
								bufferedwriter.append("Nom de la colonne: " + nom_colonne + "\n");
								stt = consqlserver.prepareCall("{ call spstatcol ( ?, ?) }");
								stt.setObject(1, name, Types.NVARCHAR);
								stt.setObject(2, nom_colonne, Types.NVARCHAR);
								sc = stt.executeQuery();
								/* ecriture du resultat sur le fichier */
								java.sql.ResultSetMetaData rsmd1 = sc.getMetaData();
								int columnsNumber1 = rsmd1.getColumnCount();
								for (int j = 1; j <= columnsNumber1; j++) {
									if (j > 1)
										bufferedwriter.append(" | ");
									bufferedwriter.append(rsmd1.getColumnName(j));
								}
								bufferedwriter.append("\n");
								while (sc.next()) {
									for (int i = 1; i <= columnsNumber1; i++) {
										if (i > 1)
											bufferedwriter.append(" | ");
										String columnValue = sc.getString(i);
										bufferedwriter.append(columnValue);
										if (i == columnsNumber1)
											bufferedwriter.append(" \n ");
									}
								}
							}
							bufferedwriter.append("\n============================\n\n");
							break;
						default:
							System.out.println("autre idrule " + idrule);
						}
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

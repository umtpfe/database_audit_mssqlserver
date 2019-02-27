package com.formatfast.servlets;

import java.io.IOException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.formatfast.connect.ConnexionMysql;
import com.mysql.jdbc.Connection;

/**
 * Servlet implementation class HelloServlet
 */
@WebServlet("/MaServlet")
public class MaServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    /**
     * @see HttpServlet#HttpServlet()
     */
    public MaServlet() {
        super();
        // TODO Auto-generated constructor stub
        con = ConnexionMysql.getConnexion();
       
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
		
		/*
		 * String requete = "SELECT * FROM rule WHERE categorie = ? AND type = ?"; try {
		 * ps = con.prepareStatement(requete); ps.setString(1, "con"); ps.setString(2,
		 * "sql");
		 * 
		 * rs = ps.executeQuery(); if(rs.next()) {
		 * System.out.println("Requete effectuée qvec succès"); }
		 * 
		 * 
		 * } catch (Exception e) { // TODO Auto-generated catch block
		 * e.printStackTrace(); }finally { try { rs.close(); ps.close(); } catch
		 * (SQLException e) { // TODO Auto-generated catch block e.printStackTrace(); }
		 * }
		 */
		 
	
		this.getServletContext().getRequestDispatcher("/WEB-INF/page.jsp").forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);	
	}

	@Override
	protected void service(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException 
	{
		// TODO Auto-generated method stub
		super.service(req, resp);		
	}
	
	
	
	
}

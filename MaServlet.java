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
    /**
     * @see HttpServlet#HttpServlet()
     */
    public MaServlet() {
        super();
        // TODO Auto-generated constructor stub
        ConMySql = ConnexionMysql.getConnexion();
        ConSqlServer = ConnexionSqlserver.getConnection();
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
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

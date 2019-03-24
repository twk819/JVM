package com.jvm.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.jvm.model.User;

public class ServletController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static UserDAO userDAO;
    
    public void init() {
        String jdbcURL = getServletContext().getInitParameter("jdbcURL");
        String jdbcUsername = getServletContext().getInitParameter("jdbcUsername");
        String jdbcPassword = getServletContext().getInitParameter("jdbcPassword");
        System.out.println("ServletController init2");
        userDAO = new UserDAO(jdbcURL, jdbcUsername, jdbcPassword);
        
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getServletPath();
        System.out.println("doGet start "+action);
        try {
            switch (action) {
            case "/insert":
                insertUser(request, response);
                break;
            case "/delete":
                deleteUser(request, response);
                break;
            case "/update":
                updateUser(request, response);
                break;
            case "/all":
            	listUser(request, response);
                break;
            case "/login":
            	checkUser(request, response);
                break;
            default:
                listUser(request, response);
                break;
            }
        } catch (Exception ex) {
            throw new ServletException(ex);
        }
    }
    
    private void checkUser(HttpServletRequest request, HttpServletResponse response)
    		throws Exception {
    	String user = request.getParameter("username");
		String pass = request.getParameter("password");
		request.setAttribute("user", null);
		if (userDAO.loginAuth(user,pass)) {
			request.setAttribute("user", user);
			//RequestDispatcher dispatcher = request.getRequestDispatcher("/all");
	        //dispatcher.forward(request, response);
			response.sendRedirect(request.getContextPath() + "/all");
		}
		else {
			System.out.println("Username or Password incorrect");
			RequestDispatcher dispatcher = request.getRequestDispatcher("login.jsp");
			dispatcher.include(request, response);
		}

			
    }
    
    private void listUser(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
    	System.out.println("listUser start");
        List<User> listUser = new ArrayList<>();
        int role = 1;//Integer.parseInt(request.getParameter("ROLE"));
        try {
            listUser = userDAO.listUsers(role, 1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        System.out.println("listUser end "+listUser);
        request.setAttribute("listUser", listUser);
        RequestDispatcher dispatcher = request.getRequestDispatcher("index.jsp");
        dispatcher.forward(request, response);
        //response.sendRedirect(request.getContextPath() + "/index.jsp");
    }

    private void insertUser(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        String title = request.getParameter("title");
        String author = request.getParameter("author");
        float price = Float.parseFloat(request.getParameter("price"));

        int id = Integer.parseInt(request.getParameter("ID"));
        int role = Integer.parseInt(request.getParameter("ROLE"));
        String username = request.getParameter("USERNAME");
        String password = request.getParameter("PASSWORD");
        int departmentID = Integer.parseInt(request.getParameter("DEPARTMENT_ID"));
        String departmentName = request.getParameter("DEPARTMENT_NAME");
        String phone = request.getParameter("PHONE");
        String email = request.getParameter("EMAIL");

        User newUser = new User(id, username, password, role, departmentID, departmentName, phone, email, "");
        try {
            userDAO.insertUser(newUser);
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect("list");
    }

    private void updateUser(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("ID"));
        String phone = request.getParameter("PHONE");
        String email = request.getParameter("EMAIL");

        User user = new User(id, phone, email);
        try {
            userDAO.updateUser(user);
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect("list");
    }

    private void deleteUser(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));

        User user = new User(id);
        try {
            userDAO.deleteUser(user);
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect("list");
 
    }
}

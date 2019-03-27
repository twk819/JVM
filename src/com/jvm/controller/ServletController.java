package com.jvm.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.jvm.model.User;

public class ServletController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static UserDAO userDAO;
    
    public void init() {
        String jdbcURL = getServletContext().getInitParameter("jdbcURL");
        String jdbcUsername = getServletContext().getInitParameter("jdbcUsername");
        String jdbcPassword = getServletContext().getInitParameter("jdbcPassword");
        userDAO = new UserDAO(jdbcURL, jdbcUsername, jdbcPassword);
        
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getServletPath();
        System.out.println("doGet start "+action);
        try {
            switch (action) {
            case "/insert":
            	checkAccess(request, response);
                insertUser(request, response);
                break;
            case "/delete":
            	checkAccess(request, response);
                deleteUser(request, response);
                break;
            case "/update":
            	checkAccess(request, response);
                updateUser(request, response);
                break;
            case "/all":
                checkAccess(request, response);
            	listUser(request, response);
                break;
            case "/login":
            	checkUser(request, response);
                break;
            case "/logout":
            	logOut(request, response);
            	break;
            default:
            	checkUser(request, response);
                break;
            }
        } catch (Exception ex) {
            throw new ServletException(ex);
        }
    }
    
    private void checkUser(HttpServletRequest request, HttpServletResponse response) throws Exception {
    	String loginId = request.getParameter("username");
        String loginPw = request.getParameter("password");
        User user = userDAO.loginAuth(loginId,loginPw);
        
		if (user != null) {
			userDAO.updateLogin(user);
			HttpSession session = request.getSession(true);
			session.setAttribute("loginUser", user);
			session.setAttribute("user_status", null);
			response.sendRedirect(request.getContextPath() + "/all");
			return;
		}
		else {
			request.setAttribute("user_status", "Username or Password incorrect");
			RequestDispatcher dispatcher = request.getRequestDispatcher("login.jsp");
	        dispatcher.forward(request, response);
			return;
		}

			
    }

    private void checkAccess(HttpServletRequest request, HttpServletResponse response) throws Exception {
    	HttpSession session = request.getSession(true);
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            request.setAttribute("user_status", "Unauthorize login");
            response.sendRedirect("/login");
            return;
        }
    }

    private void logOut(HttpServletRequest request, HttpServletResponse response) throws Exception {
    	request.setAttribute("user_status", "You have been log out.");
		RequestDispatcher dispatcher = request.getRequestDispatcher("login.jsp");
        dispatcher.forward(request, response);
		return;
    }
    
    private void listUser(HttpServletRequest request, HttpServletResponse response) throws Exception {
    	HttpSession session = request.getSession(true);
        User loginUser = (User) session.getAttribute("loginUser");
        List<User> listUser = new ArrayList<>();
        
        try {
            listUser = userDAO.listUsers(loginUser);
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        request.setAttribute("listUser", listUser);	// set list to display on /all
        RequestDispatcher dispatcher = request.getRequestDispatcher("index.jsp");
        dispatcher.forward(request, response);
        return;
    }

    private void insertUser(HttpServletRequest request, HttpServletResponse response) throws Exception {

        int role = Integer.parseInt(request.getParameter("ROLE"));
        String username = request.getParameter("USERNAME");
        String password = request.getParameter("PASSWORD");
        String department= request.getParameter("DEPARTMENT");
        String phone = request.getParameter("PHONE");
        String email = request.getParameter("EMAIL");

        User newUser = new User(0, username, password, role, department, phone, email, "");
        try {
            userDAO.insertUser(newUser);
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect("all");
        return;
    }

    private void updateUser(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String userid = request.getParameter("USERID");
        String userrole = request.getParameter("USERROLE");

        int id = Integer.parseInt(request.getParameter("ID"));
        String phone = request.getParameter("PHONE");
        String email = request.getParameter("EMAIL");

        User user = new User(id, phone, email);
        try {
            userDAO.updateUser(user);
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect("all");
        return;
    }

    private void deleteUser(HttpServletRequest request, HttpServletResponse response) throws Exception {
        int id = Integer.parseInt(request.getParameter("id"));

        User user = new User(id);
        try {
            userDAO.deleteUser(user);
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect("all");
        return;
    }
}

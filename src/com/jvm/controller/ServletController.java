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

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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
                checkAccess(request, response);
            	listUser(request, response);
                break;
            case "/login":
            	checkUser(request, response);
                break;
            case "/logout":
                logOut(request, response);
            default:
                listUser(request, response);
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
        request.setAttribute("loginUser", null);
		if (user != null) {
            request.setAttribute("loginUser", user);
            request.setAttribute("user_status", null);
			response.sendRedirect(request.getContextPath() + "/all");
		}
		else {
			System.out.println("Username or Password incorrect");
			RequestDispatcher dispatcher = request.getRequestDispatcher("login.jsp");
			dispatcher.include(request, response);
		}

			
    }

    private void checkAccess(HttpServletRequest request, HttpServletResponse response) throws Exception {
        // String user = request.getParameter("username");
        // int id = Integer.parseInt(request.getParameter("id"));
        // int access = userDAO.userAccess(user,id);
        
        // if (access > -1) {
        //     request.setAttribute("access", access);
        // }
        // else {
        //     System.out.println("Unauthorize login");
        //     request.setAttribute("user", null);
        //     request.setAttribute("id", null);
        //     request.setAttribute("role", null);
        //     RequestDispatcher dispatcher = request.getRequestDispatcher("login.jsp");
        //     dispatcher.include(request, response);
        // }
        User loginUser = (User) request.getAttribute("loginUser");
        if (loginUser == null) {
            request.setAttribute("user_status", "Unauthorize login");
            logOut(request,response);
        }
    }

    private void logOut(HttpServletRequest request, HttpServletResponse response) throws Exception {
        request.getSession().invalidate();
        response.sendRedirect("login");
    }
    
    private void listUser(HttpServletRequest request, HttpServletResponse response) throws Exception {
        System.out.println("listUser start");
        User loginUser = (User) request.getAttribute("loginUser");
        List<User> listUser = new ArrayList<>();

        try {
            listUser = userDAO.listUsers(loginUser);
        } catch (Exception e) {
            e.printStackTrace();
        }
        System.out.println("listUser end "+listUser);
        request.setAttribute("listUser", listUser);
        RequestDispatcher dispatcher = request.getRequestDispatcher("index2.jsp");
        dispatcher.forward(request, response);
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
 
    }
}

package com.jvm.controller;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.jvm.model.User;
import com.mysql.jdbc.*;

import java.text.SimpleDateFormat;  
import java.util.Date;  

public class UserDAO {

    private String jdbcURL = "";
    private String jdbcUsername = "";
    private String jdbcPassword = "";
    private Connection jdbcConnection;
    private PreparedStatement pstmt = null;

    public UserDAO(String jdbcURL, String jdbcUsername, String jdbcPassword) {
        this.jdbcURL = jdbcURL;
        this.jdbcUsername = jdbcUsername;
        this.jdbcPassword = jdbcPassword;
    }
     
    protected void connect() throws SQLException {
        if (jdbcConnection == null || jdbcConnection.isClosed()) {
            try {
                Class.forName("com.mysql.jdbc.Driver");
            } catch (ClassNotFoundException e) {
                throw new SQLException(e);
            }
            System.out.println(jdbcURL);
            jdbcConnection = DriverManager.getConnection(
                                        jdbcURL, jdbcUsername, jdbcPassword);
        }
    }
     
    protected void disconnect() throws SQLException {
        if (jdbcConnection != null && !jdbcConnection.isClosed()) {
            jdbcConnection.close();
        }
    }

    public boolean loginAuth(String username, String password) throws Exception {
    	
    	String sql = "SELECT * FROM TB_USER WHERE USERNAME='"+username+"' AND PASSWORD='"+password+"'";
    	System.out.println(sql);
        connect();
        pstmt = jdbcConnection.prepareStatement(sql);

		ResultSet rs = pstmt.executeQuery();

    	return rs.next();
    }
    
    public boolean insertUser(User user) throws Exception {
        //1000-01-01 00:00:00
        //SimpleDateFormat formatter6=new SimpleDateFormat("yyyy-mm-dd HH:mm:ss");
        //Date date6=formatter6.parse(user.getlastLogin());

        String sql = "INSERT INTO TB_USER (ID, USERNAME, PASSWORD, ROLE, DEPARTMENT_ID, PHONE, EMAIL) VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        connect();
        pstmt = jdbcConnection.prepareStatement(sql);
        pstmt.setInt(1, user.getId());
        pstmt.setInt(2, user.getRole());
        pstmt.setString(3, user.getUsername());
        pstmt.setString(4, user.getPassword());
        pstmt.setInt(5, user.getDepartment());
        pstmt.setString(6, user.getPhone());
        pstmt.setString(7, user.getEmail());  
         
        boolean rowInserted = pstmt.executeUpdate() > 0;
        pstmt.close();
        disconnect();
        return rowInserted;
    }

    public List<User> listUsers(int access, int param) throws Exception {
        List<User> list = new ArrayList<>();
         
        String sql = "SELECT A.*, B.NAME FROM TB_USER A JOIN TB_DEPARTMENT B ON A.DEPARTMENT_ID = B.ID";
        
        if (access == 2)
            sql += " WHERE A.DEPARTMENT_ID = "+param;   // users in same department only


        connect();
        System.out.println("listUser sql is "+sql); 
        Statement statement = jdbcConnection.createStatement();
        ResultSet resultSet = statement.executeQuery(sql);
        String lastLogin = "";
        while (resultSet.next()) {
            int id = resultSet.getInt("ID");
            int role = resultSet.getInt("ROLE");
            String username = resultSet.getString("USERNAME");
            String password = resultSet.getString("PASSWORD");
            int departmentID = resultSet.getInt("DEPARTMENT_ID");
            String departmentName = resultSet.getString("NAME");
            String phone = resultSet.getString("PHONE");
            String email = resultSet.getString("EMAIL");
            Timestamp ts = resultSet.getTimestamp("LAST_LOGIN");
            System.out.println("ts is "+ts);
            if (ts != null) {
            	Date date = new Date();
                date.setTime(ts.getTime());
                lastLogin = new SimpleDateFormat("yyyyMMdd").format(date);
            }
            
            System.out.println("user last login = "+lastLogin);
            User user = new User(id, username, password, role, departmentID, departmentName, phone, email, lastLogin);
            list.add(user);
        }
         
        resultSet.close();
        statement.close();
         
        disconnect();
         
        return list;
    }

    public boolean updateUser(User user) throws Exception {
        String sql = "UPDATE TB_USER SET PHONE = ?, EMAIL = ? WHERE ID = ?";
        connect();
         
        PreparedStatement statement = jdbcConnection.prepareStatement(sql);
        statement.setString(1, user.getPhone());
        statement.setString(2, user.getEmail());
        statement.setInt(3, user.getId());
         
        boolean rowUpdated = statement.executeUpdate() > 0;
        statement.close();
        disconnect();
        return rowUpdated;   
    }

    public boolean updatePhone(User user) throws Exception {
        String sql = "UPDATE TB_USER SET PHONE = ? WHERE ID = ?";
        connect();
         
        PreparedStatement statement = jdbcConnection.prepareStatement(sql);
        statement.setString(1, user.getPhone());
        statement.setInt(2, user.getId());
         
        boolean rowUpdated = statement.executeUpdate() > 0;
        statement.close();
        disconnect();
        return rowUpdated;   
    }

    public boolean deleteUser(User user) throws Exception {
        String sql = "DELETE FROM TB_USER WHERE ID = ?";
        connect();
         
        PreparedStatement statement = jdbcConnection.prepareStatement(sql);
        statement.setInt(1, user.getId());
         
        boolean rowUpdated = statement.executeUpdate() > 0;
        statement.close();
        disconnect();
        return rowUpdated;   
    }
     

}
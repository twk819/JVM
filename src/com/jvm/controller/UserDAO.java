package com.jvm.controller;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

import com.jvm.model.User;
import com.mysql.jdbc.*;

import java.text.DateFormat;
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

    public User loginAuth(String username, String password) throws Exception {
    	User user = null;
    	String sql = "SELECT * FROM TB_USER WHERE USERNAME='"+username+"' AND PASSWORD='"+password+"'";
    	System.out.println(sql);
        connect();
        pstmt = jdbcConnection.prepareStatement(sql);

		ResultSet rs = pstmt.executeQuery();
        
    	if (rs.next()) 
            user = new User(rs.getInt("ID"),rs.getString("USERNAME"),rs.getInt("ROLE"),rs.getString("DEPARTMENT"));

        return user;
    }

    public int userAccess(String username, int id) throws Exception {
        String sql = "SELECT ROLE FROM TB_USER WHERE USERNAME='"+id+"' AND ID='"+id+"'";
    	System.out.println(sql);
        connect();
        pstmt = jdbcConnection.prepareStatement(sql);

		ResultSet rs = pstmt.executeQuery();

    	if (rs.next())
			return rs.getInt("ROLE");

        return -1;
    }
    
    public void insertLog(String action, int userid, String query) throws Exception {
        
        Timestamp ts = new Timestamp(new Date().getTime());
        System.out.println("insertLog ts = "+ts);
        Timestamp now = Timestamp.valueOf(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(ts));	// used to remove ms
        System.out.println("insertLog now = "+now);
        
        java.util.Date dt = new java.util.Date();
        java.text.SimpleDateFormat sdf = 
             new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String currentTime = sdf.format(dt);
        System.out.println("insertLog currentTime = "+currentTime);
        
        String sql = "INSERT INTO TB_LOG (TYPE, USERID, TIMESTAMP, SQL) VALUES (?, ?, ?, ?)";
        connect();
        pstmt = jdbcConnection.prepareStatement(sql);
        pstmt.setString(1, action);
        pstmt.setInt(2, userid);
        pstmt.setString(3, currentTime);
        pstmt.setString(4, query);

        System.out.println("insertLog sql = "+sql);
        pstmt.executeUpdate();
        pstmt.close();
        disconnect();
    }

    public boolean insertUser(User user) throws Exception {
        //1000-01-01 00:00:00
        //SimpleDateFormat formatter6=new SimpleDateFormat("yyyy-mm-dd HH:mm:ss");
        //Date date6=formatter6.parse(user.getlastLogin());

        String sql = "INSERT INTO TB_USER (USERNAME, PASSWORD, ROLE, DEPARTMENT, PHONE, EMAIL) VALUES (?, ?, ?, ?, ?, ?)";
        connect();
        System.out.println("getrole = "+user.getRole());
        pstmt = jdbcConnection.prepareStatement(sql);
        pstmt.setString(1, user.getUsername());
        pstmt.setString(2, user.getPassword());
        pstmt.setInt(3, user.getRole());
        pstmt.setString(4, user.getDepartment());
        pstmt.setString(5, user.getPhone());
        pstmt.setString(6, user.getEmail());  
        
        System.out.println("insertUser sql = "+sql);
        insertLog("insertUser",user.getId(),sql);
        boolean rowInserted = pstmt.executeUpdate() > 0;
        pstmt.close();
        disconnect();
        return rowInserted;
    }

    public List<User> listUsers(User user) throws Exception {
        List<User> list = new ArrayList<>();
        System.out.println("list user is "+user); 
        String sql = "SELECT * FROM TB_USER ";
        if (user.getRole() == 2)
            sql += "WHERE ROLE = 2 AND DEPARTMENT = "+ user.getDepartment();   // users in same department only
        else if (user.getRole() == 3)
            sql += "WHERE ID = "+ user.getId();  // user itself only

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
            String department = resultSet.getString("DEPARTMENT");
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
            User new_user = new User(id, username, password, role, department, phone, email, lastLogin);
            list.add(new_user);
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
        
        insertLog("updateUser",user.getId(),sql);

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
        
        insertLog("updatePhone",user.getId(),sql);

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
        
        insertLog("deleteUser",user.getId(),sql);

        boolean rowUpdated = statement.executeUpdate() > 0;
        statement.close();
        disconnect();
        return rowUpdated;   
    }
     

}
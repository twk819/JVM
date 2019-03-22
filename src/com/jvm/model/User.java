package com.jvm.model;

public class User {
    protected int id;
    protected int role; // 1 - Admin, 2 = Manager, 3 - User
    protected int departmentID;
    protected String username;
    protected String password;
    protected String departmentName;
    protected String phone;
    protected String email;
    protected String lastLogin;
 
    public User(int id) {
        this.id = id;
    }

    public User(int id, String phone, String email) {
        this.id = id;
        this.phone = phone;
        this.email = email;
    }
     
    public User(int id, String username, String password, int role, int departmentID, String departmentName,String phone, String email, String lastLogin) {
        this.id = id;
        this.username = username;
        this.password = password;
        this.role = role;
        this.departmentID = departmentID;
        this.departmentName = departmentName;
        this.phone = phone;
        this.email = email;
        this.lastLogin = lastLogin;
    }
 
    public int getID() {
        return id;
    }
 
    public void setID(int id) {
        this.id = id;
    }

    public int getRole() {
        return role;
    }
 
    public void setRole(int role) {
        this.role = role;
    }

    public int getDepartmentID() {
        return departmentID;
    }
 
    public void setDepartmentID(int departmentID) {
        this.departmentID = departmentID;
    }
 
    public String getEmail() {
        return email;
    }
 
    public void setEmail(String email) {
        this.email = email;
    }
 
    public String getPhone() {
        return phone;
    }
 
    public void setPhone(String phone) {
        this.phone = phone;
    }
 
    public String getLastLogin() {
        return lastLogin;
    }
 
    public void setLastLogin(String lastLogin) {
        this.lastLogin = lastLogin;
    }

	public String getUsername() {
		return username;
	}

	public String getPassword() {
		return password;
	}
}
package com.jvm.model;

public class User {
    protected int id;
    protected int role; // 1 - Admin, 2 = Manager, 3 - User
    protected String username;
    protected String password;
    protected String department;
    protected String phone;
    protected String email;
    protected String lastLogin;
 
    public User(int id) {
        this.id = id;
    }

    public User(int id, String username, int role, String department) {
        this.id = id;
        this.username = username;
        this.role = role;
        this.department= department;
    }

    public User(int id, String phone, String email) {
        this.id = id;
        this.phone = phone;
        this.email = email;
    }
     
    public User(int id, String username, String password, int role, String department,String phone, String email, String lastLogin) {
        this.id = id;
        this.username = username;
        this.password = password;
        this.role = role;
        this.department= department;
        this.phone = phone;
        this.email = email;
        this.lastLogin = lastLogin;
    }
 
    public int getId() {
        return id;
    }
 
    public void setId(int id) {
        this.id = id;
    }

    public int getRole() {
        return role;
    }
 
    public void setRole(int role) {
        this.role = role;
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

	public String getDepartment() {
		return department;
	}
}
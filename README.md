# CRUD application
This is a CRUD application build for assignment and education purpose.

This application is built according to requirements below:

1.            Web Application with back-end in Java + frontend in any Javascript framework
2.            Database back-end
3.            3 main kinds of user types: User, Manager, Admin
4.            Admin can View All Users, Add, Modify, Delete Users. Admin should be able to modify 2 attributes of an user in 1 transaction, e.g. change user's phone and email in 1 transaction
5.            Manager can view users under their departments only. And modify their mobile number only. No add or delete.  
6.            User can update their mobile number only
7.            All users are able to login to the web app and see their relevant pages.
8.            All actions of the users should be logged for auditing purposes.


## Tool used
*Java Servlet
*MySQL 
*Vue.js
*Apache Tomcat 9

### Installing
Download and import the project into any IDE that supports J2EE.

##Database (I was not able to export the database so I only included the CREATE TABLE sql for now)

Servlet connection settings to MySQL in web.xml
```
 <context-param>
    <param-name>jdbcURL</param-name>
    <param-value>jdbc:mysql://localhost:3306/schema</param-value>
</context-param>

<context-param>
    <param-name>jdbcUsername</param-name>
    <param-value>root</param-value>
</context-param>

<context-param>
    <param-name>jdbcPassword</param-name>
    <param-value></param-value>
</context-param>
```

To create table in MySQL
```
createtable.sql
```

## Deployment
To access to the site, use the following exmaple URL, changing the port number accordingly
```
localhost:8080/JVM
```

The server will redirect to index.jsp, which will then redirect to login.jsp if there is no session available
The landing page can be changed at the following lines in web.xml
```
<welcome-file-list>
      <welcome-file>index.jsp</welcome-file>
</welcome-file-list>
  ```



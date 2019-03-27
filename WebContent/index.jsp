<%@ page language="java" import="java.util.*" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.jvm.model.User" %>
<% 
    User loginUser = (User) session.getAttribute("loginUser");
	if(loginUser == null) {
		session.invalidate();
		RequestDispatcher dispatcher = request.getRequestDispatcher("login.jsp");
        dispatcher.forward(request, response);
	    return;
	}

    int myId = loginUser.getId();
    int myRole = loginUser.getRole();
    String myDepartment = loginUser.getDepartment();
%>
<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no, minimal-ui">
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="ie=edge">
<title>App</title>
<link href="https://fonts.googleapis.com/css?family=Roboto:100,300,400,500,700,900|Material+Icons" rel="stylesheet">
<link href="https://unpkg.com/vuetify@1.5.7/dist/vuetify.min.css" rel="stylesheet">
<script src="https://unpkg.com/babel-standalone@6.26.0/babel.min.js"></script>
<style>
* {
  margin: 0;
  padding: 0;
}
html {
  overflow-x: hidden;
  overflow-y: hidden;
  background: #eeeeee;
}
body {
  display: flex;
  overflow-x: hidden;
  width: 120vh;
  margin: 0 auto;
}
#app {
  font-family: -apple-system, BlinkMacSystemFont, "PingFang SC",
    "Helvetica Neue", STHeiti, "Microsoft Yahei", Tahoma, Simsun, sans-serif;
  width: 100%;
  height: 100%;
}
#app a {
  text-decoration: none;
}

</style>
</head>
<body>
    <main id="app">
    	<template id="menu">
	        <v-toolbar app color="teal" light>
	        	<router-link :to="{path: '/'}">
	            	<v-toolbar-title>Application</v-toolbar-title>
	            </router-link>
	            <v-spacer></v-spacer>
	            <v-btn flat class="teal" href="logout">Log Out</v-btn>
	        </v-toolbar>
		</template>
        <router-view></router-view>
    </main>
    
    <table-component />

    <insert-component />
    
    <edit-component />

<script src="https://unpkg.com/vue@2.6.10/dist/vue.js"></script>
<script src="https://unpkg.com/vuetify@1.5.7/dist/vuetify.js"></script>
<script src="https://unpkg.com/vue-router@3.0.2/dist/vue-router.js"></script>
<script>
    Vue.prototype.$myid = <%= myId %>;
    Vue.prototype.$myrole = <%= myRole %>;
    Vue.prototype.$mydept = '<%= myDepartment %>';

	let users = [
		<c:forEach var="user" items="${listUser}" varStatus="status">
		    {
		    	id: '${user.id}',
		    	username: '${user.username}',
		    	role: '${user.role}',
		    	department: '${user.department}',
		    	phone: '${user.phone}',
		    	email: '${user.email}'
		    } 
		    <c:if test="${!status.last}">,</c:if>
	    </c:forEach>
	    
	];

	// Vue components
	let AppNavigator = Vue.component('AppNavigator', {
		data() {
	        return {
	        };
	    },
	    template: `
	    
	    `
	});
	
    let TableComponent = Vue.component('TableComponent', {
        data: function() {
            return {
                headers: [
                    { text: 'Id', align: 'left', width: "1%", value: "id" },
                    { text: 'Username', width: "1%", value: "username"},
                    { text: 'Role', width: "1%", value: "role"},
                    { text: 'Department', width: "1%", value: "department" },
                    { text: 'Mobile no.', width: "1%", value: "phone" },
                    { text: 'Email', width: "1%", value: "email" },
                    { text: 'Action', width: "1%", sortable: false }
                ],
                items: users
            }
        },
        methods: {
            editItem (item) {
                this.$router.push({ name: 'edit-user', params: { obj: item } })
            },
            deleteItem (item) {
                if (confirm('Are you sure you want to delete this item?')) {
                    document.mainform.action = "delete";
					document.mainform.id.value = item.id;
                    document.mainform.submit();
                  	//const index = this.items.indexOf(item);
                    //this.items.splice(index, 1);
                }
            },
        },
        template: `
        <template id="table">
            <v-app>
                <v-content>
                    <v-container>
                        <template>
                            <v-app>
                                <v-card class="pa-3">
                                <router-link :to="{path: '/add-user'}" v-if="this.$myrole == 1">
                                    <v-btn class="teal" dark>
                                        Add User
                                    </v-btn>
                                </router-link>
                                <v-data-table
                                    :headers="headers"
                                    :items="items"
                                    hide-actions
                                    disable-initial-sort
                                >
                                    <template v-slot:items="props">
                                    <td>{{ props.item.id }}</td>
                                    <td class="text-xs-left">{{ props.item.username }}</td>
                                    <td class="text-xs-left">
                                    	<span v-if="props.item.role == 1">
                                    		Admin
                                    	</span>
                                   		<span v-else-if="props.item.role == 2">
                                    		Manager
                                    	</span>
                                   		<span v-else-if="props.item.role == 3">
                                    		User
                                    	</span>
                                    </td>
                                    <td class="text-xs-left">{{ props.item.department }}</td>
                                    <td class="text-xs-left">{{ props.item.phone }}</td>
                                    <td class="text-xs-left">{{ props.item.email }}</td>
                                    <td class="justify-center layout px-0">
                                    	<v-icon small class="mr-2" @click="editItem(props.item)">edit</v-icon>
                                        <v-icon small @click="deleteItem(props.item)" v-if="<%= myRole %> == 1">delete</v-icon>
                                    </td>
                                    </template>
                                </v-data-table>
                                </v-card>
                            </v-app>
                            <form name="mainform" method="post">
								<input type="hidden" name="id" value="" />
                            </form>
                        </template>
                    </v-container>
                </v-content>
            </v-app>
        </template>
        `,
    });

    let InsertComponent = Vue.component('InsertComponent', {
         data: function () {
            return {
                user: {
                    username: '',
                    role: '',
                    department: '',
                    phone: '',
                    email: '',
                },
                roles: [
                	{ value: 1, role: 'Admin' },
	               	{ value: 2, role: 'Manager' },
	                { value: 3, role: 'User' }
	            ],
	            departments: [
                	{ value: 'IT' },
	               	{ value: 'Human Resource' },
	                { value: 'Marketing' }
	            ],
                rules: {
                    required: value => !!value || 'Required.',
                    min: v => v.length >= 4 || 'Min 4 characters',
                    email: value => {
                        const pattern = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
                        return pattern.test(value) || 'Invalid email.'
                    }
                }
            }
        },
        methods: {
            addUser: function() {
				document.insertForm.submit();
				
            }
        },
        template: `
        <template id="add-user">
            <v-app id="inspire">
            	<v-layout align-center justify-center fill-height class="pa-5 my-5">
            		<v-flex xs6>
            		<form name="insertForm" action="insert">
		                <h2>Add new user</h2>
	                    <v-text-field
	                        v-model="user.username"
	                        :rules="[rules.required, rules.min]"
	                        name="USERNAME"
	                        label="Name"
	                    ></v-text-field>
	                
	                    <v-text-field
	                        v-model="user.password"
	                        :append-icon="show ? 'visibility' : 'visibility_off'"
	                        :rules="[rules.required, rules.min]"
	                        :type="show ? 'text' : 'password'"
	                        name="PASSWORD"
	                        label="Password"
	                        hint="At least 4 characters required"
	                        @click:append="show = !show"
	                    ></v-text-field>
	
	                    <v-select
	                        v-model="user.role"
	                        :items="roles"
	                        :rules="[rules.required]"
	                       	item-text="role"
	                        NAME="SELECT_ROLE"
	                        label="User role"
	                        single-line
	                        return-object
	                    ></v-select>
	
	                    <v-select
		                    v-model="user.department"
		                    :items="departments"
		                    :rules="[rules.required]"
		                   	item-text="value"
		                    NAME="SELECT_DEPT"
		                    label="Department"
		                    single-line
		                    return-object
	                	></v-select>
	                
	                    <v-text-field
	                        v-model="user.phone"
	                        NAME="PHONE"
	                        label="Mobile no."
	                    ></v-text-field>
	
	                    <v-text-field
	                        v-model="user.email"
	                        :rules="[rules.email]"
	                        NAME="EMAIL"
	                        label="E-mail"
	                    ></v-text-field>
	                    
	                    <input type="hidden" name="ROLE" :value="this.user.role.value" />
	                    	<input type="hidden" name="DEPARTMENT" :value="this.user.department.value" />
	                    <v-btn type="button" color="success" @click="addUser">Create User</v-btn>
	                
	                    <router-link :to="{path: '/'}">
	                        <v-btn color="warning">Cancel</v-btn>
	                    </router-link>
	                </form>
	                </v-flex>
	                </v-layout>
            </v-app>
        </template>
        `
    });

    let EditComponent = Vue.component('EditComponent', {
         data: function () {
            return {
                show: false,
                user: this.$route.params.obj,
                rules: {
                    email: value => {
                        const pattern = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
                        return pattern.test(value) || 'Invalid email.'
                    }
                }
            }
        },
        template: `
        <template id="edit-user">
            <v-app>
            	<v-content>
            		<v-container fluid>
	            		<v-layout align-center justify-center fill-height class="pa-5 my-5">
		            		<v-flex xs6>
			                <form name="editForm" action="update">
			                    <h2>Update user </h2>
			                    <v-text-field
			                        v-model="user.username"
			                        :rules="[rules.required, rules.min]"
			                        name="USERNAME"
			                        	box
			                        label="Name"
			                        readonly
			                    ></v-text-field>
			
			                    <v-text-field
			                        v-model="user.phone"
			                        NAME="PHONE"
			                        label="Mobile no."
			                    ></v-text-field>
			
			                    <v-text-field
			                        v-model="user.email"
			                        :rules="[rules.email]"
			                        NAME="EMAIL"
			                        label="E-mail"
			                        v-if="this.$myrole == 1"
			                    ></v-text-field>
			                    
			                    <v-btn type="submit" color="success">Save Changes</v-btn>
			                
			                    <router-link :to="{path: '/'}">
			                        <v-btn color="warning">Cancel</v-btn>
			                    </router-link>
			                    
			                    <!-- <input type="hidden" name="USERID" :value="this.$myid" /> -->
			                    <!-- <input type="hidden" name="USERROLE" :value="this.$myrole" /> -->
			                    <input type="hidden" name="ID" :value="user.id" />
	                		</form>
	                		</v-flex>
    	                </v-layout>
               		</v-container>
            	</v-content>
            </v-app>
        </template>
        `
    });

    let router = new VueRouter({
        routes: [
            { path: '/', component: TableComponent },
            { path: '/add-user', component: InsertComponent },
            { 
            	path: '/edit-user',
            	name: 'edit-user',
            	component: EditComponent
             }
        ]
    });

    new Vue({
        router
    }).$mount('#app')
</script>
</body>
</html>
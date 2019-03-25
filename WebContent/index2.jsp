<%@ page language="java" import="java.util.*" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!-- https://www.codejava.net/coding/jsp-servlet-jdbc-mysql-create-read-update-delete-crud-example -->
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
</head>
<body>
    <main id="app">
        <router-view></router-view>
    </main>
    
    <table-component />

    <insert-component />
    

<script src="https://unpkg.com/vue@2.6.10/dist/vue.js"></script>
<script src="https://unpkg.com/vuetify@1.5.7/dist/vuetify.js"></script>
<script src="https://unpkg.com/vue-router@3.0.2/dist/vue-router.js"></script>
<script>

	let users = [
		<c:forEach var="user" items="${listUser}">
		    {
		    	id: '${user.id}',
		    	username: '${user.username}',
		    	password: '${user.password}',
		    	role: '${user.role}',
		    	department: '${user.department}',
		    	phone: '${user.phone}',
		    	email: '${user.email}'
		    } 
	    </c:forEach>  
	];

	// Vue components
    let TableComponent = Vue.component('TableComponent', {
        data: function() {
            return {
                headers: [
                    { text: 'Id', align: 'left', width: "1%" },
                    { text: 'Username', width: "1%" },
                    { text: 'Password', width: "1%" },
                    { text: 'Role', width: "1%" },
                    { text: 'Department', width: "1%" },
                    { text: 'Mobile no.', width: "1%" },
                    { text: 'Email', width: "1%" },
                    { text: 'Action', width: "1%"}
                ],
                items: users,
                role: 1
            }
        },
        methods: {
            editItem (item) {
                this.editedIndex = this.items.indexOf(item)
                this.editedItem = Object.assign({}, item)
                this.dialog = true
            },

            async deleteItem (item) {
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
                            <v-app id="inspire">
                                <v-card class="pa-3">
                                <router-link :to="{path: '/add-user'}">
                                    <v-btn color="warning" dark>
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
                                    <td class="text-xs-left">{{ props.item.password }}</td>
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
                                        <v-icon v-if="role < 2" small @click="deleteItem(props.item)">delete</v-icon>
                                    </td>
                                    </template>
                                    <v-alert v-slot:no-results :value="true" color="error" icon="warning">
                                    Your search for "{{ search }}" found no results.
                                    </v-alert>
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
                show: false,
                user: {
                    username: '',
                    password: '',
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
				let user = this.user; //let user = this.$get('user');
				/* user.push({
				    name: user.username,
				    password: user.password,
				    role: user.role
				}); */
				//router.push('/');
				document.insertForm.ROLE.value = this.user.role.value;
				document.insertForm.submit();
				
            }
        },
        template: `
        <template id="add-user">
            <v-app id="inspire">
                <form name="insertForm" action="insert">
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
                        hint="At least 6 characters"
                        @click:append="show = !show"
                    ></v-text-field>

                    <v-select
                        v-model="user.role"
                        :items="roles"
                        :rules="[rules.required]"
                       	item-text="role"
                        NAME="ROLE2"
                        label="User role"
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
                	
                    <input type="hidden" name="ROLE" value="" />
                    <v-btn type="button" color="success" @click="addUser">Create User</v-btn>
                
                    <router-link :to="{path: '/'}">
                        <v-btn color="warning">Cancel</v-btn>
                    </router-link>
                </form>
            </v-app>
        </template>
        `
    });

    let router = new VueRouter({
        routes: [
            {path: '/', component: TableComponent},
            {path: '/add-user', component: InsertComponent},
        ]
    });

    new Vue({
        router
    }).$mount('#app')
</script>
</body>
</html>
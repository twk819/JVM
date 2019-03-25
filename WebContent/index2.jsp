<%@ page language="java" import="java.util.*" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:useBean id="common" scope="page" class="com.rexit.easc.common" />
<jsp:useBean id="DB_Contact" scope="page" class="com.rexit.easc.DB_Contact" />
<jsp:useBean id="DB_uadmin" scope="page" class="com.rexit.easc.DB_uadmin" />
<%
    String permission = "";
    //ArrayList<User> alAll = (ArrayList<User>) request.getAttribute("listUser");
	String sql = "";
	
    permission = "1";

	DB_Contact.makeConnection();
	sql = "SELECT * FROM TB_OUTSTANDING_PREM FETCH FIRST 10 ROWS ONLY WITH UR";
	DB_Contact.executeQuery(sql);
	
	ArrayList alAll = new ArrayList();
	
	while(DB_Contact.getNextQuery()){
		String a		= common.setNullToString(DB_Contact.getColumnString("TIMESTAMP"));
		String b		= common.setNullToString(DB_Contact.getColumnString("EMAIL_TO"));
		String c		= common.setNullToString(DB_Contact.getColumnString("STATUS"));
		ArrayList alInner = new ArrayList(); 
		alInner.add("\""+a+"\"");
		alInner.add("\""+b+"\"");
		alInner.add("\""+c+"\"");
		alAll.add(alInner);
	}

    for (Object a : alAll) {
    	System.out.print(a);
    }

 %>
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
//test

    let TableComponent = Vue.component('TableComponent', {
        data: function() {
            return {
                headers: [
                    { text: 'A', align: 'left' },
                    { text: 'B', width: "1%" },
                    { text: 'C', width: "1%" },
                    { text: 'Action', width: "1%"}
                ],
                items: <%= alAll %>,
                role: <%= permission %>
            }
        },
        methods: {
            editItem (item) {
                this.editedIndex = this.desserts.indexOf(item)
                this.editedItem = Object.assign({}, item)
                this.dialog = true
            },

            async deleteItem (item) {
                if (confirm('Are you sure you want to delete this item?')) {
                    const index = this.items.indexOf(item);
                    document.mainform.action = "delete";

                    //document.mainform.submit();
                    this.items.splice(index, 1);
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
                                    <td>{{ props.item[0] }}</td>
                                    <td class="text-xs-left">{{ props.item[1] }}</td>
                                    <td class="text-xs-left">{{ props.item[2] }}</td>
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
                roles: [ 'Admin', 'Manager', 'User'],
                user: {
                    username: '',
                    password: '',
                    role: '',
                    department: '',
                    phone: '',
                    email: '',
                },
                rules: {
                    required: value => !!value || 'Required.',
                    min: v => v.length >= 6 || 'Min 6 characters',
                    email: value => {
                        const pattern = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
                        return pattern.test(value) || 'Invalid e-mail.'
                    }
                }
            }
        },
        methods: {
            addUser: function() {
            // let user = this.user; //let user = this.$get('user');
            // user.push({
            //     id: Math.random().toString().split('.')[1],
            //     name: user.name,
            //     description: user.description,
            //     price: user.price
            // });

                //router.push('/');
            }
        },
        template: `
        <template id="add-user">
            <v-app id="inspire">
                <form name="insertForm" action="add">
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
                        NAME="ROLE"
                        label="User role"
                        single-line
                    ></v-select>

                    <v-text-field
                        v-model="user.phone"
                        :rules="[rules.required]"
                        NAME="PHONE"
                        label="Mobile no."
                    ></v-text-field>

                    <v-text-field
                        v-model="user.email"
                        :rules="[rules.required, rules.email]"
                        NAME="EMAIL"
                        label="E-mail"
                    ></v-text-field>
                
                    <v-btn type="submit" color="success" @click="addUser">Create User</v-btn>
                
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
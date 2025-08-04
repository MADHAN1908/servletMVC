<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page language="java" import="java.sql.*,java.time.*,java.time.temporal.ChronoUnit"%>
<%@ page language="java" import="jakarta.servlet.*,jakarta.servlet.http.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Register Form</title>
<link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
</head>
<body class = "flex justify-center items-center min-h-screen  bg-gray-200">
<% 
       String url = "jdbc:postgresql://localhost:5432/user_details";
        String user = "postgres";
        String password = "";

        String action = request.getParameter("action");
        String userName = "",organisation ="",mobile ="",email ="",passwd ="" ;
        int editId = -1;
        int c_id = 0,s_id = 0, no_of_users = 0,expire_days=0;
        %>
        <% 

        
        if ("edit".equals(action)) {
            editId = Integer.parseInt(request.getParameter("id"));
            try {
            	Class.forName("org.postgresql.Driver");
            	Connection conn = DriverManager.getConnection(url, user, password);
                 PreparedStatement ps = conn.prepareStatement("SELECT * FROM users WHERE id = ?"); 
                ps.setInt(1, editId);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    userName = rs.getString("username");
                    organisation = rs.getString("organisation");
                    mobile = rs.getString("mobile_no");
                    email = rs.getString("email");
                    passwd = rs.getString("password");
                    no_of_users = rs.getInt("no_of_users");
                    c_id = rs.getInt("country");
                    s_id = rs.getInt("state");
                    Date expiryDate = rs.getDate("expire_date");  // Assuming DATE type column
                    if (expiryDate != null) {
                        LocalDate today = LocalDate.now();
                        LocalDate expDate = ((java.sql.Date) expiryDate).toLocalDate();
                        expire_days = (int) ChronoUnit.DAYS.between(today, expDate);
                    } else {
                        expire_days = 0;
                    }
                }
            } catch (Exception e) {
//                e.printStackTrace(out);
            }
        }
        %>
       
        <div class="mt-20 w-full">
        <div class="flex-auto mr-2 text-center">
        <a href="users.jsp" class="text-white bg-green-500 w-1/2 p-2 text-lg rounded hover:bg-green-700"  >Close</a>
        <div  class="flex justify-center items-center " >
        <form method="POST" action="users" enctype="multipart/form-data"  class="bg-gray-100 border-4 border-blue-800 w-1/2 p-5 rounded-md flex flex-col h-auto max-h-[450px] m-5 md:max-w-[375px]">
        <h1 class="text-blue-800 text-center text-3xl mb-4">Registration</h1>
        
        <div class="flex items-center mb-2">
        <label class="flex-1 text-lg mr-2 text-left font-semibold" for="username">Name :</label>
        <div class="flex-auto">
        <input type="hidden" name="id" value="<%= (editId != -1 ? editId : "") %>"/>
        <input type="text" id="username" name="username" value="<%= userName %>" placeholder="Name" class="w-full p-1 border border-gray-300 rounded" />
        </div></div>
        
        <div class="flex items-center mb-2">
        <label class="flex-1 text-lg mr-2 text-left font-semibold" for="organisation">Organization :</label>
        <div class="flex-auto">
        <input type="text" id="organisation" name="organisation" value="<%= organisation %>" placeholder="Organisation" class="w-full p-1 border border-gray-300 rounded" />
        </div></div>
        
        <div class="flex items-center mb-2">
        <label class="flex-1 text-lg mr-2 text-left font-semibold" for="mobile">Mobile No :</label>
        <div class="flex-auto">
        <input type="text" id="mobile" name="mobile" value="<%= mobile %>" placeholder="Mobile No" class="w-full p-1 border border-gray-300 rounded" />
        </div></div>
        
        <div class="flex items-center mb-2">
        <label class="flex-1 text-lg mr-2 text-left font-semibold" for="email">Email  :</label>
        <div class="flex-auto">
        <input type="text" id="email" name="email" value="<%= email %>" placeholder="Email ID" class="w-full p-1 border border-gray-300 rounded" />
        </div></div>
        
        <div class="flex items-center mb-2">
        <label class="flex-1 text-lg mr-2 text-left font-semibold" for="passwd">Password  :</label>
        <div class="flex-auto">
        <input type="password" id="passwd" name="passwd" value="<%= passwd %>" placeholder="Password" class="w-full p-1 border border-gray-300 rounded" />
        </div></div>
        
        <div class="flex items-center mb-2">
        <label class="flex-1 text-lg mr-2 text-left font-semibold" for="photo">Photo  :</label>
        <div class="flex-auto">
        <input type="file" id="photo" name="photo"   class="w-full p-1 border border-gray-300 rounded" />
        </div></div>
        
        <div class="flex items-center mb-2">
        <label class="flex-1 text-lg mr-2 text-left font-semibold" for="no_of_users">No of Users  :</label>
        <div class="flex-auto">
        <input type="number" id="no_of_users" name="no_of_users" value="<%= no_of_users %>"  class="w-full p-1 border border-gray-300 rounded" />
        </div></div>
        
        <div class="flex items-center mb-2">
        <label class="flex-1 text-lg mr-2 text-left font-semibold" For="country"> Country   : </label>
        <div class="flex-auto">
        <select name="country_id" id="country" class="w-full p-1 border border-gray-300 rounded" >
        <option value="">Select Country</option>
        <%
        try { 
        	Class.forName("org.postgresql.Driver");
        	Connection conn = DriverManager.getConnection(url, user, password);
        	 Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT * FROM country");
             while (rs.next()) {
            	 int currentId = rs.getInt("id");
            	 String selected = (currentId == c_id) ? "selected" : "";
                 out.println("<option key=\""+rs.getInt("id")+"\" value=\""+rs.getInt("id")+"\" "+selected+">"+rs.getString("country_name")+"</option>");
             }
             conn.close();
        } catch (Exception e) {
  //          e.printStackTrace(out);
        }
        
        %>
        </select></div></div>
        
        <div class="flex items-center mb-2">
        <label class="flex-1 text-lg mr-2 text-left font-semibold" For="state"> State   : </label>
        <div class="flex-auto">
        <select name="state_id" id="state" class="w-full p-1 border border-gray-300 rounded" >
        <option value="">Select State</option>
        <% 
        try { 
        	Class.forName("org.postgresql.Driver");
        	Connection conn = DriverManager.getConnection(url, user, password);
        	 Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT * FROM state");
             while (rs.next()) {
            	 int currentId = rs.getInt("id");
            	 String selected = (currentId == s_id) ? "selected" : "";
                 out.println("<option key=\""+rs.getInt("id")+"\" value=\""+rs.getInt("id")+"\" "+selected+">"+rs.getString("state_name")+"</option>");
             }
             conn.close();
        } catch (Exception e) {
  //          e.printStackTrace(out);
        }
        %>
        </select></div></div>
        
        <div class="flex items-center mb-2">
        <label class="flex-1 text-lg mr-2 text-left font-semibold" for="expire_days">Expire Days  :</label>
        <div class="flex-auto">
        <input type="number" id="expire_days" name="expire_days" value="<%= expire_days %>"  class="w-full p-1 border border-gray-300 rounded" />
        </div></div>


        <div id="btn" class="flex items-center mb-2">
        <button type="submit" class="text-white bg-green-500 w-full py-2 text-lg rounded hover:bg-green-700"  ><%= (editId != -1 ? "Update User" : "Add User") %></button>
        </div> </form> </div></div></div>


</body>
</html>
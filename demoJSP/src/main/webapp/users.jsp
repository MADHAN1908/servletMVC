<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page language="java" import="java.sql.*"%>
<%@ page language="java" import="jakarta.servlet.*,jakarta.servlet.http.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Users</title>
<link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
</head>
<body  class = "flex justify-center items-center min-h-screen  bg-gray-200">
<% 
String url = "jdbc:postgresql://localhost:5432/user_details";
        String user = "postgres";
        String password = "";

        String action = request.getParameter("action");
        
        	if ("delete".equals(action)) {
            int deleteId = Integer.parseInt(request.getParameter("id"));
            try { 
            	Connection conn = DriverManager.getConnection(url, user, password);
                 PreparedStatement ps = conn.prepareStatement("DELETE FROM users WHERE id = ?");
                ps.setInt(1, deleteId);
                ps.executeUpdate();
            } catch (Exception e) {
//                e.printStackTrace(out);
            }
            response.sendRedirect("users.jsp");
            return;
        }
      %>  	
       
        
        <div class="mt-20 w-full">
        <div class="flex-auto mr-2 text-center">
        <a href="userForm.jsp" class="text-white bg-green-500 w-1/4 p-2 text-lg rounded hover:bg-green-700"  >Add User</a>
        <a href="state.jsp" class="text-white bg-green-500 w-1/4 p-2 text-lg rounded hover:bg-green-700"  >Add State</a>
        <a href="country.jsp" class="text-white bg-green-500 w-1/4 p-2 text-lg rounded hover:bg-green-700"  >Add Country</a>
        <h2 class="text-blue-800 text-center text-3xl  my-4">User List</h2>
        <table class="table-auto border border-gray-300 bg-gray-100 mb-20 m-10 w-full" id="state_list"><tr>
        <th class="border-2 border-gray-300 bg-gray-200 px-4 py-2">ID</th>
        <th class="border-2 border-gray-300 bg-gray-200 px-4 py-2">Photo</th>
        <th class="border-2 border-gray-300 bg-gray-200 px-4 py-2">Name</th>
        <th class="border-2 border-gray-300 bg-gray-200 px-4 py-2">Organization</th>
        <th class="border-2 border-gray-300 bg-gray-200 px-4 py-2">Mobile No</th>
        <th class="border-2 border-gray-300 bg-gray-200 px-4 py-2">Email</th>
        <th class="border-2 border-gray-300 bg-gray-200 px-4 py-2">No Of Users</th>
        <th class="border-2 border-gray-300 bg-gray-200 px-4 py-2">State</th>
        <th class="border-2 border-gray-300 bg-gray-200 px-4 py-2">Country</th>
        <th class="border-2 border-gray-300 bg-gray-200 px-4 py-2">Expire Date</th>
        <th class="border-2 border-gray-300 bg-gray-200 px-4 py-2">Edit</th>
        <th class="border-2 border-gray-300 bg-gray-200 px-4 py-2">Delete</th></tr>
      <%   
        try {
            // Load PostgreSQL JDBC Driver
            Class.forName("org.postgresql.Driver");

            // Connect to DB
            Connection conn = DriverManager.getConnection(url, user, password);

//            <h2>Connected to PostgreSQL successfully!</h2>");

            // Example query
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT u.*,s.state_name,c.country_name FROM users u join state s on u.state = s.id  join country c on u.country = c.id Order by id ");
            while (rs.next()) {
            	out.println("<tr>");
            	out.println("<td class=\"border-2 border-gray-300 px-4 py-2 \">"+rs.getInt("id")+"</td>");
            	out.println("<td className=\"border-2 border-gray-300 px-4 py-2\"><img src=\""+rs.getString("photo")+"\" className=\"w-24 h-24 rounded-full\" alt=\"User Photo\" /></td>");
                out.println("<td class=\"border-2 border-gray-300 px-4 py-2 \">"+rs.getString("username")+"</td>");
                out.println("<td class=\"border-2 border-gray-300 px-4 py-2 \">"+rs.getString("organisation")+"</td>");
                out.println("<td class=\"border-2 border-gray-300 px-4 py-2 \">"+rs.getString("mobile_no")+"</td>");
                out.println("<td class=\"border-2 border-gray-300 px-4 py-2 \">"+rs.getString("email")+"</td>");
                out.println("<td class=\"border-2 border-gray-300 px-4 py-2 \">"+rs.getInt("no_of_users")+"</td>");
                out.println("<td class=\"border-2 border-gray-300 px-4 py-2 \">"+rs.getString("state_name")+"</td>");
                out.println("<td class=\"border-2 border-gray-300 px-4 py-2 \">"+rs.getString("country_name")+"</td>");
                out.println("<td class=\"border-2 border-gray-300 px-4 py-2 \">"+rs.getString("expire_date")+"</td>");
                out.println("<td class=\"border-2 border-gray-300 px-4 py-2 \"><a href='userForm.jsp?action=edit&id=" + rs.getInt("id") + "' class=\"bg-blue-600 text-white p-1  border rounded\">Edit</a></td>");
                out.println("<td class=\"border-2 border-gray-300 px-4 py-2 \"><a href='users.jsp?action=delete&id=" + rs.getInt("id") + "' class=\"bg-red-600 text-white p-1  border rounded\">Delete</a></td>");
                out.println("</tr>");
            }
            conn.close();
        }catch (Exception e) {
         //   e.printStackTrace(out);
        }
%>
<%
String sql = "CALL ADDState(?, ?)";
	try {
		Connection conn = DriverManager.getConnection(url, user, password);
	     CallableStatement stmt = conn.prepareCall(sql);

	    stmt.setString(1, "Tamil Nadu45");   
	    stmt.setLong(2, 1);                 

	    stmt.execute();
	    out.println("State added successfully");

	} catch (Exception e) {
	    e.printStackTrace();
	    out.println("Error: " + e.getMessage());
	}%>
</table> </div></div>
</body>
</html>
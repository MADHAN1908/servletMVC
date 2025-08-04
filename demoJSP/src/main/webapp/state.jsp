<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page language="java" import="java.sql.*"%>
    <%@ page language="java" import="jakarta.servlet.*,jakarta.servlet.http.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>State</title>
<link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
</head>
<body class = "flex justify-center items-center min-h-screen  bg-gray-200">
<% String url = "jdbc:postgresql://localhost:5432/user_details";
        String user = "postgres";
        String password = ""; 
        Connection conn = null;
        String action = request.getParameter("action") ;
        String editName = "";
        int editId = -1;
        int c_id = 0;     
 %>
 
 <%
 if ("edit".equals(action)) {
            editId = Integer.parseInt(request.getParameter("id"));
            try {conn = DriverManager.getConnection(url, user, password);
                 PreparedStatement ps = conn.prepareStatement("SELECT * FROM state WHERE id = ?"); 
                ps.setInt(1, editId);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    editName = rs.getString("state_name");
                    c_id = rs.getInt("country_id");
                }
            } catch (Exception e) {
//                e.printStackTrace(out);
            }
        } else if ("delete".equals(action)) {
            int deleteId = Integer.parseInt(request.getParameter("id"));
            try { 
            	conn = DriverManager.getConnection(url, user, password);
                 PreparedStatement ps = conn.prepareStatement("DELETE FROM state WHERE id = ?");
                ps.setInt(1, deleteId);
                ps.executeUpdate();
            } catch (Exception e) {
//                e.printStackTrace(out);
            }
            response.sendRedirect("state.jsp");
            return;
        }
        %>
        
        <div class="mt-20 w-full">
        <div class="flex-auto mr-2 text-center">
        <a href="users" class="text-white bg-green-500 w-1/4 p-2 text-lg rounded hover:bg-green-700"  >Register User</a>
        <a href="state.jsp" class="text-white bg-green-500 w-1/4 p-2 text-lg rounded hover:bg-green-700"  >Add State</a>
        <a href="country.jsp" class="text-white bg-green-500 w-1/4 p-2 text-lg rounded hover:bg-green-700"  >Add Country</a>
        <div  class="flex justify-center items-center " >
        <form method="POST" action="state" class="bg-gray-100 border-4 border-blue-800 w-96 p-5 rounded-md flex flex-col h-auto max-h-[450px] m-5 md:max-w-[375px]">
        <h1 class="text-blue-800 text-center text-3xl mb-4">State</h1>
        <div class="flex items-center mb-2">
        <label class="flex-1 text-lg mr-2 text-left font-semibold" For="country"> Country   : </label>
        <div class="flex-2">
        <select name="country_id" id="country" class="w-full p-1 border border-gray-300 rounded" >
        <option value="">Select Country</option>
        <% 
        try { 
        	conn = DriverManager.getConnection(url, user, password);
        	 Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT * FROM country");
             while (rs.next()) {
            	 int currentId = rs.getInt("id");
            	 String selected = (currentId == c_id) ? "selected" : "";
                 out.println("<option key=\""+rs.getInt("id")+"\" value=\""+rs.getInt("id")+"\" "+selected+">"+rs.getString("country_name")+"</option>");
             }
             conn.close();
        } catch (Exception e) {
//            e.printStackTrace(out);
        }
        %>
        </select></div></div>
        <div class="flex items-center mb-2">
        <label class="flex-1 text-lg mr-2 text-left font-semibold" for="state">State Name :</label>
        <div class="flex-2">
        <input type="hidden" name="id" value="<%= (editId != -1 ? editId : "") %>" />
        <input type="text" id="state" name="state" value="<%= editName %>" placeholder="State Name" class="w-full p-1 border border-gray-300 rounded" />
        </div></div>

        <div id="btn" class="flex items-center mb-2">
        <button type="submit" class="text-white bg-green-500 w-full py-2 text-lg rounded hover:bg-green-700"  ><%= (editId != -1 ? "Update State" : "Add State") %></button>
        </div> </form> </div>

        <h2 class="text-blue-800 text-center text-3xl mb-4">State List</h2>
        <table class="table-auto border border-gray-300 bg-gray-100 mb-20 m-10 w-full" id="state_list"><tr>
        <th class="border-2 border-gray-300 bg-gray-200 px-4 py-2">ID</th>
        <th class="border-2 border-gray-300 bg-gray-200 px-4 py-2">State</th>
        <th class="border-2 border-gray-300 bg-gray-200 px-4 py-2">Country</th>
        <th class="border-2 border-gray-300 bg-gray-200 px-4 py-2">Edit</th>
        <th class="border-2 border-gray-300 bg-gray-200 px-4 py-2">Delete</th></tr>
        <% 
        try {
            // Load PostgreSQL JDBC Driver
            Class.forName("org.postgresql.Driver");

            // Connect to DB
            conn = DriverManager.getConnection(url, user, password);

//            <h2>Connected to PostgreSQL successfully!</h2>");

            // Example query
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT s.*,c.country_name FROM state s join country c on s.country_id = c.id");
            while (rs.next()) {
            	out.println("<tr>");
            	out.println("<td class=\"border-2 border-gray-300 px-4 py-2 \">"+rs.getInt("id")+"</td>");
                out.println("<td class=\"border-2 border-gray-300 px-4 py-2 \">"+rs.getString("state_name")+"</td>");
                out.println("<td class=\"border-2 border-gray-300 px-4 py-2 \">"+rs.getString("country_name")+"</td>");
                out.println("<td class=\"border-2 border-gray-300 px-4 py-2 \"><a href='state.jsp?action=edit&id=" + rs.getInt("id") + "' class=\"bg-blue-600 text-white p-1  border rounded\">Edit</a></td>");
                out.println("<td class=\"border-2 border-gray-300 px-4 py-2 \"><a href='state.jsp?action=delete&id=" + rs.getInt("id") + "' class=\"bg-red-600 text-white p-1  border rounded\">Delete</a></td>");
                out.println("</tr>");
            }
        }catch(Exception e){
           	 out.println(e);
            }  finally{
           		 if (conn != null) {
           		        try { conn.close(); } catch (SQLException e) { out.println(e); }
           		    }
            }
       
            %>
            </table> </div> </div>
</body>
</html>
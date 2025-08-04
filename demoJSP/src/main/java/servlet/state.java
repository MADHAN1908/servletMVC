package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

/**
 * Servlet implementation class state
 */
@WebServlet("/state")
public class state extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public state() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.setContentType("text/html");
        PrintWriter out = response.getWriter();
		String url = "jdbc:postgresql://localhost:5432/user_details";
        String user = "postgres";
        String password = "";
        String output = null;
        
		try {
			String id = request.getParameter("id");
			String c_name = request.getParameter("state");
			String c_id = request.getParameter("country_id");
			int country_id = Integer.parseInt(c_id);
			
            Class.forName("org.postgresql.Driver");

            
            Connection conn = DriverManager.getConnection(url, user, password);
            if (id != null && !id.isEmpty()) {
                
                
                int state_id = Integer.parseInt(id);
                PreparedStatement stmt = conn.prepareStatement("UPDATE state SET state_name = ? , country_id = ? WHERE id = ?");
                stmt.setString(1, c_name);
                stmt.setInt(2, country_id);
                stmt.setInt(3, state_id);
                stmt.executeUpdate();
                conn.close();
            } else {

//            	CallableStatement stmt = conn.prepareCall("CALL ADDState(?,?)");
            	CallableStatement stmt = conn.prepareCall("CALL InsertState(?,?,?)");
//            PreparedStatement stmt = conn.prepareStatement("insert into state(state_name,country_id) values(?,?)");
            stmt.setString(1,c_name);
            stmt.setInt(2, country_id);
            stmt.setString(3,output);
            stmt.execute();
            conn.close();
            
            }

        }catch (Exception e) {
//            e.printStackTrace(out);
        }
		
		out.println(output);
//		response.sendRedirect("state.jsp");
	}

}

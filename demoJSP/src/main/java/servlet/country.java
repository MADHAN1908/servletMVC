package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

/**
 * Servlet implementation class country
 */
@WebServlet("/country")
public class country extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public country() {
        super();
        // TODO Auto-generated constructor stub
    }

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		String url = "jdbc:postgresql://localhost:5432/user_details";
        String user = "postgres";
        String password = "";
        
		try {
			String id = request.getParameter("id");
			String c_name = request.getParameter("country");
            
            Class.forName("org.postgresql.Driver");

            
            Connection conn = DriverManager.getConnection(url, user, password);
            if (id != null && !id.isEmpty()) {
                
                int country_id = Integer.parseInt(id);
                PreparedStatement stmt = conn.prepareStatement("UPDATE country SET country_name = ? WHERE id = ?");
                stmt.setString(1, c_name);
                stmt.setInt(2, country_id);
                stmt.executeUpdate();
                conn.close();
            } else {

//            out.println("<h2>Connected to PostgreSQL successfully!</h2>");

       
            PreparedStatement stmt = conn.prepareStatement("insert into country(country_name) values(?)");
            stmt.setString(1,c_name);
            stmt.executeUpdate();
            conn.close();
            }

        }catch (Exception e) {
//            e.printStackTrace(out);
        }
		response.sendRedirect("country.jsp");
	}

}

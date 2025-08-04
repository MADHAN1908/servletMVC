package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.time.LocalDate;
import java.util.Date;

/**
 * Servlet implementation class users
 */
@WebServlet("/users")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, 
maxFileSize = 1024 * 1024 * 10,       
maxRequestSize = 1024 * 1024 * 50) 
public class users extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public users() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		String url = "jdbc:postgresql://localhost:5432/user_details";
        String user = "postgres";
        String password = "";
        
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
		try {
			String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
		    File uploadDir = new File(uploadPath);
		    if (!uploadDir.exists()) uploadDir.mkdir();
		    
		    Part filePart = request.getPart("photo");
		    String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
		    
		    String filePath = uploadPath + File.separator + fileName;
		    filePart.write(filePath);

		    String imageUrl = "uploads/" + fileName;
		    
			String id = request.getParameter("id");
			String username = request.getParameter("username");
			String organisation = request.getParameter("organisation");
			String mobile = request.getParameter("mobile");
			String email = request.getParameter("email");
			String passwd = request.getParameter("passwd");
			String no_of_users = request.getParameter("no_of_users");
			String c_id = request.getParameter("country_id");
			String s_id = request.getParameter("state_id");
			String ex_days = request.getParameter("expire_days");
			int users = Integer.parseInt(no_of_users);
			int country_id = Integer.parseInt(c_id);
			int state_id = Integer.parseInt(s_id);
			int expire_days = Integer.parseInt(ex_days);
			LocalDate currentDate = LocalDate.now();

			LocalDate expireDate = currentDate.plusDays(expire_days);
			Date Expire_Date = java.sql.Date.valueOf(expireDate);

//			DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
//			String formattedExpireDate = expireDate.format(formatter);
			
			out.println(imageUrl);
			
            Class.forName("org.postgresql.Driver");

            
            Connection conn = DriverManager.getConnection(url, user, password);
            if (id != null && !id.isEmpty()) {
                
                
                int user_id = Integer.parseInt(id);
                PreparedStatement stmt = conn.prepareStatement("UPDATE users SET username = ?, organisation = ?, mobile_no = ?, email = ?,password = ?,photo = ? , no_of_users = ?, state = ? , country = ?, expire_date = ?  WHERE id = ?");
                stmt.setString(1, username);
                stmt.setString(2, organisation);
                stmt.setString(3, mobile);
                stmt.setString(4, email);
                stmt.setString(5, passwd);
                stmt.setString(6, imageUrl);
                stmt.setInt(7, users);
                stmt.setInt(8, country_id);
                stmt.setInt(9, state_id);
                stmt.setDate(10, (java.sql.Date) Expire_Date);
                stmt.setInt(11, user_id);
                stmt.executeUpdate();
                conn.close();
            } else {

       
            PreparedStatement stmt = conn.prepareStatement("insert into users(username, organisation, mobile_no, email,password,photo , no_of_users, state, country, expire_date) values(?,?,?,?,?,?,?,?,?,?)");
            stmt.setString(1, username);
            stmt.setString(2, organisation);
            stmt.setString(3, mobile);
            stmt.setString(4, email);
            stmt.setString(5, passwd);
            stmt.setString(6, imageUrl);
            stmt.setInt(7, users);
            stmt.setInt(8, country_id);
            stmt.setInt(9, state_id);
            stmt.setDate(10, (java.sql.Date) Expire_Date);
            stmt.executeUpdate();
            conn.close();
            }

        }catch (Exception e) {
            e.printStackTrace(out);
        }
		response.sendRedirect("users.jsp");
	}

}

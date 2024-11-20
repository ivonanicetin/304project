<!DOCTYPE html>
<html>
<head>
    <title>Customer Page</title>
</head>
<body>

<%@ include file="auth.jsp"%>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>

<%
    String userName = (String) session.getAttribute("authenticatedUser");
    //out.println("<p>Debug: Session Attribute for userName: " + userName + "</p>");
    NumberFormat currFormat = NumberFormat.getCurrencyInstance();
    if (userName != null) {
        try {
            getConnection(); // Establish the database connection
            
            // Prepare the SQL query to fetch customer details for the logged-in user
            String query = "SELECT customerId, firstname, lastname, email, phonenum, address, city, state, postalCode, country FROM customer WHERE userid = ?";
            PreparedStatement psmt = con.prepareStatement(query);
            psmt.setString(1, userName); // Bind the authenticated user's ID

            ResultSet rs = psmt.executeQuery();

            // Generate table if there are results
            out.println("<table border='1'>");
            //out.println("<tr><th>Customer ID</th><th>First Name</th><th>Last Name</th><th>Email</th><th>Phone</th></tr>");

            while (rs.next()) {
                
                out.println("<tr><td><th>Id</th></td><td>"+ rs.getInt("customerId") + "</td></tr>");
				out.println("<tr><td><th>Name</th></td><td>"+ rs.getString("firstname") + " "+rs.getString("lastname") + "</td></tr>");
            	out.println("<tr><td><th>Id</th></td><td>"+ rs.getString("email") + "</td></tr>");
          		out.println("<tr><td><th>Id</th></td><td>"+ rs.getString("phonenum") + "</td></tr>");
      
            }

            out.println("</table>");
            rs.close();
            psmt.close();

        } catch (SQLException ex) {
            out.println("<p>Error retrieving customer details: " + ex.getMessage() + "</p>");
        } finally {
            closeConnection();
        }
    } else {
        out.println("<p>No authenticated user found. Please log in again.</p>");
    }
%>

</body>
</html>

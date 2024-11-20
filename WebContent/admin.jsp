<!DOCTYPE html>
<html>
<head>
<title>Administrator Page</title>
</head>
<body>


<%@ include file="auth.jsp" %>
<%@ include file="jdbc.jsp" %> 
<%@ page import="java.text.NumberFormat" %>

<%
String authenticatedUser = (String) session.getAttribute("authenticatedUser");
NumberFormat currFormat = NumberFormat.getCurrencyInstance();
if (authenticatedUser != null) {
    try {
        getConnection(); // Establish the database connection
        
        // Prepare the SQL query to fetch orders for the logged-in user
        String query = "SELECT orderDate, totalAmount FROM ordersummary os JOIN customer s ON os.customerId = s.customerId WHERE userid = ?";
        PreparedStatement psmt = con.prepareStatement(query);
        psmt.setString(1, authenticatedUser); // Bind the authenticated user's ID

        //table
        out.println("<table border = 1 ");
        out.println("<tr><th>Order Date</th><th>Total Amount</th></tr>");

        ResultSet rs = psmt.executeQuery();
        //print out data for table
        while (rs.next()) {
            out.print("<tr><td>"+rs.getDate("orderDate")+"</td><td>"+currFormat.format(rs.getDouble("totalAmount"))+"</td></tr>");
        }
        rs.close();
        psmt.close();

    } catch (SQLException ex) {
        out.println("<p>Error retrieving orders: " + ex.getMessage() + "</p>");
    } finally {
        closeConnection();
    }
} else {
    out.println("<p>No authenticated user found. Please log in again.</p>");
}
        
%>

</body>
</html>


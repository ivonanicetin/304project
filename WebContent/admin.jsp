<!DOCTYPE html>
<html>
<head>
<title>Administrator Page</title>
</head>
<body>

<%@ include file="auth.jsp"%>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>
<%@ include file="header.jsp" %>


<%
    // String userName = (String) session.getAttribute("authenticatedUser");
%>

<%
    // Print out total order amount by day
    String sql = "select year(orderDate), month(orderDate), day(orderDate), SUM(totalAmount) FROM OrderSummary GROUP BY year(orderDate), month(orderDate), day(orderDate)";

    NumberFormat currFormat = NumberFormat.getCurrencyInstance();

    try {
        out.println("<h3>Administrator Sales Report by Day</h3>");
        
        getConnection();
        Statement stmt = con.createStatement(); 
        stmt.execute("USE orders");

        ResultSet rst = con.createStatement().executeQuery(sql);        
        out.println("<table class=\"table\" border=\"1\">");
        out.println("<tr><th>Order Date</th><th>Total Order Amount</th>");    

        while (rst.next()) {
            out.println("<tr><td>"+rst.getString(1)+"-"+rst.getString(2)+"-"+rst.getString(3)+"</td><td>"+currFormat.format(rst.getDouble(4))+"</td></tr>");
        }
        out.println("</table>");    

        out.println("<h3>List of customers</h3>");    

        // Fetch and display all customers
        String customerSql = "SELECT customerId, firstName, lastName, email, phonenum, city, country FROM Customer";

        try {
            PreparedStatement customerStmt = con.prepareStatement(customerSql);
            ResultSet customerRst = customerStmt.executeQuery();

            // Start customer table
            out.println("<table class=\"table\" border=\"1\">");
            out.println("<tr><th>Customer ID</th><th>First Name</th><th>Last Name</th><th>Email</th><th>Phone</th><th>City</th><th>Country</th></tr>");

            // Iterate over customer records and display them
            while (customerRst.next()) {
                out.println("<tr>");
                out.println("<td>" + customerRst.getString("customerId") + "</td>");
                out.println("<td>" + customerRst.getString("firstName") + "</td>");
                out.println("<td>" + customerRst.getString("lastName") + "</td>");
                out.println("<td>" + customerRst.getString("email") + "</td>");
                out.println("<td>" + customerRst.getString("phonenum") + "</td>");
                out.println("<td>" + customerRst.getString("city") + "</td>");
                out.println("<td>" + customerRst.getString("country") + "</td>");
                out.println("</tr>");
            }

            out.println("</table>");
        } catch (SQLException e) {
            out.println("Error fetching customer data: " + e.getMessage());
        } finally {
            closeConnection();  // Ensure the connection is closed here
        }
    } catch (SQLException ex) {     
        out.println(ex); 
    } finally {
        closeConnection();  // Ensure the connection is closed after the main query
    }
%>

</body>
</html>

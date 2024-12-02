<!DOCTYPE html>
<html>
<head>
<title>Customer Page</title>
</head>
<body>

<%@ include file="auth.jsp"%>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>
<%-- if you have a file without the header add this! --%>
 <%@ include file="header.jsp" %>  

<%
// if you get an error when you add the header comment out this
	// String userName = (String) session.getAttribute("authenticatedUser");
%>

<%

// Print Customer information
String sql = "select customerId, firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password FROM Customer WHERE userid = ?";

NumberFormat currFormat = NumberFormat.getCurrencyInstance();

try 
{	
	out.println("<h3>Customer Profile</h3>");
	
	getConnection();
	Statement stmt = con.createStatement(); 
	stmt.execute("USE orders");

	PreparedStatement pstmt = con.prepareStatement(sql);
	pstmt.setString(1, userName);	
	ResultSet rst = pstmt.executeQuery();
	
	if (rst.next())
	{
		out.println("<table class=\"table\" border=\"1\">");
		out.println("<tr><th>Id</th><td>"+rst.getString(1)+"</td></tr>");	
		out.println("<tr><th>First Name</th><td>"+rst.getString(2)+"</td></tr>");
		out.println("<tr><th>Last Name</th><td>"+rst.getString(3)+"</td></tr>");
		out.println("<tr><th>Email</th><td>"+rst.getString(4)+"</td></tr>");
		out.println("<tr><th>Phone</th><td>"+rst.getString(5)+"</td></tr>");
		out.println("<tr><th>Address</th><td>"+rst.getString(6)+"</td></tr>");
		out.println("<tr><th>City</th><td>"+rst.getString(7)+"</td></tr>");
		out.println("<tr><th>State</th><td>"+rst.getString(8)+"</td></tr>");
		out.println("<tr><th>Postal Code</th><td>"+rst.getString(9)+"</td></tr>");
		out.println("<tr><th>Country</th><td>"+rst.getString(10)+"</td></tr>");
		out.println("<tr><th>User id</th><td>"+rst.getString(11)+"</td></tr>");		
		out.println("</table>");
	}
}
catch (SQLException ex) 
{ 	out.println(ex); 
}
finally
{	
	closeConnection();	
}
%>


<h3>Edit Account Information</h3>

<!-- Form to update address and password -->
<form action="customer.jsp" method="post">
    <label for="address">New Address:</label><br>
    <input type="text" id="address" name="address" value=""><br><br>
    
    <label for="password">New Password:</label><br>
    <input type="password" id="password" name="password" value=""><br><br>
    
    <input type="submit" value="Update Information">
</form>

<%
    // updating password and address
    String newAddress = request.getParameter("address");
    String newPassword = request.getParameter("password");

    if (newAddress != null && !newAddress.isEmpty() && newPassword != null && !newPassword.isEmpty()) {
        String updateSql = "UPDATE Customer SET address = ?, password = ? WHERE userid = ?";
        
        try {
            getConnection();
            PreparedStatement updatePstmt = con.prepareStatement(updateSql);
            updatePstmt.setString(1, newAddress);
            updatePstmt.setString(2, newPassword);
            updatePstmt.setString(3, userName);

            int rowsUpdated = updatePstmt.executeUpdate();
            if (rowsUpdated > 0) {
                out.println("<p>Account information updated successfully.</p>");
            } else {
                out.println("<p>Error updating account information.</p>");
            }
        } catch (SQLException ex) {
            out.println("Error: " + ex.getMessage());
        } finally {
            closeConnection();
        }
    }
%>

</body>
</html>


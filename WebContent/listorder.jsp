<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>Julia & Ivona's Grocery Order List</title>

</head>
<body>

<h1>Order List</h1>

<%
//Note: Forces loading of SQL Server driver
try
{	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
}
catch (java.lang.ClassNotFoundException e)
{
	out.println("ClassNotFoundException: " +e);
}


String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
String uid = "sa";
String pw = "304#sa#pw";

// Useful code for formatting currency values:
// NumberFormat currFormat = NumberFormat.getCurrencyInstance();
// out.println(currFormat.format(5.0);  // Prints $5.00

// Make connection
try (Connection con = DriverManager.getConnection(url, uid, pw);){

	//query to retrieve all order summary records
	PreparedStatement pstmtOrd = con.prepareStatement("SELECT orderId, orderDate, o.customerId, firstName, lastName, totalAmount FROM OrderSummary o JOIN Customer c ON o.customerId = c.customerId");

	//query to retrieve all product that have been ordered
	PreparedStatement pstmtProd = con.prepareStatement("SELECT productId, quantity, price FROM OrderProduct WHERE orderId=?");

	ResultSet rstOrd = pstmtOrd.executeQuery();


out.println("<table border = 1 ");
out.println("<tr><th>Order Id</th><th>Order Date</th><th>Customer Id</th><th>Customer Name</th><th>Total Amount</th></tr>");
NumberFormat currFormat = NumberFormat.getCurrencyInstance();

	// For each order in the ResultSet
	while (rstOrd.next()){
		String ordId = rstOrd.getString(1);
		Timestamp date = rstOrd.getTimestamp(2);
		String custId = rstOrd.getString(3);
		String custName = rstOrd.getString(4) + " " + rstOrd.getString(5);
		Double amnt = rstOrd.getDouble(6);
		

		

		out.println("<tr><td>"+ordId+"</td><td>"+date+"</td><td>"+custId+"</td><td>"+custName+"</td><td>"+currFormat.format(amnt)+"</td></tr>");
		out.println("<tr><td colspan='5'>");
		

		//retrieve products from the order
		pstmtProd.setString(1, ordId);
		ResultSet rstProd = pstmtProd.executeQuery();

		out.println("<table border = 1>");
		out.println("<tr><th>Product Id</th><th>Quantity</th><th>Price</th></tr>");
		
		while(rstProd.next()){
			String prodId = rstProd.getString(1);
			String qnty = rstProd.getString(2);
			Double price = rstProd.getDouble(3);
			
			out.println("<tr><td>"+prodId+"</td><td>"+qnty+"</td><td>"+currFormat.format(price)+"</td></tr>");
			

		}
		
		out.println("</table>");
		out.println("</td></tr>");
	}
	out.println("</table>"); // Close outer table
}
// Close connection
catch (SQLException ex) { 	
	out.println(ex); 
}
%>

</body>
</html>


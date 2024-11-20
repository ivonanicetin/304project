<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>Julia & Ivona's Grocery</title>
</head>
<body>

<h1>Search for the products you want to buy:</h1>

<form method="get" action="listprod.jsp">
<input type="text" name="productName" size="50">
<input type="submit" value="Submit"><input type="reset" value="Reset"> (Leave blank for all products)
</form>

<% // Get product name to search for
String name = request.getParameter("productName");
		
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
// Variable name now contains the search string the user entered
// Use it to build a query and print out the resultset.  Make sure to use PreparedStatement!

try (Connection con = DriverManager.getConnection(url, uid, pw)) {
    //query
	String query;
	if (name != null && !name.isBlank()) {
    	query = "SELECT productId, productName, productPrice FROM Product WHERE productName LIKE ?";
	} else {
    	query = "SELECT productId, productName, productPrice FROM Product";
	}


        // Prepare statement
        try (PreparedStatement pstmt = con.prepareStatement(query)) {
            if (name != null && !name.isBlank()) { //handles empty submits
                pstmt.setString(1, "%" + name + "%");
            }

			//table
            try (ResultSet rs = pstmt.executeQuery()) {
                out.println("<table border='0'>"); //open table
			    out.println("<tr><th> </th><th>Product</th><th>Price</th></tr>");     
                while (rs.next()) {
                    int id = rs.getInt("productId");
                    String productName = rs.getString("productName");
                    double price = rs.getDouble("productPrice");

         

    		out.println("<tr>"); //open table
// Add to Cart
out.println("<td><a href='addcart.jsp?id=" + URLEncoder.encode(String.valueOf(id), "UTF-8")
        + "&name=" + URLEncoder.encode(productName, "UTF-8")
        + "&price=" + URLEncoder.encode(String.valueOf(price), "UTF-8") 
        + "'>Add to Cart</a></td>");
// updated product to hyperlink to image
out.println("<td><a href='product.jsp?id=" + id + "'>" + productName + "</a></td>");

// Price 
out.println("<td>$" + String.format("%.2f", price) + "</td>");
out.println("</tr>"); //close inner table
                }
                out.println("</table>"); // Close table
            }
        }
    } 
	// Close connection
	catch (SQLException ex) { 	
		out.println(ex); 
}


// Useful code for formatting currency values:
// NumberFormat currFormat = NumberFormat.getCurrencyInstance();
// out.println(currFormat.format(5.0);	// Prints $5.00

%>

</body>
</html>
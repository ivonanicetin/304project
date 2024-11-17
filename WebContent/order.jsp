



<%-- <%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>Julia & Ivona's Fitness Order Processing</title>
</head>
<body>

<% 
// Get customer id
String custId = request.getParameter("customerId");
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

// Determine if valid customer id was entered

// Determine if there are products in the shopping cart
// If either are not true, display an error message
// Make connection

// Save order information to database


	/*
	// Use retrieval of auto-generated keys.
	PreparedStatement pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);			
	ResultSet keys = pstmt.getGeneratedKeys();
	keys.next();
	int orderId = keys.getInt(1);
	*/

// Insert each item into OrderProduct table using OrderId from previous INSERT

// Update total amount for order record

// Here is the code to traverse through a HashMap
// Each entry in the HashMap is an ArrayList with item 0-id, 1-name, 2-quantity, 3-price

/*
	Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
	while (iterator.hasNext())
	{ 
		Map.Entry<String, ArrayList<Object>> entry = iterator.next();
		ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
		String productId = (String) product.get(0);
        String price = (String) product.get(2);
		double pr = Double.parseDouble(price);
		int qty = ( (Integer)product.get(3)).intValue();
            ...
	}
*/

// Print out order summary

// Clear cart if order placed successfully
%>
</BODY>
</HTML>
--%>
<%
/*
// Get customer id
String custId = request.getParameter("customerId");
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");
// Check for valid customer ID and non-empty product list
if (custId == null || custId.isEmpty() || productList == null || productList.isEmpty()) {
    out.println("<p>Error: Invalid customer ID or empty shopping cart.</p>");
    return;  // Exit early if there’s an error
}
// Database connection information
String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
String uid = "sa";
String pw = "304#sa#pw";
try (Connection con = DriverManager.getConnection(url, uid, pw)) {
    // Step 1: Insert into OrderSummary and retrieve generated order ID
    String sql = "INSERT INTO OrderSummary (customerId, orderDate, totalAmount) VALUES (?, GETDATE(), ?)";
    PreparedStatement pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
    pstmt.setString(1, custId);
    pstmt.setDouble(2, 0.0);  // Placeholder for total amount
    pstmt.executeUpdate();
    // Retrieve the generated order ID
    ResultSet keys = pstmt.getGeneratedKeys();
    keys.next();
    int orderId = keys.getInt(1);
    // Step 2: Insert items into OrderProduct and calculate total amount
    Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
    double totalAmount = 0.0;
    while (iterator.hasNext()) { 
        Map.Entry<String, ArrayList<Object>> entry = iterator.next();
        ArrayList<Object> product = entry.getValue();
        String productId = (String) product.get(0);
        int quantity = ((Integer) product.get(2)).intValue();
        double price = Double.parseDouble((String) product.get(3));
        totalAmount += price * quantity;
        String insertProductSql = "INSERT INTO OrderProduct (orderId, productId, quantity, price) VALUES (?, ?, ?, ?)";
        PreparedStatement pstmtProd = con.prepareStatement(insertProductSql);
        pstmtProd.setInt(1, orderId);
        pstmtProd.setString(2, productId);
        pstmtProd.setInt(3, quantity);
        pstmtProd.setDouble(4, price);
        pstmtProd.executeUpdate();
    }
    // Step 3: Update totalAmount in OrderSummary
    String updateOrderSql = "UPDATE OrderSummary SET totalAmount = ? WHERE orderId = ?";
    PreparedStatement pstmtUpdate = con.prepareStatement(updateOrderSql);
    pstmtUpdate.setDouble(1, totalAmount);
    pstmtUpdate.setInt(2, orderId);
    pstmtUpdate.executeUpdate();
    // Step 4: Display Order Summary
    out.println("<h2>Order Confirmation</h2>");
    out.println("<p>Order ID: " + orderId + "</p>");
    out.println("<p>Total Amount: " + NumberFormat.getCurrencyInstance().format(totalAmount) + "</p>");
    out.println("<h3>Order Details:</h3>");
    out.println("<table border='1'><tr><th>Product ID</th><th>Quantity</th><th>Price</th></tr>");
    iterator = productList.entrySet().iterator();
    while (iterator.hasNext()) { 
        Map.Entry<String, ArrayList<Object>> entry = iterator.next();
        ArrayList<Object> product = entry.getValue();
        String productId = (String) product.get(0);
        int quantity = ((Integer) product.get(2)).intValue();
        double price = Double.parseDouble((String) product.get(3));
        out.println("<tr><td>" + productId + "</td><td>" + quantity + "</td><td>" + NumberFormat.getCurrencyInstance().format(price) + "</td></tr>");
    }
    out.println("</table>");
    // Step 5: Clear the cart
    session.removeAttribute("productList");
    out.println("<p>Thank you for your order!</p>");
} catch (SQLException ex) {
    out.println("<p>Error processing order: " + ex.getMessage() + "</p>");
}
*/

 %>


 

<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>Julia & Ivona's Grocery Order Processing</title>
</head>
<body>

<% 
String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
String uid = "sa";
String pw = "304#sa#pw";

// Get customer id
String custId = request.getParameter("customerId");
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

boolean isValidCustomer = false;
boolean hasProducts = productList != null && !productList.isEmpty();

// Validate customer ID
try (Connection conn = DriverManager.getConnection(url, uid, pw)) { 

    // Query to count how many custIds are found in the database
    String sql = "SELECT COUNT(*) FROM customer WHERE customerId = ?";
    PreparedStatement stmt = conn.prepareStatement(sql);
    stmt.setString(1, custId);
    ResultSet rstId = stmt.executeQuery();
    
    // If the ID showed up in the database, set isValidCustomer = true;
    if (rstId.next()) {
        int countId = rstId.getInt(1);
        isValidCustomer = countId > 0;  
    }

} catch (Exception e) {
    e.printStackTrace();
}

// Check if the customer ID is valid
if (!isValidCustomer) {
    out.println("<h1>Invalid customer ID. Go back to the previous page and try again.</h1>");
    return; // Stop further execution if customer ID is invalid
}

// Check if there are products in the cart
if (productList == null || productList.isEmpty()) {
    out.println("<h1>Your cart is empty! </h1>");
    return; // Stop further execution if the cart is empty
} else {
    out.println("productList is not empty. Contents: " + productList);
}

try (Connection conn = DriverManager.getConnection(url, uid, pw)) { 

    Integer custIdNum = Integer.parseInt(custId);
    
    // Get customer info
    String custInfoQuery = "SELECT address, city, state, postalCode, country FROM customer WHERE customerId = ?";
    PreparedStatement custInfoStmt = conn.prepareStatement(custInfoQuery);
    custInfoStmt.setInt(1, custIdNum);
    ResultSet custRst = custInfoStmt.executeQuery();
    
    // Fetch the customer info if it exists
    String address = null, city = null, state = null, postalCode = null, country = null;
    if (custRst.next()) {
        address = custRst.getString("address");
        city = custRst.getString("city");
        state = custRst.getString("state");
        postalCode = custRst.getString("postalCode");
        country = custRst.getString("country");
    }

    // Save order information to the database
    String ordersql = "INSERT INTO ordersummary (orderDate, totalAmount, shiptoAddress, shiptoCity, shiptoState, shiptoPostalCode, shiptoCountry, customerId) VALUES (GETDATE(), ?, ?, ?, ?, ?, ?, ?)";

    PreparedStatement orderStmt = conn.prepareStatement(ordersql, Statement.RETURN_GENERATED_KEYS);    
    
    double totalAmount = 200; // (NEED TO EDIT )just for now cuz i didnt wanna actual calculate it im tired lol

    

    orderStmt.setDouble(1, totalAmount);
    orderStmt.setString(2, address);
    orderStmt.setString(3, city);
    orderStmt.setString(4, state);
    orderStmt.setString(5, postalCode);
    orderStmt.setString(6, country);
    orderStmt.setInt(7, custIdNum);

    int rowsAffected = orderStmt.executeUpdate();
    
    // Check if the order was inserted successfully and retrieve the generated orderId
    if (rowsAffected > 0) {
        ResultSet keys = orderStmt.getGeneratedKeys();
        if (keys.next()) {
            Integer orderId = keys.getInt(1);
            out.println("<h1>Order successfully placed. Order ID: " + orderId + "</h1>");
        } else {
            out.println("<h1>Order placed, but could not retrieve the order ID.</h1>");
        }
    } else {
        out.println("<h1>Failed to place the order.</h1>");
    }

} catch (SQLException e) {
    e.printStackTrace();
    out.println("<h1>Error occurred while processing your order: " + e.getMessage() + "</h1>");
} catch (Exception e) {
    e.printStackTrace();
    out.println("<h1>Unexpected error occurred. Please try again later.</h1>");
}


 

%>
</body>
</html>


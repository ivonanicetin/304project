<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>Julia & Ivona's Grocery Order Processing</title>
</head>
<body>

<% 
// Make connection
String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
String uid = "sa";
String pw = "304#sa#pw";

// Get customer id
String custId = request.getParameter("customerId");
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

// check if custID entered
boolean isValidCustomer = false;

    //customer ID is num
    try{
        Integer.parseInt(custId);
    }catch(NumberFormatException e){
        out.println("Invalid Customer ID "  +e);
        return;
    }

    // Validate customer ID
    try (Connection conn = DriverManager.getConnection(url, uid, pw)) {
        String sql = "SELECT COUNT(*) FROM customer WHERE customerId = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, custId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    isValidCustomer = rs.getInt(1) > 0;
                }
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
        // errorMessage = "Database error occurred while verifying customer ID."  +e;
        out.println("Database error occurred while verifying customer ID.");
    }
// If either are not true, display an error message
    if(isValidCustomer == false){
        out.println("Invalid customer ID");
        return;
    }

// Determine if there are products in the shopping cart
    if(productList.isEmpty()){
        out.println("Shopping cart is empty");
        return;
    }

// Save order information to database

// int orderId = 0; //allows first order recieved to be 1
//  try (Connection conn = DriverManager.getConnection(url, uid, pw)) {
//         // String sql = "INSERT INTO ordersummary (customerId, orderDate, totalAmount, shiptoAddress, shiptoCity, shiptoState, shiptoPostalCode, shiptoCountry) VALUES(?,?,?,?,?,?,?,?)";
       
//         PreparedStatement pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
 
//  }


    			
	// ResultSet keys = pstmt.getGeneratedKeys();
	// keys.next();
	// int orderId = keys.getInt(1);

	/*
	Use retrieval of auto-generated keys.
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
 try (Connection conn = DriverManager.getConnection(url, uid, pw)) {
    session.removeAttribute("productList");
    out.println("Order placed Successfully");
    out.println("Shopping cart cleared - thanks for your order");

 }catch(SQLException e){
    e.printStackTrace();
    out.println("processing error");

 }




 

%>
</body>
</html>


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
        out.println("<h1>Invalid Customer ID </h1>");
        return;
    }

    // Validate customer ID
    try (Connection con = DriverManager.getConnection(url, uid, pw)) {
        String sql = "SELECT COUNT(*) FROM customer WHERE customerId = ?";
        try (PreparedStatement stmt = con.prepareStatement(sql)) {
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
    if(productList == null ||productList.isEmpty()){
        out.println("<h1>Shopping cart is empty</h1>");
        return;
    }

// Save order information to database
int orderId = 0; //allows first order recieved to be 1
 try (Connection con = DriverManager.getConnection(url, uid, pw)) {
    String sql = "INSERT INTO ordersummary (customerId, totalAmount) VALUES(?,?)";
    try(PreparedStatement pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)){
    int customerId = Integer.parseInt(custId);
    pstmt.setInt(1, customerId);
    pstmt.setDouble(2, 0.0);

    pstmt.executeUpdate();

    try(ResultSet keys = pstmt.getGeneratedKeys()){
	if(keys.next()){
	    orderId = keys.getInt(1);
    }
    }
    }
}catch(SQLException e){
    e.printStackTrace();
    // out.println("failed to create order");

    out.println("Error: " + e.getMessage());
    out.println("SQL State: " + e.getSQLState()); 
    out.println("Error Code: " + e.getErrorCode()); 
    return;
}

if(orderId == 0){
    out.println("order failed");
    return;
}
// out.println("Your order reference number is:  " + orderId);


// Update total amount for order record

// traverse through a HashMap
double totalAmount = 0.0; //setup for total amount calculations 
try (Connection con = DriverManager.getConnection(url, uid, pw)) {
    String sql = "INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (?,?,?,?)";
    try (PreparedStatement stmt = con.prepareStatement(sql)) {
        out.println("<h1>Your Order Summary</h1>");
out.println("<table border='0' cellpadding='' cellspacing='0' style='border-collapse: collapse; width: 20%;'>");
out.println("<thead>");
out.println("<tr>");
out.println("<th>Product ID</th>");
out.println("<th>Product Name</th>");
out.println("<th>Quantity</th>");
out.println("<th>Price</th>");
out.println("<th>Subtotal</th>");
out.println("</tr>");
out.println("</thead>");
out.println("<tbody>");
        Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
	while (iterator.hasNext()){
        Map.Entry<String, ArrayList<Object>> entry = iterator.next();
		ArrayList<Object> product = (ArrayList<Object>) entry.getValue();

        int productId = Integer.parseInt(product.get(0).toString());
        double price = Double.parseDouble(product.get(2).toString());
		// double pr = Double.parseDouble(product.get(2).toString());
        String productName = product.get(1).toString(); 
		int qty = ( (Integer)product.get(3)).intValue();

        stmt.setInt(1, orderId);
        stmt.setInt(2, productId);
        stmt.setInt(3, qty);
        stmt.setDouble(4, price);
        stmt.executeUpdate();

        double subtotal = qty * price;
        totalAmount += subtotal;
// //display order info - ordered items
// out.println("<h1>Your Order Summary</h1>");
out.println("<tr>");
    out.println("<td>" + productId + "</td>");
    out.println("<td>" + productName + "</td>");
    out.println("<td>" + qty + "</td>");
    out.println("<td>" + NumberFormat.getCurrencyInstance().format(price) + "</td>");
    out.println("<td>" + NumberFormat.getCurrencyInstance().format(subtotal) + "</td>");
    out.println("</tr>");


        
        }
        out.println("</tbody>");
out.println("<tfoot>");
out.println("<tr>");
out.println("<td colspan='4' style='text-align: right;'><b>Total Amount</b></td>");
out.println("<td><b>" + NumberFormat.getCurrencyInstance().format(totalAmount) + "</b></td>");
out.println("</tr>");
out.println("</tfoot>");
out.println("</table>");
    }
}catch(SQLException e){
    e.printStackTrace();
    out.println("products were NOT inserted into orderproduct " + e.getMessage());
    return;
}




// update total amount
try (Connection con = DriverManager.getConnection(url, uid, pw)) {
    String sql = "UPDATE ordersummary SET totalAmount = ? WHERE orderId = ?";
    try(PreparedStatement pstmt = con.prepareStatement(sql)){
        pstmt.setDouble(1, totalAmount);
        pstmt.setInt(2, orderId);
        pstmt.executeUpdate();
    }
}catch(SQLException e){
    e.printStackTrace();
    out.println("total amount was not updated " + e.getMessage());
    return; 
}





// Clear cart if order placed successfully
 try (Connection con = DriverManager.getConnection(url, uid, pw)) {
    session.removeAttribute("productList");
    out.println("<h1>Order completed.  Will be shipped soon...</h1>");
     out.println("<h1>Your order reference number is: " + orderId + "</h1>");
    // out.println("Shopping cart cleared - thanks for your order");

 }catch(SQLException e){
    e.printStackTrace();
    out.println("processing error");

 }

String firstName = "";
String lastName = "";

    try (Connection con = DriverManager.getConnection(url, uid, pw)) {
         String sql = "SELECT firstName, lastName FROM customer WHERE customerId = ?";
         try(PreparedStatement pstmt = con.prepareStatement(sql)){
            pstmt.setString(1, custId);
            try(ResultSet rs = pstmt.executeQuery()){
                if(rs.next()){
                    firstName = rs.getString("firstName");
                    lastName = rs.getString("lastName");
                }else{
                    out.println("database error");
                    return;
                }
            }
         }

    }catch(SQLException e){
        e.printStackTrace();
        out.println("couldn't get customer name" + e.getMessage());
        return; 
    }
    out.println("<h1>Shipping to customer: " + custId + " Name: " + firstName + " " + lastName + "</h1>");




//  out.println("<h1>Shipping to customer: " + custId + " Name: " + firstName + " " + lastName + "</h1>");
//  out.println("<h1>Your order reference number is: " + orderId + "</h1>");

// out.println("<h1>Shipping to customer: " + custId + " Name: " + firstName + " " + lastName + "</h1>");






 

%>
</body>
</html>


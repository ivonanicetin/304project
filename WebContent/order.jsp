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

    //customer ID is num check
    try{
        Integer.parseInt(custId);
    }catch(NumberFormatException e){
        out.println("<h1>Invalid Customer ID </h1>");
        return;
    }

    // Validating customer ID
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
        out.println("Database error occurred while verifying customer ID.");
    }
// customer not valid
    if(isValidCustomer == false){
        out.println("<h1>Invalid customer ID</h1>");
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
        String sql = "INSERT INTO ordersummary (customerId, totalAmount, orderDate) VALUES(?,?, ?)";
        try(PreparedStatement pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)){
        int customerId = Integer.parseInt(custId);
        pstmt.setInt(1, customerId);
        pstmt.setDouble(2, 0.0);
        //get the date / time of order
        java.sql.Timestamp timestamp = new java.sql.Timestamp(System.currentTimeMillis());
        pstmt.setTimestamp(3, timestamp);

        pstmt.executeUpdate();

    try(ResultSet keys = pstmt.getGeneratedKeys()){
	    if(keys.next()){
	        orderId = keys.getInt(1);
            }
        }
    }
}catch(SQLException e){
    e.printStackTrace();
    out.println("failed to create order");
    return;
}

if(orderId == 0){
    out.println("order failed");
    return;
}

// traverse through a HashMap
double totalAmount = 0.0; //setup for total amount calculations 
try (Connection con = DriverManager.getConnection(url, uid, pw)) {
    String sql = "INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (?,?,?,?)";
    try (PreparedStatement stmt = con.prepareStatement(sql)) {
            Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
	        while (iterator.hasNext()){
            Map.Entry<String, ArrayList<Object>> entry = iterator.next();
		    ArrayList<Object> product = (ArrayList<Object>) entry.getValue();

                int productId = Integer.parseInt(product.get(0).toString());
                double price = Double.parseDouble(product.get(2).toString());
                String productName = product.get(1).toString(); 
                int qty = ( (Integer)product.get(3)).intValue();

                    stmt.setInt(1, orderId);
                    stmt.setInt(2, productId);
                    stmt.setInt(3, qty);
                    stmt.setDouble(4, price);
                    stmt.executeUpdate();

                        double subtotal = qty * price; //to show if 1 item is in order multiple times
                        totalAmount += subtotal;       
        }
          
        }
            }catch(SQLException e){
                e.printStackTrace();
                out.println("products were NOT inserted into orderproduct " + e.getMessage());
                return;
            }

            //formatting borrowed from showcart.jsp
            out.println("<h1>Your Order Summary</h1>");
            out.print("<table><tr><th>Product Id</th><th>Product Name</th><th>Quantity</th>");
            out.println("<th>Price</th><th>Subtotal</th></tr>");

            double total = 0; // To track the total order amount
            Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
            while (iterator.hasNext()) {
                Map.Entry<String, ArrayList<Object>> entry = iterator.next();
                ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
                if (product.size() < 4) {
                    out.println("Expected product with four entries. Got: " + product);
                    continue;
                }

                out.print("<tr><td>" + product.get(0) + "</td>");
                out.print("<td>" + product.get(1) + "</td>");

                out.print("<td align=\"center\">" + product.get(3) + "</td>");
                Object price = product.get(2);
                Object itemQty = product.get(3);
                double pr = 0;
                int qty = 0;

                try {
                    pr = Double.parseDouble(price.toString());
                } catch (Exception e) {
                    out.println("Invalid price for product: " + product.get(0) + " price: " + price);
                }

                try {
                    qty = Integer.parseInt(itemQty.toString());
                } catch (Exception e) {
                    out.println("Invalid quantity for product: " + product.get(0) + " quantity: " + qty);
                }

                out.print("<td align=\"right\">" + NumberFormat.getCurrencyInstance().format(pr) + "</td>");
                out.print("<td align=\"right\">" + NumberFormat.getCurrencyInstance().format(pr * qty) + "</td></tr>");
                total += pr * qty;
            }

            out.println("<tr><td colspan=\"4\" align=\"right\"><b>Order Total</b></td>"
                    + "<td align=\"right\">" + NumberFormat.getCurrencyInstance().format(total) + "</td></tr>");
            out.println("</table>");


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
                

            }catch(SQLException e){
                e.printStackTrace();
                out.println("processing error");
            }

        //set-up for customer name display in order summary
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
    //printing out customer name and order number
    out.println("<h1>Shipping to customer: " + custId + " Name: " + firstName + " " + lastName + "</h1>");


%>
</body>
</html>


<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Date" %>
<%@ include file="jdbc.jsp" %>


<html>
<head>
<title>Julia & Ivona Grocery Shipment Processing</title>
</head>
<body>
        
<%@ include file="header.jsp" %>

<%
// TODO: Get order id
	String orderId = request.getParameter("orderId");
if (orderId != null) {
	out.println("<p>Order ID: " + orderId + "</p>");
} else {
	out.println("<p>No Order ID provided.</p>");
}

// TODO: Check if valid order id in database
ArrayList<Map<String, Object>> orderItems = new ArrayList<>();
boolean transactionSuccess = true;
try {
	getConnection(); // Establish database connection
	// TODO: Check if valid order id in database

	
	PreparedStatement psmtValidateOrd = con.prepareStatement("SELECT orderId FROM ordersummary WHERE orderId = ?");
	psmtValidateOrd.setString(1, orderId); // Set the parameter to the provided orderId

	ResultSet rsValidateOrd = psmtValidateOrd.executeQuery();
	
	// Check if a record with the given orderId exists
	if (!rsValidateOrd.next()) {
		out.println("<p>Error: Invalid order ID.</p>");
		rsValidateOrd.close();
		psmtValidateOrd.close();
		return; // Exit if the orderId is invalid
	}
	rsValidateOrd.close();
	psmtValidateOrd.close();

// TODO: Start a transaction (turn-off auto-commit)
	con.setAutoCommit(false);
	

	// TODO: Retrieve all items in order with given id
	PreparedStatement psmtItems = con.prepareStatement("SELECT productId, quantity FROM orderProduct WHERE orderId = ?");
	psmtItems.setString(1, orderId);
	ResultSet rsItems = psmtItems.executeQuery();

	while (rsItems.next()) {
		Map<String, Object> item = new HashMap<>();
		item.put("productId", rsItems.getInt("productId"));
		item.put("quantity", rsItems.getInt("quantity"));
		orderItems.add(item);
	}
	rsItems.close();
	psmtItems.close();

	// TODO: Create a new shipment record.
	String sqlShipRec = "INSERT INTO Shipment(shipmentDate, shipmentDesc, warehouseId) VALUES (GETDATE(), ?,?)";
	PreparedStatement psmtShipRec = con.prepareStatement(sqlShipRec, Statement.RETURN_GENERATED_KEYS);
	psmtShipRec.setString(1, "Shipment for Order #" + orderId);
	psmtShipRec.setInt(2, 1);
	psmtShipRec.executeUpdate();
	ResultSet generatedKeys = psmtShipRec.getGeneratedKeys();
	int shipmentId = 0;
	if (generatedKeys.next()) {
		shipmentId = generatedKeys.getInt(1); // Retrieve the auto-generated shipmentId
	}

	generatedKeys.close();
	psmtShipRec.close();

// TODO: For each item verify sufficient quantity available in warehouse 1
	if(transactionSuccess){
		
	}
// TODO: If any item does not have sufficient inventory, cancel transaction and rollback. Otherwise, update inventory for each item.

// TODO: Auto-commit should be turned back on
	


} catch (SQLException ex) {
	out.println("<p>Error retrieving orders: " + ex.getMessage() + "</p>");
} finally {
	closeConnection(); // Ensure the connection is closed
	transactionSuccess = false;
}




// 






%>                       				

<h2><a href="shop.html">Back to Main Page</a></h2>

</body>
</html>

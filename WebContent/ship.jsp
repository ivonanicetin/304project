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
	
    try {
        getConnection(); // Establish database connection

        // SQL query to check if the orderId exists in the ordersummary table
        String sql = "SELECT orderId FROM ordersummary WHERE orderId = ?";
        PreparedStatement psmt = con.prepareStatement(sql);
        psmt.setString(1, orderId); // Set the parameter to the provided orderId

        ResultSet rs = psmt.executeQuery();
		
        // Check if a record with the given orderId exists
        if (!rs.next()) {
            out.println("<p>Error: Invalid order ID.</p>");
            rs.close();
            psmt.close();
            return; // Exit if the orderId is invalid
        }
		

        rs.close();
        psmt.close();
    } catch (SQLException ex) {
        out.println("<p>Error retrieving orders: " + ex.getMessage() + "</p>");
    } finally {
        closeConnection(); // Ensure the connection is closed
    }

	ArrayList<Map<String, Object>> orderItems = new ArrayList<>();
	boolean transactionSuccess = true;
	try{
		getConnection();
		// TODO: Start a transaction (turn-off auto-commit)
		con.setAutoCommit(false);
		

		// TODO: Retrieve all items in order with given id
		String sql = "SELECT productId, quantity FROM orderProduct WHERE orderId = ?";
		PreparedStatement psmt = con.prepareStatement(sql);
    	psmt.setString(1, orderId);
    	ResultSet rs = psmt.executeQuery();

		while (rs.next()) {
			Map<String, Object> item = new HashMap<>();
			item.put("productId", rs.getInt("productId"));
			item.put("quantity", rs.getInt("quantity"));
			orderItems.add(item);
    	}
		rs.close();
    	psmt.close();

	}catch(SQLException ex){
		out.println("<p>Error : " + ex.getMessage() + "</p>");
	}finally{
		closeConnection();
		transactionSuccess = false;
	}
	
// 
	


	// TODO: Create a new shipment record.
	try{
		getConnection();
		String sql = "INSERT INTO Shipment(shipmentDate, shipmentDesc) VALUES (GETDATE(), ?)";
		PreparedStatement psmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
		psmt.setString(1, "Shipment for Order #" + orderId);
		ResultSet generatedKeys = psmt.getGeneratedKeys();
		int shipmentId = 0;
		if (generatedKeys.next()) {
			shipmentId = generatedKeys.getInt(1); // Retrieve the auto-generated shipmentId
		}

		generatedKeys.close();
		pstm.close();

	}catch(SQLException ex){
		out.println("<p>Error : " + ex.getMessage() + "</p>");
	}finally{
		closeConnection();
	}
	// TODO: For each item verify sufficient quantity available in warehouse 1.
	// TODO: If any item does not have sufficient inventory, cancel transaction and rollback. Otherwise, update inventory for each item.
	
	// TODO: Auto-commit should be turned back on
%>                       				

<h2><a href="shop.html">Back to Main Page</a></h2>

</body>
</html>

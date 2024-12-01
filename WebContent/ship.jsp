<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Date" %>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>Ray's Grocery Shipment Processing</title>
</head>
<body>

<%@ include file="header.jsp" %>

<%
String ordId = request.getParameter("orderId");

try {
    if (ordId == null || ordId.equals("")) {
        out.println("<h1>Invalid order ID.</h1>");
    } else {
        // Get database connection
        getConnection();

        // Validate order ID in ordersummary table
        String validateOrderSql = "SELECT orderId FROM ordersummary WHERE orderId = ?";
        PreparedStatement validateOrderStmt = con.prepareStatement(validateOrderSql);
        validateOrderStmt.setInt(1, Integer.parseInt(ordId));
        ResultSet validateOrderRs = validateOrderStmt.executeQuery();
        if (!validateOrderRs.next()) {
            out.println("<h1>Error: Invalid order ID.</h1>");
            validateOrderRs.close();
            validateOrderStmt.close();
            return;
        }
        validateOrderRs.close();
        validateOrderStmt.close();

        // Retrieve items in the order
        String orderItemsSql = "SELECT productId, quantity FROM orderproduct WHERE orderId = ?";
        PreparedStatement orderItemsStmt = con.prepareStatement(orderItemsSql);
        orderItemsStmt.setInt(1, Integer.parseInt(ordId));
        ResultSet orderItemsRs = orderItemsStmt.executeQuery();

        if (!orderItemsRs.next()) {
            out.println("<h1>Error: No items found in order ID " + ordId + ".</h1>");
            orderItemsRs.close();
            orderItemsStmt.close();
            return;
        }

        ArrayList<Map<String, Object>> orderItems = new ArrayList<>();
        do {
            Map<String, Object> item = new HashMap<>();
            item.put("productId", orderItemsRs.getInt("productId"));
            item.put("quantity", orderItemsRs.getInt("quantity"));
            orderItems.add(item);
        } while (orderItemsRs.next());
        orderItemsRs.close();
        orderItemsStmt.close();

        // Turn off auto-commit
        con.setAutoCommit(false);

        // Insert shipment record
        String insertShipmentSql = "INSERT INTO shipment (shipmentDate, shipmentDesc, warehouseId) VALUES (?, ?, ?)";
        PreparedStatement shipmentStmt = con.prepareStatement(insertShipmentSql, Statement.RETURN_GENERATED_KEYS);
        shipmentStmt.setTimestamp(1, new java.sql.Timestamp(new Date().getTime()));
        shipmentStmt.setString(2, "Shipment for Order #" + ordId);
        shipmentStmt.setInt(3, 1); // Warehouse ID 1
        shipmentStmt.executeUpdate();

        ResultSet generatedKeys = shipmentStmt.getGeneratedKeys();
        int shipmentId = 0;
        if (generatedKeys.next()) {
            shipmentId = generatedKeys.getInt(1);
        }
        generatedKeys.close();
        shipmentStmt.close();

        // Check inventory and update for each item
        boolean success = true;
        for (Map<String, Object> item : orderItems) {
            int productId = (int) item.get("productId");
            int orderedQty = (int) item.get("quantity");

            // Check inventory
            String checkInventorySql = "SELECT quantity FROM productinventory WHERE warehouseId = ? AND productId = ?";
            PreparedStatement checkInventoryStmt = con.prepareStatement(checkInventorySql);
            checkInventoryStmt.setInt(1, 1); // Warehouse ID 1
            checkInventoryStmt.setInt(2, productId);
            ResultSet inventoryRs = checkInventoryStmt.executeQuery();

            if (!inventoryRs.next() || inventoryRs.getInt("quantity") < orderedQty) {
                out.println("<h1>Shipment not done. Insufficient inventory for product ID: " + productId + "</h1>");
                success = false;
                inventoryRs.close();
                checkInventoryStmt.close();
                break;
            }

            int currentQty = inventoryRs.getInt("quantity");
            inventoryRs.close();
            checkInventoryStmt.close();

            // Update inventory
            String updateInventorySql = "UPDATE productinventory SET quantity = quantity - ? WHERE warehouseId = ? AND productId = ?";
            PreparedStatement updateInventoryStmt = con.prepareStatement(updateInventorySql);
            updateInventoryStmt.setInt(1, orderedQty);
            updateInventoryStmt.setInt(2, 1); // Warehouse ID 1
            updateInventoryStmt.setInt(3, productId);
            updateInventoryStmt.executeUpdate();
            updateInventoryStmt.close();

            out.println("<h2>Ordered product: " + productId + ", Qty: " + orderedQty +
                        ", Previous Inventory: " + currentQty + ", New Inventory: " + (currentQty - orderedQty) + "</h2><br>");
        }

        // Commit or rollback transaction
        if (success) {
            con.commit();
            out.println("<h1>Shipment successfully processed for Order ID: " + ordId + "</h1>");
        } else {
            con.rollback();
            out.println("<h1>Transaction rolled back due to insufficient inventory.</h1>");
        }

        // Turn auto-commit back on
        con.setAutoCommit(true);
    }
} catch (SQLException ex) {
    out.println("<h1>Error: " + ex.getMessage() + "</h1>");
    try {
        if (con != null) {
            con.rollback();
        }
    } catch (SQLException rollbackEx) {
        out.println("<h1>Rollback Error: " + rollbackEx.getMessage() + "</h1>");
    }
} finally {
    try {
        if (con != null) {
            con.close();
        }
    } catch (SQLException closeEx) {
        out.println("<h1>Close Error: " + closeEx.getMessage() + "</h1>");
    }
}
%>

<h2><a href="shop.html">Back to Main Page</a></h2>

</body>
</html>

<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<html>
<head>
    <title>Ray's Grocery - Product Information</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <style>
        /* CSS for resizing product images */
        img.product-image {
            width: 200px; 
            height: auto; 
            object-fit: contain; 
		}
 /*table spacing*/
			 table.table th:first-child, table.table td:first-child {
        width: 125px; /* Adjust the width */
        white-space: nowrap; /* Prevent text wrapping */
        }
    </style>
</head>
<body>

<%@ include file="header.jsp" %>

<%
    // Get productId parameter
    String productId = request.getParameter("id");

    String sql = "SELECT productId, productName, productPrice, productImageURL, productImage FROM Product WHERE productId = ?";

    NumberFormat currFormat = NumberFormat.getCurrencyInstance();

    try {
        getConnection();
        Statement stmt = con.createStatement();             
        stmt.execute("USE orders");
        
        PreparedStatement pstmt = con.prepareStatement(sql);
        pstmt.setInt(1, Integer.parseInt(productId));            
            
        ResultSet rst = pstmt.executeQuery();
                
        if (!rst.next()) {
            out.println("<h3>Invalid product</h3>");
        } else {        
            int prodId = rst.getInt("productId");
            String productName = rst.getString("productName");
            double productPrice = rst.getDouble("productPrice");
            String productImageURL = rst.getString("productImageURL");
            byte[] productImageBinary = rst.getBytes("productImage");
            
            out.println("<table class=\"table\">");
            out.println("<tr><th>Product ID</th><td>" + prodId + "</td></tr>");
            out.println("<tr><th>Product Name</th><td>" + productName + "</td></tr>");
            out.println("<tr><th>Price</th><td>" + currFormat.format(productPrice) + "</td></tr>");
            
            // Show image from URL
            if (productImageURL != null && !productImageURL.isEmpty()) {
                out.println("<tr><th>Image</th><td><img src='" + productImageURL + "' class='product-image' alt='Product Image'></td></tr>");
            }
            
            // Show image stored in database (if exists)
            if (productImageBinary != null) {
                out.println("<tr><th>Image</th><td><img src='displayImage.jsp?id=" + prodId + "' class='product-image' alt='Product Image'></td></tr>");
            }

            out.println("</table>");
            
            out.println("<h3><a href=\"addcart.jsp?id=" + prodId + "&name=" + productName
                    + "&price=" + productPrice + "\">Add to Cart</a></h3>");
            out.println("<h3><a href=\"listprod.jsp\">Continue Shopping</a></h3>");
        }
    } catch (SQLException ex) {
        out.println("<h3>Error: " + ex.getMessage() + "</h3>");
    } finally {
        closeConnection();
    }
%>

</body>
</html>

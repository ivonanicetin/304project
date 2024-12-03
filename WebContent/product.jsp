<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<html>
<head>
    <title>Julia and Ivona's Grocery - Product Information</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <style>
        /* CSS for resizing product images */
        img.product-image {
            width: 200px; 
            height: auto; 
            object-fit: contain; 
        }
        /* Table spacing */
        table.table th:first-child, table.table td:first-child {
            width: 125px;
            white-space: nowrap;
        }
    </style>
</head>
<body>
<title>Review Form</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <style>
        form {
            max-width: 600px; /* Set a maximum width for the form */
            margin: 0 auto; /* Center the form horizontally */
            padding: 20px; /* Add some padding inside the form */
            border: 1px solid #ccc; /* Add a border to the form */
            border-radius: 10px; /* Round the corners of the form */
            background-color: #f9f9f9; /* Set a background color for the form */
        }
        form button {
            background-color: #8B0000 !important;
            color: white;
            border: 0px solid #8B0000;
        }
                
    </style>

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
%>
            <h3>Invalid product</h3>
<%
        } else {        
            int prodId = rst.getInt("productId");
            String productName = rst.getString("productName");
            double productPrice = rst.getDouble("productPrice");
            String productImageURL = rst.getString("productImageURL");
            byte[] productImageBinary = rst.getBytes("productImage");
%>
            <table class="table">
                <tr><th>Product ID</th><td><%= prodId %></td></tr>
                <tr><th>Product Name</th><td><%= productName %></td></tr>
                <tr><th>Price</th><td><%= currFormat.format(productPrice) %></td></tr>
                <% if (productImageURL != null && !productImageURL.isEmpty()) { %>
                    <tr><th>Image</th>
                        <td><img src="<%= productImageURL %>" class="product-image" alt="Product Image"></td>
                    </tr>
                <% } %>
                <% if (productImageBinary != null) { %>
                    <tr><th>Image</th>
                        <td><img src="displayImage.jsp?id=<%= prodId %>" class="product-image" alt="Product Image"></td>
                    </tr>
                <% } %>
            </table>

            <h3><a href="addcart.jsp?id=<%= prodId %>&name=<%= productName %>&price=<%= productPrice %>">Add to Cart</a></h3>
            <h3><a href="listprod.jsp">Continue Shopping</a></h3>

            <!--line seperating-->
            <hr style="border: 2px solid #8B0000; margin-top: 20px; margin-bottom: 20px;">


            <!-- Add Review Form -->
            <h3>Leave a Review</h3>
            <form action="submitReview.jsp" method="post">
                <input type="hidden" name="productId" value="<%= productId %>">
                <div class="form-group">
                    <label for="customerId">Customer ID:</label>
                    <input type="number" name="customerId" id="customerId" class="form-control" required>
                </div>
                <div class="form-group">
                    <label for="rating">Rating (1-5):</label>
                    <input type="number" name="rating" id="rating" class="form-control" min="1" max="5" required>
                </div>
                <div class="form-group">
                    <label for="review">Comment:</label>
                    <textarea name="review" id="review" class="form-control" rows="4" required></textarea>
                </div>
                <button type="submit" class="btn btn-primary">Submit Review</button>
            </form>
<%
        }
    } catch (SQLException ex) {
%>
        <h3>Error: <%= ex.getMessage() %></h3>
<%
    } finally {
        closeConnection();
    }
%>

</body>
</html>

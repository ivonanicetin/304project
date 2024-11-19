 <%-- <%@ page import="java.sql.*,java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="header.jsp" %>
<%@ page import="java.net.URLEncoder" %>


<html>
<head>
    <title>Julia & Ivona Grocery - Product Information</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<%
    try {
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
    } catch (ClassNotFoundException e) {
        out.println("<p>Error: Unable to load database driver.</p>");
        return;
    }

    String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
    String uid = "sa";
    String pw = "304#sa#pw";

    String productId = request.getParameter("id");

    if (productId != null && !productId.isEmpty()) {
        String sql = "SELECT * FROM product WHERE ProductId = ?";

        try (Connection con = DriverManager.getConnection(url, uid, pw);
             PreparedStatement stmt = con.prepareStatement(sql)) {

            stmt.setString(1, productId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    // Retrieve variables from ResultSet
                    String id = rs.getString("ProductId");
                    String prodName = rs.getString("ProductName");
                    double price = rs.getDouble("ProductPrice");
                    String productImageURL = rs.getString("ProductImageURL");

%>
<div class="container mt-4">
    <h1>Product Details</h1>
    <table class="table">
        <tbody>
            <tr>
                <th>Product ID</th>
                <td><%= id %></td>
            </tr>
            <tr>
                <th>Product Name</th>
                <td><%= prodName %></td>
            </tr>
            <tr>
                <th>Price</th>
                <td><%= NumberFormat.getCurrencyInstance().format(price) %></td>
            </tr>
            <tr>
                <th>Image</th>
                <td>
                    <% if (productImageURL != null && !productImageURL.isEmpty()) { %>
                        <img src="<%= productImageURL %>" alt="Product Image" class="img-thumbnail" style="max-width: 200px;">
                    <% } else { %>
                        <p>No image available</p>
                    <% } %>
                </td>
            </tr>
        </tbody>
    </table>
  <a href="addcart.jsp?id=<%= URLEncoder.encode(String.valueOf(id), "UTF-8") %>&name=<%= URLEncoder.encode(productName, "UTF-8") %>&price=<%= URLEncoder.encode(String.valueOf(price), "UTF-8") %>" 
   class="btn btn-primary">Add to Cart</a>


        <!-- Continue Shopping Link -->
        <a href="listprod.jsp" class="btn btn-secondary">Continue Shopping</a>
    </div>
</div>
<%
                } else {
                    out.println("<p>Product not found.</p>");
                }
            }
        } catch (SQLException e) {
            out.println("<p>Error accessing database: " + e.getMessage() + "</p>");
        }
    } else {
        out.println("<p>Error: No product ID provided.</p>");
    }
   
%>

</body>
</html> --%>

<%@ page import="java.sql.*,java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="header.jsp" %>
<%@ page import="java.net.URLEncoder" %>

<html>
<head>
    <title>Julia & Ivona Grocery - Product Information</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<%
    try {
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
    } catch (ClassNotFoundException e) {
        out.println("<p>Error: Unable to load database driver.</p>");
        return;
    }

    String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
    String uid = "sa";
    String pw = "304#sa#pw";

    String productId = request.getParameter("id");

    if (productId != null && !productId.isEmpty()) {
        String sql = "SELECT * FROM product WHERE ProductId = ?";

        try (Connection con = DriverManager.getConnection(url, uid, pw);
             PreparedStatement stmt = con.prepareStatement(sql)) {

            stmt.setString(1, productId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    // Retrieve variables from ResultSet
                    String id = rs.getString("ProductId");
                    String prodName = rs.getString("ProductName");
                    double price = rs.getDouble("ProductPrice");
                    String productImageURL = rs.getString("ProductImageURL");

%>
<div class="container mt-4">
    <h1>Product Details</h1>
    <table class="table">
        <tbody>
            <tr>
                <th>Product ID</th>
                <td><%= id %></td>
            </tr>
            <tr>
                <th>Product Name</th>
                <td><%= prodName %></td>
            </tr>
            <tr>
                <th>Price</th>
                <td><%= NumberFormat.getCurrencyInstance().format(price) %></td>
            </tr>
            <tr>
                <th>Image</th>
                <td>
                    <% if (productImageURL != null && !productImageURL.isEmpty()) { %>
                         <%-- Render primary image from URL if available --%>
        <img src="img/<%= productId %>.jpg" style="max-width: 200px;" alt="Product Image">
        
        <%-- Render secondary image from binary data --%>
        <img src="displayImage.jsp?id=<%= productId %>" style="max-width: 200px;" alt="Binary Product Image" onerror="this.style.display='none';">

                    <% } else { %>
                        <p> no image</p>
                    <% } %>
                </td>
            </tr>
        </tbody>
    </table>
    <div style="margin-top: 20px;">
        <!-- Add to Cart Link -->
        <a href="addcart.jsp?id=<%= id %>&name=<%= prodName %>&price=<%= price %>">Add to Cart</a>

        <!-- Continue Shopping Link -->
        <a href="listprod.jsp">|| Continue Shopping</a>
    </div>
</div>
<%
                // } else {
                //     out.println("<p>Product not found.</p>");
                // }
            }
            }
        } catch (SQLException e) {
            out.println("<p>Error accessing database: " + e.getMessage() + "</p>");
        }
    }
    // } else {
    //     out.println("<p>Error: No product ID provided.</p>");
    // }
%>

</body>
</html>


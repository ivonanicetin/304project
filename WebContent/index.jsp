<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>


<!DOCTYPE html>
<html>
<head>
    <%@ include file="header.jsp" %> <!-- Includes header logic -->
    <title>JV's Shoe Store Main Page</title>
    <style>
        /* General body styling */
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
           
        }

        /* Banner styling */
        .banner {
            position: relative; /* To enable positioning of overlay text */
            background: url('img/banner.jpg') no-repeat center center;
            background-size: cover;
            height: 800px;
        }
        

        /* Text overlay styling */
        .banner-text {
            position: absolute;
            top: 50%; /* Center vertically */
            right: 12%; /* Position on the right */
            transform: translateY(-50%);
            color: #8B0000;
            font-size: 60px;
            font-weight: bold;
            line-height: 1.2; /* Adjusts spacing between lines */
        }

        /* Content section styling */
        .content {
            text-align: center;
            padding: 20px;
        }

        .content h2 a {
            color: #008080;
            text-decoration: none;
        }

        .content h2 a:hover {
            text-decoration: underline;
        }
        /* Top Products Section */

        .top-products {
            margin: 20px;
            text-align: center;
        }

        /* Styling for the "Best Sellers" heading */
        .top-products h2 {
            font-size: 24px;
            margin-bottom: 20px;
            position: relative;
        }

        /*add a line under the "Best Sellers" title */
        .top-products h2::after {
            content: "";
            display: block;
            width: 100%;
            height: 4px; /* Thickness of the line */
            background-color: #8B0000; /* Color of the line */
            position: absolute;
            bottom: -10px; /* Adjusts the position of the line */
            left: 0;
        }

        .product-container {
            display: flex;
            justify-content: center;
            flex-wrap: wrap;
            gap: 20px; /* Space between product cards */
        }

        .product-card {
            display: flex;
            flex-direction: column;
            align-items: center;
            border: none;
            text-align: center;
            width: 200px;
            background-color: #f9f9f9;
            border-radius: 8px;
            padding: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        /* Image styling */
        .product-card img {
            width: 100%; /* Makes the image fill the width of the card */
            max-height: 200px; /* Adjust this value to set a max height */
            object-fit: cover; /* Ensures the image covers the area */
            border-radius: 8px;
            margin-bottom: 15px;
        }
        /* Image zoom effect */
        .product-card:hover img {
            transform: scale(1.1);  /* Slight zoom-in effect on image */
        }

        .product-card h3 {
            font-size: 18px;
            margin-bottom: 10px;
        }

        .product-card p {
            font-size: 14px;
            color: #555;
        }

        /* Optional hover effect on product cards */
        .product-card:hover {
            box-shadow: 0 6px 12px rgba(0, 0, 0, 0.2);
            transform: translateY(-5px);
            transition: all 0.3s ease-in-out;
        }
    </style>
</head>
<body>
    <!-- Banner Section -->
    <div class="banner">
        <div class="banner-text">
            JV's Shoe Store
        </div>
    </div>

    <!-- Content Section -->
    <%-- <div class="content">
        <!-- Optionally display user information -->
        <% 
            if (session.getAttribute("authenticatedUser") != null) {
                out.println("<h3>Welcome to Julia & Ivona's Shoe Store!</h3>");
            } else {
                out.println("<h3>Please log in to access all features.</h3>");
            }
        %>
    </div> --%>

    <div class="top-products">
        <h2>Best Sellers</h2>
        <div class="product-container">

        <%
        try {
            // Query to get the top 6 products
            getConnection();
            String sql ="SELECT TOP 5 p.productId, p.productName, p.productPrice, p.productImageURL, SUM(op.quantity) AS totalSales " +
                "FROM orderproduct op " +
                "JOIN product p ON p.productId = op.productId " +
                "GROUP BY p.productId, p.productName, p.productPrice, p.productImageURL "+
                "ORDER BY totalSales DESC";

            Statement stmt = con.createStatement();
            ResultSet rst = stmt.executeQuery(sql);

            while (rst.next()) {
              String productName = rst.getString("productName");
              String productId = rst.getString("productId");
                        double productPrice = rst.getDouble("productPrice");
                        String productImageURL = rst.getString("productImageURL");
                // Display each product as a card
        %>
       
        <div class="product-card">
            <a href="product.jsp?id=<%= productId %>"> <!-- Make the entire card clickable -->
                <img src="<%= productImageURL %>" alt="<%= productName %>">
                <h3><%= productName %></h3>
                <p><%= NumberFormat.getCurrencyInstance().format(productPrice) %></p>
            </a>
        </div>
        
         <%
            }
            closeConnection();
        } catch (SQLException ex) {
            out.println("<p>Error loading top products: " + ex.getMessage() + "</p>");
        }
        %>
    </div>
</div>
        

</body>
</html>

<!DOCTYPE html>
<html>
<head>
    <title>Julia & Ivona's Shoe Store</title>
    <style>
        /* General body styling */
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
        }

        /* Header styling */
        .header {
            background-color: #8B0000; /* Deep red color */
            color: white;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 10px 20px;
        }

        .header .logo {
            font-size: 24px;
            font-weight: bold;
        }

        .header nav {
            display: flex;
            gap: 15px;
        }

        .header nav a {
            color: white;
            text-decoration: none;
            font-size: 18px;
            padding: 5px 10px;
            border-radius: 5px;
        }

        .header nav a:hover {
            background-color: #B74E4E; /* Slightly lighter red for hover */
        }
    </style>
</head>
<body>
    <!-- Header Section -->
    <div class="header">
        <div class="logo">Julia & Ivona's Shoe Store</div>
        <nav>
            <a href="index.jsp">Home</a>
            <a href="listprod.jsp">Begin Shopping</a>
            <a href="listorder.jsp">Orders</a>
            <a href="customer.jsp">Account</a>
            <a href="addcart.jsp">Cart</a>
            <a href="admin.jsp">Admin</a>
            <%
                String userName = (String) session.getAttribute("authenticatedUser");
                if (userName != null) {
            %>
                <a href="logout.jsp">Logged in as: <%= userName %></a>
            <%
                } else {
            %>
                <a href="login.jsp">Login</a>
            <%
                }
            %>
        </nav>
    </div>
</body>
</html>

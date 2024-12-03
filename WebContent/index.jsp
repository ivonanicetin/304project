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
</body>
</html>

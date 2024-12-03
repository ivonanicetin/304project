<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="jdbc.jsp" %>

<%
    // Retrieve parameters from the submitted form
    String rating = request.getParameter("rating");
    String customerId = request.getParameter("customerId");
    String productId = request.getParameter("productId");
    String reviewComment = request.getParameter("review");


    try {
        
         // Establish connection
        getConnection();
        Statement stmt = con.createStatement();
        stmt.execute("USE orders");

        // Step 1: Check if the customerId exists in the database
        String checkCustomerSql = "SELECT customerId FROM customer WHERE customerId = ?";
        PreparedStatement pstmt1 = con.prepareStatement(checkCustomerSql);
        pstmt1.setInt(1, Integer.parseInt(customerId));
        ResultSet rst1 = pstmt1.executeQuery();

        if (!rst1.next()) {
            out.println("<h3>Customer ID does not exist, please try again.</h3>");
        } else {

            // SQL query to insert review
            String sql = "INSERT INTO review (reviewRating, reviewDate, customerId, productId, reviewComment) VALUES (?, ?, ?, ?, ?)";

            PreparedStatement pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, Integer.parseInt(rating)); // Rating from form
            pstmt.setTimestamp(2, Timestamp.valueOf(java.time.LocalDateTime.now())); // Current date and time
            pstmt.setInt(3, Integer.parseInt(customerId)); // Customer ID from form
            pstmt.setInt(4, Integer.parseInt(productId)); // Product ID from form
            pstmt.setString(5, reviewComment); // Review comment from form

            int rowsAffected = pstmt.executeUpdate();

            if (rowsAffected > 0) {
                out.println("<h3>Review submitted successfully!</h3>");
            } else {
                out.println("<h3>Failed to submit review.</h3>");
            }
        }

    } catch (Exception e) {
        out.println("<h3>Error: " + e.getMessage() + "</h3>");
    } finally {
        closeConnection();
    }
%>

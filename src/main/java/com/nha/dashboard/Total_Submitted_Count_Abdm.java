/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.nha.dashboard;

import db.dbcon;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.json.JSONArray;
import org.json.JSONObject;

/**
 *
 * @author vikram
 */
public class Total_Submitted_Count_Abdm extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("LogUsername") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"error\":\"User is not logged in or session has expired.\"}");
            return;
        }

        String usernameFromSession = (String) session.getAttribute("LogUsername");
        System.out.println("Username from session: " + usernameFromSession);

        dbcon db = new dbcon();
        db.getCon("nha_cdr");

        try (PrintWriter out = response.getWriter()) {
            // Get user type
            String userType = "";
            String sqlCheckUserType = "SELECT user_type FROM users WHERE username = '" + usernameFromSession + "'";
            Statement stmt = db.getStmt();
            ResultSet rsUserType = stmt.executeQuery(sqlCheckUserType);

            if (rsUserType.next()) {
                userType = rsUserType.getString("user_type");
                System.out.println("User Type: " + userType);
            }
            rsUserType.close();

            // Fetch submission counts
            JSONArray jsonArray = new JSONArray();
            long totalSum = 0, successSum = 0, failedSum = 0, pendingSum = 0;

            String sql = "SELECT \n"
                    + "    t1.date, \n"
                    + "    t1.Total, \n"
                    + "    t1.Success, \n"
                    + "    t1.Failed \n"
                    + "FROM \n"
                    + "    User_Counts_Api_production t1\n"
                    + "JOIN \n"
                    + "    AccountDetails ad \n"
                    + "WHERE \n"
                    + "    ad.department = '" + userType + "';";

            System.out.println("sql pie chart :" + sql);
            ResultSet rs = db.getResult(sql);
            while (rs != null && rs.next()) {
                // Get the values from the database and ensure they are not negative
                long total = rs.getObject("Total") != null ? Math.max(rs.getLong("Total"), 0) : 0;
                long success = rs.getObject("Success") != null ? Math.max(rs.getLong("Success"), 0) : 0;
                long failed = rs.getObject("Failed") != null ? Math.max(rs.getLong("Failed"), 0) : 0;
                long pending = total - (success + failed);

                // Ensure pending is non-negative
                pending = Math.max(pending, 0);

                // Add to total counts
                totalSum += total;
                successSum += success;
                failedSum += failed;
                pendingSum += pending;

                // Create a JSON object for each row
                JSONObject jsonObject = new JSONObject();
                jsonObject.put("Total", total);
                jsonObject.put("Success", success);
                jsonObject.put("Failed", failed);
                jsonObject.put("Pending", pending);

                jsonArray.put(jsonObject);
            }

            stmt.close();
            db.closeConection();

            // Create a JSON object for totals
            JSONObject totalCounts = new JSONObject();
            totalCounts.put("TotalSum", totalSum);
            totalCounts.put("SuccessSum", successSum);
            totalCounts.put("FailedSum", failedSum);
            totalCounts.put("PendingSum", pendingSum);

            // Create final JSON response
            JSONObject jsonResponse = new JSONObject();
            jsonResponse.put("data", jsonArray);
            jsonResponse.put("totals", totalCounts);
            System.out.println("totalCounts :" + totalCounts);
            out.print(totalCounts);

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error occurred.");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet for retrieving total submitted count from the database.";
    }
}

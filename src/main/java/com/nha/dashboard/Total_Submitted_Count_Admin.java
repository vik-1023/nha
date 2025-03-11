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
public class Total_Submitted_Count_Admin extends HttpServlet {

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

            // Add separate total sums for each department
            long totalSumABDM = 0, successSumABDM = 0, failedSumABDM = 0, pendingSumABDM = 0;
            long totalSumPMJAY = 0, successSumPMJAY = 0, failedSumPMJAY = 0, pendingSumPMJAY = 0;

            JSONArray jsonArrayABDM = new JSONArray();
            JSONArray jsonArrayPMJAY = new JSONArray();

            // Execute SQL query for 'ABDM' department
            if ("admin".equals(userType) || "ABDM".equals(userType) || "PMJAY".equals(userType)) {
                String sqlABDM = "SELECT SUM(DISTINCT COALESCE(t1.Total, 0)) AS Total,SUM(DISTINCT COALESCE(t1.Success, 0)) AS Success ,SUM(t1.Failed) AS Failed    FROM sgc_billing t1 JOIN AccountDetails ad  ON ad.accountname = t1.Username where ad.department = 'ABDM';";

                ResultSet rsABDM = db.getResult(sqlABDM);
                while (rsABDM != null && rsABDM.next()) {
                    long total = rsABDM.getObject("Total") != null ? Math.max(rsABDM.getLong("Total"), 0) : 0;
                    long success = rsABDM.getObject("Success") != null ? Math.max(rsABDM.getLong("Success"), 0) : 0;
                    long failed = rsABDM.getObject("Failed") != null ? Math.max(rsABDM.getLong("Failed"), 0) : 0;
                    long pending = total - (success + failed);
                    pending = Math.max(pending, 0);

                    totalSumABDM += total;
                    successSumABDM += success;
                    failedSumABDM += failed;
                    pendingSumABDM += pending;

                    JSONObject jsonObject = new JSONObject();
                    jsonObject.put("Total", total);
                    jsonObject.put("Success", success);
                    jsonObject.put("Failed", failed);
                    jsonObject.put("Pending", pending);

                    jsonArrayABDM.put(jsonObject);
                }

                // Execute SQL query for 'PMJAY' department
                String sqlPMJAY = "SELECT SUM(DISTINCT COALESCE(t1.Total, 0)) AS Total,SUM(DISTINCT COALESCE(t1.Success, 0)) AS Success ,SUM(t1.Failed) AS Failed    FROM sgc_billing t1 JOIN AccountDetails ad  ON ad.accountname = t1.Username where ad.department = 'PMJAY';";

                ResultSet rsPMJAY = db.getResult(sqlPMJAY);
                while (rsPMJAY != null && rsPMJAY.next()) {
                    long total = rsPMJAY.getObject("Total") != null ? Math.max(rsPMJAY.getLong("Total"), 0) : 0;
                    long success = rsPMJAY.getObject("Success") != null ? Math.max(rsPMJAY.getLong("Success"), 0) : 0;
                    long failed = rsPMJAY.getObject("Failed") != null ? Math.max(rsPMJAY.getLong("Failed"), 0) : 0;
                    long pending = total - (success + failed);
                    pending = Math.max(pending, 0);

                    totalSumPMJAY += total;
                    successSumPMJAY += success;
                    failedSumPMJAY += failed;
                    pendingSumPMJAY += pending;

                    JSONObject jsonObject = new JSONObject();
                    jsonObject.put("Total", total);
                    jsonObject.put("Success", success);
                    jsonObject.put("Failed", failed);
                    jsonObject.put("Pending", pending);

                    jsonArrayPMJAY.put(jsonObject);
                }
            }

            stmt.close();
            db.closeConection();

            // Combine the total counts from both departments
            long totalSumBoth = totalSumABDM + totalSumPMJAY;
            long successSumBoth = successSumABDM + successSumPMJAY;
            long failedSumBoth = failedSumABDM + failedSumPMJAY;
            long pendingSumBoth = pendingSumABDM + pendingSumPMJAY;

            // Create JSON objects for totals
            JSONObject totalCountsABDM = new JSONObject();
            totalCountsABDM.put("TotalSum", totalSumABDM);
            totalCountsABDM.put("SuccessSum", successSumABDM);
            totalCountsABDM.put("FailedSum", failedSumABDM);
            totalCountsABDM.put("PendingSum", pendingSumABDM);

            JSONObject totalCountsPMJAY = new JSONObject();
            totalCountsPMJAY.put("TotalSum", totalSumPMJAY);
            totalCountsPMJAY.put("SuccessSum", successSumPMJAY);
            totalCountsPMJAY.put("FailedSum", failedSumPMJAY);
            totalCountsPMJAY.put("PendingSum", pendingSumPMJAY);

            JSONObject totalCountsBoth = new JSONObject();
            totalCountsBoth.put("TotalSum", totalSumBoth);
            totalCountsBoth.put("SuccessSum", successSumBoth);
            totalCountsBoth.put("FailedSum", failedSumBoth);
            totalCountsBoth.put("PendingSum", pendingSumBoth);

            // Create the final JSON response
            // Create the final JSON response
            JSONObject jsonResponse = new JSONObject();
            jsonResponse.put("ABDM", jsonArrayABDM);
            jsonResponse.put("PMJAY", jsonArrayPMJAY);
            jsonResponse.put("totalsABDM", totalCountsABDM);
            jsonResponse.put("totalsPMJAY", totalCountsPMJAY);
            jsonResponse.put("totalsBoth", totalCountsBoth);
            jsonResponse.put("userType", userType); // Add userType here

            // Output the final response
            System.out.println("User Type: " + userType);
            System.out.println("totalCounts ABDM: " + totalCountsABDM);
            System.out.println("totalCounts PMJAY: " + totalCountsPMJAY);
            System.out.println("totalCounts Both: " + totalCountsBoth);

            out.print(jsonResponse);  // Send response to the client

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

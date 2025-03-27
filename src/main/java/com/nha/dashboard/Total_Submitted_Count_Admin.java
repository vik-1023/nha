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
            // Get user type using direct SQL query with Statement
            String userType = getUserType(db, usernameFromSession);
            if (userType == null) {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("{\"error\":\"User type not found.\"}");
                return;
            }

            // Initialize sums for both departments
            long totalSumABDM = 0, successSumABDM = 0, failedSumABDM = 0, pendingSumABDM = 0;
            long totalSumPMJAY = 0, successSumPMJAY = 0, failedSumPMJAY = 0, pendingSumPMJAY = 0;

            JSONArray jsonArrayABDM = new JSONArray();
            JSONArray jsonArrayPMJAY = new JSONArray();

            if ("admin".equals(userType) || "ABDM".equals(userType) || "PMJAY".equals(userType)) {

                // Get data for 'ABDM' department
                String sqlABDM = "SELECT       COALESCE(SUM(DISTINCT t1.Total), 0) + COALESCE(SUM(DISTINCT t2.Total), 0) AS Total_Sum,       COALESCE(SUM(DISTINCT t1.Success), 0) + COALESCE(SUM(DISTINCT t2.Success), 0) AS Success_Sum,       COALESCE(SUM(DISTINCT t1.Failed), 0) + COALESCE(SUM(DISTINCT t2.Failed), 0) AS Failed_Sum   FROM User_Counts_Api_production t1   LEFT\n"
                        + "JOIN User_Counts_Api t2 ON t1.Username = t2.Username       AND t2.last_updated = (SELECT MAX(last_updated) FROM User_Counts_Api WHERE date = CURRENT_DATE)       AND t2.date = CURRENT_DATE   LEFT JOIN AccountDetails ad ON ad.accountname = t1.Username   WHERE ad.department = 'ABDM'   AND t1.last_updated = (SELECT MAX(last_updated) FROM User_Counts_Api_production WHERE date = CURRENT_DATE)   AND t1.date = CURRENT_DATE;";

                ResultSet rsABDM = db.getResult(sqlABDM);
                while (rsABDM != null && rsABDM.next()) {
                    long total = Math.max(rsABDM.getLong("Total_Sum"), 0);
                    long success = Math.max(rsABDM.getLong("Success_Sum"), 0);
                    long failed = Math.max(rsABDM.getLong("Failed_Sum"), 0);
                    long pending = Math.max(total - (success + failed), 0);

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

                // Get data for 'PMJAY' department
                String sqlPMJAY = "SELECT  COALESCE(SUM(DISTINCT t1.Total), 0) + COALESCE(SUM(DISTINCT t2.Total), 0) AS Total_Sum,       COALESCE(SUM(DISTINCT t1.Success), 0) + COALESCE(SUM(DISTINCT t2.Success), 0) AS Success_Sum,       COALESCE(SUM(DISTINCT t1.Failed), 0) + COALESCE(SUM(DISTINCT t2.Failed), 0) AS Failed_Sum   FROM User_Counts_Api_production t1   LEFT\n"
                        + "JOIN User_Counts_Api t2 ON t1.Username = t2.Username       AND t2.last_updated = (SELECT MAX(last_updated) FROM User_Counts_Api WHERE date = CURRENT_DATE)       AND t2.date = CURRENT_DATE   LEFT JOIN AccountDetails ad ON ad.accountname = t1.Username   WHERE ad.department = 'pmjay'   AND t1.last_updated = (SELECT MAX(last_updated) FROM User_Counts_Api_production WHERE date = CURRENT_DATE)   AND t1.date = CURRENT_DATE;";

                ResultSet rsPMJAY = db.getResult(sqlPMJAY);
                while (rsPMJAY != null && rsPMJAY.next()) {
                    long total = Math.max(rsPMJAY.getLong("Total_Sum"), 0);
                    long success = Math.max(rsPMJAY.getLong("Success_Sum"), 0);
                    long failed = Math.max(rsPMJAY.getLong("Failed_Sum"), 0);
                    long pending = Math.max(total - (success + failed), 0);

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

            db.closeConection();

            // Combine totals
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

            // Prepare the final response JSON
            JSONObject jsonResponse = new JSONObject();
            jsonResponse.put("ABDM", jsonArrayABDM);
            jsonResponse.put("PMJAY", jsonArrayPMJAY);
            jsonResponse.put("totalsABDM", totalCountsABDM);
            jsonResponse.put("totalsPMJAY", totalCountsPMJAY);
            jsonResponse.put("totalsBoth", totalCountsBoth);
            jsonResponse.put("userType", userType);

            out.print(jsonResponse);  // Send response to the client

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error occurred.");
        }
    }

    private String getUserType(dbcon db, String username) throws SQLException {
        String userType = null;
        String sqlCheckUserType = "SELECT user_type FROM users WHERE username = '" + username + "'"; // Concatenating username directly
        Statement stmt = db.getStmt();
        ResultSet rsUserType = stmt.executeQuery(sqlCheckUserType);
        if (rsUserType.next()) {
            userType = rsUserType.getString("user_type");
        }
        rsUserType.close();
        return userType;
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

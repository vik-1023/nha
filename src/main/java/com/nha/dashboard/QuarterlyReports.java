/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.nha.dashboard;

import com.google.gson.Gson;
import db.dbcon;
import java.io.IOException;
import java.sql.ResultSet;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


public class QuarterlyReports extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        dbcon db = new dbcon();
        response.setContentType("application/json;charset=UTF-8");

        // Get parameters from the request
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String groupBy = request.getParameter("groupBy");  // "none", "date", or "username"

        // If startDate and endDate are not provided, set default dates (current quarter)
        if (startDate == null || endDate == null) {
            Calendar calendar = Calendar.getInstance();
            int currentMonth = calendar.get(Calendar.MONTH) + 1;

            // Default to current financial quarter
            if (currentMonth >= 4 && currentMonth <= 6) {
                // Financial Year Q1 (April - June)
                calendar.set(Calendar.MONTH, Calendar.APRIL);
                calendar.set(Calendar.DAY_OF_MONTH, 1);
                startDate = new SimpleDateFormat("yyyy-MM-dd").format(calendar.getTime());

                calendar.set(Calendar.MONTH, Calendar.JUNE);
                calendar.set(Calendar.DAY_OF_MONTH, 30);
                endDate = new SimpleDateFormat("yyyy-MM-dd").format(calendar.getTime());
            } else if (currentMonth >= 7 && currentMonth <= 9) {
                // Financial Year Q2 (July - September)
                calendar.set(Calendar.MONTH, Calendar.JULY);
                calendar.set(Calendar.DAY_OF_MONTH, 1);
                startDate = new SimpleDateFormat("yyyy-MM-dd").format(calendar.getTime());

                calendar.set(Calendar.MONTH, Calendar.SEPTEMBER);
                calendar.set(Calendar.DAY_OF_MONTH, 30);
                endDate = new SimpleDateFormat("yyyy-MM-dd").format(calendar.getTime());
            } else if (currentMonth >= 10 && currentMonth <= 12) {
                // Financial Year Q3 (October - December)
                calendar.set(Calendar.MONTH, Calendar.OCTOBER);
                calendar.set(Calendar.DAY_OF_MONTH, 1);
                startDate = new SimpleDateFormat("yyyy-MM-dd").format(calendar.getTime());

                calendar.set(Calendar.MONTH, Calendar.DECEMBER);
                calendar.set(Calendar.DAY_OF_MONTH, 31);
                endDate = new SimpleDateFormat("yyyy-MM-dd").format(calendar.getTime());
            } else {
                // Financial Year Q4 (January - March)
                calendar.set(Calendar.MONTH, Calendar.JANUARY);
                calendar.set(Calendar.DAY_OF_MONTH, 1);
                startDate = new SimpleDateFormat("yyyy-MM-dd").format(calendar.getTime());

                calendar.set(Calendar.MONTH, Calendar.MARCH);
                calendar.set(Calendar.DAY_OF_MONTH, 31);
                endDate = new SimpleDateFormat("yyyy-MM-dd").format(calendar.getTime());
            }
        }

        try {
            db.getCon("nha_cdr");

            // Get user type from the session
            HttpSession session = request.getSession(false);
            if (session == null) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.getWriter().write("{\"error\":\"User is not logged in or session has expired.\"}");
                return;
            }

            String usernameFromSession = (String) session.getAttribute("LogUsername");
            if (usernameFromSession == null) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.getWriter().write("{\"error\":\"No username found in session.\"}");
                return;
            }

            // Get user type (ABDM, PMJAY, or Admin)
            String userType = "";
            String sqlCheckUserType = "SELECT user_type FROM users WHERE username = '" + usernameFromSession + "'";
            Statement stmt = db.getStmt();
            ResultSet rsUserType = stmt.executeQuery(sqlCheckUserType);
            if (rsUserType.next()) {
                userType = rsUserType.getString("user_type");
            }

            // Build the SQL query dynamically based on 'groupBy' parameter and user type
            StringBuilder queryBuilder = new StringBuilder();
            queryBuilder.append("SELECT ");

            if ("none".equals(groupBy)) {
                queryBuilder.append("t1.Username, ")
                        .append("CASE ")
                        .append("WHEN MONTH(t1.date) BETWEEN 4 AND 6 THEN 'Q1' ")  // Financial Year Q1 (April - June)
                        .append("WHEN MONTH(t1.date) BETWEEN 7 AND 9 THEN 'Q2' ")  // Financial Year Q2 (July - September)
                        .append("WHEN MONTH(t1.date) BETWEEN 10 AND 12 THEN 'Q3' ") // Financial Year Q3 (October - December)
                        .append("WHEN MONTH(t1.date) BETWEEN 1 AND 3 THEN 'Q4' ")  // Financial Year Q4 (January - March)
                        .append("END AS Quarterly_Period, ");
            } else if ("date".equals(groupBy)) {
                queryBuilder.append("CASE ")
                        .append("WHEN MONTH(t1.date) BETWEEN 4 AND 6 THEN 'Q1' ")
                        .append("WHEN MONTH(t1.date) BETWEEN 7 AND 9 THEN 'Q2' ")
                        .append("WHEN MONTH(t1.date) BETWEEN 10 AND 12 THEN 'Q3' ")
                        .append("WHEN MONTH(t1.date) BETWEEN 1 AND 3 THEN 'Q4' ")
                        .append("END AS Quarterly_Period, ");
            } else if ("username".equals(groupBy)) {
                queryBuilder.append("t1.Username, ");
            }

            queryBuilder.append("SUM(COALESCE(t1.Total, 0)) AS Total, ")
                    .append("SUM(COALESCE(t1.Success, 0)) AS Success ");

            queryBuilder.append("FROM sgc_billing t1 ")
                     .append("JOIN AccountDetails ad ON ad.accountname = t1.username ") // Join with AccountDetails table
                    .append("WHERE t1.date >= '").append(startDate).append("' ")
                    .append("AND t1.date <= '").append(endDate).append("' ");

            // Add user type condition
            if ("admin".equals(userType)) {
                // Admin can view all data for both departments
                queryBuilder.append("AND ad.department IN ('ABDM', 'PMJAY') ");
            } else if ("ABDM".equals(userType)) {
                queryBuilder.append("AND ad.department = 'ABDM' ");
            } else if ("PMJAY".equals(userType)) {
                queryBuilder.append("AND ad.department = 'PMJAY' ");
            }

            // Apply grouping based on the 'groupBy' parameter
            if ("none".equals(groupBy)) {
                queryBuilder.append("GROUP BY t1.Username, Quarterly_Period ");
            } else if ("date".equals(groupBy)) {
                queryBuilder.append("GROUP BY Quarterly_Period ");
            } else if ("username".equals(groupBy)) {
                queryBuilder.append("GROUP BY t1.Username ");
            }

            // Apply ordering based on 'groupBy' parameter
            if ("none".equals(groupBy)) {
                queryBuilder.append("ORDER BY t1.Username, Quarterly_Period;");
            } else if ("date".equals(groupBy)) {
                queryBuilder.append("ORDER BY Quarterly_Period;");
            } else if ("username".equals(groupBy)) {
                queryBuilder.append("ORDER BY t1.Username;");
            }

            // Execute the query and fetch data
            ResultSet rs = db.getResult(queryBuilder.toString());

            // Prepare a list to store the report data
            List<Map<String, Object>> reportData = new ArrayList<>();

            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();

                if ("none".equals(groupBy)) {
                    row.put("Username", rs.getString("Username"));
                    row.put("Quarterly_Period", rs.getString("Quarterly_Period"));
                } else if ("date".equals(groupBy)) {
                    row.put("Quarterly_Period", rs.getString("Quarterly_Period"));
                } else if ("username".equals(groupBy)) {
                    row.put("Username", rs.getString("Username"));
                }

                row.put("Total", rs.getDouble("Total"));
                row.put("Success", rs.getDouble("Success"));
                reportData.add(row);
            }

            // Convert the result to JSON format
            Gson gson = new Gson();
            String jsonResponse = gson.toJson(reportData);
            response.getWriter().write(jsonResponse);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("Error: " + e.getMessage());
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Quarterly Report Servlet with Dynamic Grouping and User Type Filtering based on Financial Year";
    }
}
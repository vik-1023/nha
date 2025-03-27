/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.nha.dashboard;

import db.dbcon;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.sql.Statement;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONArray;
import org.json.JSONObject;

public class BiWeeklyReports extends HttpServlet {

    // Utility method to build the CASE statement for biweekly periods dynamically
    private String getBiweeklyPeriodCase(String startDate, String endDate) {
        // Parse the start and end date to get the day and month information
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        try {
            Date start = sdf.parse(startDate);
            Date end = sdf.parse(endDate);

            Calendar startCalendar = Calendar.getInstance();
            startCalendar.setTime(start);
            Calendar endCalendar = Calendar.getInstance();
            endCalendar.setTime(end);

            int startMonth = startCalendar.get(Calendar.MONTH) + 1;
            int startDay = startCalendar.get(Calendar.DAY_OF_MONTH);
            int endMonth = endCalendar.get(Calendar.MONTH) + 1;
            int endDay = endCalendar.get(Calendar.DAY_OF_MONTH);

            StringBuilder caseStatement = new StringBuilder("CASE ");

            // Biweekly logic - for simplicity, handle two periods per month
            // First period (1st to 14th)
            caseStatement.append("WHEN DAY(t1.date) BETWEEN 1 AND 14 THEN '")
                    .append(startCalendar.get(Calendar.YEAR)).append("-")
                    .append(String.format("%02d", startMonth)).append("-01 to ")
                    .append(startCalendar.get(Calendar.YEAR)).append("-")
                    .append(String.format("%02d", startMonth)).append("-14' ");

            // Second period (15th to end of month or 28th/29th/30th based on the month)
            if (endDay >= 29) {
                caseStatement.append("WHEN DAY(t1.date) BETWEEN 15 AND ").append(endDay).append(" THEN '")
                        .append(startCalendar.get(Calendar.YEAR)).append("-")
                        .append(String.format("%02d", startMonth)).append("-15 to ")
                        .append(endCalendar.get(Calendar.YEAR)).append("-")
                        .append(String.format("%02d", endMonth)).append("-")
                        .append(String.format("%02d", endDay)).append("' ");
            } else {
                caseStatement.append("WHEN DAY(t1.date) BETWEEN 15 AND 28 THEN '")
                        .append(startCalendar.get(Calendar.YEAR)).append("-")
                        .append(String.format("%02d", startMonth)).append("-15 to ")
                        .append(startCalendar.get(Calendar.YEAR)).append("-")
                        .append(String.format("%02d", startMonth)).append("-28' ");
            }

            caseStatement.append("ELSE 'Other' END");
            return caseStatement.toString();
        } catch (ParseException e) {
            e.printStackTrace();
            return "CASE WHEN 1=1 THEN 'Error' END"; // Return error case if date parsing fails
        }
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        dbcon db = new dbcon();
        response.setContentType("application/json;charset=UTF-8");  // Set the response type to JSON
        PrintWriter out = response.getWriter();

        try {
            // Get parameters from the request
            String startDate = request.getParameter("startDate");
            String endDate = request.getParameter("endDate");
            String groupBy = request.getParameter("groupBy");  // Get the 'groupBy' parameter
            System.out.println("groupBy: " + groupBy);
            System.out.println("startDate :" + startDate);
            System.out.println("endDate :" + endDate);

            // Session validation
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

            db.getCon("nha_cdr");
            System.out.println("Username from session: " + usernameFromSession);

            // Get user type
            String userType = "";
            String sqlCheckUserType = "SELECT user_type FROM users WHERE username = '" + usernameFromSession + "'";
            Statement stmt = db.getStmt();
            ResultSet rsUserType = stmt.executeQuery(sqlCheckUserType);
            if (rsUserType.next()) {
                userType = rsUserType.getString("user_type");
                System.out.println("userType: " + userType);
            }

            // Default to 'none' if 'groupBy' is null or empty
            if (groupBy == null || groupBy.isEmpty()) {
                groupBy = "none";
            }

            // Construct the base SQL query
            StringBuilder query = new StringBuilder("SELECT ");

            // Get the dynamic CASE statement for biweekly periods
            String dynamicBiweeklyPeriodCase = getBiweeklyPeriodCase(startDate, endDate);

            // Add groupBy logic to the query based on the selected 'groupBy' option
            if ("none".equals(groupBy) || "username".equals(groupBy)) {
                query.append("t1.username, ").append(dynamicBiweeklyPeriodCase).append(" AS Biweekly_Period, ");
            } else if ("biweeklyPeriod".equals(groupBy)) {
                query.append("t1.username, ").append(dynamicBiweeklyPeriodCase).append(" AS Biweekly_Period, ");
            }

            query.append("SUM(COALESCE(t1.Total, 0)) AS Total, ")
                    .append("SUM(COALESCE(t1.Success, 0)) AS Success ");

            // Base query continues with WHERE clause and JOIN with AccountDetails
            query.append("FROM sgc_billing t1 ")
                    .append("JOIN AccountDetails ad ON ad.accountname = t1.username ")
                    .append("WHERE t1.date >= '").append(startDate).append("' ")
                    .append("AND t1.date <= '").append(endDate).append("' ");

            // Handle different user types
            if ("admin".equals(userType)) {
                query.append("AND ad.department IN ('ABDM', 'PMJAY') ");
            } else if ("ABDM".equals(userType)) {
                query.append("AND ad.department = 'ABDM' ");
            } else if ("PMJAY".equals(userType)) {
                query.append("AND ad.department = 'PMJAY' ");
            }

            // Add GROUP BY clause based on the 'groupBy' parameter
            query.append("GROUP BY t1.username, ").append(dynamicBiweeklyPeriodCase);

            // Order by group
            query.append(" ORDER BY t1.username, ").append(dynamicBiweeklyPeriodCase);

            // Execute the query
            stmt = db.getStmt();
            ResultSet rs = stmt.executeQuery(query.toString());

            // Create JSON array to hold the results
            JSONArray jsonArray = new JSONArray();

            // Check if there are any results and construct the response
            while (rs.next()) {
                JSONObject jsonObject = new JSONObject();
                jsonObject.put("Username", rs.getString("username"));
                jsonObject.put("Biweekly_Period", rs.getString("Biweekly_Period"));
                jsonObject.put("Total", rs.getDouble("Total"));
                jsonObject.put("Success", rs.getDouble("Success"));
                jsonArray.put(jsonObject);
            }

            // Send the JSON response back to the client
            if (jsonArray.isEmpty()) {
                out.println("[]"); // Return an empty JSON array if no data
            } else {
                out.println(jsonArray.toString()); // Return the populated JSON array
            }
            System.out.println("query: " + query);
        } catch (Exception e) {
            e.printStackTrace();
            out.println("{\"error\": \"An error occurred while processing the request.\"}");
        } finally {
            db.closeConection();
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "BiWeeklyReports Servlet";
    }
}

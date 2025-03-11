/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.nha.dashboard;

import db.dbcon;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.json.JSONObject;

public class BiWeeklyReports extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        dbcon db = new dbcon();
        response.setContentType("application/json;charset=UTF-8");  // Set the response type to JSON
        PrintWriter out = response.getWriter();

        try {
            // Get start, end date, and groupBy parameters from the request
            String startDate = request.getParameter("startDate");
            String endDate = request.getParameter("endDate");
            String groupBy = request.getParameter("groupBy");  // Get the 'groupBy' parameter
            System.out.println("groupBy :" + groupBy);

            // Default to 'none' if 'groupBy' is null or empty
            if (groupBy == null || groupBy.isEmpty()) {
                groupBy = "none";
            }

            // Construct the base SQL query
            StringBuilder query = new StringBuilder("SELECT ");

            // Add groupBy logic to the query based on the selected 'groupBy' option
            if ("none".equals(groupBy)) {
                query.append("t1.username, ")
                        .append("CASE ")
                        .append("WHEN DAY(t1.date) BETWEEN 1 AND 14 THEN '1 to 14' ")
                        .append("WHEN DAY(t1.date) BETWEEN 15 AND 28 THEN '15 to 28' ")
                        .append("WHEN DAY(t1.date) = 29 AND MONTH(t1.date) IN (2, 4, 6, 9, 11) THEN '15 to 28' ")
                        .append("WHEN DAY(t1.date) = 30 AND MONTH(t1.date) IN (1, 3, 5, 7, 8, 10, 12) THEN '15 to 28' ")
                        .append("ELSE '15 to 28' ")
                        .append("END AS Biweekly_Period, ");
            } else if ("username".equals(groupBy)) {
                query.append("t1.username, ")
                        .append("CASE ")
                        .append("WHEN DAY(t1.date) BETWEEN 1 AND 14 THEN '1 to 14' ")
                        .append("WHEN DAY(t1.date) BETWEEN 15 AND 28 THEN '15 to 28' ")
                        .append("WHEN DAY(t1.date) = 29 AND MONTH(t1.date) IN (2, 4, 6, 9, 11) THEN '15 to 28' ")
                        .append("WHEN DAY(t1.date) = 30 AND MONTH(t1.date) IN (1, 3, 5, 7, 8, 10, 12) THEN '15 to 28' ")
                        .append("ELSE '15 to 28' ")
                        .append("END AS Biweekly_Period, ");
            } else if ("biweeklyPeriod".equals(groupBy)) {
                query.append("t1.username, ")  // Add username for biweeklyPeriod grouping
                        .append("CASE ")
                        .append("WHEN DAY(t1.date) BETWEEN 1 AND 14 THEN '1 to 14' ")
                        .append("WHEN DAY(t1.date) BETWEEN 15 AND 28 THEN '15 to 28' ")
                        .append("WHEN DAY(t1.date) = 29 AND MONTH(t1.date) IN (2, 4, 6, 9, 11) THEN '15 to 28' ")
                        .append("WHEN DAY(t1.date) = 30 AND MONTH(t1.date) IN (1, 3, 5, 7, 8, 10, 12) THEN '15 to 28' ")
                        .append("ELSE '15 to 28' ")
                        .append("END AS Biweekly_Period, ");
            }

            // Add SUM of Total and Success
            query.append("SUM(COALESCE(t1.Total, 0)) AS Total, ")
                    .append("SUM(COALESCE(t1.Success, 0)) AS Success ");

            // Base query continues with WHERE clause
            query.append("FROM sgc_billing t1 ")
                    .append("WHERE t1.date >= '").append(startDate).append("' ")
                    .append("AND t1.date <= '").append(endDate).append("' ");

            // Add GROUP BY clause based on the 'groupBy' parameter
            if ("none".equals(groupBy)) {
                query.append("GROUP BY t1.username, ");
                query.append("CASE ")
                        .append("WHEN DAY(t1.date) BETWEEN 1 AND 14 THEN '1 to 14' ")
                        .append("WHEN DAY(t1.date) BETWEEN 15 AND 28 THEN '15 to 28' ")
                        .append("WHEN DAY(t1.date) = 29 AND MONTH(t1.date) IN (2, 4, 6, 9, 11) THEN '15 to 28' ")
                        .append("WHEN DAY(t1.date) = 30 AND MONTH(t1.date) IN (1, 3, 5, 7, 8, 10, 12) THEN '15 to 28' ")
                        .append("ELSE '15 to 28' ")
                        .append("END ");
            } else if ("username".equals(groupBy)) {
                query.append("GROUP BY t1.username, ");
                query.append("CASE ")
                        .append("WHEN DAY(t1.date) BETWEEN 1 AND 14 THEN '1 to 14' ")
                        .append("WHEN DAY(t1.date) BETWEEN 15 AND 28 THEN '15 to 28' ")
                        .append("WHEN DAY(t1.date) = 29 AND MONTH(t1.date) IN (2, 4, 6, 9, 11) THEN '15 to 28' ")
                        .append("WHEN DAY(t1.date) = 30 AND MONTH(t1.date) IN (1, 3, 5, 7, 8, 10, 12) THEN '15 to 28' ")
                        .append("ELSE '15 to 28' ")
                        .append("END ");
            } else if ("biweeklyPeriod".equals(groupBy)) {
                query.append("GROUP BY t1.username, ");  // Add username in GROUP BY
                query.append("CASE ")
                        .append("WHEN DAY(t1.date) BETWEEN 1 AND 14 THEN '1 to 14' ")
                        .append("WHEN DAY(t1.date) BETWEEN 15 AND 28 THEN '15 to 28' ")
                        .append("WHEN DAY(t1.date) = 29 AND MONTH(t1.date) IN (2, 4, 6, 9, 11) THEN '15 to 28' ")
                        .append("WHEN DAY(t1.date) = 30 AND MONTH(t1.date) IN (1, 3, 5, 7, 8, 10, 12) THEN '15 to 28' ")
                        .append("ELSE '15 to 28' ")
                        .append("END ");
            }

            // Order by group
            query.append("ORDER BY ");

            if ("none".equals(groupBy)) {
                query.append("t1.username, ");
                query.append("CASE ")
                        .append("WHEN DAY(t1.date) BETWEEN 1 AND 14 THEN '1 to 14' ")
                        .append("WHEN DAY(t1.date) BETWEEN 15 AND 28 THEN '15 to 28' ")
                        .append("WHEN DAY(t1.date) = 29 AND MONTH(t1.date) IN (2, 4, 6, 9, 11) THEN '15 to 28' ")
                        .append("WHEN DAY(t1.date) = 30 AND MONTH(t1.date) IN (1, 3, 5, 7, 8, 10, 12) THEN '15 to 28' ")
                        .append("ELSE '15 to 28' ")
                        .append("END ");
            } else if ("username".equals(groupBy)) {
                query.append("t1.username, ");
                query.append("CASE ")
                        .append("WHEN DAY(t1.date) BETWEEN 1 AND 14 THEN '1 to 14' ")
                        .append("WHEN DAY(t1.date) BETWEEN 15 AND 28 THEN '15 to 28' ")
                        .append("WHEN DAY(t1.date) = 29 AND MONTH(t1.date) IN (2, 4, 6, 9, 11) THEN '15 to 28' ")
                        .append("WHEN DAY(t1.date) = 30 AND MONTH(t1.date) IN (1, 3, 5, 7, 8, 10, 12) THEN '15 to 28' ")
                        .append("ELSE '15 to 28' ")
                        .append("END ");
            } else if ("biweeklyPeriod".equals(groupBy)) {
                query.append("t1.username, ");  // Add username in ORDER BY
                query.append("CASE ")
                        .append("WHEN DAY(t1.date) BETWEEN 1 AND 14 THEN '1 to 14' ")
                        .append("WHEN DAY(t1.date) BETWEEN 15 AND 28 THEN '15 to 28' ")
                        .append("WHEN DAY(t1.date) = 29 AND MONTH(t1.date) IN (2, 4, 6, 9, 11) THEN '15 to 28' ")
                        .append("WHEN DAY(t1.date) = 30 AND MONTH(t1.date) IN (1, 3, 5, 7, 8, 10, 12) THEN '15 to 28' ")
                        .append("ELSE '15 to 28' ")
                        .append("END ");
            }

            // Execute the query
            db.getCon("nha_cdr");
            ResultSet rs = db.getResult(query.toString());

            // Create JSON array to hold the results
            JSONArray jsonArray = new JSONArray();

            while (rs.next()) {
                JSONObject jsonObject = new JSONObject();
                jsonObject.put("Username", rs.getString("username"));
                jsonObject.put("Biweekly_Period", rs.getString("Biweekly_Period"));
                jsonObject.put("Total", rs.getDouble("Total"));
                jsonObject.put("Success", rs.getDouble("Success"));
                jsonArray.put(jsonObject);
            }

            // Send the JSON response back to the client
            out.println(jsonArray.toString());

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
        return "Short description";
    }
}



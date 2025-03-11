/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.nha.dashboard;

import db.dbcon;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.JSONArray;
import org.json.JSONObject;

/**
 *
 * @author vikram
 */
public class NhaServletChart extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        dbcon db = new dbcon();

        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            LocalDate currentDate = LocalDate.now();

            // Set the start date to the 1st of the current month
            LocalDate startDate = currentDate.withDayOfMonth(1);

            // Format the dates to the desired format (YYYY-MM-DD)
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
            String startDateStr = startDate.format(formatter);
            String endDateStr = currentDate.format(formatter);
            
            System.out.println("startDateStr :"+startDateStr);
            System.out.println("endDateStr :"+endDateStr);
            
            // Initialize SQL query variable
            String sql = "";

            // Log the parameters for debugging
            // Establish connection to the database
            db.getCon("nha_cdr");

            sql = "SELECT \n"
                    + "    date,\n"
                    + "    SUM(Total) AS Total,\n"
                    + "    SUM(Success) AS Success,\n"
                    + "    SUM(Failed) AS Failed\n"
                    + "FROM User_Counts_Api_production AS uca\n"
                    + "WHERE \n"
                    + "    (date, last_updated) IN (\n"
                    + "        SELECT date, MAX(last_updated)\n"
                    + "        FROM User_Counts_Api_production\n"
                    + "        WHERE date BETWEEN '"+startDateStr+"' AND '"+endDateStr+"'\n"
                    + "        GROUP BY date\n"
                    + "    )\n"
                    + "GROUP BY date;";

            // Execute the query
            ResultSet rs = db.getResult(sql);
            System.out.println("SQL: " + sql); // Log the SQL query for debugging

            // Create a JSON array to hold the results
            JSONArray jsonArray = new JSONArray();
            while (rs.next()) {
                // Create a JSON object for each row in the result set
                JSONObject jsonObject = new JSONObject();
                jsonObject.put("date", rs.getString("date"));
                jsonObject.put("total", rs.getString("Total"));
                jsonObject.put("success", rs.getString("Success"));
                jsonObject.put("failed", rs.getString("Failed"));

                jsonArray.put(jsonObject);
            }

            // Write the JSON response
            out.print(jsonArray.toString());
            out.flush();

        } catch (Exception e) {
            // Handle exceptions
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().print("{\"error\": \"An error occurred while processing your request.\"}");
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
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }

}

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
public class NhaServletProduction extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        dbcon db = new dbcon();
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {

            JSONArray jsonArray = new JSONArray();
            String sql = "SELECT \n"
                    + "    SUM(t1.Total) AS Total, \n"
                    + "    SUM(t1.Success) AS Success, \n"
                    + "    SUM(t1.Failed) AS Failed \n"
                    + "FROM \n"
                    + "    User_Counts_Api_production t1\n"
                    + "JOIN \n"
                    + "    (SELECT \n"
                    + "        date, \n"
                    + "        MAX(last_updated) AS max_last_updated \n"
                    + "     FROM \n"
                    + "        User_Counts_Api_production \n"
                    + "     WHERE \n"
                    + "        date = CURDATE() \n"
                    + "     GROUP BY \n"
                    + "        date) t2 \n"
                    + "ON \n"
                    + "    t1.date = t2.date \n"
                    + "    AND t1.last_updated = t2.max_last_updated \n"
                    + "WHERE \n"
                    + "    t1.date = CURDATE();";

            db.getCon("nha_cdr");
            try (ResultSet rs = db.getResult(sql)) {
                if (rs == null) {
                    response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to retrieve data from the database.");
                    return;
                }

                while (rs.next()){
                    JSONObject jsonObject = new JSONObject();
                    jsonObject.put("Total", rs.getObject("Total") != null ? rs.getInt("Total") : 0);
                    jsonObject.put("Success", rs.getObject("Success") != null ? rs.getInt("Success") : 0);
                    jsonObject.put("Failed", rs.getObject("Failed") != null ? rs.getInt("Failed") : 0);

                    jsonArray.put(jsonObject);
                }
                System.out.println("jsonArray :" +jsonArray);
                out.print(jsonArray.toString());
            } catch (SQLException e) {
                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database query failed.");
            }
        } catch (Exception e) {
            e.printStackTrace();
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

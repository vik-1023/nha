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

public class NhaServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");

        try (PrintWriter out = response.getWriter()) {

            dbcon db = new dbcon();
            String accountname = request.getParameter("accountname");
            String fromDate = request.getParameter("fromDate");
            String toDate = request.getParameter("toDate");
            String environment = request.getParameter("environment");

            String sql = "";
            String tbl = ("production".equals(environment)) ? "User_Counts_Api_production" : "User_Counts_Api";

            System.out.println("accountname: " + accountname);
            System.out.println("fromDate: " + fromDate);
            System.out.println("toDate: " + toDate);
            System.out.println("environment: " + environment);

            db.getCon("nha_cdr");

            if (accountname == null || accountname.isEmpty()) {
                sql = "SELECT t1.date, t1.Username, t1.Total, t1.Success, t1.Failed "
                        + "FROM " + tbl + " t1 "
                        + "JOIN ( "
                        + "    SELECT date, MAX(last_updated) AS max_last_updated "
                        + "    FROM " + tbl + " "
                        + "    GROUP BY date "
                        + ") t2 ON t1.date = t2.date AND t1.last_updated = t2.max_last_updated "
                        + "ORDER BY t1.date;";
            } else if (fromDate != null && !fromDate.isEmpty() && toDate != null && !toDate.isEmpty()) {
                if (fromDate.length() == 7 && toDate.length() == 7) {
                    // YYYY-MM (Month-level filter)
                    sql = "SELECT t1.date, t1.Username, t1.Total, t1.Success, t1.Failed "
                            + "FROM " + tbl + " t1 "
                            + "JOIN ( "
                            + "    SELECT date, MAX(last_updated) AS max_last_updated "
                            + "    FROM " + tbl + " "
                            + "    WHERE Username = '" + accountname + "' "
                            + "    AND DATE_FORMAT(date, '%Y-%m') BETWEEN '" + fromDate + "' AND '" + toDate + "' "
                            + "    GROUP BY date "
                            + ") t2 ON t1.date = t2.date AND t1.last_updated = t2.max_last_updated "
                            + "WHERE t1.Username = '" + accountname + "' "
                            + "ORDER BY t1.date;";
                } else {
                    // YYYY-MM-DD (Day-level filter)
                    sql = "SELECT t1.date, t1.Username, t1.Total, t1.Success, t1.Failed "
                            + "FROM " + tbl + " t1 "
                            + "JOIN ( "
                            + "    SELECT date, MAX(last_updated) AS max_last_updated "
                            + "    FROM " + tbl + " "
                            + "    WHERE date BETWEEN '" + fromDate + "' AND '" + toDate + "' "
                            + "    AND Username = '" + accountname + "' "
                            + "    GROUP BY date "
                            + ") t2 ON t1.date = t2.date AND t1.last_updated = t2.max_last_updated "
                            + "WHERE t1.Username = '" + accountname + "' "
                            + "ORDER BY t1.date;";
                }
            } else {
                // Fetch all data for a specific accountname if no valid date range is provided
                sql = "SELECT t1.date, t1.Username, t1.Total, t1.Success, t1.Failed "
                        + "FROM " + tbl + " t1 "
                        + "JOIN ( "
                        + "    SELECT date, MAX(last_updated) AS max_last_updated "
                        + "    FROM " + tbl + " "
                        + "    WHERE Username = '" + accountname + "' "
                        + "    GROUP BY date "
                        + ") t2 ON t1.date = t2.date AND t1.last_updated = t2.max_last_updated "
                        + "WHERE t1.Username = '" + accountname + "' "
                        + "ORDER BY t1.date;";
            }

            ResultSet rs = db.getResult(sql);
            System.out.println("SQL: " + sql);

            JSONArray jsonArray = new JSONArray();
            while (rs.next()) {
                JSONObject jsonObject = new JSONObject();
                jsonObject.put("date", rs.getString("date"));
                jsonObject.put("username", rs.getString("Username"));
                jsonObject.put("total", rs.getString("Total"));
                jsonObject.put("success", rs.getString("Success"));
                jsonObject.put("failed", rs.getString("Failed"));
                jsonArray.put(jsonObject);
            }

            out.print(jsonArray.toString());
            out.flush();

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().print("{\"error\": \"An error occurred while processing your request.\"}");
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
}

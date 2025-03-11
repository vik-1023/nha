<%-- 
    Document   : index
    Created on : 19 Feb, 2025, 2:34:19 PM
    Author     : vikram
--%>


<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="db.dbcon"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    response.setHeader("Cache-Control", "no-store");

    HttpSession s = request.getSession(false);

    String LogUsername = null;

    if (s != null) {
        LogUsername = (String) s.getAttribute("LogUsername");
        System.out.println(LogUsername);
        if (LogUsername == null) {
            response.sendRedirect("Login");
            return;
        }
    } else {
        response.sendRedirect("Login");
        return;
    }
%>
<!DOCTYPE html>

<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>VNS | NHA</title>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
        <!-- SheetJS Library for Excel Export -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.17.0/xlsx.full.min.js"></script>
        <!-- Font Awesome for Icons -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
        <style>
            /* General body styles */
            body {
                font-family: 'Roboto', sans-serif;
                background-color: #f4f7fc;
                color: #333;
                margin: 0;
                padding: 0;
            }

            .header {
                background-color: #fff;
                padding: 10px 20px;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                position: fixed;
                top: 0;
                left: 0px; /* Shift header to the right by sidebar width */
                width: 100%; /* Adjust width to account for sidebar */
                z-index: 999; /* Ensure header is below sidebar */
                transition: left 0.3s ease;
            }
            .nha-logo {
                width: 100px; /* Adjust the size as needed */
                height: auto; /* Maintain aspect ratio */
            }
            .left-logo {
                float: left;
                width: 93%;
            }

            /* Container for the form and report */
            .container {
                max-width: 1000px;
                margin: 50px auto;
                padding: 30px;
                background-color: #ffffff;
                border-radius: 12px;
                box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
            }

            /* Heading styles */
            h2 {
                font-size: 28px;
                color: #007bff;
                text-align: center;
                margin-bottom: 30px;
                font-weight: 700;
            }

            h3 {
                font-size: 22px;
                color: #444;
                margin-top: 30px;
                font-weight: 600;
            }

            /* Form styles */
            form {
                display: flex;
                flex-wrap: wrap;
                gap: 40px;
                margin-bottom: 30px;
            }

            form > div {
                flex: 1;
                min-width: 200px;
            }

            label {
                font-size: 16px;
                font-weight: 500;
                color: #555;
                display: block;
                margin-bottom: 8px;
            }

            input[type="date"],
            select {
                width: 100%;
                padding: 10px;
                border: 1px solid #ccc;
                border-radius: 6px;
                font-size: 14px;
                outline: none;
                transition: border-color 0.3s ease;
            }

            input[type="date"]:focus,
            select:focus {
                border-color: #007bff;
            }

            button {
                background-color: #007bff;
                color: #ffffff;
                padding: 12px 24px;
                font-size: 16px;
                font-weight: 500;
                border: none;
                border-radius: 6px;
                cursor: pointer;
                transition: background-color 0.3s ease, transform 0.2s ease;
            }

            button:hover {
                background-color: #0056b3;
                transform: translateY(-2px);
            }

            button:active {
                transform: translateY(0);
            }

            /* Download buttons */
            .download-buttons {
                margin-top: 20px;
                text-align: right;
            }

            .download-buttons button {
                margin-left: 10px;
                background-color: #28a745;
                padding: 10px 20px;
                font-size: 14px;
                font-weight: 500;
                border: none;
                border-radius: 6px;
                cursor: pointer;
                transition: background-color 0.3s ease, transform 0.2s ease;
            }

            .download-buttons button:hover {
                background-color: #218838;
                transform: translateY(-2px);
            }

            .download-buttons button:active {
                transform: translateY(0);
            }

            /* Loading spinner */
            .spinner {
                text-align: center;
                margin-top: 20px;
                display: none;
            }

            .spinner i {
                font-size: 24px;
                color: #007bff;
            }

            .spinner p {
                margin-top: 10px;
                font-size: 14px;
                color: #555;
            }

            /* Error message */
            .error-message {
                color: #ff4d4d;
                text-align: center;
                margin-top: 20px;
                font-size: 14px;
            }

            /* Table styles */
            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 30px;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
                border-radius: 8px;
                overflow: hidden;
            }

            th, td {
                padding: 14px;
                text-align: center;
                border: 1px solid #ddd;
            }

            th {
                background-color: #007bff;
                color: #ffffff;
                font-weight: 600;
                text-transform: uppercase;
                font-size: 14px;
            }

            td {
                background-color: #ffffff;
                font-size: 14px;
            }

            tr:nth-child(even) {
                background-color: #f9f9f9;
            }

            tr:hover {
                background-color: #f1f1f1;
                transition: background-color 0.3s ease;
            }

            /* Responsive design */
            @media (max-width: 768px) {
                form {
                    flex-direction: column;
                }

                .container {
                    margin: 20px;
                    padding: 20px;
                }

                h2 {
                    font-size: 24px;
                }

                h3 {
                    font-size: 20px;
                }

                th, td {
                    padding: 10px;
                    font-size: 12px;
                }

                .download-buttons {
                    text-align: center;
                }

                .download-buttons button {
                    margin: 5px;
                    width: 100%;
                }
            }
        </style>
    </head>
    <body>
        <header id="header" class="header fixed-top d-flex align-items-center">
            <!-- Menu Icon (Visible only on smaller screens) -->
            <div class="menu-icon d-block d-md-none" onclick="toggleSidebar()">
                <i class="bi bi-list"></i> <!-- Use any icon library like Bootstrap Icons -->
            </div>

            <!-- Logo -->
            <div class="left-logo">
                <img id="LoginLogoPage_1" src="https://app.virtuosorbm.com/assets/img/logo.png" style="width:10%;">
            </div>
            <div class="right-logo">
                <img src="https://abdm.gov.in:8081/uploads/NHA_logo_hd_3099160d92.svg" alt="National Health Authority" class="nha-logo">
            </div>

        </header>
        <div class="container" style="margin-top: 50px;">
            <h2> Bi-Weekly Report</h2>

            <!-- Form to select start and end dates, and group by -->
            <form id="reportForm">
                <div>
                    <label for="environment">Reports</label>
                    <select class="form-select" onchange="window.location.href = this.value;" style="width: 200px;">
                        <option value="BiWeekly.jsp">Bi Weekly Reports</option>
                        <option value="current">Current Day Reports</option>
                        <option value="previous">Previous Day Reports</option>

                        <option value="month">Month Wise Reports</option>
                        <option value="quarterly.jsp">Quarterly Reports</option>
                    </select>
                </div>

                <div>
                    <label for="startDate">Start Date:</label>
                    <input type="date" id="startDate" name="startDate" required style="width: 200px;">
                </div>

                <div>
                    <label for="endDate">End Date:</label>
                    <input type="date" id="endDate" name="endDate" required style="width: 200px;">
                </div>

                <div>
                    <label for="groupBy">Group By:</label>
                    <select id="groupBy" name="groupBy" required style="width: 200px;">
                        <option value="none">None</option>
                        <option value="username">Username</option>
                        <option value="biweeklyPeriod">Biweekly Period</option>
                    </select>
                </div>

                <div>
                    <button type="submit">Submit</button>
                </div>
            </form>

            <!-- Download Buttons -->
            <div class="download-buttons">
                <button id="exportExcel"><i class="fas fa-file-excel"></i> Export to Excel</button>
                <button id="exportCSV"><i class="fas fa-file-csv"></i> Export to CSV</button>
            </div>

            <!-- Loading Spinner -->
            <div class="spinner" id="spinner">
                <i class="fa fa-spinner fa-spin"></i>
                <p>Loading...</p>
            </div>

            <!-- Error message -->
            <div class="error-message" id="errorMessage"></div>

            <!-- Table to display results -->
            <table id="reportTable">
                <thead>
                    <tr>
                        <th id="usernameColumn">Username</th>
                        <th id="biweeklyPeriodColumn">Biweekly Period</th>
                        <th>Total</th>
                        <th>Success</th>
                    </tr>
                </thead>
                <tbody>
                    <!-- Data will be dynamically inserted here by AJAX -->
                </tbody>
            </table>
        </div>

        <script>
            $(document).ready(function () {
                // Function to format date as YYYY-MM-DD
                function formatDate(date) {
                    var d = new Date(date),
                            month = '' + (d.getMonth() + 1),
                            day = '' + d.getDate(),
                            year = d.getFullYear();

                    if (month.length < 2)
                        month = '0' + month;
                    if (day.length < 2)
                        day = '0' + day;

                    return [year, month, day].join('-');
                }

                // Set default dates (bi-weekly: 14 days before today)
                var today = new Date();
                var endDate = formatDate(today); // Today's date
                var startDate = formatDate(new Date(today.setDate(today.getDate() - 14))); // 14 days before today

                // Set the default values in the date inputs
                $("#startDate").val(startDate);
                $("#endDate").val(endDate);

                // AJAX request when the form is submitted
                $("#reportForm").on("submit", function (event) {
                    event.preventDefault(); // Prevent the form from submitting normally

                    // Get the form values (start and end date, group by option)
                    var startDate = $("#startDate").val();
                    var endDate = $("#endDate").val();
                    var groupBy = $("#groupBy").val(); // Get selected group by option

                    // Show loading spinner
                    $('#spinner').show();

                    // Hide error message and clear previous table data
                    $('#errorMessage').text('');
                    $('#reportTable tbody').empty();

                    // Send AJAX request to the servlet
                    $.ajax({
                        url: 'BiWeeklyReports', // Servlet URL
                        type: 'GET',
                        data: {
                            startDate: startDate,
                            endDate: endDate,
                            groupBy: groupBy  // Send the group by option
                        },
                        success: function (response) {
                            // Hide loading spinner
                            $('#spinner').hide();

                            // Check if the response is an array
                            if (Array.isArray(response)) {
                                // Adjust the table headers and data rows based on the groupBy selection
                                if (groupBy === "none") {
                                    $('#usernameColumn').show();
                                    $('#biweeklyPeriodColumn').show();
                                } else if (groupBy === "username") {
                                    $('#usernameColumn').show();
                                    $('#biweeklyPeriodColumn').hide();
                                } else if (groupBy === "biweeklyPeriod") {
                                    $('#usernameColumn').hide();
                                    $('#biweeklyPeriodColumn').show();
                                }

                                // Insert data into the table dynamically
                                response.forEach(function (row) {
                                    var tr = "<tr>";

                                    // Handle different groupBy cases for username and biweekly period columns
                                    if (groupBy === "none" || groupBy === "username") {
                                        tr += "<td>" + row.Username + "</td>";
                                    }

                                    if (groupBy === "none" || groupBy === "biweeklyPeriod") {
                                        tr += "<td>" + row.Biweekly_Period + "</td>";
                                    }

                                    // Add Total and Success columns for all cases
                                    tr += "<td>" + row.Total + "</td>" +
                                            "<td>" + row.Success + "</td>" +
                                            "</tr>";

                                    $("#reportTable tbody").append(tr);
                                });
                            } else {
                                alert("Invalid response format. Expected an array.");
                            }
                        },
                        error: function () {
                            // Hide loading spinner
                            $('#spinner').hide();

                            // Show error message
                            $('#errorMessage').text('An error occurred while fetching the data.');
                        }
                    });
                });

                // Function to export table data to Excel
                $('#exportExcel').on('click', function () {
                    var table = document.getElementById('reportTable');
                    var workbook = XLSX.utils.table_to_book(table, {sheet: "Sheet1"});
                    XLSX.writeFile(workbook, 'BiWeeklyReport.xlsx');
                });

                // Function to export table data to CSV
                $('#exportCSV').on('click', function () {
                    var table = document.getElementById('reportTable');
                    var rows = table.querySelectorAll('tr');
                    var csv = [];

                    // Extract headers
                    var headers = [];
                    table.querySelectorAll('th').forEach(function (th) {
                        headers.push(th.innerText);
                    });
                    csv.push(headers.join(','));

                    // Extract rows
                    rows.forEach(function (row) {
                        var rowData = [];
                        row.querySelectorAll('td').forEach(function (td) {
                            rowData.push(td.innerText);
                        });
                        csv.push(rowData.join(','));
                    });

                    // Create CSV file
                    var csvContent = "data:text/csv;charset=utf-8," + csv.join('\n');
                    var encodedUri = encodeURI(csvContent);
                    var link = document.createElement('a');
                    link.setAttribute('href', encodedUri);
                    link.setAttribute('download', 'BiWeeklyReport.csv');
                    document.body.appendChild(link);
                    link.click();
                    document.body.removeChild(link);
                });
            });
        </script>
    </body>
</html>
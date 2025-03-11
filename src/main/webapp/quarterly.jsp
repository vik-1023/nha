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
        <title>Quarterly Report</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
        <!-- SheetJS Library for Excel Export -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.17.0/xlsx.full.min.js"></script>
        <style>
            /* General body styles */
            body {
                font-family: 'Roboto', sans-serif;
                margin: 0;
                padding: 0;
                background-color: #f4f7fc;
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
            }

            .download-buttons button:hover {
                background-color: #218838;
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
        
        
        
        
        <div class="container">
            <h2>Quarterly Report</h2>

            <!-- Form to select start and end dates, and group by -->
            <form id="reportForm">

                <div>
                    <label for="environment">Reports</label>
                    <select class="form-select mt-2" onchange="window.location.href = this.value;">
                         <option value="quarterly.jsp">Quarterly Reports</option>
                        <option value="current">Current Day Reports</option>
                        <option value="previous">Previous Day Reports</option>

                        <option value="BiWeekly.jsp">Bi Weekly Reports</option>
                        <option value="month">Month Wise Reports</option>
                       
                    </select>
                </div>
                <div>
                    <label for="startDate">Start Date:</label>
                    <input type="date" id="startDate" name="startDate" required>
                </div>



                <div>
                    <label for="endDate">End Date:</label>
                    <input type="date" id="endDate" name="endDate" required>
                </div>

                <div>
                    <label for="groupBy">Group By:</label>
                    <select id="groupBy" name="groupBy" required>
                        <option value="none">None</option>
                        <option value="date">Date</option>
                        <option value="username">Username</option>
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
                        <th id="quarterColumn">Quarterly Period</th>
                        <th>Total</th>
                        <th>Success</th>
                    </tr>
                </thead>
                <tbody>
                    <!-- Data will be dynamically inserted here by AJAX -->
                </tbody>
            </table>
        </div>

        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
        <script>
                        // Function to get the default start and end date for the current quarter
                        function getQuarterDates() {
                            var now = new Date();
                            var currentMonth = now.getMonth();
                            var currentYear = now.getFullYear();
                            var startDate = '';
                            var endDate = '';

                            // Determine the current quarter and set the start and end dates
                            if (currentMonth >= 0 && currentMonth <= 2) { // Q1: Jan 1 - Mar 31
                                startDate = new Date(currentYear, 0, 1); // January 1st
                                endDate = new Date(currentYear, 2, 31);  // March 31st
                            } else if (currentMonth >= 3 && currentMonth <= 5) { // Q2: Apr 1 - Jun 30
                                startDate = new Date(currentYear, 3, 1); // April 1st
                                endDate = new Date(currentYear, 5, 30);  // June 30th
                            } else if (currentMonth >= 6 && currentMonth <= 8) { // Q3: Jul 1 - Sep 30
                                startDate = new Date(currentYear, 6, 1); // July 1st
                                endDate = new Date(currentYear, 8, 30);  // September 30th
                            } else { // Q4: Oct 1 - Dec 31
                                startDate = new Date(currentYear, 9, 1); // October 1st
                                endDate = new Date(currentYear, 11, 31); // December 31st
                            }

                            // Convert dates to yyyy-mm-dd format for input fields
                            var startDateStr = startDate.toISOString().split('T')[0];
                            var endDateStr = endDate.toISOString().split('T')[0];

                            // Set the default values in the form fields
                            document.getElementById('startDate').value = startDateStr;
                            document.getElementById('endDate').value = endDateStr;
                        }

                        // Set default quarter date when the page loads
                        window.onload = function () {
                            getQuarterDates();
                        };

                        // Handle form submission
                        $('#reportForm').on('submit', function (event) {
                            event.preventDefault();

                            var startDate = $('#startDate').val();
                            var endDate = $('#endDate').val();
                            var groupBy = $('#groupBy').val();

                            // Show loading spinner
                            $('#spinner').show();

                            // Hide error message and clear previous table data
                            $('#errorMessage').text('');
                            $('#reportTable tbody').empty();

                            // Make AJAX request to get data
                            $.ajax({
                                url: 'QuarterlyReports', // Your servlet URL
                                type: 'GET',
                                data: {
                                    startDate: startDate,
                                    endDate: endDate,
                                    groupBy: groupBy  // Send the selected group by option
                                },
                                success: function (data) {
                                    // Hide loading spinner
                                    $('#spinner').hide();

                                    // Check if data exists
                                    if (data && data.length > 0) {
                                        // Adjust columns based on groupBy
                                        if (groupBy === "none") {
                                            $('#usernameColumn').show();  // Show Username column
                                            $('#quarterColumn').show();  // Show Quarterly Period column
                                        } else if (groupBy === "date") {
                                            $('#usernameColumn').hide(); // Hide Username column
                                            $('#quarterColumn').show();  // Show Quarterly Period column
                                        } else if (groupBy === "username") {
                                            $('#usernameColumn').show();  // Show Username column
                                            $('#quarterColumn').hide();   // Hide Quarterly Period column
                                        }

                                        // Populate table with data based on groupBy option
                                        data.forEach(function (item) {
                                            var row = '<tr>';

                                            // Handle different groupBy cases
                                            if (groupBy === "none" || groupBy === "username") {
                                                row += '<td>' + item.Username + '</td>';
                                            }

                                            if (groupBy === "none" || groupBy === "date") {
                                                row += '<td>' + item.Quarterly_Period + '</td>';
                                            }

                                            // Add Total and Success columns
                                            row += '<td>' + item.Total + '</td>' +
                                                    '<td>' + item.Success + '</td>' +
                                                    '</tr>';

                                            $('#reportTable tbody').append(row);
                                        });
                                    } else {
                                        // If no data is found, show message
                                        $('#errorMessage').text('No data found for the selected date range.');
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
                            XLSX.writeFile(workbook, 'QuarterlyReport.xlsx');
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
                            link.setAttribute('download', 'QuarterlyReport.csv');
                            document.body.appendChild(link);
                            link.click();
                            document.body.removeChild(link);
                        });
        </script>
    </body>
</html>
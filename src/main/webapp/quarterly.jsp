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

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">


        <style>
            /* General body styles */
            body {
                font-family: 'Roboto', sans-serif;
                margin: 0;
                padding: 0;
                background-color: #f4f7fc;
            }

            /* Container for the form and report */
            .container{
                max-width: 1000px;
                margin: 94px auto;
                padding: 30px;
                background-color: #ffffff;
                border-radius: 12px;
                box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
            }
            .total-row {
                font-weight: bold;
                background-color: #f2f2f2;
            }

           

            /* Highlight individual cells in the total row */
        

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
                gap: 80px;
            }

            form > div {
                flex: 1;
                min-width: 170px;
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
                color: var(--bs-body-color);
            }

            button {

                padding: 12px 24px;
                font-size: 16px;
                font-weight: 500;
                border: none;
                border-radius: 6px;
                cursor: pointer;
                transition: background-color 0.3s ease, transform 0.2s ease;
                margin-top: 25px;
            }




            /* Download buttons */
            .download-buttons {
                margin-top: 20px;
                text-align: right;
            }

            .download-buttons button {
                margin-left: 10px;

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



            /* Sidebar Styles */
            .sidebar {
                width: 250px;
                height: 100vh;
                background-color: #2c3e50;
                position: absolute;
                top: 63px;
                left: 0;
                z-index: 1000;
                transition: left 0.3s ease;
            }

            .sidebar-nav {
                list-style-type: none;
                padding: 0;
                margin: 0;
            }

            .sidebar-nav .nav-item {
                padding: 3px 20px;
            }

            .sidebar-nav .nav-link {
                text-decoration: none;
                font-size: 16px;
                display: block;
                color: #000000;
                background-color: #fff;
                border-radius: 2px;
                padding: 10px;
            }

            .sidebar-nav .nav-link:hover {
                background-color: #fff;
                color:#000;
            }

            .dropdown-menu {
                position: absolute;
                top: 100%;
                left: 20px;
                z-index: 1000;
                display: none;
                float: left;
                min-width: 13rem;
                padding: 0.5rem 0;
                margin: 0.125rem 0 0;
                font-size: 1rem;
                color: #000000;
                text-align: left;
                list-style: none;
                background-color: #fff;
                background-clip: padding-box;
                border: 1px solid #e0e0ef;
                border-radius: 0.25rem;
            }

            #main, #footer {
                margin-left: 251px;
                background-color: #e9e9e9;
            }
            #main {
                margin-top: 60px;
                padding: 20px 30px;
                transition: all 0.3s;
                background-color: #e9e9e9;
            }
            .rept {
                width: 100%;
                gap: 55px;
            }
            .subm {
                margin-top: 0;
                padding: 10px 14px;
                background-color: #198754;
                color: #fff;
                font-size: 14px;
            }
            .top01 {
                position: relative;
                bottom: 40px;
            }
            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 30px;
                box-shadow: 0 0px 0px rgba(0, 0, 0, 0.1);
                border-radius: 8px;
                overflow: hidden;
            }
            th {
                background-color: #007bff00;
                color: #000000;
                font-weight: 600;
                text-transform: uppercase;
                font-size: 14px;
            }
        </style>
    </head>
    <body>
        <aside id="sidebar" class="sidebar" style=" position: fixed;">
            <ul class="sidebar-nav">
                <li class="nav-item mt-3">
                    <a class="nav-link" href="Dashboard">Dashboard</a> 
                </li>

                <li class="nav-item">
                    <a href="current" class="nav-link">Reports</a>
                </li>

                <li class="nav-item">
                    <a href="Logout" class="nav-link">Logout</a>
                </li>
            </ul>
        </aside>

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
        <main class="main" id="main">
            <h2 style="color: #333;">Quarterly Report</h2>

            <!-- Form to select start and end dates, and group by -->
            <form id="reportForm" class="rept">
                <div class="col-md-3 col-sm-3 col-xs-12">
                    <label for="environment">Reports</label>
                    <select class="form-select mt-2" onchange="window.location.href = this.value;">
                        <option value="quarterly">Quarterly Reports</option>
                        <option value="current">Current Day Reports</option>
                        <option value="previous">Previous Day Reports</option>
                        <option value="BiWeekly">Bi Weekly Reports</option>
                        <option value="month">Month Wise Reports</option>
                    </select>
                </div>
                <div class="col-md-2 col-sm-2 col-xs-12">
                    <label for="startDate">Start Date:</label>
                    <input type="date" id="startDate" name="startDate" required>
                </div>

                <div class="col-md-2 col-sm-2 col-xs-12">
                    <label for="endDate">End Date:</label>
                    <input type="date" id="endDate" name="endDate" required>
                </div>

                <div class="col-md-3 col-sm-3 col-xs-12">
                    <label for="groupBy">Group By:</label>
                    <select id="groupBy" name="groupBy" required>
                        <option value="none">None</option>
                        <option value="date">Quarterly Period</option>
                        <option value="username">Username</option>
                    </select>
                </div>

                <div class="col-md-2 col-sm-2 col-xs-12 top01">
                    <button class="subm" type="submit">Submit</button>
                </div>
            </form>

            <!-- Download Buttons -->
            <div class="download-buttons">
                <button id="exportExcel"class="btn btn-primary"><i class="fas fa-file-excel"></i> Export to Excel</button>
                <button id="exportCSV"class="btn btn-secondary"><i class="fas fa-file-csv"></i> Export to CSV</button>
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
        </main>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
        <script>
                        // Function to get the default start and end date for the current quarter based on financial year
                        function getQuarterDates() {
                            const now = new Date();
                            const currentMonth = now.getMonth(); // 0 = January, 11 = December
                            const currentYear = now.getFullYear();
                            let startDate, endDate;

                            // Adjust based on financial year starting from April 1st
                            if (currentMonth >= 0 && currentMonth <= 2) { // Q4: Jan 1 - Mar 31
                                startDate = new Date(currentYear, 0, 1); // Start date for Q4 (Jan 1)
                                endDate = new Date(currentYear, 2, 31);  // End date for Q4 (Mar 31)
                            } else if (currentMonth >= 3 && currentMonth <= 5) { // Q1: Apr 1 - Jun 30
                                startDate = new Date(currentYear, 3, 1); // Start date for Q1 (Apr 1)
                                endDate = new Date(currentYear, 5, 30);  // End date for Q1 (Jun 30)
                            } else if (currentMonth >= 6 && currentMonth <= 8) { // Q2: Jul 1 - Sep 30
                                startDate = new Date(currentYear, 6, 1); // Start date for Q2 (Jul 1)
                                endDate = new Date(currentYear, 8, 30);  // End date for Q2 (Sep 30)
                            } else { // Q3: Oct 1 - Dec 31
                                startDate = new Date(currentYear, 9, 1); // Start date for Q3 (Oct 1)
                                endDate = new Date(currentYear, 11, 31); // End date for Q3 (Dec 31)
                            }

                            // Convert dates to yyyy-mm-dd format for input fields
                            const formatDate = (date) => {
                                return date.getFullYear() + "-" +
                                        String(date.getMonth() + 1).padStart(2, "0") + "-" +
                                        String(date.getDate()).padStart(2, "0");
                            };

                            const startDateStr = formatDate(startDate);
                            const endDateStr = formatDate(endDate);

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

                            const startDate = $('#startDate').val();
                            const endDate = $('#endDate').val();
                            const groupBy = $('#groupBy').val();

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

                                        let totalTotal = 0;
                                        let totalSuccess = 0;

                                        // Populate table with data based on groupBy option
                                        data.forEach(function (item) {
                                            const row = $('<tr>');

                                            // Handle different groupBy cases
                                            if (groupBy === "none" || groupBy === "username") {
                                                row.append($('<td>').text(item.Username));
                                            }

                                            if (groupBy === "none" || groupBy === "date") {
                                                row.append($('<td>').text(item.Quarterly_Period));
                                            }

                                            // Add Total and Success columns
                                            row.append(
                                                    $('<td>').text(item.Total),
                                                    $('<td>').text(item.Success)
                                                    );

                                            // Update totals
                                            totalTotal += item.Total;
                                            totalSuccess += item.Success;

                                            $('#reportTable tbody').append(row);
                                        });

                                        // Add total row with highlighting
                                        const totalRow = $('<tr>').addClass('total-row');

                                        // Add "Total" label in the correct column based on groupBy
                                        if (groupBy === "none") {
                                            totalRow.append($('<td>').text('Total').addClass('highlight'));
                                            totalRow.append($('<td>').text('').addClass('highlight')); // Empty cell for Quarterly Period
                                        } else if (groupBy === "date") {
                                            totalRow.append($('<td>').text('Total').addClass('highlight')); // "Total" label in the first column
                                        } else if (groupBy === "username") {
                                            totalRow.append($('<td>').text('Total').addClass('highlight'));
                                        }

                                        // Add Total and Success values
                                        totalRow.append(
                                                $('<td>').text(totalTotal).addClass('highlight'),
                                                $('<td>').text(totalSuccess).addClass('highlight')
                                                );

                                        $('#reportTable tbody').append(totalRow);

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
                            const table = document.getElementById('reportTable');
                            const workbook = XLSX.utils.table_to_book(table, {sheet: "Sheet1"});
                            XLSX.writeFile(workbook, 'QuarterlyReport.xlsx');
                        });

                        // Function to export table data to CSV
                        $('#exportCSV').on('click', function () {
                            const table = document.getElementById('reportTable');
                            const rows = table.querySelectorAll('tr');
                            const csv = [];

                            // Extract headers
                            const headers = [];
                            table.querySelectorAll('th').forEach(function (th) {
                                headers.push(th.innerText);
                            });
                            csv.push(headers.join(','));

                            // Extract rows
                            rows.forEach(function (row) {
                                const rowData = [];
                                row.querySelectorAll('td').forEach(function (td) {
                                    rowData.push(td.innerText);
                                });
                                csv.push(rowData.join(','));
                            });

                            // Create CSV file
                            const csvContent = "data:text/csv;charset=utf-8," + csv.join('\n');
                            const encodedUri = encodeURI(csvContent);
                            const link = document.createElement('a');
                            link.setAttribute('href', encodedUri);
                            link.setAttribute('download', 'QuarterlyReport.csv');
                            document.body.appendChild(link);
                            link.click();
                            document.body.removeChild(link);
                        });
        </script>
    </body>
</html>
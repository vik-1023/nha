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

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">


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
                margin: 93px auto;
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
                gap: 50px;

            }

            form > div {
                flex: 1;
                min-width: 180px;
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
                background-color: #007bff;
                color: #ffffff;
                padding: 12px 24px;
                font-size: 16px;
                font-weight: 500;
                border: none;
                border-radius: 6px;
                cursor: pointer;
                transition: background-color 0.3s ease, transform 0.2s ease;
                margin-top: 25px;
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

                padding: 10px 20px;
                font-size: 14px;
                font-weight: 500;
                border: none;
                border-radius: 6px;
                cursor: pointer;
                transition: background-color 0.3s ease, transform 0.2s ease;
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

                color: black;
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
                padding:10px;
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
            .rept {
                gap: 0px;
            }
            .subm {
                margin-top: 0;
                padding: 10px 14px;
                background-color: #198754;
                color: #fff;
                font-size: 14px;
                margin-top:20px;
            }
            .subm:hover {
                background-color: #198754;
                color: #fff;
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
            <h2 style="color: #333;"> Bi-Weekly Report</h2>
            <!-- Form to select start and end dates, and group by -->
            <form id="reportForm" class="rept">
                <div class="col-md-3 col-sm-3 col-xs-12">
                    <label for="environment">Reports</label>
                    <select class="form-select" onchange="window.location.href = this.value;" style="width: 200px;">
                        <option value="BiWeekly">Bi Weekly Reports</option>
                        <option value="current">Current Day Reports</option>
                        <option value="previous">Previous Day Reports</option>

                        <option value="month">Month Wise Reports</option>
                        <option value="quarterly">Quarterly Reports</option>
                    </select>
                </div>
                <div class="col-md-3 col-sm-3 col-xs-12">
                    <label for="startDate">Start Date:</label>
                    <input type="date" id="startDate" name="startDate" required style="width: 200px;">
                </div>
                <div class="col-md-3 col-sm-3 col-xs-12">
                    <label for="endDate">End Date:</label>
                    <input type="date" id="endDate" name="endDate" required style="width: 200px;">
                </div>

                <div class="col-md-3 col-sm-3 col-xs-12">
                    <label for="groupBy">Group By:</label>
                    <select id="groupBy" name="groupBy" required >
                        <option value="none">None</option>
                        <option value="username">Username</option>
                        <option value="biweeklyPeriod">Biweekly Period</option>
                    </select>
                </div>
                <div class="col-md-2 col-sm-2 col-xs-12">
                    <button class="subm" type="submit">Submit</button>
                </div>
            </form>

            <!-- Download Buttons -->
            <div class="download-buttons">
                <button id="exportExcel" class="btn btn-primary"><i class="fas fa-file-excel"></i> Export to Excel</button>
                <button id="exportCSV" class="btn btn-secondary"><i class="fas fa-file-csv"></i> Export to CSV</button>
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
        </main>

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
        console.log("Start Date: ", startDate);
console.log("End Date: ", endDate);

        // Set the default values in the date inputs
        $("#startDate").val(startDate);
        $("#endDate").val(endDate);

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
                dataType: 'json', // Expect JSON response
                success: function (response) {
                    // Hide loading spinner
                    $('#spinner').hide();

                    // Check if the response is an array
                    if (Array.isArray(response)) {
                        // Show the table after data is loaded
                        $('#reportTable').show();

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

                        // Variables to calculate totals
                        let totalTotal = 0;
                        let totalSuccess = 0;

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

                            // Update totals
                            totalTotal += parseInt(row.Total, 10);
                            totalSuccess += parseInt(row.Success, 10);
                        });

                        // Add the total row
                        var totalRow = "<tr style='font-weight: bold;'>";

                        // Merge the username and biweekly period columns for the total row
                        if (groupBy === "none") {
                            totalRow += "<td colspan='2'>Total</td>"; // Merge two columns
                        } else if (groupBy === "username" || groupBy === "biweeklyPeriod") {
                            totalRow += "<td>Total</td>"; // Merge one column
                        }

                        // Add the total values
                        totalRow += "<td>" + totalTotal + "</td>" +
                                "<td>" + totalSuccess + "</td>" +
                                "</tr>";

                        $("#reportTable tbody").append(totalRow);
                    } else {
                        $('#errorMessage').text('Invalid response format. Expected an array.');
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
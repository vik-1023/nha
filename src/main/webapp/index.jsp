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
<html>
    <head>


        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>VNS | NHA</title>

 
        <!-- Google Fonts -->
        <link href="https://fonts.gstatic.com" rel="preconnect">
        <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,300i,400,400i,600,600i,700,700i|Nunito:300,300i,400,400i,600,600i,700,700i|Poppins:300,300i,400,400i,500,500i,600,600i,700,700i" rel="stylesheet">

        <!-- Vendor CSS Files -->
        <link href="assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
        <link href="assets/vendor/bootstrap-icons/bootstrap-icons.css" rel="stylesheet">
        <link href="assets/vendor/boxicons/css/boxicons.min.css" rel="stylesheet">
        <link href="assets/vendor/quill/quill.snow.css" rel="stylesheet">
        <link href="assets/vendor/quill/quill.bubble.css" rel="stylesheet">
        <link href="assets/vendor/remixicon/remixicon.css" rel="stylesheet">
        <link href="assets/vendor/simple-datatables/style.css" rel="stylesheet">

        <!-- Template Main CSS File -->
        <link href="assets/css/style.css" rel="stylesheet">


        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

        <!-- Include SheetJS for Excel export -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js"></script>

        <!-- Include FontAwesome for icons -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

        <script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js"></script>

        <!-- Include SweetAlert for confirmation dialogs -->
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

        <!-- Include FontAwesome for icons -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

        <style>
            .logo-container {
                display: flex;
                align-items: center; /* Align elements vertically */
                position: relative;
            }

            .nha-title {
                font-size: 28px; /* Adjust font size */
                font-weight: bold;
                color: #333; /* Customize color */

                position: absolute;
                left: 50%;
                transform: translateX(-50%);
            }

            .nha-logo {
                width: 180px; /* Adjust logo size */
                height: auto;
            }





            .loader {
                position: fixed; /* Fixed position to center it on the screen */
                top: 50%; /* Center vertically */
                left: 50%; /* Center horizontally */
                transform: translate(-50%, -50%); /* Adjust for exact center */
                z-index: 1000; /* Ensure it's above other elements */
                display: none; /* Initially hidden */
            }

            /* Optional: Add a semi-transparent overlay */
            .loader-overlay {
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(255, 255, 255, 0.8); /* Semi-transparent white */
                z-index: 999; /* Below the loader but above other content */
                display: none; /* Initially hidden */
            }

            .spinner-border {
                width: 3rem;
                height: 3rem;
            }

            .nha-logo {
                width: 100px; /* Adjust the size as needed */
                height: auto; /* Maintain aspect ratio */
            }




            /* Basic Reset */
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            /* Sticky Header */
            .header {
                background-color: #fff;
                padding: 10px 20px;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                position: fixed;
                top: 0;
                left: 250px; /* Shift header to the right by sidebar width */
                width: calc(100% - 250px); /* Adjust width to account for sidebar */
                z-index: 999; /* Ensure header is below sidebar */
                transition: left 0.3s ease;
            }

            .menu-icon {
                font-size: 24px;
                cursor: pointer;
                margin-right: 20px;
            }



            /* Main Content (Shifted to the right by default) */
            .main {
                margin-left: 250px; /* Shift main content to the right */
                padding: 20px;
                transition: margin-left 0.3s ease;
            }

            /* Footer */
            .footer {
                background-color: #f8f9fa;
                padding: 20px;
                text-align: center;
                position: fixed;
                bottom: 0;
                width: calc(100% - 250px); /* Adjust width to account for sidebar */
                margin-left: 250px; /* Shift footer to the right */
                transition: margin-left 0.3s ease;
            }



            /* General sidebar styling */
            .sidebar {
                width: 250px; /* Set the width of the sidebar */
                height: 100vh; /* Full height */
                background-color: #2c3e50; /* Dark background color */
                color: #ecf0f1; /* Light text color */
                position: fixed; /* Fixed position */
                top: 0;
                left: 0;
                overflow-x: hidden; /* Hide horizontal scrollbar */
                padding-top: 20px; /* Add some padding at the top */
                box-shadow: 2px 0 5px rgba(0, 0, 0, 0.1); /* Add a shadow for depth */
            }

            /* Sidebar navigation list */
            .sidebar-nav {
                list-style-type: none; /* Remove bullet points */
                padding: 0;
                margin: 0;
            }

            /* Navigation item styling */
            .nav-item {
                width: 100%;
                margin: 10px 0;
            }

            /* Navigation link styling */
            .nav-link {
                display: block;
                padding: 10px 20px;
                color: #ecf0f1; /* Light text color */
                text-decoration: none; /* Remove underline */
                font-size: 16px;
                transition: background-color 0.3s, color 0.3s; /* Smooth transition */
            }

            /* Hover effect for links */
            .nav-link:hover {
                background-color: #34495e; /* Slightly lighter background on hover */
                color: #1abc9c; /* Highlight color */
            }

            /* Active link styling */
            .nav-link.active {
                background-color: #1abc9c; /* Highlight color for active link */
                color: #fff; /* White text for active link */
            }

            /* Responsive design for smaller screens */
            @media (max-width: 768px) {
                .sidebar {
                    width: 100%; /* Full width on smaller screens */
                    height: auto; /* Auto height */
                    position: relative; /* Relative position */
                }

                .nav-item {
                    text-align: center; /* Center align items */
                }
            }

        </style>
    </head>
    <%
        // Get the current date in YYYY-MM-DD format
        java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
        String currentDate = sdf.format(new java.util.Date());
    %>
    <body




        <!-- ======= Header ======= -->
        <aside id="sidebar" class="sidebar">
            <ul class="sidebar-nav">
                <li class="nav-item mt-3">
                    <a class="nav-link" href="Dashboard">Dashboard</a>
                </li>
                <li class="nav-item mt-3">
                    <a class="nav-link" href="current">Current Day Reports</a>
                </li>
                <li class="nav-item mt-3">
                    <a class="nav-link" href="previous">Previous Day Reports</a>
                </li>
                <li class="nav-item mt-3">
                    <a class="nav-link" href="month">Month Wise Reports</a>
                </li>

                <li class="nav-item mt-3">
                    <a href="Logout" class="btn btn-danger nav-link">Logout</a>
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
                <img id="LoginLogoPage_1" src="https://app.virtuosorbm.com/assets/img/logo.png" style="width:60%;">
            </div>


        </header>


        <main id="main" class="main">
            <!-- Logo and Title -->
            <div class="d-flex justify-content-between align-items-center mt-3 logo-container">
                <h3 class="nha-title mx-auto">NHA Current Day Reports</h3> 
                <img src="https://abdm.gov.in:8081/uploads/NHA_logo_hd_3099160d92.svg" 
                     alt="National Health Authority" class="nha-logo">
            </div>

            <!-- Loader Overlay -->
            <div id="loader-overlay" class="loader-overlay"></div>

            <!-- Loader -->
            <div id="loader" class="loader">
                <div class="spinner-border text-primary" role="status">
                    <span class="visually-hidden">Loading...</span>
                </div>
            </div>

            <%
                try {
                    dbcon db = new dbcon();
                    db.getCon("nha_cdr");
                    String sql = "SELECT accountname FROM AccountDetails WHERE Setup = '-1';";
                    ResultSet rs = db.getResult(sql);
            %>
            <section class="section dashboard mt-5">
                <form id="dataForm" action="/action_page.php" method="POST">
                    <div class="row">
                        <div class="col-md-3 col-sm-3 col-xs-12">
                            <label for="environment">Environment</label>
                            <select class="form-select mt-2" id="environment" name="environment">
                                <option value="production">Production</option>
                                <option value="sandbox">Sandbox</option>
                            </select>
                        </div>
                        <!-- Username Dropdown -->
                        <div class="col-md-3 col-sm-3 col-xs-12">
                            <label for="accountname">Username</label>
                            <select class="form-select mt-2" id="accountname" name="accountname">
                                <%
                                    while (rs.next()) {
                                        String accountname = rs.getString("accountname");
                                %>
                                <option value="<%= accountname%>"><%= accountname%></option>
                                <%
                                    }
                                %>
                            </select>
                        </div>

                        <!-- From Date Input -->
                        <div class="col-md-3 col-sm-3 col-xs-12">
                            <label for="fromDate">From</label>
                            <input class="form-control mt-2" type="date" id="fromDate" name="fromDate" value="<%= currentDate%>" min="<%= currentDate%>" max="<%= currentDate%>">
                        </div>

                        <!-- To Date Input -->
                        <div class="col-md-3 col-sm-3 col-xs-12">
                            <label for="toDate">To</label>
                            <input class="form-control mt-2" type="date" id="toDate" name="toDate" value="<%= currentDate%>" min="<%= currentDate%>" max="<%= currentDate%>">
                        </div>

                        <!-- Submit and Export Buttons -->
                        <div class="col-md-12 col-sm-12 col-xs-12 mt-5 d-flex justify-content-between">
                            <div>
                                <button type="button" onclick="getData()" class="btn btn-success">Submit</button>
                            </div>
                            <div>
                                <button id="excelBtn" type="button" onclick="exportToExcel()" class="btn btn-primary" disabled>
                                    <i class="fas fa-file-excel"></i> Export to Excel
                                </button>
                                <button id="csvBtn" type="button" onclick="exportToCSV()" class="btn btn-secondary" disabled>
                                    <i class="fas fa-file-csv"></i> Export to CSV
                                </button>
                            </div>
                        </div>
                    </div>
                </form>

                <!-- Table to display data -->
                <div class="row mt-4">
                    <div class="col-md-12 text-center">
                        <table id="dataTable" class="table table-striped table-bordered" style="display: none;">
                            <thead>
                                <tr>
                                    <th>Date</th>
                                    <th>Username</th>
                                    <th>Total</th>
                                    <th>Success</th>
                                    <th>Failed</th>
                                </tr>
                            </thead>
                            <tbody>
                                <!-- Data will be populated here by JavaScript -->
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Chart Canvas -->
                <div class="row mt-4">
                    <div class="col-md-12">
                        <canvas id="dataChart" width="400" height="200"></canvas>
                    </div>
                </div>
            </section>
            <%
                } catch (Exception e) {
                    e.printStackTrace();
                }
            %>
        </main>

        <div id="loader" class="loader" style="display: none;">
            <div class="spinner-border text-primary " role="status">
                <span class="visually-hidden">Loading...</span>
            </div>
        </div>
        <!-- ======= Footer ======= -->
        <footer id="footer" class="footer">
            <div class="copyright">
                &copy; Copyright <strong><span>VNS</span></strong>. All Rights Reserved
            </div>

        </footer><!-- End Footer -->

        <a href="#" class="back-to-top d-flex align-items-center justify-content-center"><i class="bi bi-arrow-up-short"></i></a>


        <!-- Template Main JS File -->



        <script>
            function getData() {
                // Show loader
                document.getElementById('loader').style.display = 'block';

                // Get form values
                const accountname = document.getElementById('accountname').value;
                const fromDate = document.getElementById('fromDate').value;
                const toDate = document.getElementById('toDate').value;
                const environment = document.getElementById('environment').value;

                // Prepare the data as a simple URL-encoded string
                const data = 'accountname=' + encodeURIComponent(accountname) +
                        '&fromDate=' + encodeURIComponent(fromDate) +
                        '&toDate=' + encodeURIComponent(toDate) +
                        "&environment=" + encodeURIComponent(environment);

                // Send AJAX request using fetch
                fetch('NhaServlet', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: data // Send data as URL-encoded string
                })
                        .then(response => {
                            if (!response.ok) {
                                throw new Error('Network response was not ok');
                            }
                            return response.json(); // Parse the JSON response
                        })
                        .then(data => {
                            console.log("Response from servlet:", data);
                            if (data.length === 0) {
                                // No records found
                                Swal.fire({
                                    icon: 'info',
                                    title: 'No Records Found',
                                    text: 'No data was found for the given criteria.',
                                });
                            } else {
                                updateTable(data); // Update the table with the response data
                            }
                            // Enable export buttons
                            document.getElementById('excelBtn').disabled = false;
                            document.getElementById('csvBtn').disabled = false;
                        })
                        .catch(error => {
                            console.error('Error:', error);
                            Swal.fire({
                                icon: 'error',
                                title: 'Error',
                                text: 'An error occurred while fetching data.',
                            });
                        })
                        .finally(() => {
                            // Hide loader after completion
                            document.getElementById('loader').style.display = 'none';
                        });
            }

            function updateTable(data) {
                const tableBody = document.querySelector("#dataTable tbody");
                tableBody.innerHTML = ""; // Clear existing table data

                data.forEach(item => {
                    const row = document.createElement("tr");

                    // Add Date cell
                    const dateCell = document.createElement("td");
                    dateCell.textContent = item.date; // Ensure 'date' is in the JSON response
                    row.appendChild(dateCell);

                    // Add Username cell
                    const usernameCell = document.createElement("td");
                    usernameCell.textContent = item.username;
                    row.appendChild(usernameCell);

                    // Add Total cell
                    const totalCell = document.createElement("td");
                    totalCell.textContent = item.total;
                    row.appendChild(totalCell);

                    // Add Success cell
                    const successCell = document.createElement("td");
                    successCell.textContent = item.success;
                    row.appendChild(successCell);

                    // Add Failed cell
                    const failedCell = document.createElement("td");
                    failedCell.textContent = item.failed;
                    row.appendChild(failedCell);

                    // Append the row to the table body
                    tableBody.appendChild(row);
                });

                // Show the table
                document.getElementById('dataTable').style.display = 'table';
            }

            // Export to Excel
            function exportToExcel() {
                const table = document.getElementById("dataTable");
                const rows = table.querySelectorAll("tbody tr");
                const username = document.getElementById('accountname').value || "All";
                const environment = document.getElementById('environment').value || "Default";
                const filename = username + "_" + environment + ".xlsx";
                if (rows.length === 0) {
                    // Ask for confirmation if the table is empty
                    Swal.fire({
                        icon: 'question',
                        title: 'Empty Table',
                        text: 'The table is empty. Do you want to download an empty sheet?',
                        showCancelButton: true,
                        confirmButtonText: 'Yes',
                        cancelButtonText: 'No',
                    }).then((result) => {
                        if (result.isConfirmed) {
                            const workbook = XLSX.utils.table_to_book(table, {sheet: "Sheet1"});
                            XLSX.writeFile(workbook, filename);
                        }
                    });
                } else {
                    const workbook = XLSX.utils.table_to_book(table, {sheet: "Sheet1"});
                    XLSX.writeFile(workbook, filename);
                }
            }

            // Export to CSV
            function exportToCSV() {
                const table = document.getElementById("dataTable");
                const rows = table.querySelectorAll("tbody tr");
                const username = document.getElementById('accountname').value || "All";
                const environment = document.getElementById('environment').value || "Default";
                const filename = username + "_" + environment + ".csv";

                if (rows.length === 0) {
                    // Ask for confirmation if the table is empty
                    Swal.fire({
                        icon: 'question',
                        title: 'Empty Table',
                        text: 'The table is empty. Do you want to download an empty sheet?',
                        showCancelButton: true,
                        confirmButtonText: 'Yes',
                        cancelButtonText: 'No',
                    }).then((result) => {
                        if (result.isConfirmed) {
                            const csvContent = getCSVContent(table);
                            downloadCSV(csvContent, filename);
                        }
                    });
                } else {
                    const csvContent = getCSVContent(table);
                    downloadCSV(csvContent, filename);
                }
            }

            // Helper function to generate CSV content
            function getCSVContent(table) {
                const rows = table.querySelectorAll("tr");
                let csvContent = "";

                rows.forEach(row => {
                    const rowData = [];
                    row.querySelectorAll("th, td").forEach(cell => {
                        rowData.push(cell.innerText);
                    });
                    csvContent += rowData.join(",") + "\n";
                });

                return csvContent;
            }

            // Helper function to download CSV
            function downloadCSV(content, fileName) {
                const blob = new Blob([content], {type: "text/csv;charset=utf-8;"});
                const link = document.createElement("a");
                link.href = URL.createObjectURL(blob);
                link.download = fileName;
                link.click();
            }
        </script>


        <script>
            document.addEventListener('DOMContentLoaded', function () {
                // Select the logout button
                const logoutButton = document.querySelector('a[href="Logout"]');

                // Add click event listener to the logout button
                logoutButton.addEventListener('click', function (event) {
                    event.preventDefault(); // Prevent the default link behavior

                    // Show SweetAlert confirmation popup
                    Swal.fire({
                        title: 'Are you sure?',
                        text: 'You are about to log out. Do you want to continue?',
                        icon: 'warning',
                        showCancelButton: true,
                        confirmButtonColor: '#3085d6',
                        cancelButtonColor: '#d33',
                        confirmButtonText: 'Yes, log out!',
                        cancelButtonText: 'Cancel'
                    }).then((result) => {
                        if (result.isConfirmed) {
                            // Redirect to the logout URL if confirmed
                            window.location.href = logoutButton.href;
                        }
                    });
                });
            });
        </script>

        <!-- SweetAlert2 CSS -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">

        <!-- SweetAlert2 JS -->
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

        <a href="#" class="back-to-top d-flex align-items-center justify-content-center">
            <i class="bi bi-arrow-up-short"></i>
        </a>




    </body>
</html>
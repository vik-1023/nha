<%@page import="java.util.Date"%>


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
        <!-- Required meta tags -->
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>VNS | NHA</title>
        <!-- plugins:css -->
        <link rel="stylesheet" href="vendors/iconfonts/font-awesome/css/all.min.css">
        <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
        <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
        <link rel="stylesheet" href="css/style.css">
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <style>
            @media (min-width: 768px) {
                .dropdown:hover .dropdown-menu {
                    display: block;
                    margin-top: 0;
                }
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




            /* Sidebar Styles */
            .sidebar {
                width: 250px;
                height: 100vh;
                background-color: #2c3e50;
                position: absolute;
                top: 70px;
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
                padding: 10px 20px;
            }

            .sidebar-nav .nav-link {
                text-decoration: none;
                font-size: 16px;
                display: block;
                color: #000000;
                background-color: #fff;
                border-radius: 2px;
            }

            .sidebar-nav .nav-link:hover {
                background-color: #fff;
                color:#000;
            }

            .main-content {
                margin-left: 250px;
                padding: 20px;
                transition: margin-left 0.3sease;
                background-color: #ebebeb;
            }

            @media (max-width: 768px) {
                .sidebar {
                    left: -250px;
                }

                .sidebar.active {
                    left: 0;
                }

                .main-content {
                    margin-left: 0;
                }
            }

            .statistics-item {
                flex: 1;

                padding: 15px;
                margin: 10px;
                background: #f9f9f9;
                border-radius: 10px;
                text-align: center;
            }

            .statistics-item p {
                font-size: 15px;
                color: #555;
                margin-bottom: 5px;
                font-weight: bold;
            }

            .statistics-item .icon {
                font-size: 16px;
                margin-bottom: 10px;
            }

            .total-icon {
                color: #FF5733; /* Example red color for 'Total' */
            }

            .success-icon {
                color: #4CAF50; /* Example green color for 'Success' */
            }

            .mt-5 {
                background: linear-gradient(85deg, #392c70, #6a005b);
                color: #ffffff;
                border-radius: 4px;
                margin-top: 0px !important;
                padding-top: 0px;
            }

            .hidden {
                display: none !important;
            }

            .visible {
                display: block !important;
            }


            .circle-value {
                color: #333;
                font-size: 24px;
                font-weight: bold;
            }

            .shadow {
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                border-radius: 8px;
                transition: transform 0.3s ease, box-shadow 0.3s ease;
            }

            .shadow:hover {
                box-shadow: 0 6px 12px rgba(0, 0, 0, 0.2);
                transform: translateY(-5px);
            }

            .shadow-animate {
                animation: fadeInUp 0.5s ease-in-out;
            }

            @keyframes fadeInUp {
                from {
                    opacity: 0;
                    transform: translateY(20px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            /* Loader Styles */
            .loader-overlay {
                position: fixed;
                top: 0;
                left: 0;
                width: 100vw;
                height: 100vh;
                background-color: rgba(255, 255, 255, 0.8);
                display: flex;
                justify-content: center;
                align-items: center;
                z-index: 999;
                display: none; /* Initially hidden */
            }

            .loader {
                border: 8px solid #f3f3f3;
                border-top: 8px solid #3498db;
                border-radius: 50%;
                width: 50px;
                height: 50px;
                animation: spin 2s linear infinite;
            }

            @keyframes spin {
                0% {
                    transform: rotate(0deg);
                }
                100% {
                    transform: rotate(360deg);
                }
            }

            .logo-container {
                background-color: #ffffff;
                border-bottom: 1px solid #ccc;
                padding-top: 10px;
                padding-bottom: 11px;
            }




            .card {
                border-radius: 12px;
                background: #ffffff;
                padding: 20px;
                box-shadow: 2px 4px 10px rgba(0, 0, 0, 0.1);
            }

            .card-header {
                background: #f8f9fa;
                border-radius: 10px 10px 0 0;
                padding: 12px;
                font-size: 16px;
                font-weight: 600;
            }
            .mb-20 {
                margin-bottom: 60px;
            }
            .chart-container {
                width: 100%;
                height: 250px; /* Set a fixed height for consistency */
                display: flex;
                justify-content: center; /* Center align the chart */
                align-items: center;
            }


            @media (max-width: 768px) {
                .chart-container {
                    height: 300px;
                }
            }
            .footer {
                background-color: #f8f9fa;
                padding: 20px;
                text-align: center;
                position: fixed;
                bottom: 0;
                width: calc(100% - 250px); /* Adjust width to account for sidebar */
                margin-left: 240px;
                /* Shift footer to the right */
                transition: margin-left 0.3s ease;
            }
        </style>
    </head>
    <body>
        <!-- Sidebar -->
        <aside id="sidebar" class="sidebar">
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
        <div class="d-flex justify-content-between align-items-center logo-container">
            <!-- Left Logo -->
            <div class="left-logo">
                <img id="LoginLogoPage_1" src="https://app.virtuosorbm.com/assets/img/logo.png" style="width:55%; margin-top: 10px;">
            </div>

            <!-- NHA Dashboard Title -->
            <div class="nha-title">
                <h3>NHA Reports</h3>
            </div>

            <!-- Right Logo -->
            <div class="right-logo">
                <img src="https://abdm.gov.in:8081/uploads/NHA_logo_hd_3099160d92.svg" alt="National Health Authority" class="nha-logo">
            </div>
        </div>
        <!-- Main Content -->
        <div class="main-content" id="main-content">

            <div class="container">

                <div class="row grid-margin mt-5">

                    <div class="col-md-6 col-sm-3 col-xs-12">
                        <div class="statistics-item text-center shadow-animate total">
                            <p><i class="fas fa-envelope-open icon total-icon"></i>TOTAL</p>
                            <h2 id="counter-total-pro" class="circle-value counter" data-target="0">0</h2>
                        </div>
                    </div>
                    <div class="col-md-6 col-sm-3 col-xs-12">
                        <div class="statistics-item text-center shadow-animate total">
                            <p><i class="fas fa-paper-plane icon success-icon"></i>SUCCESS</p>
                            <h2 id="counter-success-pro" class="circle-value counter" data-target="0">0</h2>
                        </div>
                    </div>
                </div>

                <div id="UserWiseDropdown">
                    <label for="graph">Department Wise Graph</label>
                    <select class="form-control" id="graph" name="graph" style="width: 150px;" onchange="fetchGraphData(this.value)">
                        <option value="ABDM and PMJAY">ABDM and PMJAY</option>
                        <option value="PMJAY">PMJAY Accounts</option>
                        <option value="ABDM">ABDM Accounts</option>
                    </select>
                </div>

                <div class="card-header text-center">
                    <h5 class="mb-0 font-weight-bold">Overview of Total Submission Delivered Count</h5>

                </div>


                <div class="card-body">
                    <div class="row" id="adminChart">
                        <div class="col-4" id="total_chart">
                            <div id="totalCount" style="display: none;">
                                <canvas id="totalCountChart" style="height: 160px; width: 160px;"></canvas>
                            </div>
                        </div>
                        <div class="col-4" id="abdm_chart">
                            <div id="totalCountAbdm" style="display: none;">
                                <canvas id="totalCountAbdmChart" style="height: 160px; width: 160px;"></canvas>
                            </div>
                        </div>

                        <div class="col-4" id="pmjay_chart">
                            <div id="totalPmjay" style="display: none;">
                                <canvas id="totalPmjayChart" style="height: 160px; width: 160px;"></canvas>
                            </div> 
                        </div>


                    </div>



                    <div class="row" id="userChart">
                        <div class="col-12">
                            <canvas id="graph-chart" style="height: 400px; width: 200px;"></canvas>

                        </div>
                    </div>
                </div>
            </div>
        </div>









        <footer id="footer" class="footer">
            <div class="copyright">
                &copy; Copyright <strong><span>VNS</span></strong>. All Rights Reserved
            </div>

        </footer>


        <!-- Loader Overlay -->
        <div id="loader-overlay" class="loader-overlay">
            <div class="loader"></div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script type="text/javascript">
                        google.charts.load('current', {'packages': ['bar']});
                        google.charts.setOnLoadCallback(drawCharts);

                        function drawCharts() {
                            drawMonthWiseData();
                            drawCurrentDayData();
                            drawPreviousDayData();
                        }

                        // Month-wise data chart (example with monthly sales data)
                        function drawMonthWiseData() {
                            // Fetch data from the servlet
                            fetch('NhaServletChart')
                                    .then(response => response.json())
                                    .then(data => {
                                        // Process the data and create the DataTable
                                        var chartData = [['Date', 'Total', 'Success']];
                                        data.forEach(row => {
                                            var parts = row.date.split('-'); // Ensure the format is YYYY-MM-DD
                                            if (parts.length === 3) {
                                                var day = parts[2].padStart(2, '0'); // Ensure two-digit day
                                                var month = parts[1].padStart(2, '0'); // Ensure two-digit month
                                                var formattedDate = day + "-" + month;

                                                // Format as DD-MM

                                                chartData.push([formattedDate, parseInt(row.total), parseInt(row.success)]);
                                            }
                                        });

                                        var dataTable = google.visualization.arrayToDataTable(chartData);

                                        var options = {
                                            chart: {
                                                title: 'User Counts',
                                                subtitle: 'Total, Success, by Date',
                                            },
                                            bars: 'vertical',
                                            vAxis: {format: 'decimal'},
                                            height: 300,
                                            series: {
                                                0: {color: '#FF5733'}, // Color for 'Total' (e.g., red)
                                                1: {color: '#4CAF50'}, // Color for 'Success' (e.g., green)
                                            },
                                        };

                                        var chart = new google.charts.Bar(document.getElementById('monthWiseData'));
                                        chart.draw(dataTable, google.charts.Bar.convertOptions(options));
                                    })
                                    .catch(error => {
                                        console.error('Error fetching data:', error);
                                    });
                        }


</script>




<script type="text/javascript">
    // Function to draw Total Submitted Count chart
    function drawTotalSubmittedData() {
        fetch('Total_Submitted_Count_Admin')
                .then(response => response.json())
                .then(data => {
                    const total = data.totalsBoth.TotalSum;
                    const success = data.totalsBoth.SuccessSum;
                    var userType = data.userType;

                    // Toggle visibility based on userType
                    document.getElementById("totalCount").style.display = userType === "admin" ? "block" : "none";
                    document.getElementById("totalCountAbdm").style.display = (userType === "ABDM" || userType === "admin") ? "block" : "none";
                    document.getElementById("totalPmjay").style.display = (userType === "PMJAY" || userType === "admin") ? "block" : "none";

                    // Chart data
                    var chartData = {
                        labels: ['Total', 'Success'],
                        datasets: [{
                                label: 'Count',
                                data: [total, success],
                                backgroundColor: ['#FF5733', '#4CAF50'],
                                borderColor: ['#FF5733', '#4CAF50'],
                                borderWidth: 1
                            }]
                    };

                    // Chart options
                    var options = {
                        responsive: true,
                        plugins: {
                            legend: {
                                display: false
                            },
                            title: {
                                display: true,
                                text: 'Total Submitted Count'
                            }
                        },
                        scales: {
                            x: {
                                stacked: true, // Stack the bars
                                title: {
                                    display: true,
                                    text: 'Counts'
                                },
                                barPercentage: 0.4, // Control the width of the bars
                                categoryPercentage: 0.1, // Control space between the bars
                            },
                            y: {
                                beginAtZero: true,
                                stacked: true, // Stack bars on Y-axis
                                title: {
                                    display: true,
                                    text: 'Count'
                                }
                            }
                        },
                        layout: {
                            padding: {
                                left: 20,
                                right: 20,
                                top: 20,
                                bottom: 20
                            }
                        }
                    };

                    // Create the chart
                    var ctx = document.getElementById('totalCountChart').getContext('2d');
                    new Chart(ctx, {
                        type: 'bar',
                        data: chartData,
                        options: options
                    });
                })
                .catch(error => console.error('Error fetching data for Total Submitted Count:', error));
    }

    // Function to draw ABDM Submitted Count chart
    function drawTotalAbdmData() {
        fetch('Total_Submitted_Count_Admin')
                .then(response => response.json())
                .then(data => {
                    const total = data.totalsABDM.TotalSum;
                    const success = data.totalsABDM.SuccessSum;
                    var userType = data.userType;

                    // Toggle visibility based on userType
                    document.getElementById("totalCountAbdm").style.display = (userType === "ABDM" || userType === "admin") ? "block" : "none";

                    // Chart data
                    var chartData = {
                        labels: ['Total', 'Success'],
                        datasets: [{
                                label: 'Count',
                                data: [total, success],
                                backgroundColor: ['#FF5733', '#4CAF50'],
                                borderColor: ['#FF5733', '#4CAF50'],
                                borderWidth: 1
                            }]
                    };

                    // Chart options
                    var options = {
                        responsive: true,
                        plugins: {
                            legend: {
                                display: false
                            },
                            title: {
                                display: true,
                                text: 'ABDM Count'
                            }
                        },
                        scales: {
                            x: {
                                stacked: true, // Stack the bars
                                title: {
                                    display: true,
                                    text: 'Counts'
                                },
                                barPercentage: 0.4, // Control the width of the bars
                                categoryPercentage: 0.1, // Control space between the bars
                            },
                            y: {
                                beginAtZero: true,
                                stacked: true, // Stack bars on Y-axis
                                title: {
                                    display: true,
                                    text: 'Count'
                                }
                            }
                        },
                        layout: {
                            padding: {
                                left: 20,
                                right: 20,
                                top: 20,
                                bottom: 20
                            }
                        }
                    };

                    // Create the chart
                    var ctx = document.getElementById('totalCountAbdmChart').getContext('2d');
                    new Chart(ctx, {
                        type: 'bar',
                        data: chartData,
                        options: options
                    });
                })
                .catch(error => console.error('Error fetching data for ABDM:', error));
    }

    // Function to draw PMJAY Submitted Count chart
    function drawTotalPmjayData() {
        fetch('Total_Submitted_Count_Admin')
                .then(response => response.json())
                .then(data => {
                    const total = data.totalsPMJAY.TotalSum;
                    const success = data.totalsPMJAY.SuccessSum;
                    var userType = data.userType;

                    // Hide the user dropdown if the user is PMJAY or ABDM
                    if (userType === "PMJAY" || userType === "ABDM") {
                        document.getElementById("UserWiseDropdown").style.display = "none";
                    }

                    // Toggle visibility based on userType
                    document.getElementById("totalPmjay").style.display = (userType === "PMJAY" || userType === "admin") ? "block" : "none";

                    // Collapse the other columns if the user is PMJAY
                    if (userType === "PMJAY") {
                        // Collapse the total and ABDM charts
                        document.getElementById("total_chart").classList.add("collapse");
                        document.getElementById("abdm_chart").classList.add("collapse");
                        document.getElementById("pmjay_chart").classList.remove("collapse");
                        let element = document.getElementById("pmjay_chart");
                        element.style.display = "block";  // Ensure the element is displayed if it was previously hidden
                        element.style.textAlign = "center";  // Center the text inside the element

// Optionally, you can also center the element itself if it's a block-level element
                        element.style.marginLeft = "auto";
                        element.style.marginRight = "auto";

                    }

                    // Chart data
                    var chartData = {
                        labels: ['Total', 'Success'],
                        datasets: [{
                                label: 'Count',
                                data: [total, success],
                                backgroundColor: ['#FF5733', '#4CAF50'],
                                borderColor: ['#FF5733', '#4CAF50'],
                                borderWidth: 1
                            }]
                    };

                    // Chart options
                    var options = {
                        responsive: true,
                        plugins: {
                            legend: {
                                display: false
                            },
                            title: {
                                display: true,
                                text: 'PMJAY Count'
                            }
                        },
                        scales: {
                            x: {
                                stacked: true, // Stack the bars
                                title: {
                                    display: true,
                                    text: 'Counts'
                                },
                                barPercentage: 0.4, // Control the width of the bars
                                categoryPercentage: 0.1, // Control space between the bars
                            },
                            y: {
                                beginAtZero: true,
                                stacked: true, // Stack bars on Y-axis
                                title: {
                                    display: true,
                                    text: 'Count'
                                }
                            }
                        },
                        layout: {
                            padding: {
                                left: 20,
                                right: 20,
                                top: 20,
                                bottom: 20
                            }
                        }
                    };

                    // Create the chart
                    var ctx = document.getElementById('totalPmjayChart').getContext('2d');
                    new Chart(ctx, {
                        type: 'bar',
                        data: chartData,
                        options: options
                    });
                })
                .catch(error => console.error('Error fetching data for PMJAY:', error));
    }


    // Initialize charts
    drawTotalSubmittedData();
    drawTotalAbdmData();
    drawTotalPmjayData();
</script>








<script>
    function loadPage(page) {
        var contentContainer = document.getElementById('main-content');
        fetch(page)
                .then(response => response.text())
                .then(data => {
                    contentContainer.innerHTML = data; // Load the page content into the container
                })
                .catch(error => {
                    console.error('Error loading page:', error);
                });
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







<script>
    document.addEventListener("DOMContentLoaded", function () {
        const loaderOverlay = document.getElementById('loader-overlay');
        loaderOverlay.style.display = 'flex';

        // Function to set up counters with the provided values (Removed pending)
        const setupCounters = (total, success) => {
            document.getElementById("counter-total-pro").setAttribute("data-target", total);
            document.getElementById("counter-success-pro").setAttribute("data-target", success);
            //document.getElementById("counter-failed").setAttribute("data-target", failed);

            const counters = document.querySelectorAll(".counter");
            counters.forEach(counter => {
                const target = +counter.getAttribute("data-target");
                let count = 0;
                const speed = 10;

                const updateCounter = () => {
                    const increment = target / 100;
                    count = Math.ceil(count + increment);

                    if (count < target) {
                        counter.innerText = count;
                        setTimeout(updateCounter, speed);
                    } else {
                        counter.innerText = target;
                    }
                };

                updateCounter();
            });
        };

        // Function to update the counters with the fetched data (Removed pending)
        function updateCircles(data) {
            let total = 0;
            let success = 0;
//                    let failed = 0;

            data.forEach(function (item) {
                total += item.Total || 0;
                success += item.Success || 0;
//                        failed += item.Failed || 0;
            });

            setupCounters(total, success);  // Now, only updating total, success, and failed counters
        }

        // AJAX request to fetch data
        $.ajax({
            url: 'Dashboard_Monitor', // Adjust the URL as needed
            type: 'GET',
            dataType: 'json',
            beforeSend: function () {
                loaderOverlay.style.display = 'flex';  // Show loader before request
            },
            success: function (data) {
                updateCircles(data);  // Update the counters with fetched data
            },
            error: function (xhr, status, error) {
                console.error('Error fetching data:', status, error);
                Swal.fire({
                    icon: 'error',
                    title: 'Error',
                    text: 'Failed to fetch data. Please try again.',
                });
            },
            complete: function () {
                loaderOverlay.style.display = 'none';  // Hide loader after request completes
            }
        });
    });



</script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>


<script>
    document.addEventListener('DOMContentLoaded', function () {
        let chart; // This will store the chart instance
        const userChartDiv = document.getElementById("userChart");
        const adminChartDiv = document.getElementById("adminChart");
        const UserWiseDropdown = document.getElementById("UserWiseDropdown");
        // Function to toggle chart visibility based on selected value
        function toggleChartVisibility(chartType) {
            // Reset visibility for both charts
            userChartDiv.classList.add('hidden');
            adminChartDiv.classList.add('hidden');

            if (chartType === "ABDM and PMJAY") {

                adminChartDiv.classList.remove('hidden');
            } else if (chartType === "PMJAY" || chartType === "ABDM") {
                // Show user chart and hide admin chart
                userChartDiv.classList.remove('hidden');
            }
        }

        // Function to fetch data and render the chart
        function fetchGraphData(selectedValue) {
            $.ajax({
                url: 'DepartmentWiseGraphServlet', // Servlet URL
                type: 'GET', // HTTP method
                data: {graph: selectedValue}, // Pass the selected value as a parameter
                dataType: 'json', // Expect JSON response
                success: function (response) {
                    console.log("Response from servlet:", response);

                    // Destroy the existing chart if it exists
                    if (chart) {
                        chart.destroy();
                    }

                    // Render the new chart
                    let ctx = document.getElementById('graph-chart').getContext('2d');
                    chart = new Chart(ctx, {
                        type: 'bar', // Bar chart type
                        data: {
                            labels: response.map(user => user.username), // X-axis labels (usernames)
                            datasets: [
                                {
                                    label: 'Total', // Dataset label
                                    data: response.map(user => user.Total), // Y-axis data (total values)
                                    backgroundColor: 'rgba(139, 0, 0, 0.8)', // Dark Red color for Total bars
                                    borderColor: 'rgba(139, 0, 0, 1)', // Dark Red border for Total bars
                                    borderWidth: 1 // Border width
                                },
                                {
                                    label: 'Success', // Dataset label
                                    data: response.map(user => user.Success), // Y-axis data (success values)
                                    backgroundColor: 'rgba(0, 128, 0, 0.8)', // Dark Green color for Success bars
                                    borderColor: 'rgba(0, 128, 0, 1)', // Dark Green border for Success bars
                                    borderWidth: 1 // Border width
                                }
                            ]
                        },
                        options: {
                            indexAxis: 'x', // Bars are displayed horizontally (default)
                            scales: {
                                x: {
                                    stacked: false, // Bars are not stacked
                                    grid: {
                                        display: false // Hide grid lines on the X-axis
                                    }
                                },
                                y: {
                                    beginAtZero: true, // Start Y-axis from 0
                                    stacked: false, // Bars are not stacked
                                    ticks: {
                                        stepSize: 1, // Ensure Y-axis labels are integers
                                        min: 0, // Ensure the minimum is 0 to make low values visible
                                        max: Math.max(...response.map(user => Math.max(user.Total, user.Success))) + 5 // Dynamic max based on data
                                    },
                                    grid: {
                                        display: true // Show grid lines on the Y-axis
                                    }
                                }
                            },
                            plugins: {
                                legend: {
                                    display: true, // Show the legend
                                    position: 'top' // Position the legend at the top
                                }
                            },
                            responsive: true, // Make the chart responsive
                            maintainAspectRatio: false, // Adjust the chart's aspect ratio
                            layout: {
                                padding: {
                                    left: 20,
                                    right: 20,
                                    top: 20,
                                    bottom: 20
                                }
                            },
                            barPercentage: 0.9, // Increase the width of the bars for better visibility
                            categoryPercentage: 0.5 // Increase the spacing between bars
                        }
                    });
                },
                error: function (xhr, status, error) {
                    console.error("Error fetching data:", error);
                }
            });
        }

        // Event listener for the dropdown (ID "graph")
        const graphSelect = document.getElementById('graph');
        graphSelect.addEventListener('change', function () {
            const selectedValue = this.value;
            toggleChartVisibility(selectedValue); // Toggle visibility based on selected value
            fetchGraphData(selectedValue); // Fetch data for the selected value
        });

        // Fetch initial data (optional) when the page loads
        const initialValue = graphSelect.value; // Get the default selected value
        toggleChartVisibility(initialValue); // Toggle chart visibility based on the initial value
        fetchGraphData(initialValue); // Fetch data for the initial value
    });
</script>








<!-- SweetAlert2 CSS -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">

<!-- SweetAlert2 JS -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</body>
</html>

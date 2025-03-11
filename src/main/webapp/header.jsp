<%-- 
    Document   : header
    Created on : 5 Mar, 2025, 9:50:13 AM
    Author     : vikram
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
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

        <style>
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
                height: 280px;
                width: 100%;
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
                margin-left: 0px; /* Shift footer to the right */
                transition: margin-left 0.3s ease;
            }






            /* Add space between the icon and text */

        </style>
     </head>
    <body>
        <div class="d-flex justify-content-between align-items-center logo-container">
            <!-- Left Logo -->
            <div class="left-logo">
                <img id="LoginLogoPage_1" src="https://app.virtuosorbm.com/assets/img/logo.png" style="width:55%; margin-top: 10px;">
            </div>

            <!-- NHA Dashboard Title -->
            <div class="nha-title">
                <h3> </h3>
            </div>

            <!-- Right Logo -->
            <div class="right-logo">
                <img src="https://abdm.gov.in:8081/uploads/NHA_logo_hd_3099160d92.svg" alt="National Health Authority" class="nha-logo">
            </div>
        </div>
    </body>
</html>

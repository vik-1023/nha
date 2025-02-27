
<%@include file="session.jsp" %>

<%@page import="java.sql.ResultSet"%>
<%@page import="db.dbcon"%>
<%@page import="org.slf4j.LoggerFactory"%>
<%@page import="org.slf4j.Logger"%>
 
<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="utf-8">
        <meta content="width=device-width, initial-scale=1.0" name="viewport">

        <title>RCS BOT</title>
        <meta content="" name="description">
        <meta content="" name="keywords">

        <!-- Favicons -->
        <link href="https://app.virtuosorbm.com/assets/img/favicon.png" rel="icon">
        <link href="https://app.virtuosorbm.com/assets/img/apple-touch-icon.png" rel="apple-touch-icon">

        <!-- Google Fonts -->
        <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,300i,400,400i,600,600i,700,700i|Raleway:300,300i,400,400i,500,500i,600,600i,700,700i|Poppins:300,300i,400,400i,500,500i,600,600i,700,700i" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@6.4.2/css/fontawesome.min.css" integrity="sha384-BY+fdrpOd3gfeRvTSMT+VUZmA728cfF9Z2G42xpaRkUGu2i3DyzpTURDo5A6CaLK" crossorigin="anonymous">
        <!-- Vendor CSS Files -->
        <link href="assets/vendor/aos/aos.css" rel="stylesheet">
        <link href="assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
        <link href="assets/vendor/bootstrap-icons/bootstrap-icons.css" rel="stylesheet">
        <link href="assets/vendor/boxicons/css/boxicons.min.css" rel="stylesheet">
        <link href="assets/vendor/glightbox/css/glightbox.min.css" rel="stylesheet">
        <link href="assets/vendor/remixicon/remixicon.css" rel="stylesheet">
        <link href="assets/vendor/swiper/swiper-bundle.min.css" rel="stylesheet">

        <!-- Template Main CSS File -->
        <link href="assets/css/style24.css" rel="stylesheet">


    </head>
    
    <body>

        <%@include file="header.jsp" %>

        <!-- ======= Hero Section ======= -->
        <section id="hero1" class="d-flex align-items-center">
            <div class="container" data-aos="fade-up" data-aos-delay="100">
                <div class="row justify-content-left">

                    <div class="col-md-4 col-sm-4 col-xs-12">

                        <!-- Search form -->
                        <label class="s_bot" for="search">Search Brands</label>
                        <div class="active-purple-3 active-purple-4 mb-4">
                            <input class="form-control" type="text" placeholder="Search" aria-label="Search" id="myInput">
                        </div>
                    </div>
                    <div class="col-md-12 col-sm-12 colxs-12 table-responsive">
                        <h1 class="brand">Brands</h1>
                        <div class="main-table">
                            <table class="table">
                                <thead class="table-top">
                                    <tr class="bg-color">
                                        <th scope="col">Brands Submitted</th>
                                        <th scope="col"></th>
                                        <th scope="col"></th>
                                        <th scope="col"></th>
                                        <th scope="col"></th>

                                    </tr>
                                </thead>
                                <tr class="table-data">
                                    <th scope="row">Brand Name</th>
                                    <td><b>Industry Type</b></td>

                                    <td><b>Status</b></td>
                                    <td><b>Action</b></td>

                                </tr>

                                <tbody id="myTable" class="table-data">



                                    <%                             String Industry_Type = "NA";
                                        String all_data = "select distinct(brand_name),status from rbm_table;";
                                        dbcon db = new dbcon();
                                        db.getCon(db.getdbName());
                                        ResultSet rs = db.getResult(all_data);

                                        while (rs.next()) {
                                            String sts = rs.getString(2);
                                            String Brand_Name = rs.getString(1);
                                            if (sts.equals("true")) {
                                                sts = "Verified";
                                            } else {
                                                sts = "Under Review";
                                            }
                                    %>
                                    <tr>
                                        <td scope="row"><%=Brand_Name%></td>
                                        <td><%= Industry_Type%></td>
                                        <td ><span class="Creation"><%=sts%></span></td>
                                        <td  > <span onclick="del()" type="button" class="view">View Details</span> </td>
                                    </tr>
                                    <%
                                        }
                                             Logger logger =  LoggerFactory.getLogger(request.getRequestURL().toString());
                                            logger.info("Brand page :- Username"+ username+"query "+all_data);
                                    %>

                                </tbody>
                            </table>

                        </div>
                    </div>
                </div>
                <!--  <div class="text-center">
                   <a href="#about" class="btn-get-started scrollto">Get Started</a>
                 </div>
                -->

            </div>

            <script
            src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
            <script>
                                            function del() {
                                                alert("Task Pending !!");
                                            }
                                            $(document).ready(
                                                    function () {
                                                        $("#myInput").on(
                                                                "keyup",
                                                                function () {
                                                                    var value = $(this).val().toLowerCase();
                                                                    $("#myTable tr").filter(
                                                                            function () {
                                                                                $(this).toggle(
                                                                                        $(this).text().toLowerCase()
                                                                                        .indexOf(value) > -1);
                                                                            });
                                                                });
                                                    });
            </script>
        </section><!-- End Hero -->









        <!-- ======= Footer ======= -->
        <footer id="footer">



            <div class="container d-md-flex py-4">

                <div class="me-md-auto text-center text-md-start">
                    <div class="copyright">
                        &copy; Copyright <strong><span>OnePage</span></strong>. All Rights Reserved
                    </div>

                </div>
                <div class="social-links text-center text-md-right pt-3 pt-md-0">
                    <a href="#" class="twitter"><i class="bx bxl-twitter"></i></a>
                    <a href="#" class="facebook"><i class="bx bxl-facebook"></i></a>
                    <a href="#" class="instagram"><i class="bx bxl-instagram"></i></a>
                    <a href="#" class="google-plus"><i class="bx bxl-skype"></i></a>
                    <a href="#" class="linkedin"><i class="bx bxl-linkedin"></i></a>
                </div>
            </div>
        </footer><!-- End Footer -->

        <a href="#" class="back-to-top d-flex align-items-center justify-content-center"><i class="bi bi-arrow-up-short"></i></a>

        <!-- Vendor JS Files -->
        <script src="assets/vendor/purecounter/purecounter_vanilla.js"></script>
        <script src="assets/vendor/aos/aos.js"></script>
        <script src="assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
        <script src="assets/vendor/glightbox/js/glightbox.min.js"></script>
        <script src="assets/vendor/isotope-layout/isotope.pkgd.min.js"></script>
        <script src="assets/vendor/swiper/swiper-bundle.min.js"></script>
        <script src="assets/vendor/php-email-form/validate.js"></script>

        <!-- Template Main JS File -->
        <script src="assets/js/main.js"></script>

    </body>

</html>
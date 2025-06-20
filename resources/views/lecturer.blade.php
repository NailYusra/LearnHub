<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <title>Instructor Profile - LearnHub</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <meta content="" name="keywords">
    <meta content="" name="description">

    <!-- Favicon -->
    <link href="/img/favicon.ico" rel="icon">

    <!-- Google Web Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Heebo:wght@400;500;600&family=Nunito:wght@600;700;800&display=swap" rel="stylesheet">

    <!-- Icon Font Stylesheet -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css" rel="stylesheet">

    <!-- Libraries Stylesheet -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css" rel="stylesheet">

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Template Stylesheet -->
    <link href="/css/style.css" rel="stylesheet">
</head>

<body>
    <!-- Navbar Start -->
    <nav class="navbar navbar-expand-lg bg-white navbar-light shadow sticky-top p-0">
        <a href="{{ route('home') }}" class="navbar-brand d-flex align-items-center px-4 px-lg-5">
            <img src="/img/LOGO.png" alt="LearnHub" style="height: 40px; margin-right: 10px;">
            <h2 class="m-0 text-primary">LearnHub</h2>
        </a>

        <button type="button" class="navbar-toggler me-4" data-bs-toggle="collapse" data-bs-target="#navbarCollapse">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarCollapse">
            <div class="navbar-nav ms-auto p-4 p-lg-0">
                <a href="{{ route('home') }}" class="nav-item nav-link active">Home</a>
                <a href="{{ route('about') }}" class="nav-item nav-link">About</a>
                <a href="{{ route('courses') }}" class="nav-item nav-link active">Courses</a>
                <a href="{{ route('forum') }}" class="nav-item nav-link">Forum</a>
                <div class="nav-item dropdown">
                    <a href="#" class="nav-link dropdown-toggle" data-bs-toggle="dropdown">Pages</a>
                    <div class="dropdown-menu fade-down m-0">
                        <a href="{{ route('team') }}" class="dropdown-item">Our Tutor</a>
                        <a href="{{ route('testimonial') }}" class="dropdown-item">Testimonial</a>
                        <a href="{{ route('404') }}" class="dropdown-item">404 Page</a>
                    </div>
                </div>
                <a href="{{ route('contact') }}" class="nav-item nav-link">Contact</a>
            </div>
            <a href="{{ route('download') }}" class="btn btn-primary py-4 px-lg-5 d-none d-lg-block">Join Now<i class="fa fa-arrow-right ms-3"></i></a>
        </div>
    </nav>
    <!-- Navbar End -->

    <?php
        $lecturer_id = last(explode('/',url()->current()));

        $api_url = 'http://localhost:8080/api/tutor/tutor_id/'. $lecturer_id;

        // Read JSON file
        $json_data = file_get_contents($api_url);

        // Decode JSON data into PHP array
        $response_data = json_decode($json_data);

        // All user data exists in 'data' object
        $tutor_data = $response_data;

    ?>

    <!-- Profile Header Start -->
    <div class="profile-header">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-4 text-center text-lg-start">
                    <img src="https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=300&h=300&fit=crop&crop=face" alt="Dr. John Anderson" class="profile-image mb-3">
                </div>
                <div class="col-lg-8">
                    <?php
                        echo '<h1 class="display-5 fw-bold mb-2">'. $tutor_data->nama .'</h1>';
                        echo '<h4 class="mb-3">'. $tutor_data->prodi_nama .'</h4>';
                    ?>

                    <div class="rating-stars mb-3">
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <i class="fas fa-star"></i>
                        <?php
                            echo '<span class="ms-2 fs-6">'. $tutor_data->rating_mean .'</span>';
                        ?>
                    </div>
                    <?php
                        echo '<p class="mb-4 fs-5">'. $tutor_data->bio .'</p>';
                        echo '<div class="d-flex align-items-center mb-4">';
                        echo  '<i class="fas fa-envelope"></i>';
                        echo  '<span>'. $tutor_data->email .'</span>';
                        echo '</div>';
                        echo '<div class="d-flex align-items-center mb-4">';
                        echo  '<i class="fas fa-phone"></i>';
                        echo  '<span>+62 '. $tutor_data->no_telp.'</span>';
                        echo '</div>';
                    ?>
                </div>
            </div>
        </div>
    </div>
    <!-- Profile Header End -->

    <!-- Stats Section Start -->
    <div class="container-xxl py-5">
        <div class="container">
            <div class="row g-4">
                <div class="col-lg-3 col-md-6">
                    <div class="stats-card">
                        <div class="certificate-icon">
                            <i class="fas fa-medal"></i>
                        </div>
                        <?php
                            echo '<h3>'. $tutor_data->num_course .'</h3>';
                        ?>
                        <p class="mb-0">Courses Taught</p>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6">
                    <div class="stats-card">
                        <div class="certificate-icon">
                            <i class="fas fa-medal"></i>
                        </div>
                        <?php
                            echo '<h3>'. $tutor_data->num_customer .'</h3>';
                        ?>
                        <p class="mb-0">Students</p>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6">
                    <div class="stats-card">
                        <div class="certificate-icon">
                            <i class="fas fa-medal"></i>
                        </div>
                        <?php
                            echo '<h3>'. $tutor_data->kumpulanCertificate .'</h3>';
                        ?>
                        <p class="mb-0">Certificates</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- Stats Section End -->



    <!-- Footer Start -->
    <div class="container-fluid bg-dark text-light footer mt-5 wow fadeIn" data-wow-delay="0.1s">
        <!-- <div class="container py-5">
            <div class="row g-5">
                <div class="col-lg-3 col-md-6">
                    <h4 class="text-white mb-3">Quick Link</h4>
                    <a class="btn btn-link" href="">About Us</a>
                    <a class="btn btn-link" href="">Contact Us</a>
                    <a class="btn btn-link" href="">Privacy Policy</a>
                    <a class="btn btn-link" href="">Terms & Condition</a>
                    <a class="btn btn-link" href="">FAQs & Help</a>
                </div>
                <div class="col-lg-3 col-md-6">
                    <h4 class="text-white mb-3">Contact</h4>
                    <p class="mb-2"><i class="fa fa-map-marker-alt me-3"></i>123 Street, New York, USA</p>
                    <p class="mb-2"><i class="fa fa-phone-alt me-3"></i>+012 345 67890</p>
                    <p class="mb-2"><i class="fa fa-envelope me-3"></i>info@example.com</p>
                    <div class="d-flex pt-2">
                        <a class="btn btn-outline-light btn-social" href=""><i class="fab fa-twitter"></i></a>
                        <a class="btn btn-outline-light btn-social" href=""><i class="fab fa-facebook-f"></i></a>
                        <a class="btn btn-outline-light btn-social" href=""><i class="fab fa-youtube"></i></a>
                        <a class="btn btn-outline-light btn-social" href=""><i class="fab fa-linkedin-in"></i></a>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6">
                    <h4 class="text-white mb-3">Newsletter</h4>
                    <p>Dolor amet sit justo amet elitr clita ipsum elitr est.</p>

                </div>
            </div>
        </div> -->
        <div class="container">
            <div class="copyright">
                <div class="row">
                    <div class="col-md-6 text-center text-md-start mb-3 mb-md-0">
                        &copy; <a class="border-bottom" href="#">learnhub.com</a>, All Right Reserved.
                    </div>
                    <div class="col-md-6 text-center text-md-end">
                        <div class="footer-menu">
                            <a href="">Home</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- Footer End -->
    <!-- Back to Top -->
    <a href="#" class="btn btn-lg btn-primary btn-lg-square back-to-top"><i class="bi bi-arrow-up"></i></a>

    <!-- JavaScript Libraries -->
    <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js"></script>

    <style>
        .back-to-top {
            position: fixed;
            display: none;
            right: 45px;
            bottom: 45px;
            z-index: 99;
            border: none;
            outline: none;
            cursor: pointer;
            padding: 0;
            width: 48px;
            height: 48px;
            border-radius: 6px;
            color: #FFFFFF;
            background: var(--primary);
        }

        .back-to-top:hover {
            background: #c82333;
        }

        .footer .btn.btn-social {
            margin-right: 5px;
            width: 35px;
            height: 35px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--light);
            font-weight: normal;
            border: 1
        }
    </style>


</body>
</html>

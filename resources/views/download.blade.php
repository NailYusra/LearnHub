<!DOCTYPE html>
<html lang="id">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Download App | LearnHub</title>
  <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <meta content="Download LearnHub mobile app for iOS and Android" name="description">
    <meta content="LearnHub, mobile app, education, learning, download" name="keywords">

    <!-- Favicon -->
    <link href="img/favicon.ico" rel="icon">

    <!-- Google Web Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Heebo:wght@400;500;600&family=Nunito:wght@600;700;800&display=swap" rel="stylesheet">

    <!-- Icon Font Stylesheet -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css" rel="stylesheet">

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <link href="css/style.css" rel="stylesheet">
</head>
<body>

<!-- Navbar Start -->
    <nav class="navbar navbar-expand-lg bg-white navbar-light shadow sticky-top p-0">
        <a href="{{ route('home') }}" class="navbar-brand d-flex align-items-center px-4 px-lg-5">
            <img src="img/LOGO.png" alt="LearnHub" style="height: 40px; margin-right: 10px;">
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
                <a href="{{ route('contact') }}" class="nav-item nav-link">Contact</a>
            </div>
            <a href="{{ route('download') }}" class="btn btn-primary py-4 px-lg-5 d-none d-lg-block">Join Now<i class="fa fa-arrow-right ms-3"></i></a>
        </div>
    </nav>
    <!-- Navbar End -->

<!-- Hero Section Start -->
    <section class="hero-section">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-6">
                    <div class="hero-content">
                        <h1 class="display-4 fw-bold mb-4">Take Learning Anywhere with LearnHub Mobile</h1>
                        <p class="fs-5 mb-4">Access thousands of courses, track your progress, and learn on the go with our powerful mobile app. Available for iOS and Android devices.</p>
                        <div class="d-flex flex-wrap">
                            <a href="#download" class="btn btn-light btn-lg me-3 mb-3">
                                <i class="download"></i>Download Now
                            </a>

                        </div>
                    </div>
                </div>
                <div class="col-lg-6">
                    <div class="phone-mockup">
                        <div class="phone-frame">
                            <div class="phone-screen">
                                <div class="text-center">
                                    <i class="fas fa-graduation-cap fa-3x mb-3"></i>
                                    <h4>LearnHub</h4>
                                    <p>Mobile App</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
    <!-- Hero Section End -->

    <!-- Download Section Start -->
    <section id="download" class="download-section">
        <div class="container">
            <div class="text-center mb-5">
                <h2 class="display-5 fw-bold text-primary mb-3">Download LearnHub App</h2>
                <p class="fs-5 text-muted">Get started with learning today. Download our app from your preferred platform.</p>
            </div>

            <div class="row justify-content-center">
                <div class="col-md-8 text-center">
                    <a href="#" class="download-btn">
                        <i class="fab fa-apple fa-2x"></i>
                        <div class="btn-text">
                            <small>Download on the</small>
                            <strong>App Store</strong>
                        </div>
                    </a>
                    
                    <a href="#" class="download-btn">
                        <i class="fab fa-google-play fa-2x"></i>
                        <div class="btn-text">
                            <small>Get it on</small>
                            <strong>Google Play</strong>
                        </div>
                    </a>
                </div>
            </div>
        </div>
    </section>
    <!-- Download Section End -->

    <!-- Features Section Start -->
    <section id="features" class="features-section">
        <div class="container">
            <div class="text-center mb-5">
                <h2 class="display-5 fw-bold text-primary mb-3">Why Choose LearnHub Mobile?</h2>
                <p class="fs-5 text-muted">Discover the powerful features that make learning easier and more engaging</p>
            </div>

            <div class="row g-4">
                <div class="col-lg-4 col-md-6">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-download"></i>
                        </div>
                        <h5>Offline Learning</h5>
                        <p>Download courses and learn without internet connection. Perfect for commuting or traveling.</p>
                    </div>
                </div>

                <div class="col-lg-4 col-md-6">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-sync"></i>
                        </div>
                        <h5>Sync Across Devices</h5>
                        <p>Start learning on your phone and continue on your tablet or computer. All progress synced automatically.</p>
                    </div>
                </div>

                <div class="col-lg-4 col-md-6">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-bell"></i>
                        </div>
                        <h5>Smart Notifications</h5>
                        <p>Get personalized reminders and updates to keep you motivated and on track with your learning goals.</p>
                    </div>
                </div>

                <div class="col-lg-4 col-md-6">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-video"></i>
                        </div>
                        <h5>HD Video Streaming</h5>
                        <p>Watch high-quality video lectures with adaptive streaming for the best viewing experience.</p>
                    </div>
                </div>

                <div class="col-lg-4 col-md-6">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-users"></i>
                        </div>
                        <h5>Community Access</h5>
                        <p>Connect with fellow learners, join discussions, and get help from instructors directly in the app.</p>
                    </div>
                </div>

                <div class="col-lg-4 col-md-6">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-certificate"></i>
                        </div>
                        <h5>Digital Certificates</h5>
                        <p>Earn and share certificates instantly. Add them to your LinkedIn profile with one tap.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>
    <!-- Features Section End -->

    <!-- QR Code Section Start -->
    <section class="qr-section">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-6">
                    <h2 class="display-6 fw-bold text-primary mb-4">Quick Download with QR Code</h2>
                    <p class="fs-5 mb-4">Scan the QR code with your phone camera to quickly access the download links for both iOS and Android versions.</p>
                    <ul class="list-unstyled">
                        <li class="mb-2"><i class="fas fa-check text-primary me-2"></i>Instant access to download links</li>
                        <li class="mb-2"><i class="fas fa-check text-primary me-2"></i>Works with any QR code scanner</li>
                        <li class="mb-2"><i class="fas fa-check text-primary me-2"></i>No typing required</li>
                    </ul>
                </div>
                <div class="col-lg-6 text-center">
                    <div class="qr-code"></div>
                    <p class="text-muted">Scan to download LearnHub Mobile App</p>
                </div>
            </div>
        </div>
    </section>
    <!-- QR Code Section End -->


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

</body>
</html>

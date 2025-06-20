<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <title>Forum - LearnHub</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <meta content="" name="keywords">
    <meta content="" name="description">

    <!-- Google Web Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Heebo:wght@400;500;600&family=Nunito:wght@600;700;800&display=swap" rel="stylesheet">

    <!-- Icon Font Stylesheet -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css" rel="stylesheet">

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/css/bootstrap.min.css" rel="stylesheet">

      <!-- Template Stylesheet -->
    <link href="css/style.css" rel="stylesheet">

    <style>
        /********** Template CSS **********/
        :root {
            --primary: #B6252A;
            --light: #faefed;
            --dark: #333333;
        }

        body {
            font-family: 'Heebo', sans-serif;
            background-color: #f8f9fa;
        }

        .fw-medium {
            font-weight: 600 !important;
        }

        .fw-semi-bold {
            font-weight: 700 !important;
        }

        /*** Button ***/
        .btn {
            font-family: 'Nunito', sans-serif;
            font-weight: 600;
            transition: .5s;
        }

        .btn.btn-primary,
        .btn.btn-secondary {
            color: #FFFFFF;
            background-color: var(--primary) !important;
            border-color: var(--primary) !important;
        }

        .btn.btn-primary:hover {
            background-color: #9a1f23 !important;
            border-color: #9a1f23 !important;
        }

        .btn-square {
            width: 38px;
            height: 38px;
        }

        .btn-sm-square {
            width: 32px;
            height: 32px;
        }

        .btn-lg-square {
            width: 48px;
            height: 48px;
        }

        .btn-square,
        .btn-sm-square,
        .btn-lg-square {
            padding: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: normal;
            border-radius: 50%;
        }

        /*** Navbar ***/
        .navbar {
            background-color: white;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .navbar-brand {
            font-family: 'Nunito', sans-serif;
            font-weight: 800;
        }

        .text-primary {
            color: var(--primary) !important;
        }

        /*** Header ***/
        .forum-header {
            background: linear-gradient(135deg, var(--primary) 0%,#B6252A 100%);
            color: white;
            padding: 2rem 0;
            position: relative;
        }

        .forum-header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 20"><defs><pattern id="grain" width="100" height="100" patternUnits="userSpaceOnUse"><circle cx="25" cy="25" r="1" fill="white" opacity="0.1"/><circle cx="75" cy="75" r="1" fill="white" opacity="0.1"/></pattern></defs><rect width="100" height="20" fill="url(%23grain)"/></svg>');
            opacity: 0.1;
        }

        .forum-header .container {
            position: relative;
            z-index: 1;
        }

        .forum-header h1 {
            font-family: 'Nunito', sans-serif;
            font-weight: 800;
            margin-bottom: 0;
            font-size: 2.5rem;
        }

        .demo-badge {
            position: absolute;
            top: 1rem;
            right: 1rem;
            background: rgba(255,255,255,0.2);
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-size: 0.875rem;
            font-weight: 600;
            transform: rotate(15deg);
        }

        /*** Forum Cards ***/
        .forum-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            padding: 1.5rem;
            margin-bottom: 1rem;
            transition: all 0.3s ease;
            border-left: 4px solid transparent;
        }

        .forum-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 30px rgba(0,0,0,0.15);
            border-left-color: var(--primary);
        }

        .forum-card h5 {
            color: var(--dark);
            font-family: 'Nunito', sans-serif;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }

        .forum-card p {
            color: #666;
            margin-bottom: 0.75rem;
            line-height: 1.6;
        }

        .forum-card .author {
            color: #999;
            font-size: 0.875rem;
            display: flex;
            align-items: center;
        }

        .forum-card .author i {
            margin-right: 0.5rem;
            color: var(--primary);
        }

        /*** Floating Action Button ***/
        .fab {
            position: fixed;
            right: 2rem;
            width: 60px;
            height: 60px;
            background: var(--primary);
            color: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            box-shadow: 0 5px 15px rgba(182, 37, 42, 0.4);
            transition: all 0.3s ease;
            z-index: 1000;
            text-decoration: none;
        }

        .fab:hover {
            background: #9a1f23;
            color: white;
            transform: scale(1.1);
            box-shadow: 0 8px 25px rgba(182, 37, 42, 0.6);
        }

        /*** Bottom Navigation ***/
        .bottom-nav {
            position: fixed;
            bottom: 0;
            left: 0;
            right: 0;
            background: var(--primary);
            padding: 0.75rem 0;
            z-index: 1000;
            box-shadow: 0 -2px 10px rgba(0,0,0,0.1);
        }

        .bottom-nav .nav-item {
            flex: 1;
            text-align: center;
        }

        .bottom-nav .nav-link {
            color: rgba(255,255,255,0.7);
            text-decoration: none;
            display: flex;
            flex-direction: column;
            align-items: center;
            font-size: 0.75rem;
            transition: all 0.3s ease;
        }

        .bottom-nav .nav-link.active,
        .bottom-nav .nav-link:hover {
            color: white;
            transform: translateY(-2px);
        }

        .bottom-nav .nav-link i {
            font-size: 1.25rem;
            margin-bottom: 0.25rem;
        }

        /*** Content Spacing ***/
        .content-wrapper {
            padding-bottom: 120px; /* Space for bottom nav */
        }

        /*** Responsive Design ***/
        @media (max-width: 768px) {
            .forum-header h1 {
                font-size: 2rem;
            }

            .forum-card {
                padding: 1rem;
                margin-bottom: 0.75rem;
            }

            .fab {
                bottom: 100px; /* Above bottom nav */
                right: 1rem;
                width: 50px;
                height: 50px;
                font-size: 1.25rem;
            }
        }

        /* Override Bootstrap color utilities */
        .text-primary {
            color: var(--primary) !important;
        }

        .bg-primary {
            background-color: var(--primary) !important;
        }

        .border-primary {
            border-color: var(--primary) !important;
        }
        /* baru tambahan */
        .forum-card {
    background-color: #fff;
}


    .forum-card {
      background: #fff;
      padding: 1rem;
      border-radius: 10px;
      box-shadow: 0 0 8px rgba(0, 0, 0, 0.1);
      margin-bottom: 1rem;
    }

    .comment-actions {
      display: flex;
      justify-content: flex-end;
      gap: 12px;
    }

    .comment-btn {
      background: none;
      border: 1px solid red;
      color: red;
      padding: 0.5rem 1rem;
      border-radius: 20px;
      font-size: 0.875rem;
      cursor: pointer;
    }

    .comment-list {
      margin-top: 1rem;
      padding: 1rem;
      background-color: #f9f9f9;
      border-radius: 10px;
      box-shadow: 0 0 5px rgba(0,0,0,0.05);
    }

    .comment-card {
      padding: 0.5rem 0;
      border-bottom: 1px solid #ddd;
    }

    .comment-card:last-child {
      border-bottom: none;
    }

    </style>
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
                <a href="{{ route('home') }}" class="nav-item nav-link">Home</a>
                <a href="{{ route('about') }}" class="nav-item nav-link">About</a>
                <a href="{{ route('courses') }}" class="nav-item nav-link active">Courses</a>
                <a href="{{ route('forum') }}" class="nav-item nav-link active">Forum</a>
                <a href="{{ route('contact') }}" class="nav-item nav-link">Contact</a>
            </div>
            <a href="{{ route('download') }}" class="btn btn-primary py-4 px-lg-5 d-none d-lg-block">Join Now<i class="fa fa-arrow-right ms-3"></i></a>
        </div>
    </nav>
    <!-- Navbar End -->


 <!-- Forum Header -->
<div class="forum-header bg-light py-3 mb-4">
    <div class="container">
        <h1 class="">Daftar Forum</h1>
    </div>
</div>

<!-- Forum Content -->
<div class="content-wrapper">
    <div class="container py-4">
        <div class="text-center wow fadeInUp" data-wow-delay="0.1s">
            <h6 class="section-title bg-white text-center text-primary px-3">Forum</h6>
            <h1 class="mb-5">Ayo Bercerita</h1>
        </div>

        <?php
            $api_url = 'http://localhost:8080/api/forum/full';

            // Read JSON file
            $json_data = file_get_contents($api_url);

            // Decode JSON data into PHP array
            $response_data = json_decode($json_data);

            // All user data exists in 'data' object
            $forum_data = $response_data;

            // Traverse array and display user data
            foreach ($forum_data as $item) {
                echo '<div class="forum-card">';
                echo        '<h5>' . $item->header_question . '</h5>';
                echo        '<p>' . $item->question .'</p>';
                echo        '<div class="author">';
                echo            '<i class="fas fa-user"></i>';
                if (isset($user_data) && $user_data!=null) {
                    echo        '<span>Oleh:' . $item->user . '</span>';
                }else {
                    echo        '<span>Oleh: rusak </span>';
                }
                echo        '</div>';

                echo       '<div class="comment-actions">';
                echo            '<button class="comment-btn" onclick="toggleComments(\'comments'.strtolower($item->forum_id).'\')">';
                echo                '💬 Lihat Komentar';
                echo            '</button>';
                echo        '</div>';

                echo        '<div id="comments' . strtolower($item->forum_id) . '" class="comment-list" style="display: none;">';

                // Traverse array and display user data
                foreach ($item->answers as $item_answer) {
                    echo            '<div class="comment-card">';
                    echo               '<strong>'. $item_answer->user_nama .':</strong> '. $item_answer->answer;
                    echo            '</div>';
                }

                    echo '</div>';

                echo '</div>';
            }
        ?>
        </div>

        <!--
            <div class="forum-card">
                <h5>Diskusi Algoritma</h5>
                <p>Mari bahas algoritma sorting terbaik!</p>
                <div class="author">
                    <i class="fas fa-user"></i>
                    <span>Oleh: John Doe</span>
                </div>

                <div class="comment-actions">
                    <button class="comment-btn" onclick="toggleComments('comments1')">
                        💬 Lihat Komentar
                    </button>
                </div>


                <div id="comments1" class="comment-list" style="display: none;">
                    <div class="comment-card">
                        <strong>Alice:</strong> Aku suka QuickSort!
                    </div>
                    <div class="comment-card">
                        <strong>Bob:</strong> MergeSort tetap juara.
                    </div>
                </div>
            </div>
        -->


        <!-- Forum lainnya bisa ditambahkan di sini -->
             <!-- Floating Action Button -->
     <!-- Tombol FAB untuk menampilkan form tambah forum -->

    </div>
</div>

    <!-- Spacer -->
    <div style="height: 17.2vh;"></div>

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

    <!-- JavaScript Libraries -->
    <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js"></script>

    <script>

        function toggleForumForm() {
        const form = document.getElementById('forumForm');
        form.style.display = (form.style.display === 'none') ? 'block' : 'none';
    }
        function toggleCommentForum() {
        const form = document.getElementById("comment-form");
        if (form.style.display === "none" || form.style.display === "") {
        form.style.display = "block";
        } else {
        form.style.display = "none";
        }
        }
        // Smooth scrolling and interactions
        document.addEventListener('DOMContentLoaded', function() {
            // Add click animations to forum cards
            const forumCards = document.querySelectorAll('.forum-card');
            forumCards.forEach(card => {
                card.addEventListener('click', function() {
                    // Add ripple effect or navigation logic here
                    console.log('Forum card clicked:', this.querySelector('h5').textContent);
                });
            });

            // FAB click handler
            const fab = document.querySelector('.fab');
            fab.addEventListener('click', function(e) {
                e.preventDefault();
                // Add new forum logic here

            });

            // Bottom nav click handlers
            const navLinks = document.querySelectorAll('.bottom-nav .nav-link');
            navLinks.forEach(link => {
                link.addEventListener('click', function(e) {
                    e.preventDefault();

                    // Remove active class from all links
                    navLinks.forEach(l => l.classList.remove('active'));

                    // Add active class to clicked link
                    this.classList.add('active');

                    // Navigation logic would go here
                    const section = this.querySelector('span').textContent;
                    console.log('Navigating to:', section);
                });
            });
        });

          function toggleComments(id) {
    const el = document.getElementById(id);
    if (el.style.display === "none" || el.style.display === "") {
      el.style.display = "block";
    } else {
      el.style.display = "none";
    }
  }
    </script>


<!-- JavaScript Libraries -->
    <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="lib/wow/wow.min.js"></script>
    <script src="lib/easing/easing.min.js"></script>
    <script src="lib/waypoints/waypoints.min.js"></script>
    <script src="lib/owlcarousel/owl.carousel.min.js"></script>

    <!-- Template Javascript -->
    <script src="js/main.js"></script>
</body>

</html>

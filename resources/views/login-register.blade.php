<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Auth - LearnHub</title>

    <!-- Google Fonts & Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css" rel="stylesheet">

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <meta content="" name="keywords">
    <meta content="" name="description">

    <!-- Favicon -->
    <link href="img/favicon.ico" rel="icon">

    <!-- Google Web Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Heebo:wght@400;500;600&family=Nunito:wght@600;700;800&display=swap" rel="stylesheet">

    <!-- Icon Font Stylesheet -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css" rel="stylesheet">

    <!-- Libraries Stylesheet -->
    <link href="lib/animate/animate.min.css" rel="stylesheet">
    <link href="lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">

    <!-- Customized Bootstrap Stylesheet -->
    <link href="css/bootstrap.min.css" rel="stylesheet">

    <!-- Template Stylesheet -->
    <link href="css/style.css" rel="stylesheet">

    <!-- Custom Style -->
<style>
    :root {
        --primary: #B6252A;
        --light: #f8f9fa;
        --dark: #333;
    }

    body {
        font-family: 'Nunito', sans-serif;
        background: url('img/login-register.jpg') no-repeat center center fixed;
        background-size: cover;
        min-height: 100vh;
        display: flex;
        flex-direction: column;
    }

    .auth-container {
        flex: 1;
        display: flex;
        align-items: center;
        justify-content: center;
        padding: 3rem 1rem;
    }

    .auth-box {
        background: rgba(255, 255, 255, 0.95); /* semi transparan */
        padding: 2rem;
        border-radius: 10px;
        box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        max-width: 400px;
        width: 100%;
    }

    .auth-box h3 {
        color: var(--primary);
        font-weight: 700;
        margin-bottom: 1rem;
        text-align: center;
    }

    .form-control {
        border-radius: 8px;
    }

    .btn-primary {
        background-color: var(--primary);
        border: none;
    }

    .btn-primary:hover {
        background-color: #9a1f23;
    }

    .toggle-link {
        cursor: pointer;
        color: var(--primary);
        font-weight: 600;
        text-decoration: underline;
    }

    footer {
        background-color: var(--dark);
        color: #fff;
    }

    .footer-menu a {
        color: #ccc;
        margin-left: 15px;
        text-decoration: none;
    }

    .footer-menu a:hover {
        text-decoration: underline;
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
                <a href="{{ route('home') }}" class="nav-item nav-link active">Home</a>
                <a href="{{ route('about') }}" class="nav-item nav-link">About</a>
            </div>
        </div>
    </nav>
    <!-- Navbar End -->

    <!-- Auth Box -->
    <div class="auth-container">
        <div class="auth-box">
            <h3 id="formTitle">Login to LearnHub</h3>
            <form id="loginForm">
                <div class="mb-3">
                    <input type="email" class="form-control" placeholder="Email" required>
                </div>
                <div class="mb-3">
                    <input type="password" class="form-control" placeholder="Password" required>
                </div>
                <button type="submit" class="btn btn-primary w-100 mb-2">Login</button>
                <p class="text-center">
                    Belum punya akun? <span class="toggle-link" onclick="toggleForm()">Daftar</span>
                </p>
            </form>

            <form id="registerForm" style="display: none;">
                <div class="mb-3">
                    <input type="text" class="form-control" placeholder="Nama Lengkap" required>
                </div>
                <div class="mb-3">
                    <input type="email" class="form-control" placeholder="Email" required>
                </div>
                <div class="mb-3">
                    <input type="password" class="form-control" placeholder="Password" required>
                </div>
                <div class="mb-3">
                    <label class="form-label d-block fw-bold">Daftar sebagai:</label>
                    <div class="form-check form-check-inline">
                        <input class="form-check-input" type="radio" name="role" id="mentee" value="mentee">
                        <label class="form-check-label" for="mentee">Mentee</label>
                    </div>
                    <div class="form-check form-check-inline">
                        <input class="form-check-input" type="radio" name="role" id="mentor" value="mentor">
                        <label class="form-check-label" for="mentor">Mentor</label>
                    </div>
                </div>

                <button type="submit" class="btn btn-primary w-100 mb-2">Register</button>
                <p class="text-center">
                    Sudah punya akun? <span class="toggle-link" onclick="toggleForm()">Login</span>
                </p>
            </form>
        </div>
    </div>

    <!-- Footer Start -->
    <div class="container-fluid bg-dark text-light footer mt-auto">
        <div class="container">
            <div class="copyright py-3">
                <div class="row">
                    <div class="col-md-6 text-center text-md-start mb-2 mb-md-0">
                        &copy; <a class="border-bottom text-light" href="#">learnhub.com</a>, All Right Reserved.
                    </div>
                    <div class="col-md-6 text-center text-md-end">
                        <div class="footer-menu">
                            <a href="#">Home</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- Footer End -->

    <!-- Scripts -->
    <script>
        function toggleForm() {
            const login = document.getElementById('loginForm');
            const register = document.getElementById('registerForm');
            const title = document.getElementById('formTitle');

            if (login.style.display === 'none') {
                login.style.display = 'block';
                register.style.display = 'none';
                title.innerText = 'Login to LearnHub';
            } else {
                login.style.display = 'none';
                register.style.display = 'block';
                title.innerText = 'Register on LearnHub';
            }
        }
    </script>

</body>
</html>

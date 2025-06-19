<?php

use Illuminate\Support\Facades\Route;

// Home page
Route::get('/', function () {
    return view('home');
})->name('home');

// About page
Route::get('/about', function () {
    return view('about');
})->name('about');

// Contact page
Route::get('/contact', function () {
    return view('contact');
})->name('contact');

// Courses page
Route::get('/courses', function () {
    return view('courses');
})->name('courses');

// Forum page
Route::get('/forum', function () {
    return view('forum');
})->name('forum');

// Team page
Route::get('/team', function () {
    return view('team');
})->name('team');

// Testimonial page
Route::get('/testimonial', function () {
    return view('testimonial');
})->name('testimonial');

// // Auth page
// Route::get('/login-register', function () {
//     return view('login-register');
// })->name('login-register');

// Download page
Route::get('/download', function () {
    return view('download');
})->name('download');

// Lecturer page
Route::get('/lecturer', function () {
    return view('lecturer');
})->name('lecturer');

// 404 custom page
Route::get('/404', function () {
    return view('404');
})->name('404');
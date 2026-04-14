package com.project;

public class Validator {

    public static boolean isValidEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }
        // Basic email format validation
        return email.matches("^[A-Za-z0-9+_.-]+@(.+)$");
    }

    public static boolean isValidPassword(String password) {
        if (password == null || password.trim().isEmpty()) {
            return false;
        }
        // Password must be at least 6 characters
        return password.length() >= 6;
    }
}

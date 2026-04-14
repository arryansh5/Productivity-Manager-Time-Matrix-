package com.project;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;

public class RegisterServlet extends BaseServlet {

    @Override
    protected String getServletNameCustom() {
        return "RegisterServlet";
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name     = request.getParameter("name").trim();
        String email    = request.getParameter("email").trim().toLowerCase();
        String password = request.getParameter("password").trim();
        String confirm  = request.getParameter("confirm").trim();

        if (!Validator.isValidEmail(email)) {
            sendError(request, response, "Invalid or missing email address.", "register.jsp");
            return;
        }
        if (!Validator.isValidPassword(password)) {
            request.setAttribute("error", "Password must be at least 6 characters.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        if (name.isEmpty()) {
            request.setAttribute("error", "Name is required.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        if (!password.equals(confirm)) {
            request.setAttribute("error", "Passwords do not match.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        boolean success = UserStore.getInstance().register(name, email, password);
        if (success) {
            request.setAttribute("success", "Account created successfully! Please login.");
            request.getRequestDispatcher("index.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Email is already registered. Please login.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("register.jsp");
    }
}

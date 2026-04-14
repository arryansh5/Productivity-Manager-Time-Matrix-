package com.project;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;

public class LoginServlet extends BaseServlet {

    @Override
    protected String getServletNameCustom() {
        return "LoginServlet";
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email    = request.getParameter("email").trim().toLowerCase();
        String password = request.getParameter("password").trim();

        if (email.isEmpty() || password.isEmpty()) {
            sendError(request, response, "Email and password are required.", "index.jsp");
            return;
        }

        boolean valid = UserStore.getInstance().login(email, password);
        if (valid) {
            HttpSession session = request.getSession(true);
            session.setAttribute("email", email);
            session.setAttribute("name", UserStore.getInstance().getName(email));
            session.setMaxInactiveInterval(30 * 60);
            response.sendRedirect("dashboard.jsp");
        } else {
            request.setAttribute("error", "Invalid email or password. Please try again.");
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("index.jsp");
    }
}

package com.project;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.ServletException;
import java.io.IOException;

public abstract class BaseServlet extends HttpServlet {
    
    // An abstract method that requires implementation by child classes
    protected abstract String getServletNameCustom();

    // A shared utility method demonstrating inheritance of functionality
    protected void sendError(HttpServletRequest request, HttpServletResponse response, String message, String page) 
            throws ServletException, IOException {
        request.setAttribute("error", message);
        request.getRequestDispatcher(page).forward(request, response);
    }
}

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    HttpSession s = request.getSession(false);
    if (s == null || s.getAttribute("email") == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    String name = (String) s.getAttribute("name");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Dashboard — Productivity Manager</title>
    <meta name="description" content="Your Productivity Manager dashboard — access all student tools from one place."/>
    <link rel="stylesheet" href="style.css"/>
</head>
<body>
<div class="page-wrapper">
    <nav class="navbar">
        <a href="dashboard.jsp" class="navbar-brand">Productivity Manager</a>
        <ul class="navbar-nav">
            <li><a href="dashboard.jsp" class="active">Dashboard</a></li>

            <li><a href="todo.jsp">To-Do</a></li>
        </ul>
        <div class="navbar-user">
            <span><%= name %></span>
            <a href="logout" class="btn btn-sm btn-secondary">Logout</a>
        </div>
    </nav>

    <div class="container">
        <div style="margin:2rem 0 2.5rem;">
            <h1 class="page-title">
                Good <%= java.time.LocalTime.now(java.time.ZoneId.of("Asia/Kolkata")).getHour() < 12 ? "Morning" : java.time.LocalTime.now(java.time.ZoneId.of("Asia/Kolkata")).getHour() < 17 ? "Afternoon" : "Evening" %>, <%= name %>
            </h1>
            <p class="page-subtitle">What would you like to do today?</p>
        </div>

        <div style="display:flex; justify-content:center; margin-top:3rem;">
            <a href="todo.jsp" class="feature-card" style="width: 100%; max-width: 600px; text-align: center; padding: 4rem 2rem; display: flex; flex-direction: column; align-items: center;">
                <h2 style="font-size: 2.5rem; margin-bottom: 2rem;">To-Do List</h2>
                <span class="badge badge-purple" style="font-size: 1.1rem; padding: 0.8rem 2.5rem; letter-spacing: 1px;">OPEN →</span>
            </a>
        </div>

        <footer style="margin-top: 5rem; padding: 2rem 0; text-align: center; border-top: 1px solid rgba(255,255,255,0.05);">
            <p style="font-size: 0.75rem; color: rgba(255,255,255,0.3); letter-spacing: 1px; font-weight: 500;">
                Arryansh Messon 590013268 B9
            </p>
        </footer>

    </div>
</div>
</body>
</html>

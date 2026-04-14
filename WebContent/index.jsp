<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    HttpSession s = request.getSession(false);
    if (s != null && s.getAttribute("email") != null) {
        response.sendRedirect("dashboard.jsp");
        return;
    }
    String error   = (String) request.getAttribute("error");
    String success = (String) request.getAttribute("success");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Login — Productivity Manager</title>
    <meta name="description" content="Login to Productivity Manager — your all-in-one productivity dashboard."/>
    <link rel="stylesheet" href="style.css"/>
</head>
<body>
<div class="page-wrapper">
    <div class="auth-wrapper">
        <div class="auth-card">

            <h1 class="text-center" style="font-size:1.8rem;margin-bottom:0.3rem;">Welcome Back</h1>
            <p class="text-muted text-center mb-3">Sign in to your Productivity Manager account</p>

            <% if (error != null) { %>
            <div id="errorAlert" class="alert alert-error"><span>⚠️</span> <%= error %></div>
            <% } %>
            <% if (success != null) { %>
            <div id="successAlert" class="alert alert-success"><span>✅</span> <%= success %></div>
            <% } %>

            <form id="loginForm" action="login" method="post" novalidate>
                <div class="form-group">
                    <label for="loginEmail">Email Address</label>
                    <input type="email" id="loginEmail" name="email" placeholder="you@example.com" required autocomplete="email"/>
                </div>
                <div class="form-group">
                    <label for="loginPassword">Password</label>
                    <input type="password" id="loginPassword" name="password" placeholder="••••••••" required autocomplete="current-password"/>
                </div>
                <button type="submit" class="btn btn-primary mt-2" id="loginBtn">Sign In →</button>
            </form>

            <div class="divider">or</div>
            <a href="register.jsp" class="btn btn-secondary" style="width:100%;text-align:center;">Create an Account</a>
            <p class="text-sm text-muted text-center mt-2">Productivity Manager &copy; 2025</p>
        </div>
    </div>
</div>
<script>
['errorAlert','successAlert'].forEach(function(id){
    var el=document.getElementById(id);
    if(el) setTimeout(function(){el.style.opacity='0';el.style.transition='opacity 0.5s';},5000);
});
</script>
</body>
</html>

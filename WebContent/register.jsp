<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    HttpSession s = request.getSession(false);
    if (s != null && s.getAttribute("email") != null) {
        response.sendRedirect("dashboard.jsp");
        return;
    }
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Register — Productivity Manager</title>
    <meta name="description" content="Create your Productivity Manager account and access all productivity tools."/>
    <link rel="stylesheet" href="style.css"/>
</head>
<body>
<div class="page-wrapper">
    <div class="auth-wrapper">
        <div class="auth-card">

            <h1 class="text-center" style="font-size:1.8rem;margin-bottom:0.3rem;">Create Account</h1>
            <p class="text-muted text-center mb-3">Join Productivity Manager — free forever</p>

            <% if (error != null) { %>
            <div id="errorAlert" class="alert alert-error"><span>⚠️</span> <%= error %></div>
            <% } %>

            <form id="regForm" action="register" method="post" novalidate>
                <div class="form-group">
                    <label for="regName">Full Name</label>
                    <input type="text" id="regName" name="name" placeholder="John Doe" required autocomplete="name"/>
                </div>
                <div class="form-group">
                    <label for="regEmail">Email Address</label>
                    <input type="email" id="regEmail" name="email" placeholder="you@example.com" required autocomplete="email"/>
                </div>
                <div class="form-group">
                    <label for="regPassword">Password <span style="color:var(--text-muted)">(min 6 chars)</span></label>
                    <input type="password" id="regPassword" name="password" placeholder="••••••••" required minlength="6"/>
                </div>
                <div class="form-group">
                    <label for="regConfirm">Confirm Password</label>
                    <input type="password" id="regConfirm" name="confirm" placeholder="••••••••" required/>
                </div>
                <div id="clientError" class="alert alert-error" style="display:none;"></div>
                <button type="button" id="submitBtn" class="btn btn-primary mt-2">Create Account →</button>
            </form>

            <div class="divider">already have an account?</div>
            <a href="index.jsp" class="btn btn-secondary" style="width:100%;text-align:center;">Sign In</a>
        </div>
    </div>
</div>
<script>
document.getElementById('submitBtn').addEventListener('click',function(){
    var name=document.getElementById('regName').value.trim();
    var email=document.getElementById('regEmail').value.trim();
    var password=document.getElementById('regPassword').value;
    var confirm=document.getElementById('regConfirm').value;
    var err=document.getElementById('clientError');
    err.style.display='none';
    if(!name||!email||!password||!confirm){err.textContent='⚠️ All fields are required.';err.style.display='flex';return;}
    if(password.length<6){err.textContent='⚠️ Password must be at least 6 characters.';err.style.display='flex';return;}
    if(password!==confirm){err.textContent='⚠️ Passwords do not match.';err.style.display='flex';return;}
    document.getElementById('regForm').submit();
});
var err=document.getElementById('errorAlert');
if(err) setTimeout(function(){err.style.opacity='0';err.style.transition='opacity 0.5s';},5000);
</script>
</body>
</html>

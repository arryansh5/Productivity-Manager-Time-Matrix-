package com.project;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.util.*;

public class TodoServlet extends HttpServlet {

    @SuppressWarnings("unchecked")
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("email") == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        List<Map<String, String>> todos =
                (List<Map<String, String>>) session.getAttribute("todos");
        if (todos == null) {
            todos = new ArrayList<>();
            session.setAttribute("todos", todos);
        }

        String action = request.getParameter("action");
        if (action == null) action = "";

        switch (action) {
            case "add": {
                String task = request.getParameter("task");
                String urgent = request.getParameter("urgent");
                String important = request.getParameter("important");
                if (task != null && !task.trim().isEmpty()) {
                    Map<String, String> item = new LinkedHashMap<>();
                    item.put("id",     java.util.UUID.randomUUID().toString());
                    item.put("task",   task.trim());
                    item.put("status", "pending");
                    item.put("urgent", urgent != null ? "true" : "false");
                    item.put("important", important != null ? "true" : "false");
                    todos.add(item);
                    session.setAttribute("todos", todos); // Force session update
                }
                break;
            }
            case "complete": {
                String id = request.getParameter("id");
                if (id != null) {
                    for (Map<String, String> t : todos) {
                        if (id.trim().equals(t.get("id").trim())) {
                            t.put("status", "done");
                            break;
                        }
                    }
                    session.setAttribute("todos", todos); // Force session update
                }
                break;
            }
            case "delete": {
                String id = request.getParameter("id");
                if (id != null) {
                    String finalId = id.trim();
                    todos.removeIf(t -> finalId.equals(t.get("id").trim()));
                    session.setAttribute("todos", todos); // Force session update
                }
                break;
            }
            case "clearAll": {
                todos.clear();
                break;
            }
        }

        response.sendRedirect("todo.jsp");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("todo.jsp");
    }
}

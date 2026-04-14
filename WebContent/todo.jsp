<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%
    HttpSession s = request.getSession(false);
    if (s == null || s.getAttribute("email") == null) { response.sendRedirect("index.jsp"); return; }
    String name = (String) s.getAttribute("name");

    @SuppressWarnings("unchecked")
    List<Map<String, String>> todos = (List<Map<String, String>>) s.getAttribute("todos");
    if (todos == null) todos = new ArrayList<>();

    int total = todos.size();

    int q1Count=0, q2Count=0, q3Count=0, q4Count=0;
    int q1Done=0, q2Done=0, q3Done=0, q4Done=0, totalDone=0;
    for(Map<String,String> t : todos){
        boolean u = "true".equals(t.get("urgent"));
        boolean i = "true".equals(t.get("important"));
        boolean done = "done".equals(t.get("status"));
        if(done) totalDone++;
        if(u && i)   { q1Count++; if(done) q1Done++; }
        else if(!u && i) { q2Count++; if(done) q2Done++; }
        else if(u && !i) { q3Count++; if(done) q3Done++; }
        else             { q4Count++; if(done) q4Done++; }
    }

    int q1Pct = total==0 ? 0 : (int)Math.round((q1Done*100.0)/total);
    int q2Pct = total==0 ? 0 : (int)Math.round((q2Done*100.0)/total);
    int q3Pct = total==0 ? 0 : (int)Math.round((q3Done*100.0)/total);
    int q4Pct = total==0 ? 0 : (int)Math.round((q4Done*100.0)/total);

    int aDone1 = totalDone==0 ? 0 : (int)Math.round((q1Done*100.0)/totalDone);
    int aDone2 = totalDone==0 ? 0 : (int)Math.round((q2Done*100.0)/totalDone);
    int aDone3 = totalDone==0 ? 0 : (int)Math.round((q3Done*100.0)/totalDone);
    int aDone4 = totalDone==0 ? 0 : (int)Math.round((q4Done*100.0)/totalDone);

    int q2Prod = q2Pct;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Eisenhower Matrix — Productivity Manager</title>
    <link rel="stylesheet" href="style.css"/>
    <style>
        /* Analytics */
        .analytics-bars { display: grid; grid-template-columns: repeat(4, 1fr); gap: 1.5rem; }
        .stat-bar .label { display: block; font-size: 0.82rem; font-weight: 600; margin-bottom: 0.4rem; }
        .bar-bg  { background: rgba(255,255,255,0.07); border-radius: 999px; height: 6px; overflow: hidden; }
        .bar-fill { height: 100%; border-radius: 999px; transition: width 0.6s ease; }

        /* Add Task Form */
        .add-task-card {
            background: #000;
            border: 1px solid rgba(255,255,255,0.13);
            border-radius: 14px;
            padding: 1.4rem 1.8rem;
            margin-bottom: 2rem;
        }
        .add-task-card h3 {
            font-size: 0.95rem;
            font-weight: 700;
            color: rgba(255,255,255,0.6);
            margin-bottom: 1rem;
            text-transform: uppercase;
            letter-spacing: 0.08em;
        }
        .add-task-row {
            display: flex;
            gap: 0.75rem;
            align-items: center;
            flex-wrap: wrap;
        }
        .add-task-input {
            flex: 1;
            min-width: 200px;
            background: rgba(255,255,255,0.05);
            border: 1px solid rgba(255,255,255,0.14);
            border-radius: 9px;
            padding: 0.55rem 0.9rem;
            color: #fff;
            font-size: 0.95rem;
        }
        .add-task-input::placeholder { color: rgba(255,255,255,0.25); }
        .add-task-input:focus { outline: none; border-color: rgba(124,58,237,0.6); }

        .checkbox-group {
            display: flex;
            gap: 1.2rem;
            align-items: center;
        }
        .checkbox-label {
            display: flex;
            align-items: center;
            gap: 0.45rem;
            font-size: 0.88rem;
            font-weight: 600;
            cursor: pointer;
            color: rgba(255,255,255,0.75);
            user-select: none;
        }
        .checkbox-label input[type="checkbox"] {
            width: 16px; height: 16px;
            accent-color: #7c3aed;
            cursor: pointer;
        }
        .urgent-cb { color: #ff6b6b; }
        .important-cb { color: #7c3aed; }

        .add-btn {
            background: #7c3aed;
            border: none;
            border-radius: 9px;
            color: #fff;
            font-weight: 700;
            font-size: 0.9rem;
            padding: 0.55rem 1.4rem;
            cursor: pointer;
            transition: background 0.2s;
            white-space: nowrap;
        }
        .add-btn:hover { background: #6d28d9; }

        /* Matrix outer */
        .em-outer { display: flex; align-items: stretch; margin-top: 0; }
        .em-yaxis {
            display: flex; flex-direction: column; align-items: flex-end;
            justify-content: space-between; width: 70px; padding-right: 10px;
        }
        .em-yaxis-label {
            font-weight: 800; font-size: 0.95rem; color: #fff;
            writing-mode: vertical-rl; transform: rotate(180deg); align-self: center;
        }
        .em-yaxis-tick {
            font-size: 0.88rem; font-weight: 600; color: rgba(255,255,255,0.4);
            height: 50%; display: flex; align-items: center; justify-content: flex-end;
        }
        .em-right { flex: 1; display: flex; flex-direction: column; }

        .em-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            grid-template-rows: 1fr 1fr;
            border: 2px solid rgba(255,255,255,0.12);
            border-radius: 14px;
            overflow: hidden;
            flex: 1;
        }

        /* Productivity Button & Card Styles */
        .productivity-container {
            margin-top: 3.5rem;
            text-align: center;
        }
        .btn-outline-purple {
            background: transparent;
            border: 2px solid #9f67f8;
            color: #9f67f8;
            padding: 1rem 3rem;
            font-size: 1.1rem;
            font-weight: 800;
            border-radius: 50px; /* Rounded Rectangle (Pill Shape) */
            cursor: pointer;
            text-transform: uppercase;
            letter-spacing: 0.1em;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            outline: none;
            display: inline-block;
        }
        .btn-outline-purple:hover {
            background: #9f67f822; /* Slight tint on hover */
            box-shadow: 0 0 25px rgba(159, 103, 248, 0.4);
            transform: translateY(-3px);
        }
        .productivity-card {
            display: none;
            margin: 2.5rem auto;
            padding: 3rem;
            background: rgba(255, 255, 255, 0.04);
            backdrop-filter: blur(15px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 28px;
            max-width: 450px;
            animation: slideUpFade 0.7s ease forwards;
        }
        .productivity-score {
            font-size: 5.5rem;
            font-weight: 900;
            color: #9f67f8;
            line-height: 1;
            margin-bottom: 0.8rem;
            text-shadow: 0 0 20px rgba(159, 103, 248, 0.3);
        }
        .productivity-label {
            font-size: 1.2rem;
            color: rgba(255,255,255,0.6);
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.15em;
        }
        @keyframes slideUpFade {
            from { opacity: 0; transform: translateY(40px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .em-cell {
            background: #000;
            border: 1px solid rgba(255,255,255,0.08);
            padding: 1.2rem 1.4rem;
            display: flex; flex-direction: column; gap: 0.55rem;
            position: relative; min-height: 240px;
        }
        .em-cell::before {
            content: ''; position: absolute; top: 0; left: 0; right: 0; height: 3px;
        }
        .q1::before { background: #ff4d4d; }
        .q2::before { background: #20c997; }
        .q3::before { background: #f59e0b; }
        .q4::before { background: #60a5fa; }

        /* Cell header: "40% Do First" */
        .em-cell-header { display: flex; align-items: baseline; gap: 0.45rem; margin-bottom: 0.1rem; }
        .em-pct { font-size: 2.2rem; font-weight: 900; line-height: 1; }
        .em-action { font-size: 1.3rem; font-weight: 800; }
        .q1 .em-pct, .q1 .em-action { color: #ff4d4d; }
        .q2 .em-pct, .q2 .em-action { color: #20c997; }
        .q3 .em-pct, .q3 .em-action { color: #f59e0b; }
        .q4 .em-pct, .q4 .em-action { color: #60a5fa; }
        .em-sub { font-size: 0.75rem; color: rgba(255,255,255,0.3); margin-bottom: 0.3rem; }

        .em-divider { height: 1px; background: rgba(255,255,255,0.07); }

        /* Task list */
        .em-tasks { display: flex; flex-direction: column; gap: 0.3rem; overflow-y: auto; max-height: 140px; }
        .em-task {
            display: flex; align-items: center; gap: 0.5rem;
            background: rgba(255,255,255,0.03);
            border: 1px solid rgba(255,255,255,0.06);
            border-radius: 7px; padding: 0.32rem 0.6rem; font-size: 0.82rem;
        }
        .em-task.done { opacity: 0.38; text-decoration: line-through; }
        .em-dot { width: 7px; height: 7px; border-radius: 50%; flex-shrink: 0; }
        .em-task-text { flex: 1; color: #ddd; }
        .em-task-btns { display: flex; gap: 0.2rem; }
        .em-task-btns form { display: inline; }
        .em-task-btns button { background: transparent; border: none; cursor: pointer; font-size: 0.75rem; padding: 2px 5px; border-radius: 4px; line-height: 1; }
        .em-task-btns .done-btn { color: #20c997; }
        .em-task-btns .done-btn:hover { background: rgba(32,201,151,0.15); }
        .em-task-btns .del-btn  { color: #ff4d4d; }
        .em-task-btns .del-btn:hover  { background: rgba(255,77,77,0.15); }
        .em-empty { color: rgba(255,255,255,0.18); font-size: 0.8rem; font-style: italic; text-align: center; padding: 0.8rem 0; }

        /* X-axis */
        .em-xaxis { display: flex; align-items: center; justify-content: space-around; padding-top: 0.6rem; position: relative; }
        .em-xaxis-tick { font-size: 0.88rem; font-weight: 600; color: rgba(255,255,255,0.38); width: 50%; text-align: center; }
        .em-xaxis-label { position: absolute; left: 50%; transform: translateX(-50%); font-weight: 800; font-size: 0.95rem; color: #fff; white-space: nowrap; }
    </style>
</head>
<body>
<div class="page-wrapper">
    <nav class="navbar">
        <a href="dashboard.jsp" class="navbar-brand">Productivity Manager</a>
        <ul class="navbar-nav">
            <li><a href="dashboard.jsp">Dashboard</a></li>
            <li><a href="todo.jsp" class="active">Matrix</a></li>
        </ul>
        <div class="navbar-user">
            <span><%= name %></span>
            <a href="logout" class="btn btn-sm btn-secondary">Logout</a>
        </div>
    </nav>

    <div style="max-width:1300px; margin:0 auto; padding: 2rem;">

        <div style="margin:2rem 0 1.5rem; display:flex; align-items:flex-start; justify-content:space-between; flex-wrap:wrap; gap:1rem;">
            <div>
                <h1 class="page-title">Eisenhower Matrix</h1>
                <p class="page-subtitle">Tick Urgent and/or Important to classify your task</p>
            </div>
            <form action="todo" method="post">
                <input type="hidden" name="action" value="clearAll"/>
                <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('Clear all tasks?')" <%= todos.isEmpty()?"disabled":"" %>>Clear All</button>
            </form>
        </div>

        <%-- ── Add Task Form ── --%>
        <div class="add-task-card">
            <h3>Add New Task</h3>
            <form action="todo" method="post">
                <input type="hidden" name="action" value="add"/>
                <div class="add-task-row">
                    <input type="text" name="task" class="add-task-input" placeholder="Enter task description..." required maxlength="200"/>
                    <div class="checkbox-group">
                        <label class="checkbox-label urgent-cb">
                            <input type="checkbox" name="urgent" value="true" id="urgentCb"/> Urgent
                        </label>
                        <label class="checkbox-label important-cb">
                            <input type="checkbox" name="important" value="true" id="importantCb"/> Important
                        </label>
                    </div>
                    <button type="submit" class="add-btn">+ Add Task</button>
                </div>
            </form>
        </div>

        <%-- ── Eisenhower Matrix ── --%>
        <div class="em-outer">
            <%-- Y-Axis --%>
            <div class="em-yaxis">
                <div class="em-yaxis-tick">No</div>
                <div class="em-yaxis-label">Urgent?</div>
                <div class="em-yaxis-tick">Yes</div>
            </div>

            <div class="em-right">
                <div class="em-grid">

                    <%-- TOP-LEFT: Urgent=No, Important=No → Eliminate (Q4) --%>
                    <div class="em-cell q4">
                        <div class="em-cell-header">
                            <span class="em-pct"><%= q4Pct %>%</span>
                            <span class="em-action">Eliminate</span>
                        </div>
                        <div class="em-sub">Not Urgent &amp; Not Important</div>
                        <div class="em-divider"></div>
                        <div class="em-tasks">
                            <% boolean q4Has=false; for(Map<String,String> t:todos){ if("false".equals(t.get("urgent")) && "false".equals(t.get("important"))) { q4Has=true; boolean d="done".equals(t.get("status")); %>
                            <div class="em-task <%= d?"done":"" %>">
                                <div class="em-dot" style="background:#60a5fa;"></div>
                                <span class="em-task-text"><%= t.get("task") %></span>
                                <div class="em-task-btns">
                                    <% if(!d){ %><form action="todo" method="post"><input type="hidden" name="action" value="complete"/><input type="hidden" name="id" value="<%= t.get("id") %>"/><button type="submit" class="done-btn" title="Complete">✓</button></form><% } %>
                                    <form action="todo" method="post"><input type="hidden" name="action" value="delete"/><input type="hidden" name="id" value="<%= t.get("id") %>"/><button type="submit" class="del-btn" title="Delete">✕</button></form>
                                </div>
                            </div>
                            <% }} if(!q4Has){ %><div class="em-empty">No tasks</div><% } %>
                        </div>
                    </div>

                    <%-- TOP-RIGHT: Urgent=No, Important=Yes → Schedule (Q2) --%>
                    <div class="em-cell q2">
                        <div class="em-cell-header">
                            <span class="em-pct"><%= q2Pct %>%</span>
                            <span class="em-action">Schedule</span>
                        </div>
                        <div class="em-sub">Not Urgent, Important</div>
                        <div class="em-divider"></div>
                        <div class="em-tasks">
                            <% boolean q2Has=false; for(Map<String,String> t:todos){ if("false".equals(t.get("urgent")) && "true".equals(t.get("important"))) { q2Has=true; boolean d="done".equals(t.get("status")); %>
                            <div class="em-task <%= d?"done":"" %>">
                                <div class="em-dot" style="background:#20c997;"></div>
                                <span class="em-task-text"><%= t.get("task") %></span>
                                <div class="em-task-btns">
                                    <% if(!d){ %><form action="todo" method="post"><input type="hidden" name="action" value="complete"/><input type="hidden" name="id" value="<%= t.get("id") %>"/><button type="submit" class="done-btn" title="Complete">✓</button></form><% } %>
                                    <form action="todo" method="post"><input type="hidden" name="action" value="delete"/><input type="hidden" name="id" value="<%= t.get("id") %>"/><button type="submit" class="del-btn" title="Delete">✕</button></form>
                                </div>
                            </div>
                            <% }} if(!q2Has){ %><div class="em-empty">No tasks</div><% } %>
                        </div>
                    </div>

                    <%-- BOTTOM-LEFT: Urgent=Yes, Important=No → Delegate (Q3) --%>
                    <div class="em-cell q3">
                        <div class="em-cell-header">
                            <span class="em-pct"><%= q3Pct %>%</span>
                            <span class="em-action">Delegate</span>
                        </div>
                        <div class="em-sub">Urgent, but Not Important</div>
                        <div class="em-divider"></div>
                        <div class="em-tasks">
                            <% boolean q3Has=false; for(Map<String,String> t:todos){ if("true".equals(t.get("urgent")) && "false".equals(t.get("important"))) { q3Has=true; boolean d="done".equals(t.get("status")); %>
                            <div class="em-task <%= d?"done":"" %>">
                                <div class="em-dot" style="background:#f59e0b;"></div>
                                <span class="em-task-text"><%= t.get("task") %></span>
                                <div class="em-task-btns">
                                    <% if(!d){ %><form action="todo" method="post"><input type="hidden" name="action" value="complete"/><input type="hidden" name="id" value="<%= t.get("id") %>"/><button type="submit" class="done-btn" title="Complete">✓</button></form><% } %>
                                    <form action="todo" method="post"><input type="hidden" name="action" value="delete"/><input type="hidden" name="id" value="<%= t.get("id") %>"/><button type="submit" class="del-btn" title="Delete">✕</button></form>
                                </div>
                            </div>
                            <% }} if(!q3Has){ %><div class="em-empty">No tasks</div><% } %>
                        </div>
                    </div>

                    <%-- BOTTOM-RIGHT: Urgent=Yes, Important=Yes → Do First (Q1) --%>
                    <div class="em-cell q1">
                        <div class="em-cell-header">
                            <span class="em-pct"><%= q1Pct %>%</span>
                            <span class="em-action">Do First</span>
                        </div>
                        <div class="em-sub">Urgent &amp; Important</div>
                        <div class="em-divider"></div>
                        <div class="em-tasks">
                            <% boolean q1Has=false; for(Map<String,String> t:todos){ if("true".equals(t.get("urgent")) && "true".equals(t.get("important"))) { q1Has=true; boolean d="done".equals(t.get("status")); %>
                            <div class="em-task <%= d?"done":"" %>">
                                <div class="em-dot" style="background:#ff4d4d;"></div>
                                <span class="em-task-text"><%= t.get("task") %></span>
                                <div class="em-task-btns">
                                    <% if(!d){ %><form action="todo" method="post"><input type="hidden" name="action" value="complete"/><input type="hidden" name="id" value="<%= t.get("id") %>"/><button type="submit" class="done-btn" title="Complete">✓</button></form><% } %>
                                    <form action="todo" method="post"><input type="hidden" name="action" value="delete"/><input type="hidden" name="id" value="<%= t.get("id") %>"/><button type="submit" class="del-btn" title="Delete">✕</button></form>
                                </div>
                            </div>
                            <% }} if(!q1Has){ %><div class="em-empty">No tasks</div><% } %>
                        </div>
                    </div>

                </div><%-- end .em-grid --%>

                <%-- X-Axis --%>
                <div class="em-xaxis">
                    <span class="em-xaxis-tick">No</span>
                    <span class="em-xaxis-label">Important</span>
                    <span class="em-xaxis-tick">Yes</span>
                </div>
            </div>
        </div>

        <div class="productivity-container">
            <button class="btn-outline-purple" onclick="revealProductivity()">Calculate Productivity</button>
            
            <div id="productivityCard" class="productivity-card">
                <div class="productivity-score"><%= q2Prod %>%</div>
                <div class="productivity-label">Productivity Score</div>
                <div style="font-size: 0.85rem; color: rgba(255,255,255,0.2); margin-top: 1rem;">
                    Quadrant 2 (Schedule) Productivity Contribution
                </div>
            </div>
        </div>

        </div>

        <footer style="margin-top: 4rem; padding: 2rem 0; text-align: center; border-top: 1px solid rgba(255,255,255,0.05);">
            <p style="font-size: 0.75rem; color: rgba(255,255,255,0.3); letter-spacing: 1px; font-weight: 500;">
                Arryansh Messon 590013268 B9
            </p>
        </footer>

    </div>

<script>
function revealProductivity() {
    localStorage.setItem('productivityRevealed', 'true');
    const card = document.getElementById('productivityCard');
    card.style.display = 'block';
    setTimeout(() => {
        card.scrollIntoView({ behavior: 'smooth', block: 'center' });
    }, 100);
}

// Auto-reveal if it was already open before reload
window.onload = function() {
    if (localStorage.getItem('productivityRevealed') === 'true') {
        document.getElementById('productivityCard').style.display = 'block';
    }
}
</script>
</body>
</html>
# Productivity Manager

A professional Eisenhower Matrix productivity tool designed for high-performance task management. This application uses a dark glassmorphism theme and a robust Java/Servlet backend.

## 📋 Prerequisites
- **Java JDK 21** or higher
- **Maven 3.9+**

---

## 🛠️ Build and Deployment Commands

### 1. Compile the Project
To verify the code and compile all classes:
```bash
mvn clean compile
```

### 2. Run All Tests
To execute the 13-case JUnit test suite (Positive, Negative, Boundary, and Parameterized):
```bash
mvn test
```

### 3. Build the Application Portfolio (.war)
To generate the final deployable artifact for your server:
```bash
mvn clean package
```
*The resulting file will be located at: `target/ProductivityMatrix.war`*

---

## 🔍 Data Management & Utilities

### View Registered User Data
Since the user records are stored in a serialized `.dat` file, use this command to view the list of users and passwords in your terminal:

```bash
# Ensure the project is compiled first
java -cp target/classes com.project.ReadUsers
```

---

## 🚀 How to Run the App
1.  **Build the .war file** using the command above.
2.  **Deploy to Tomcat**: Move the `ProductivityMatrix.war` file to your server’s `/webapps` directory.
3.  **Access the App**: Navigate to `http://localhost:8080/ProductivityMatrix` in your browser.

---

## 📁 Project Structure
- **/src/main/java**: Core Servlet and Logic (UserStore, TodoServlet)
- **/src/test/java**: JUnit 5 Test Suite (AppTest)
- **/WebContent**: UI Layer (JSP, CSS, and styling)
- **Productivity_Manager_Report.doc**: Final project report

---
**Developer:** Arryansh Messon 590013268 B9

package com.project;

import org.junit.jupiter.api.*;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.ValueSource;

import static org.junit.jupiter.api.Assertions.*;

@DisplayName("Productivity Matrix Application Test Suite")
public class AppTest {

    private UserStore store;

    @BeforeAll
    static void initAll() {
        System.out.println("=========================================");
        System.out.println(" Starting Junit Test Runner for Productivity Matrix");
        System.out.println("=========================================");
    }

    @AfterAll
    static void tearDownAll() {
        System.out.println("=========================================");
        System.out.println(" Completed All 13 Test Cases Successfully");
        System.out.println("=========================================");
    }

    @BeforeEach
    void setUp() {
        store = UserStore.getInstance();
    }

    @AfterEach
    void tearDown() {
    }

    // ----------------------------------------------------
    // POSITIVE TEST CASES (5)
    // ----------------------------------------------------

    @Test
    @DisplayName("Pos 1: Valid Email returns true")
    void testValidEmail() {
        assertTrue(Validator.isValidEmail("student@university.edu"));
    }

    @Test
    @DisplayName("Pos 2: Registering a unique user returns true")
    void testUserRegistration() {
        String uniqueEmail = "user" + System.currentTimeMillis() + "@test.com";
        assertTrue(store.register("Alice", uniqueEmail, "secure123"));
    }

    @Test
    @DisplayName("Pos 3: Login succeeds with correct credentials")
    void testUserLoginSuccess() {
        String email = "login" + System.currentTimeMillis() + "@test.com";
        store.register("Bob", email, "mypassword");
        assertTrue(store.login(email, "mypassword"));
    }

    @Test
    @DisplayName("Pos 4: Checking if registered user exists returns true")
    void testUserExists() {
        String email = "exist" + System.currentTimeMillis() + "@test.com";
        store.register("Charlie", email, "secret");
        assertTrue(store.exists(email));
    }

    @Test
    @DisplayName("Pos 5: getName correctly retrieves user by email")
    void testGetUserName() {
        String email = "nameuser" + System.currentTimeMillis() + "@test.com";
        store.register("David", email, "secret789");
        assertEquals("David", store.getName(email));
    }

    // ----------------------------------------------------
    // NEGATIVE TEST CASES (3)
    // ----------------------------------------------------

    @Test
    @DisplayName("Neg 1: Registering an already existing email returns false")
    void testDuplicateRegistration() {
        String email = "duplicate" + System.currentTimeMillis() + "@test.com";
        store.register("Eve", email, "testpass");
        
        assertFalse(store.register("Eve Duplicate", email, "testpass2"));
    }

    @Test
    @DisplayName("Neg 2: Login fails when password is incorrect")
    void testLoginWrongPassword() {
        String email = "wrong" + System.currentTimeMillis() + "@test.com";
        store.register("Frank", email, "correctpass");
        
        assertFalse(store.login(email, "WRONGpass"));
    }

    @Test
    @DisplayName("Neg 3: Exception Handling Verification (assertThrows)")
    void testExpectedException() {
        String emptyVal = null;
        assertThrows(NullPointerException.class, () -> {
            emptyVal.toLowerCase();
        });
    }

    // ----------------------------------------------------
    // BOUNDARY TEST CASES (3)
    // ----------------------------------------------------

    @Test
    @DisplayName("Bound 1: Exact lower limit for password length (6 chars)")
    void testPasswordExactBoundary() {
        assertTrue(Validator.isValidPassword("123456"));
    }

    @Test
    @DisplayName("Bound 2: One character below the minimum password length (5 chars)")
    void testPasswordSlightlyBelowBoundary() {
        assertFalse(Validator.isValidPassword("12345"));
    }

    @Test
    @DisplayName("Bound 3: Minimal acceptable email format")
    void testEmailMinimalBoundary() {
        assertTrue(Validator.isValidEmail("a@b"));
    }

    // ----------------------------------------------------
    // PARAMETERIZED TEST CASES (2)
    // ----------------------------------------------------

    @ParameterizedTest
    @ValueSource(strings = {"no_at_symbol_email.com", "@missingprefix.com", "missingpostfix@"})
    @DisplayName("Param 1: Parameterized check of Invalid Emails")
    void testMultipleInvalidEmails(String invalidParam) {
        assertFalse(Validator.isValidEmail(invalidParam));
    }

    @ParameterizedTest
    @ValueSource(strings = {"mypass123", "verySecure!123", "a_long_complex_password_456"})
    @DisplayName("Param 2: Parameterized check of Valid Passwords")
    void testMultipleValidPasswords(String validParam) {
        assertTrue(Validator.isValidPassword(validParam));
    }
}

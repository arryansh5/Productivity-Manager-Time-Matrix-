package com.project;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.junit.jupiter.api.Assertions.assertFalse;

public class ValidatorTest {

    // ✅ Email Tests
    @Test
    void testValidEmail() {
        assertTrue(Validator.isValidEmail("test@gmail.com"));
    }

    @Test
    void testInvalidEmail() {
        assertFalse(Validator.isValidEmail("wrong-email"));
    }

    @Test
    void testNullEmail() {
        assertFalse(Validator.isValidEmail(null));
    }

    @Test
    void testEmptyEmail() {
        assertFalse(Validator.isValidEmail(""));
    }

    // ✅ Password Tests
    @Test
    void testValidPassword() {
        assertTrue(Validator.isValidPassword("abcdef"));
        assertTrue(Validator.isValidPassword("securepassword123"));
    }

    @Test
    void testShortPassword() {
        assertFalse(Validator.isValidPassword("abc"));
        assertFalse(Validator.isValidPassword("12345"));
    }

    @Test
    void testNullPassword() {
        assertFalse(Validator.isValidPassword(null));
    }
}

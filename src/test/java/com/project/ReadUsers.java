package com.project;

import java.io.*;
import java.util.*;

public class ReadUsers {
    public static void main(String[] args) {
        File file = new File(System.getProperty("user.home") + File.separator + "productivity_matrix_users.dat");
        System.out.println("Reading from: " + file.getAbsolutePath());
        
        if (!file.exists()) {
            System.out.println("\n[Status] The file does not exist yet. You need to run the application and register a user first!");
            return;
        }

        try (ObjectInputStream ois = new ObjectInputStream(new FileInputStream(file))) {
            @SuppressWarnings("unchecked")
            Map<String, String[]> users = (Map<String, String[]>) ois.readObject();
            
            System.out.println("\n============ REGISTERED USERS ============");
            if (users.isEmpty()) {
                System.out.println("  No users found in the database.");
            } else {
                for (Map.Entry<String, String[]> entry : users.entrySet()) {
                    System.out.println("  Email:    " + entry.getKey());
                    System.out.println("  Name:     " + entry.getValue()[0]);
                    System.out.println("  Password: " + entry.getValue()[1]);
                    System.out.println("  ----------------------------------------");
                }
            }
            System.out.println("==========================================");
            
        } catch (Exception e) {
            System.out.println("Error reading file: " + e.getMessage());
        }
    }
}

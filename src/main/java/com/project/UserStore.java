package com.project;

import java.io.*;
import java.util.HashMap;
import java.util.Map;

public class UserStore implements Authentication {

    private static UserStore instance;
    private final Map<String, String[]> users = new HashMap<>();
    private final String storeFile = System.getProperty("user.home") + File.separator + "productivity_matrix_users.dat";

    private UserStore() {
        loadUsers();
    }

    private void loadUsers() {
        File file = new File(storeFile);
        if (file.exists()) {
            try (ObjectInputStream ois = new ObjectInputStream(new FileInputStream(file))) {
                @SuppressWarnings("unchecked")
                Map<String, String[]> loadedUsers = (Map<String, String[]>) ois.readObject();
                users.putAll(loadedUsers);
            } catch (Exception e) {
                System.err.println("Failed to load users: " + e.getMessage());
            }
        }
    }

    private void saveUsers() {
        try (ObjectOutputStream oos = new ObjectOutputStream(new FileOutputStream(storeFile))) {
            oos.writeObject(users);
        } catch (Exception e) {
            System.err.println("Failed to save users: " + e.getMessage());
        }
    }

    public static synchronized UserStore getInstance() {
        if (instance == null) {
            instance = new UserStore();
        }
        return instance;
    }

    public boolean register(String name, String email, String password) {
        if (users.containsKey(email)) return false;
        users.put(email, new String[]{name, password});
        saveUsers();
        return true;
    }

    public boolean login(String email, String password) {
        String[] data = users.get(email);
        return data != null && data[1].equals(password);
    }

    public String getName(String email) {
        String[] data = users.get(email);
        return data != null ? data[0] : null;
    }

    public boolean exists(String email) {
        return users.containsKey(email);
    }
}

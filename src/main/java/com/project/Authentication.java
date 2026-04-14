package com.project;

public interface Authentication {
    boolean register(String name, String email, String password);
    boolean login(String email, String password);
    boolean exists(String email);
    String getName(String email);
}

package com.forum.service;

import com.forum.entity.User;
import java.util.List;

public interface UserService {

    User login(String username, String password);

    boolean register(User user);

    User findById(Long id);

    User findByUsername(String username);

    boolean updateProfile(User user);

    boolean changePassword(Long userId, String oldPassword, String newPassword);

    List<User> getAllUsers(int page, int size);

    int getUserCount();

    boolean updateUserStatus(Long userId, Integer status);

    boolean updateUserRole(Long userId, Integer role);

    boolean isUsernameExists(String username);

    boolean isEmailExists(String email);
}
package com.forum.service.impl;

import com.forum.entity.User;
import com.forum.mapper.UserMapper;
import com.forum.service.UserService;
import org.apache.commons.codec.digest.DigestUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class UserServiceImpl implements UserService {

    @Autowired
    private UserMapper userMapper;

    @Override
    public User login(String username, String password) {
        User user = userMapper.findByUsername(username);
        if (user != null && user.getStatus() == 1) {
            String encodedPassword = DigestUtils.md5Hex(password);
            if (encodedPassword.equals(user.getPassword())) {
                return user;
            }
        }
        return null;
    }

    @Override
    public boolean register(User user) {
        if (isUsernameExists(user.getUsername()) || isEmailExists(user.getEmail())) {
            return false;
        }
        user.setPassword(DigestUtils.md5Hex(user.getPassword()));
        user.setRole(0);  // 默认为普通用户
        user.setStatus(1); // 默认为正常状态
        return userMapper.insert(user) > 0;
    }

    @Override
    public User findById(Long id) {
        return userMapper.findById(id);
    }

    @Override
    public User findByUsername(String username) {
        return userMapper.findByUsername(username);
    }

    @Override
    public boolean updateProfile(User user) {
        return userMapper.update(user) > 0;
    }

    @Override
    public boolean changePassword(Long userId, String oldPassword, String newPassword) {
        User user = userMapper.findById(userId);
        if (user != null) {
            String encodedOldPassword = DigestUtils.md5Hex(oldPassword);
            if (encodedOldPassword.equals(user.getPassword())) {
                user.setPassword(DigestUtils.md5Hex(newPassword));
                return userMapper.update(user) > 0;
            }
        }
        return false;
    }

    @Override
    public List<User> getAllUsers(int page, int size) {
        int offset = (page - 1) * size;
        return userMapper.findAll(offset, size);
    }

    @Override
    public int getUserCount() {
        return userMapper.countAll();
    }

    @Override
    public boolean updateUserStatus(Long userId, Integer status) {
        return userMapper.updateStatus(userId, status) > 0;
    }

    @Override
    public boolean isUsernameExists(String username) {
        return userMapper.findByUsername(username) != null;
    }

    @Override
    public boolean isEmailExists(String email) {
        return userMapper.findByEmail(email) != null;
    }
}
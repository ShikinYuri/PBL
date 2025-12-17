package com.forum.mapper;

import com.forum.entity.User;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface UserMapper {

    User findById(Long id);

    User findByUsername(@Param("username") String username);

    User findByEmail(@Param("email") String email);

    int insert(User user);

    int update(User user);

    int deleteById(Long id);

    List<User> findAll(@Param("offset") int offset, @Param("limit") int limit);

    int countAll();

    int updateStatus(@Param("id") Long id, @Param("status") Integer status);

    int countByRole(@Param("role") Integer role);
}
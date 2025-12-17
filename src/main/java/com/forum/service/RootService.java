package com.forum.service;

import com.forum.entity.Root;

import java.util.List;

public interface RootService {
    Root findByUserId(Long userId);

    List<Root> findAll(int page, int size);

    int getCount();

    boolean addRoot(Long userId);

    boolean setActive(Long userId, Integer active);

    boolean removeRoot(Long userId);

    boolean isRoot(Long userId);
}

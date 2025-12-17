package com.forum.service.impl;

import com.forum.entity.Root;
import com.forum.mapper.RootMapper;
import com.forum.service.RootService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class RootServiceImpl implements RootService {

    @Autowired
    private RootMapper rootMapper;

    @Override
    public Root findByUserId(Long userId) {
        return rootMapper.findByUserId(userId);
    }

    @Override
    public List<Root> findAll(int page, int size) {
        int offset = (page - 1) * size;
        return rootMapper.findAll(offset, size);
    }

    @Override
    public int getCount() {
        return rootMapper.countAll();
    }

    @Override
    public boolean addRoot(Long userId) {
        Root exists = rootMapper.findByUserId(userId);
        if (exists != null) {
            // 若已存在则激活
            exists.setActive(1);
            return rootMapper.update(exists) > 0;
        }
        Root root = new Root();
        root.setUserId(userId);
        root.setActive(1);
        return rootMapper.insert(root) > 0;
    }

    @Override
    public boolean setActive(Long userId, Integer active) {
        Root exists = rootMapper.findByUserId(userId);
        if (exists == null) return false;
        exists.setActive(active);
        return rootMapper.update(exists) > 0;
    }

    @Override
    public boolean removeRoot(Long userId) {
        return rootMapper.deleteByUserId(userId) > 0;
    }

    @Override
    public boolean isRoot(Long userId) {
        Root r = rootMapper.findByUserId(userId);
        return r != null && r.getActive() != null && r.getActive() == 1;
    }
}

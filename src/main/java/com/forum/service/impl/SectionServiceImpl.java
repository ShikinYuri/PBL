package com.forum.service.impl;

import com.forum.entity.Section;
import com.forum.mapper.PostMapper;
import com.forum.mapper.SectionMapper;
import com.forum.service.SectionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class SectionServiceImpl implements SectionService {

    @Autowired
    private SectionMapper sectionMapper;

    @Autowired
    private PostMapper postMapper;

    @Override
    public List<Section> getAllSections() {
        return sectionMapper.findAll();
    }

    @Override
    public Section getSectionById(Long id) {
        return sectionMapper.findById(id);
    }

    @Override
    public boolean createSection(Section section) {
        section.setPostCount(0);
        section.setStatus(1);
        return sectionMapper.insert(section) > 0;
    }

    @Override
    public boolean updateSection(Section section) {
        return sectionMapper.update(section) > 0;
    }

    @Override
    public boolean deleteSection(Long id) {
        return sectionMapper.deleteById(id) > 0;
    }

    @Override
    public void updatePostCount(Long sectionId) {
        int count = postMapper.countBySectionId(sectionId);
        sectionMapper.updatePostCount(sectionId, count);
    }
}
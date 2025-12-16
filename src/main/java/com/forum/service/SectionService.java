package com.forum.service;

import com.forum.entity.Section;
import java.util.List;

public interface SectionService {

    List<Section> getAllSections();

    Section getSectionById(Long id);

    boolean createSection(Section section);

    boolean updateSection(Section section);

    boolean deleteSection(Long id);

    void updatePostCount(Long sectionId);
}
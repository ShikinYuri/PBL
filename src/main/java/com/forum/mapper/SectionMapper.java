package com.forum.mapper;

import com.forum.entity.Section;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface SectionMapper {

    Section findById(Long id);

    List<Section> findAll();

    int insert(Section section);

    int update(Section section);

    int deleteById(Long id);

    int updatePostCount(@Param("id") Long id, @Param("count") Integer count);
}
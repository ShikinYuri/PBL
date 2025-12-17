package com.forum.mapper;

import com.forum.entity.Root;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface RootMapper {
    Root findByUserId(@Param("userId") Long userId);

    List<Root> findAll(@Param("offset") int offset, @Param("limit") int limit);

    int countAll();

    int insert(Root root);

    int update(Root root);

    int deleteByUserId(@Param("userId") Long userId);
}

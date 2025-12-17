package com.forum.mapper;

import com.forum.entity.Reply;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface ReplyMapper {

    Reply findById(Long id);

    List<Reply> findByPostId(@Param("postId") Long postId, @Param("offset") int offset, @Param("limit") int limit);

    List<Reply> findByUserId(@Param("userId") Long userId, @Param("offset") int offset, @Param("limit") int limit);

    int insert(Reply reply);

    int update(Reply reply);

    int deleteById(Long id);

    int countByPostId(Long postId);

    int countByUserId(Long userId);

    int getMaxFloorByPostId(Long postId);
}
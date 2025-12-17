package com.forum.mapper;

import com.forum.entity.Post;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface PostMapper {

    Post findById(Long id);

    List<Post> findBySectionId(@Param("sectionId") Long sectionId, @Param("offset") int offset, @Param("limit") int limit);

    List<Post> findByUserId(@Param("userId") Long userId, @Param("offset") int offset, @Param("limit") int limit);

    List<Post> findAll(@Param("offset") int offset, @Param("limit") int limit);

    List<Post> findTopPosts(@Param("limit") int limit);

    int insert(Post post);

    int update(Post post);

    int deleteById(Long id);

    int countBySectionId(Long sectionId);

    int countByUserId(Long userId);

    int countAll();

    int increaseViewCount(Long id);

    int increaseReplyCount(@Param("id") Long id, @Param("lastReplyTime") String lastReplyTime, @Param("lastReplyUserId") Long lastReplyUserId);

    int updateReplyCount(@Param("postId") Long postId);

    List<Post> searchPosts(@Param("keyword") String keyword, @Param("offset") int offset, @Param("limit") int limit);

    int countSearchPosts(@Param("keyword") String keyword);
}
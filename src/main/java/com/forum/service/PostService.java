package com.forum.service;

import com.forum.entity.Post;
import java.util.List;

public interface PostService {

    boolean createPost(Post post);

    Post getPostById(Long id);

    boolean updatePost(Post post);

    boolean deletePost(Long id);

    List<Post> getPostsBySectionId(Long sectionId, int page, int size);

    List<Post> getPostsByUserId(Long userId, int page, int size);

    List<Post> getAllPosts(int page, int size);

    List<Post> getTopPosts(int limit);

    List<Post> searchPosts(String keyword, int page, int size);

    int getPostCount();

    int getPostCountBySectionId(Long sectionId);

    int getPostCountByUserId(Long userId);

    int getSearchPostCount(String keyword);

    boolean increaseViewCount(Long postId);

    // 更新帖子回复信息（回复数、最后回复时间、最后回复人）
    void updateReplyInfo(Long postId, Long replyUserId);
}
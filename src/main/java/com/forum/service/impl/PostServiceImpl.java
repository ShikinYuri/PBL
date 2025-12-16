package com.forum.service.impl;

import com.forum.entity.Post;
import com.forum.mapper.PostMapper;
import com.forum.service.PostService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@Service
@Transactional
public class PostServiceImpl implements PostService {

    @Autowired
    private PostMapper postMapper;

    @Override
    public boolean createPost(Post post) {
        post.setStatus(1);
        post.setViewCount(0);
        post.setReplyCount(0);
        post.setIsTop(0);
        post.setIsEssence(0);
        return postMapper.insert(post) > 0;
    }

    @Override
    public Post getPostById(Long id) {
        return postMapper.findById(id);
    }

    @Override
    public boolean updatePost(Post post) {
        return postMapper.update(post) > 0;
    }

    @Override
    public boolean deletePost(Long id) {
        return postMapper.deleteById(id) > 0;
    }

    @Override
    public List<Post> getPostsBySectionId(Long sectionId, int page, int size) {
        int offset = (page - 1) * size;
        return postMapper.findBySectionId(sectionId, offset, size);
    }

    @Override
    public List<Post> getPostsByUserId(Long userId, int page, int size) {
        int offset = (page - 1) * size;
        return postMapper.findByUserId(userId, offset, size);
    }

    @Override
    public List<Post> getAllPosts(int page, int size) {
        int offset = (page - 1) * size;
        return postMapper.findAll(offset, size);
    }

    @Override
    public List<Post> getTopPosts(int limit) {
        return postMapper.findTopPosts(limit);
    }

    @Override
    public List<Post> searchPosts(String keyword, int page, int size) {
        int offset = (page - 1) * size;
        return postMapper.searchPosts(keyword, offset, size);
    }

    @Override
    public int getPostCount() {
        return postMapper.countAll();
    }

    @Override
    public int getPostCountBySectionId(Long sectionId) {
        return postMapper.countBySectionId(sectionId);
    }

    @Override
    public int getPostCountByUserId(Long userId) {
        return postMapper.countByUserId(userId);
    }

    @Override
    public int getSearchPostCount(String keyword) {
        return postMapper.countSearchPosts(keyword);
    }

    @Override
    public boolean increaseViewCount(Long postId) {
        return postMapper.increaseViewCount(postId) > 0;
    }

    public void updateReplyInfo(Long postId, Long replyUserId) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String now = sdf.format(new Date());
        postMapper.increaseReplyCount(postId, now, replyUserId);
    }
}
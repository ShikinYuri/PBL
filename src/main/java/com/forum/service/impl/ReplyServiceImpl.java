package com.forum.service.impl;

import com.forum.entity.Reply;
import com.forum.mapper.ReplyMapper;
import com.forum.service.ReplyService;
<<<<<<< HEAD
import com.forum.service.PostService;
=======
>>>>>>> ShikinYuri
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class ReplyServiceImpl implements ReplyService {

    @Autowired
    private ReplyMapper replyMapper;
<<<<<<< HEAD
    @Autowired
    private PostService postService;
=======
>>>>>>> ShikinYuri

    @Override
    public boolean createReply(Reply reply) {
        reply.setStatus(1);
        int maxFloor = replyMapper.getMaxFloorByPostId(reply.getPostId());
        reply.setFloor(maxFloor + 1);
        return replyMapper.insert(reply) > 0;
    }

    @Override
    public Reply getReplyById(Long id) {
        return replyMapper.findById(id);
    }

    @Override
    public boolean updateReply(Reply reply) {
        return replyMapper.update(reply) > 0;
    }

    @Override
    public boolean deleteReply(Long id) {
<<<<<<< HEAD
        // 获取回复以便知道所属帖子
        Reply r = replyMapper.findById(id);
        boolean ok = replyMapper.deleteById(id) > 0;
        if (ok && r != null && r.getPostId() != null) {
            // 调整帖子回复计数为数据库真实值
            postService.updateReplyCount(r.getPostId());
        }
        return ok;
=======
        return replyMapper.deleteById(id) > 0;
>>>>>>> ShikinYuri
    }

    @Override
    public List<Reply> getRepliesByPostId(Long postId, int page, int size) {
        int offset = (page - 1) * size;
        return replyMapper.findByPostId(postId, offset, size);
    }

    @Override
    public List<Reply> getRepliesByUserId(Long userId, int page, int size) {
        int offset = (page - 1) * size;
        return replyMapper.findByUserId(userId, offset, size);
    }

    @Override
    public int getReplyCountByPostId(Long postId) {
        return replyMapper.countByPostId(postId);
    }

    @Override
    public int getReplyCountByUserId(Long userId) {
        return replyMapper.countByUserId(userId);
    }
}
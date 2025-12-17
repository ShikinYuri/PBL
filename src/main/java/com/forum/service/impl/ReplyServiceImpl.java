package com.forum.service.impl;

import com.forum.entity.Reply;
import com.forum.mapper.ReplyMapper;
import com.forum.service.ReplyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class ReplyServiceImpl implements ReplyService {

    @Autowired
    private ReplyMapper replyMapper;

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
        return replyMapper.deleteById(id) > 0;
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
package com.forum.service;

import com.forum.entity.Reply;
import java.util.List;

public interface ReplyService {

    boolean createReply(Reply reply);

    Reply getReplyById(Long id);

    boolean updateReply(Reply reply);

    boolean deleteReply(Long id);

    List<Reply> getRepliesByPostId(Long postId, int page, int size);

    List<Reply> getRepliesByUserId(Long userId, int page, int size);

    int getReplyCountByPostId(Long postId);

    int getReplyCountByUserId(Long userId);
}
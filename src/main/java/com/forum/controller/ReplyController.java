package com.forum.controller;

import com.forum.entity.Post;
import com.forum.entity.Reply;
import com.forum.entity.User;
import com.forum.service.PostService;
import com.forum.service.ReplyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/reply")
public class ReplyController {

    @Autowired
    private ReplyService replyService;

    @Autowired
    private PostService postService;

    @PostMapping("/create")
    @ResponseBody
    public Map<String, Object> createReply(@RequestParam Long postId,
                                          @RequestParam String content,
                                          @RequestParam(required = false) Long replyUserId,
                                          HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            result.put("success", false);
            result.put("message", "请先登录");
            return result;
        }

        if (content == null || content.trim().isEmpty()) {
            result.put("success", false);
            result.put("message", "回复内容不能为空");
            return result;
        }

        Post post = postService.getPostById(postId);
        if (post == null) {
            result.put("success", false);
            result.put("message", "帖子不存在");
            return result;
        }

        Reply reply = new Reply();
        reply.setContent(content.trim());
        reply.setPostId(postId);
        reply.setUserId(user.getId());
        reply.setReplyUserId(replyUserId);

        if (replyService.createReply(reply)) {
            // 更新帖子的回复信息
            if (postService instanceof com.forum.service.impl.PostServiceImpl) {
                ((com.forum.service.impl.PostServiceImpl) postService).updateReplyInfo(postId, user.getId());
            }

            result.put("success", true);
            result.put("message", "回复成功");
            result.put("replyId", reply.getId());
            result.put("floor", reply.getFloor());
        } else {
            result.put("success", false);
            result.put("message", "回复失败");
        }
        return result;
    }

    @GetMapping("/list/{postId}")
    public String replyList(@PathVariable Long postId, Model model,
                           @RequestParam(defaultValue = "1") int page,
                           @RequestParam(defaultValue = "10") int size) {
        Post post = postService.getPostById(postId);
        if (post == null) {
            return "redirect:/post/list";
        }

        List<Reply> replies = replyService.getRepliesByPostId(postId, page, size);
        int totalCount = replyService.getReplyCountByPostId(postId);

        model.addAttribute("post", post);
        model.addAttribute("replies", replies);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", (int) Math.ceil((double) totalCount / size));
        return "reply/list";
    }

    @PostMapping("/delete")
    @ResponseBody
    public Map<String, Object> deleteReply(@RequestParam Long id, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            result.put("success", false);
            result.put("message", "请先登录");
            return result;
        }

        Reply reply = replyService.getReplyById(id);
        if (reply == null || (!user.isSuperUser() && !reply.getUserId().equals(user.getId()))) {
            result.put("success", false);
            result.put("message", "无权限删除该回复");
            return result;
        }

        if (replyService.deleteReply(id)) {
            result.put("success", true);
            result.put("message", "删除成功");
        } else {
            result.put("success", false);
            result.put("message", "删除失败");
        }
        return result;
    }

    @GetMapping("/my")
    public String myReplies(Model model, HttpSession session,
                           @RequestParam(defaultValue = "1") int page,
                           @RequestParam(defaultValue = "10") int size) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login";
        }

        List<Reply> replies = replyService.getRepliesByUserId(user.getId(), page, size);
        int totalCount = replyService.getReplyCountByUserId(user.getId());

        model.addAttribute("replies", replies);
        model.addAttribute("pageTitle", "我的回复");
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", (int) Math.ceil((double) totalCount / size));
        return "reply/my";
    }
}
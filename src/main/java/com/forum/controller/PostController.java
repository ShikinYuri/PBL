package com.forum.controller;

import com.forum.entity.Post;
import com.forum.entity.Section;
import com.forum.entity.User;
import com.forum.service.PostService;
import com.forum.service.SectionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/post")
public class PostController {

    @Autowired
    private PostService postService;

    @Autowired
    private SectionService sectionService;

    @GetMapping("/list")
    public String postList(Model model,
                           @RequestParam(defaultValue = "1") int page,
                           @RequestParam(defaultValue = "10") int size,
                           @RequestParam(required = false) Long sectionId) {
        List<Post> posts;
        int totalCount;
        String pageTitle = "所有帖子";

        if (sectionId != null) {
            posts = postService.getPostsBySectionId(sectionId, page, size);
            totalCount = postService.getPostCountBySectionId(sectionId);
            Section section = sectionService.getSectionById(sectionId);
            if (section != null) {
                pageTitle = section.getName();
            }
            model.addAttribute("sectionId", sectionId);
        } else {
            posts = postService.getAllPosts(page, size);
            totalCount = postService.getPostCount();
        }

        model.addAttribute("posts", posts);
        model.addAttribute("pageTitle", pageTitle);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", (int) Math.ceil((double) totalCount / size));
        model.addAttribute("sections", sectionService.getAllSections());
        return "post/list";
    }

    @GetMapping("/detail/{id}")
    public String postDetail(@PathVariable Long id, Model model) {
        // Detail view removed; redirect to reply list page for the post
        Post post = postService.getPostById(id);
        if (post == null) {
            return "redirect:/post/list";
        }
        // increase view count then redirect to reply list
        postService.increaseViewCount(id);
        return "redirect:/reply/list/" + id;
    }

    @GetMapping("/create")
    public String createPostPage(Model model) {
        model.addAttribute("sections", sectionService.getAllSections());
        return "post/create";
    }

    @PostMapping("/create")
    @ResponseBody
    public Map<String, Object> createPost(@RequestParam String title,
                                          @RequestParam String content,
                                          @RequestParam Long sectionId,
                                          HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            result.put("success", false);
            result.put("message", "请先登录");
            return result;
        }

        if (title == null || title.trim().isEmpty()) {
            result.put("success", false);
            result.put("message", "标题不能为空");
            return result;
        }

        if (content == null || content.trim().isEmpty()) {
            result.put("success", false);
            result.put("message", "内容不能为空");
            return result;
        }

        Post post = new Post();
        post.setTitle(title.trim());
        post.setContent(content);
        post.setUserId(user.getId());
        post.setSectionId(sectionId);

        if (postService.createPost(post)) {
            result.put("success", true);
            result.put("message", "发帖成功");
            result.put("postId", post.getId());
        } else {
            result.put("success", false);
            result.put("message", "发帖失败");
        }
        return result;
    }

    @GetMapping("/edit/{id}")
    public String editPostPage(@PathVariable Long id, Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login";
        }

        Post post = postService.getPostById(id);
        if (post == null || (!user.isSuperUser() && !post.getUserId().equals(user.getId()))) {
            return "redirect:/post/list";
        }

        model.addAttribute("post", post);
        model.addAttribute("sections", sectionService.getAllSections());
        return "post/edit";
    }

    @PostMapping("/edit")
    @ResponseBody
    public Map<String, Object> editPost(@RequestParam Long id,
                                        @RequestParam String title,
                                        @RequestParam String content,
                                        HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            result.put("success", false);
            result.put("message", "请先登录");
            return result;
        }

        Post post = postService.getPostById(id);
        if (post == null || (!user.isSuperUser() && !post.getUserId().equals(user.getId()))) {
            result.put("success", false);
            result.put("message", "无权限编辑该帖子");
            return result;
        }

        post.setTitle(title.trim());
        post.setContent(content);

        if (postService.updatePost(post)) {
            result.put("success", true);
            result.put("message", "更新成功");
        } else {
            result.put("success", false);
            result.put("message", "更新失败");
        }
        return result;
    }

    @PostMapping("/delete")
    @ResponseBody
    public Map<String, Object> deletePost(@RequestParam Long id, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            result.put("success", false);
            result.put("message", "请先登录");
            return result;
        }

        Post post = postService.getPostById(id);
        if (post == null || (!user.isSuperUser() && !post.getUserId().equals(user.getId()))) {
            result.put("success", false);
            result.put("message", "无权限删除该帖子");
            return result;
        }

        if (postService.deletePost(id)) {
            result.put("success", true);
            result.put("message", "删除成功");
        } else {
            result.put("success", false);
            result.put("message", "删除失败");
        }
        return result;
    }

    @GetMapping("/search")
    public String searchPosts(@RequestParam String keyword,
                              Model model,
                              @RequestParam(defaultValue = "1") int page,
                              @RequestParam(defaultValue = "10") int size) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return "redirect:/post/list";
        }

        keyword = keyword.trim();
        List<Post> posts = postService.searchPosts(keyword, page, size);
        int totalCount = postService.getSearchPostCount(keyword);

        model.addAttribute("posts", posts);
        model.addAttribute("keyword", keyword);
        model.addAttribute("pageTitle", "搜索结果: " + keyword);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", (int) Math.ceil((double) totalCount / size));
        return "post/list";
    }

    @GetMapping("/my")
    public String myPosts(Model model, HttpSession session,
                         @RequestParam(defaultValue = "1") int page,
                         @RequestParam(defaultValue = "10") int size) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login";
        }

        List<Post> posts = postService.getPostsByUserId(user.getId(), page, size);
        int totalCount = postService.getPostCountByUserId(user.getId());

        model.addAttribute("posts", posts);
        model.addAttribute("pageTitle", "我的帖子");
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", (int) Math.ceil((double) totalCount / size));
        return "post/list";
    }
}
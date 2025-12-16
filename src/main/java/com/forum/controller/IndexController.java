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
import java.util.List;

@Controller
public class IndexController {

    @Autowired
    private PostService postService;

    @Autowired
    private SectionService sectionService;

    @GetMapping("/")
    public String index(Model model,
                       @RequestParam(defaultValue = "1") int page,
                       @RequestParam(defaultValue = "10") int size) {
        List<Section> sections = sectionService.getAllSections();
        List<Post> topPosts = postService.getTopPosts(5);
        List<Post> recentPosts = postService.getAllPosts(page, size);
        int totalCount = postService.getPostCount();

        model.addAttribute("sections", sections);
        model.addAttribute("topPosts", topPosts);
        model.addAttribute("recentPosts", recentPosts);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", (int) Math.ceil((double) totalCount / size));
        return "index";
    }

    @GetMapping("/section/{id}")
    public String sectionPosts(@PathVariable Long id, Model model,
                              @RequestParam(defaultValue = "1") int page,
                              @RequestParam(defaultValue = "10") int size) {
        Section section = sectionService.getSectionById(id);
        if (section == null) {
            return "redirect:/";
        }

        List<Post> posts = postService.getPostsBySectionId(id, page, size);
        int totalCount = postService.getPostCountBySectionId(id);

        model.addAttribute("section", section);
        model.addAttribute("sections", sectionService.getAllSections());
        model.addAttribute("posts", posts);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", (int) Math.ceil((double) totalCount / size));
        return "section/posts";
    }
}
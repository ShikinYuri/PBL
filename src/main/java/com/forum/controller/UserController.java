package com.forum.controller;

import com.forum.entity.User;
import com.forum.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/user")
public class UserController {

    @Autowired
    private UserService userService;
    @Autowired
    private com.forum.service.RootService rootService;

    @GetMapping("/login")
    public String loginPage() {
        return "user/login";
    }

    @GetMapping("/register")
    public String registerPage() {
        return "user/register";
    }

    @PostMapping("/login")
    @ResponseBody
    public Map<String, Object> login(@RequestParam String username,
                                     @RequestParam String password,
                                     HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        // 先判断用户是否存在且被禁用，优先返回禁用提示
        User exists = userService.findByUsername(username);
        if (exists != null && exists.getStatus() != null && exists.getStatus() == 0) {
            result.put("success", false);
            result.put("message", "你已被封禁");
            return result;
        }

        User user = userService.login(username, password);
        if (user != null) {
            session.setAttribute("user", user);
            result.put("success", true);
            result.put("message", "登录成功");
            result.put("role", user.getRole());
        } else {
            result.put("success", false);
            result.put("message", "用户名或密码错误");
        }
        return result;
    }

    @PostMapping("/register")
    @ResponseBody
    public Map<String, Object> register(@RequestParam String username,
                                        @RequestParam String password,
                                        @RequestParam String email,
                                        @RequestParam String nickname) {
        Map<String, Object> result = new HashMap<>();
        if (username == null || username.trim().isEmpty()) {
            result.put("success", false);
            result.put("message", "用户名不能为空");
            return result;
        }
        if (password == null || password.length() < 6) {
            result.put("success", false);
            result.put("message", "密码长度不能少于6位");
            return result;
        }
        if (email == null || !email.contains("@")) {
            result.put("success", false);
            result.put("message", "邮箱格式不正确");
            return result;
        }

        User user = new User();
        user.setUsername(username.trim());
        user.setPassword(password);
        user.setEmail(email);
        user.setNickname(nickname);

        if (userService.register(user)) {
            result.put("success", true);
            result.put("message", "注册成功，请登录");
        } else {
            result.put("success", false);
            result.put("message", "注册失败，用户名或邮箱已存在");
        }
        return result;
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.removeAttribute("user");
        session.invalidate();
        return "redirect:/";
    }

    @GetMapping("/profile")
    public String profile(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login";
        }
        user = userService.findById(user.getId());
        // 同步 session 中的 user 为最新数据，避免视图中 sessionScope 与 model 中不一致
        session.setAttribute("user", user);
        model.addAttribute("user", user);
        return "user/profile";
    }

    @PostMapping("/updateProfile")
    @ResponseBody
    public Map<String, Object> updateProfile(@RequestParam String email,
                                            @RequestParam String nickname,
                                            HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            result.put("success", false);
            result.put("message", "请先登录");
            return result;
        }

        user.setEmail(email);
        user.setNickname(nickname);
        if (userService.updateProfile(user)) {
            session.setAttribute("user", user);
            result.put("success", true);
            result.put("message", "更新成功");
        } else {
            result.put("success", false);
            result.put("message", "更新失败");
        }
        return result;
    }

    @GetMapping("/manage")
    public String manageUsers(Model model, HttpSession session,
                              @RequestParam(defaultValue = "1") int page,
                              @RequestParam(defaultValue = "10") int size) {
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null || !currentUser.isSuperUser()) {
            return "redirect:/";
        }

        model.addAttribute("users", userService.getAllUsers(page, size));
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", (int) Math.ceil((double) userService.getUserCount() / size));
        return "admin/userManage";
    }

    @GetMapping("/rootManage")
    public String rootManage(Model model, HttpSession session,
                             @RequestParam(defaultValue = "1") int page,
                             @RequestParam(defaultValue = "10") int size) {
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null || !currentUser.isSuperUser()) {
            return "redirect:/";
        }

        java.util.List<com.forum.entity.Root> roots = rootService.findAll(page, size);
        // enrich with user info
        java.util.List<java.util.Map<String, Object>> items = new java.util.ArrayList<>();
        for (com.forum.entity.Root r : roots) {
            java.util.Map<String, Object> m = new java.util.HashMap<>();
            m.put("root", r);
            com.forum.entity.User u = userService.findById(r.getUserId());
            m.put("user", u);
            items.add(m);
        }

        model.addAttribute("roots", items);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", (int) Math.ceil((double) rootService.getCount() / size));
        return "admin/rootManage";
    }

    @PostMapping("/root/add")
    @ResponseBody
    public Map<String, Object> addRoot(@RequestParam(required = false) Long userId,
                                       @RequestParam(required = false) String username,
                                       HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null || !currentUser.isSuperUser()) {
            result.put("success", false);
            result.put("message", "权限不足");
            return result;
        }

        if (userId == null) {
            if (username == null || username.trim().isEmpty()) {
                result.put("success", false);
                result.put("message", "请提供 userId 或 username");
                return result;
            }
            com.forum.entity.User u = userService.findByUsername(username.trim());
            if (u == null) {
                result.put("success", false);
                result.put("message", "未找到该用户");
                return result;
            }
            userId = u.getId();
        }

        if (rootService.addRoot(userId)) {
            result.put("success", true);
            result.put("message", "添加成功");
        } else {
            result.put("success", false);
            result.put("message", "添加失败");
        }
        return result;
    }

    @PostMapping("/root/toggle")
    @ResponseBody
    public Map<String, Object> toggleRoot(@RequestParam Long userId,
                                          @RequestParam Integer active,
                                          HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null || !currentUser.isSuperUser()) {
            result.put("success", false);
            result.put("message", "权限不足");
            return result;
        }

        if (rootService.setActive(userId, active)) {
            result.put("success", true);
            result.put("message", "更新成功");
        } else {
            result.put("success", false);
            result.put("message", "更新失败");
        }
        return result;
    }

    @PostMapping("/root/delete")
    @ResponseBody
    public Map<String, Object> deleteRoot(@RequestParam Long userId, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null || !currentUser.isSuperUser()) {
            result.put("success", false);
            result.put("message", "权限不足");
            return result;
        }

        if (rootService.removeRoot(userId)) {
            result.put("success", true);
            result.put("message", "删除成功");
        } else {
            result.put("success", false);
            result.put("message", "删除失败");
        }
        return result;
    }

    @PostMapping("/updateStatus")
    @ResponseBody
    public Map<String, Object> updateStatus(@RequestParam Long userId,
                                           @RequestParam Integer status,
                                           HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null || !currentUser.isSuperUser()) {
            result.put("success", false);
            result.put("message", "权限不足");
            return result;
        }

        if (userService.updateUserStatus(userId, status)) {
            result.put("success", true);
            result.put("message", "更新成功");
        } else {
            result.put("success", false);
            result.put("message", "更新失败");
        }
        return result;
    }
}
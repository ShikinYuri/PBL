package com.forum.session;

import org.springframework.stereotype.Component;

import javax.servlet.http.HttpSession;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;

@Component
public class SessionRegistry {

    // map userId -> HttpSession
    private final ConcurrentMap<Long, HttpSession> userSessionMap = new ConcurrentHashMap<>();
    // map sessionId -> userId
    private final ConcurrentMap<String, Long> sessionUserMap = new ConcurrentHashMap<>();

    public void register(HttpSession session, Long userId) {
        if (session == null || userId == null) return;
        userSessionMap.put(userId, session);
        sessionUserMap.put(session.getId(), userId);
    }

    public void removeBySession(HttpSession session) {
        if (session == null) return;
        Long userId = sessionUserMap.remove(session.getId());
        if (userId != null) {
            userSessionMap.remove(userId);
        }
    }

    public void removeByUserId(Long userId) {
        if (userId == null) return;
        HttpSession session = userSessionMap.remove(userId);
        if (session != null) {
            sessionUserMap.remove(session.getId());
        }
    }

    public HttpSession getSessionByUserId(Long userId) {
        if (userId == null) return null;
        return userSessionMap.get(userId);
    }
}

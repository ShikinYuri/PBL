package com.forum.session;

import javax.servlet.annotation.WebListener;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;
import org.springframework.beans.factory.annotation.Autowired;

@WebListener
public class SessionListener implements HttpSessionListener {

    private static SessionRegistry registry;

    @Autowired
    public void setRegistry(SessionRegistry reg) {
        SessionListener.registry = reg;
    }

    @Override
    public void sessionCreated(HttpSessionEvent se) {
        // no-op
    }

    @Override
    public void sessionDestroyed(HttpSessionEvent se) {
        if (registry != null) {
            registry.removeBySession(se.getSession());
        }
    }
}

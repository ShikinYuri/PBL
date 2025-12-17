package com.forum.entity;

import java.util.Date;

public class Post {
    private Long id;
    private String title;
    private String content;
    private Long userId;
    private Long sectionId;
    private Integer viewCount;
    private Integer replyCount;
    private Date lastReplyTime;
    private Long lastReplyUserId;
    private Integer isTop;  // 0-否，1-是
    private Integer isEssence;  // 0-否，1-是
    private Integer status;  // 0-删除，1-正常
    private Date createTime;
    private Date updateTime;

    private String username;
    private String nickname;
    private String avatar;
    private String sectionName;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public Long getSectionId() {
        return sectionId;
    }

    public void setSectionId(Long sectionId) {
        this.sectionId = sectionId;
    }

    public Integer getViewCount() {
        return viewCount;
    }

    public void setViewCount(Integer viewCount) {
        this.viewCount = viewCount;
    }

    public Integer getReplyCount() {
        return replyCount;
    }

    public void setReplyCount(Integer replyCount) {
        this.replyCount = replyCount;
    }

    public Date getLastReplyTime() {
        return lastReplyTime;
    }

    public void setLastReplyTime(Date lastReplyTime) {
        this.lastReplyTime = lastReplyTime;
    }

    public Long getLastReplyUserId() {
        return lastReplyUserId;
    }

    public void setLastReplyUserId(Long lastReplyUserId) {
        this.lastReplyUserId = lastReplyUserId;
    }

    public Integer getIsTop() {
        return isTop;
    }

    public void setIsTop(Integer isTop) {
        this.isTop = isTop;
    }

    public Integer getIsEssence() {
        return isEssence;
    }

    public void setIsEssence(Integer isEssence) {
        this.isEssence = isEssence;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public Date getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(Date updateTime) {
        this.updateTime = updateTime;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getNickname() {
        return nickname;
    }

    public void setNickname(String nickname) {
        this.nickname = nickname;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public String getSectionName() {
        return sectionName;
    }

    public void setSectionName(String sectionName) {
        this.sectionName = sectionName;
    }
}
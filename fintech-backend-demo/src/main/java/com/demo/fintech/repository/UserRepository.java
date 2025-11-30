package com.demo.fintech.repository;

import com.demo.fintech.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    // 这里的代码通常为空，等待 AI 自动生成 findByUsername 等方法
}

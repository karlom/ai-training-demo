package com.demo.fintech.service;

import java.math.BigDecimal;

/**
 * 复杂的收益计算逻辑
 */
public class RewardCalculator {

    /**
     * 计算阶梯式收益 (Stub)
     * 规则：
     * 1. 本金 < 10,000，年化 3%
     * 2. 10,000 <= 本金 < 50,000，年化 4%
     * 3. 本金 >= 50,000，年化 5%
     * 4. 且如果是 VIP 用户，额外加 1%
     * 5. 按天计算复利
     */
    public BigDecimal calculateCompoundInterest(BigDecimal principal, int days, boolean isVip) {
        // TODO: 演示 2.3 - 选中这个空方法，把上面的注释发给 AI，让它生成完整算法
        return BigDecimal.ZERO;
    }
}

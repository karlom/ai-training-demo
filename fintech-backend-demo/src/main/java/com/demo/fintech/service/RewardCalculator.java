package com.demo.fintech.service;

import java.math.BigDecimal;

/**
 * 复杂的收益计算逻辑
 */
public class RewardCalculator {

    /**
     * 计算阶梯式收益
     * 规则：
     * 1. 本金 < 10,000，年化 3%
     * 2. 10,000 <= 本金 < 50,000，年化 4%
     * 3. 本金 >= 50,000，年化 5%
     * 4. 且如果是 VIP 用户，额外加 1%
     * 5. 按天计算复利
     */
    public BigDecimal calculateCompoundInterest(BigDecimal principal, int days, boolean isVip) {
        if (principal == null || principal.compareTo(BigDecimal.ZERO) <= 0 || days <= 0) {
            return BigDecimal.ZERO;
        }

        // 定义阈值
        BigDecimal threshold1 = new BigDecimal("10000");
        BigDecimal threshold2 = new BigDecimal("50000");

        // 年利率设置
        BigDecimal rate;
        if (principal.compareTo(threshold1) < 0) {
            rate = new BigDecimal("0.03"); // 3%
        } else if (principal.compareTo(threshold2) < 0) {
            rate = new BigDecimal("0.04"); // 4%
        } else {
            rate = new BigDecimal("0.05"); // 5%
        }

        // VIP奖励
        if (isVip) {
            rate = rate.add(new BigDecimal("0.01")); // 额外1%
        }

        // 一年按照365天
        BigDecimal n = new BigDecimal("365");
        // 计算每日收益率
        BigDecimal dailyRate = rate.divide(n, 20, BigDecimal.ROUND_HALF_UP);

        // 复利公式：A = P * (1 + r)^days
        // 用 pow 不能用 BigDecimal 的scale小数，所以用 (1+r)^days
        BigDecimal onePlusR = BigDecimal.ONE.add(dailyRate);
        BigDecimal amount = principal;

        // 幂次计算 (1+r)^days 用 BigDecimal高精度
        amount = principal.multiply(onePlusR.pow(days));

        // 返回利息（总收益-本金），保留2位小数
        return amount.subtract(principal).setScale(2, BigDecimal.ROUND_HALF_UP);
    }
}

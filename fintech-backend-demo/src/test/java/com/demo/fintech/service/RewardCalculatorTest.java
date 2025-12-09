package com.demo.fintech.service;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;

import java.math.BigDecimal;

import static org.junit.jupiter.api.Assertions.*;

/**
 * RewardCalculator 单元测试
 * 测试重点：
 * 1. 临界点测试（10000 和 50000）
 * 2. VIP 加成逻辑
 * 3. 边界条件处理
 */
@DisplayName("收益计算器测试")
class RewardCalculatorTest {

    private RewardCalculator calculator;

    @BeforeEach
    void setUp() {
        calculator = new RewardCalculator();
    }

    // ========== 临界点测试：10000 阈值 ==========

    @Test
    @DisplayName("临界点测试：本金 9999.99 应使用 3% 利率")
    void testBelowThreshold1() {
        BigDecimal principal = new BigDecimal("9999.99");
        int days = 365;
        boolean isVip = false;

        BigDecimal interest = calculator.calculateCompoundInterest(principal, days, isVip);

        // 预期：(1 + 0.03/365)^365 * 9999.99 - 9999.99 ≈ 304.53
        BigDecimal expected = new BigDecimal("304.53");
        assertEquals(0, interest.compareTo(expected),
                "本金 9999.99（低于10000）应使用 3% 年化利率");
    }

    @Test
    @DisplayName("临界点测试：本金 10000 应使用 4% 利率")
    void testAtThreshold1() {
        BigDecimal principal = new BigDecimal("10000");
        int days = 365;
        boolean isVip = false;

        BigDecimal interest = calculator.calculateCompoundInterest(principal, days, isVip);

        // 预期：(1 + 0.04/365)^365 * 10000 - 10000 ≈ 408.08
        BigDecimal expected = new BigDecimal("408.08");
        assertEquals(0, interest.compareTo(expected),
                "本金 10000（等于阈值）应使用 4% 年化利率");
    }

    @Test
    @DisplayName("临界点测试：本金 10000.01 应使用 4% 利率")
    void testAboveThreshold1() {
        BigDecimal principal = new BigDecimal("10000.01");
        int days = 365;
        boolean isVip = false;

        BigDecimal interest = calculator.calculateCompoundInterest(principal, days, isVip);

        // 预期：(1 + 0.04/365)^365 * 10000.01 - 10000.01 ≈ 408.09
        BigDecimal expected = new BigDecimal("408.09");
        assertEquals(0, interest.compareTo(expected),
                "本金 10000.01（高于10000）应使用 4% 年化利率");
    }

    // ========== 临界点测试：50000 阈值 ==========

    @Test
    @DisplayName("临界点测试：本金 49999.99 应使用 4% 利率")
    void testBelowThreshold2() {
        BigDecimal principal = new BigDecimal("49999.99");
        int days = 365;
        boolean isVip = false;

        BigDecimal interest = calculator.calculateCompoundInterest(principal, days, isVip);

        // 预期：(1 + 0.04/365)^365 * 49999.99 - 49999.99 ≈ 2040.42
        BigDecimal expected = new BigDecimal("2040.42");
        assertEquals(0, interest.compareTo(expected),
                "本金 49999.99（低于50000）应使用 4% 年化利率");
    }

    @Test
    @DisplayName("临界点测试：本金 50000 应使用 5% 利率")
    void testAtThreshold2() {
        BigDecimal principal = new BigDecimal("50000");
        int days = 365;
        boolean isVip = false;

        BigDecimal interest = calculator.calculateCompoundInterest(principal, days, isVip);

        // 预期：(1 + 0.05/365)^365 * 50000 - 50000 ≈ 2563.37
        BigDecimal expected = new BigDecimal("2563.37");
        assertEquals(0, interest.compareTo(expected),
                "本金 50000（等于阈值）应使用 5% 年化利率");
    }

    @Test
    @DisplayName("临界点测试：本金 50000.01 应使用 5% 利率")
    void testAboveThreshold2() {
        BigDecimal principal = new BigDecimal("50000.01");
        int days = 365;
        boolean isVip = false;

        BigDecimal interest = calculator.calculateCompoundInterest(principal, days, isVip);

        // 预期：(1 + 0.05/365)^365 * 50000.01 - 50000.01 ≈ 2563.38
        BigDecimal expected = new BigDecimal("2563.38");
        assertEquals(0, interest.compareTo(expected),
                "本金 50000.01（高于50000）应使用 5% 年化利率");
    }

    // ========== VIP 加成测试：第一阶段（< 10000）==========

    @Test
    @DisplayName("VIP 加成：本金 5000，非 VIP 应使用 3% 利率")
    void testNonVipTier1() {
        BigDecimal principal = new BigDecimal("5000");
        int days = 365;
        boolean isVip = false;

        BigDecimal interest = calculator.calculateCompoundInterest(principal, days, isVip);

        // 预期：(1 + 0.03/365)^365 * 5000 - 5000 ≈ 152.27
        BigDecimal expected = new BigDecimal("152.27");
        assertEquals(0, interest.compareTo(expected),
                "非 VIP 用户，本金 5000 应使用 3% 年化利率");
    }

    @Test
    @DisplayName("VIP 加成：本金 5000，VIP 应使用 4% 利率（3% + 1%）")
    void testVipTier1() {
        BigDecimal principal = new BigDecimal("5000");
        int days = 365;
        boolean isVip = true;

        BigDecimal interest = calculator.calculateCompoundInterest(principal, days, isVip);

        // 预期：(1 + 0.04/365)^365 * 5000 - 5000 ≈ 204.04
        BigDecimal expected = new BigDecimal("204.04");
        assertEquals(0, interest.compareTo(expected),
                "VIP 用户，本金 5000 应使用 4% 年化利率（基础 3% + VIP 1%）");
    }

    // ========== VIP 加成测试：第二阶段（10000 <= 本金 < 50000）==========

    @Test
    @DisplayName("VIP 加成：本金 30000，非 VIP 应使用 4% 利率")
    void testNonVipTier2() {
        BigDecimal principal = new BigDecimal("30000");
        int days = 365;
        boolean isVip = false;

        BigDecimal interest = calculator.calculateCompoundInterest(principal, days, isVip);

        // 预期：(1 + 0.04/365)^365 * 30000 - 30000 ≈ 1224.25
        BigDecimal expected = new BigDecimal("1224.25");
        assertEquals(0, interest.compareTo(expected),
                "非 VIP 用户，本金 30000 应使用 4% 年化利率");
    }

    @Test
    @DisplayName("VIP 加成：本金 30000，VIP 应使用 5% 利率（4% + 1%）")
    void testVipTier2() {
        BigDecimal principal = new BigDecimal("30000");
        int days = 365;
        boolean isVip = true;

        BigDecimal interest = calculator.calculateCompoundInterest(principal, days, isVip);

        // 预期：(1 + 0.05/365)^365 * 30000 - 30000 ≈ 1538.02
        BigDecimal expected = new BigDecimal("1538.02");
        assertEquals(0, interest.compareTo(expected),
                "VIP 用户，本金 30000 应使用 5% 年化利率（基础 4% + VIP 1%）");
    }

    // ========== VIP 加成测试：第三阶段（>= 50000）==========

    @Test
    @DisplayName("VIP 加成：本金 100000，非 VIP 应使用 5% 利率")
    void testNonVipTier3() {
        BigDecimal principal = new BigDecimal("100000");
        int days = 365;
        boolean isVip = false;

        BigDecimal interest = calculator.calculateCompoundInterest(principal, days, isVip);

        // 预期：(1 + 0.05/365)^365 * 100000 - 100000 ≈ 5126.75
        BigDecimal expected = new BigDecimal("5126.75");
        assertEquals(0, interest.compareTo(expected),
                "非 VIP 用户，本金 100000 应使用 5% 年化利率");
    }

    @Test
    @DisplayName("VIP 加成：本金 100000，VIP 应使用 6% 利率（5% + 1%）")
    void testVipTier3() {
        BigDecimal principal = new BigDecimal("100000");
        int days = 365;
        boolean isVip = true;

        BigDecimal interest = calculator.calculateCompoundInterest(principal, days, isVip);

        // 预期：(1 + 0.06/365)^365 * 100000 - 100000 ≈ 6183.13
        BigDecimal expected = new BigDecimal("6183.13");
        assertEquals(0, interest.compareTo(expected),
                "VIP 用户，本金 100000 应使用 6% 年化利率（基础 5% + VIP 1%）");
    }

    // ========== 临界点的 VIP 加成测试 ==========

    @Test
    @DisplayName("临界点 VIP 加成：本金 10000，VIP 和非 VIP 的差异")
    void testVipBonus_AtThreshold1() {
        BigDecimal principal = new BigDecimal("10000");
        int days = 365;

        BigDecimal nonVipInterest = calculator.calculateCompoundInterest(principal, days, false);
        BigDecimal vipInterest = calculator.calculateCompoundInterest(principal, days, true);

        // 非 VIP: 4% ≈ 408.08
        // VIP: 5% ≈ 512.67
        assertTrue(vipInterest.compareTo(nonVipInterest) > 0,
                "VIP 用户在 10000 临界点应获得更高收益");

        BigDecimal expectedNonVip = new BigDecimal("408.08");
        BigDecimal expectedVip = new BigDecimal("512.67");
        assertEquals(0, nonVipInterest.compareTo(expectedNonVip));
        assertEquals(0, vipInterest.compareTo(expectedVip));
    }

    @Test
    @DisplayName("临界点 VIP 加成：本金 50000，VIP 和非 VIP 的差异")
    void testVipBonus_AtThreshold2() {
        BigDecimal principal = new BigDecimal("50000");
        int days = 365;

        BigDecimal nonVipInterest = calculator.calculateCompoundInterest(principal, days, false);
        BigDecimal vipInterest = calculator.calculateCompoundInterest(principal, days, true);

        // 非 VIP: 5% ≈ 2563.37
        // VIP: 6% ≈ 3091.57
        assertTrue(vipInterest.compareTo(nonVipInterest) > 0,
                "VIP 用户在 50000 临界点应获得更高收益");

        BigDecimal expectedNonVip = new BigDecimal("2563.37");
        BigDecimal expectedVip = new BigDecimal("3091.57");
        assertEquals(0, nonVipInterest.compareTo(expectedNonVip));
        assertEquals(0, vipInterest.compareTo(expectedVip));
    }

    // ========== 边界条件测试 ==========

    @Test
    @DisplayName("边界条件：null 本金应返回 0")
    void testNullPrincipal() {
        BigDecimal interest = calculator.calculateCompoundInterest(null, 365, false);
        assertEquals(BigDecimal.ZERO, interest, "null 本金应返回 0");
    }

    @Test
    @DisplayName("边界条件：零本金应返回 0")
    void testZeroPrincipal() {
        BigDecimal principal = BigDecimal.ZERO;
        BigDecimal interest = calculator.calculateCompoundInterest(principal, 365, false);
        assertEquals(BigDecimal.ZERO, interest, "零本金应返回 0");
    }

    @Test
    @DisplayName("边界条件：负本金应返回 0")
    void testNegativePrincipal() {
        BigDecimal principal = new BigDecimal("-1000");
        BigDecimal interest = calculator.calculateCompoundInterest(principal, 365, false);
        assertEquals(BigDecimal.ZERO, interest, "负本金应返回 0");
    }

    @Test
    @DisplayName("边界条件：零天数应返回 0")
    void testZeroDays() {
        BigDecimal principal = new BigDecimal("10000");
        BigDecimal interest = calculator.calculateCompoundInterest(principal, 0, false);
        assertEquals(BigDecimal.ZERO, interest, "零天数应返回 0");
    }

    @Test
    @DisplayName("边界条件：负天数应返回 0")
    void testNegativeDays() {
        BigDecimal principal = new BigDecimal("10000");
        BigDecimal interest = calculator.calculateCompoundInterest(principal, -10, false);
        assertEquals(BigDecimal.ZERO, interest, "负天数应返回 0");
    }

    // ========== 参数化测试：不同天数的计算 ==========

    @ParameterizedTest
    @CsvSource({
            "10000, 1, false, 1.10", // 1天，非VIP
            "10000, 7, false, 7.67", // 1周，非VIP
            "10000, 30, false, 32.93", // 1月，非VIP
            "10000, 90, false, 99.11", // 3月，非VIP
            "10000, 180, false, 199.21", // 半年，非VIP
            "50000, 1, false, 6.85", // 1天，非VIP
            "50000, 30, false, 205.89", // 1月，非VIP
            "50000, 180, false, 1248.12" // 半年，非VIP
    })
    @DisplayName("参数化测试：不同天数的收益计算")
    void testDifferentDays(String principalStr, int days, boolean isVip, String expectedStr) {
        BigDecimal principal = new BigDecimal(principalStr);
        BigDecimal expected = new BigDecimal(expectedStr);

        BigDecimal interest = calculator.calculateCompoundInterest(principal, days, isVip);

        assertEquals(0, interest.compareTo(expected),
                String.format("本金 %s，%d 天，VIP=%s 的收益应为 %s",
                        principalStr, days, isVip, expectedStr));
    }

    // ========== 精度测试 ==========

    @Test
    @DisplayName("精度测试：结果应保留两位小数")
    void testDecimalPrecision() {
        BigDecimal principal = new BigDecimal("12345.67");
        int days = 100;

        BigDecimal interest = calculator.calculateCompoundInterest(principal, days, false);

        assertEquals(2, interest.scale(), "收益结果应保留两位小数");
    }

    @Test
    @DisplayName("复利效果验证：长期收益应大于简单利息")
    void testCompoundInterestEffect() {
        BigDecimal principal = new BigDecimal("10000");
        int days = 365;

        BigDecimal compoundInterest = calculator.calculateCompoundInterest(principal, days, false);

        // 简单利息: 10000 * 0.04 = 400
        BigDecimal simpleInterest = new BigDecimal("400.00");

        assertTrue(compoundInterest.compareTo(simpleInterest) > 0,
                "复利收益应大于简单利息");
    }
}

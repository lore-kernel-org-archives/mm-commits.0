From: akpm@linux-foundation.org
Subject: [folded-merged]
 rtc-omap-add-support-for-pmic_power_en-v3-fix.patch removed from -mm tree
Date: Wed, 10 Dec 2014 15:21:35 -0800
Message-ID: <5488d57f.kQPSse8fJ3yjmxgE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58339 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933125AbaLJXVg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Dec 2014 18:21:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.zummo@towertech.it, anilkumar@ti.com, balbi@ti.com, bcousson@baylibre.com, colin.foeparker@logicpd.com, j-keerthy@ti.com, johan@kernel.org, linux@roeck-us.net, lokeshvutla@ti.com, nsekhar@ti.com, t-kristo@ti.com, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc-omap-add-support-for-pmic_power_en-v3-fix
has been removed from the -mm tree.  Its filename was
     rtc-omap-add-support-for-pmic_power_en-v3-fix.patch

This patch was dropped because it was folded into rtc-omap-add-support-for-pmic_power_en.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: rtc-omap-add-support-for-pmic_power_en-v3-fix

add comment

Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: AnilKumar Ch <anilkumar@ti.com>
Cc: Benot Cousson <bcousson@baylibre.com>
Cc: Colin Foe-Parker <colin.foeparker@logicpd.com>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Johan Hovold <johan@kernel.org>
Cc: Keerthy J <j-keerthy@ti.com>
Cc: Lokesh Vutla <lokeshvutla@ti.com>
Cc: Sekhar Nori <nsekhar@ti.com>
Cc: Tero Kristo <t-kristo@ti.com>
Cc: Tony Lindgren <tony@atomide.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-omap.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/rtc/rtc-omap.c~rtc-omap-add-support-for-pmic_power_en-v3-fix drivers/rtc/rtc-omap.c
--- a/drivers/rtc/rtc-omap.c~rtc-omap-add-support-for-pmic_power_en-v3-fix
+++ a/drivers/rtc/rtc-omap.c
@@ -417,6 +417,7 @@ static void omap_rtc_power_off(void)
 	rtc_writel(rtc, OMAP_RTC_INTERRUPTS_REG,
 			val | OMAP_RTC_INTERRUPTS_IT_ALARM2);
 
+	/* Allow alarm to trigger before returning */
 	mdelay(2000);
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-cma-fix-boot-regression-due-to-physical-address-of-high_memory.patch
slab-improve-checking-for-invalid-gfp_flags.patch
mm-memcontrol-lockless-page-counters.patch
kernel-res_counter-remove-the-unused-api.patch
mm-compaction-simplify-deferred-compaction.patch
mm-compaction-always-update-cached-scanner-positions.patch
mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag.patch
mm-fix-huge-zero-page-accounting-in-smaps-report.patch
fs-proc-use-a-rb-tree-for-the-directory-entries.patch
fs-binfmt_miscc-use-gfp_kernel-instead-of-gfp_user.patch
init-allow-config_init_fallback=n-to-disable-defaults-if-init=-fails.patch
rtc-omap-add-support-for-pmic_power_en.patch
drivers-rtc-rtc-sirfsocc-add-alarm_irq_enable-support-fix.patch
rtc-ds1374-add-watchdog-support-fix.patch
rtc-ds1374-add-watchdog-support-checkpatch-fixes.patch
exit-wait-cleanup-the-ptrace_reparented-checks-fix.patch


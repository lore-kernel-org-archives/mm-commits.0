From: akpm@linux-foundation.org
Subject: [folded-merged]
 drivers-rtc-rtc-sirfsocc-add-alarm_irq_enable-support-fix.patch removed
 from -mm tree
Date: Wed, 10 Dec 2014 15:22:23 -0800
Message-ID: <5488d5af.aKGtO2dK8Baa5dle%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58477 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758383AbaLJXWY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Dec 2014 18:22:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, Baohua.Song@csr.com, a.zummo@towertech.it, hao.liu@csr.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers-rtc-rtc-sirfsocc-add-alarm_irq_enable-support-fix
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-sirfsocc-add-alarm_irq_enable-support-fix.patch

This patch was dropped because it was folded into drivers-rtc-rtc-sirfsocc-add-alarm_irq_enable-support.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers-rtc-rtc-sirfsocc-add-alarm_irq_enable-support-fix

remove unneeded cast

Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Barry Song <Baohua.Song@csr.com>
Cc: hao liu <hao.liu@csr.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-sirfsoc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-sirfsoc.c~drivers-rtc-rtc-sirfsocc-add-alarm_irq_enable-support-fix drivers/rtc/rtc-sirfsoc.c
--- a/drivers/rtc/rtc-sirfsoc.c~drivers-rtc-rtc-sirfsocc-add-alarm_irq_enable-support-fix
+++ a/drivers/rtc/rtc-sirfsoc.c
@@ -215,7 +215,7 @@ static int sirfsoc_rtc_alarm_irq_enable(
 	unsigned long rtc_status_reg = 0x0;
 	struct sirfsoc_rtc_drv *rtcdrv;
 
-	rtcdrv = (struct sirfsoc_rtc_drv *)dev_get_drvdata(dev);
+	rtcdrv = dev_get_drvdata(dev);
 
 	local_irq_disable();
 
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
drivers-rtc-rtc-sirfsocc-add-alarm_irq_enable-support.patch
rtc-ds1374-add-watchdog-support-fix.patch
rtc-ds1374-add-watchdog-support-checkpatch-fixes.patch
exit-wait-cleanup-the-ptrace_reparented-checks-fix.patch


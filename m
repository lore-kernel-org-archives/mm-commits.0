From: akpm@linux-foundation.org
Subject: [folded-merged]
 rtc-ds1374-add-watchdog-support-checkpatch-fixes.patch removed from -mm
 tree
Date: Wed, 10 Dec 2014 15:22:48 -0800
Message-ID: <5488d5c8.NLsmYqpy4yQZ4Arz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58492 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932354AbaLJXWt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Dec 2014 18:22:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.zummo@towertech.it, san@rosetechnology.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc-ds1374-add-watchdog-support-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     rtc-ds1374-add-watchdog-support-checkpatch-fixes.patch

This patch was dropped because it was folded into rtc-ds1374-add-watchdog-support.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: rtc-ds1374-add-watchdog-support-checkpatch-fixes

WARNING: Possible switch case/default not preceeded by break or fallthrough comment
#283: FILE: drivers/rtc/rtc-ds1374.c:533:
+	case WDIOC_GETTIMEOUT:

total: 0 errors, 2 warnings, 360 lines checked

./patches/rtc-ds1374-add-watchdog-support.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Soeren Andersen <san@rosetechnology.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1374.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-ds1374.c~rtc-ds1374-add-watchdog-support-checkpatch-fixes drivers/rtc/rtc-ds1374.c
--- a/drivers/rtc/rtc-ds1374.c~rtc-ds1374-add-watchdog-support-checkpatch-fixes
+++ a/drivers/rtc/rtc-ds1374.c
@@ -529,7 +529,7 @@ static long ds1374_wdt_ioctl(struct file
 		wdt_margin = new_margin;
 		ds1374_wdt_settimeout(new_margin);
 		ds1374_wdt_ping();
-		/* Fall */
+		/* fallthrough */
 	case WDIOC_GETTIMEOUT:
 		return put_user(wdt_margin, (int __user *)arg);
 	case WDIOC_SETOPTIONS:
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
rtc-ds1374-add-watchdog-support.patch
exit-wait-cleanup-the-ptrace_reparented-checks-fix.patch


From: akpm@linux-foundation.org
Subject: [folded-merged]
 init-allow-config_init_fallback=n-to-disable-defaults-if-init=-fails-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 10 Dec 2014 15:21:02 -0800
Message-ID: <5488d55e.XQRMOG9Q5XkEUm+3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58318 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933125AbaLJXVD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Dec 2014 18:21:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cebbert.lkml@gmail.com, frowand.list@gmail.com, josh@joshtriplett.org, luto@amacapital.net, rdunlap@infradead.org, rob@landley.net, rusty@rustcorp.com.au, shuah.kh@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: init-allow-config_init_fallback=n-to-disable-defaults-if-init=-fails-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     init-allow-config_init_fallback=n-to-disable-defaults-if-init=-fails-checkpatch-fixes.patch

This patch was dropped because it was folded into init-allow-config_init_fallback=n-to-disable-defaults-if-init=-fails.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: init-allow-config_init_fallback=n-to-disable-defaults-if-init=-fails-checkpatch-fixes

WARNING: 'indended' may be misspelled - perhaps 'intended'?
#53: FILE: init/Kconfig:1315:
+	  especially on kiosks and on kernels that are indended to be

total: 0 errors, 1 warnings, 36 lines checked

./patches/init-allow-config_init_fallback=n-to-disable-defaults-if-init=-fails.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Chuck Ebbert <cebbert.lkml@gmail.com>
Cc: Frank Rowand <frowand.list@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Rob Landley <rob@landley.net>
Cc: Shuah Khan <shuah.kh@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN init/Kconfig~init-allow-config_init_fallback=n-to-disable-defaults-if-init=-fails-checkpatch-fixes init/Kconfig
--- a/init/Kconfig~init-allow-config_init_fallback=n-to-disable-defaults-if-init=-fails-checkpatch-fixes
+++ a/init/Kconfig
@@ -1300,7 +1300,7 @@ config INIT_FALLBACK
 
 	  The default value of Y is consistent with historical behavior.
 	  Selecting N is likely to be more appropriate for most uses,
-	  especially on kiosks and on kernels that are indended to be
+	  especially on kiosks and on kernels that are intended to be
 	  run under the control of a script.
 
 config CC_OPTIMIZE_FOR_SIZE
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
rtc-omap-add-support-for-pmic_power_en-v3-fix.patch
drivers-rtc-rtc-sirfsocc-add-alarm_irq_enable-support-fix.patch
rtc-ds1374-add-watchdog-support-fix.patch
rtc-ds1374-add-watchdog-support-checkpatch-fixes.patch
exit-wait-cleanup-the-ptrace_reparented-checks-fix.patch


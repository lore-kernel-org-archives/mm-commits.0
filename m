From: akpm@linux-foundation.org
Subject: [folded] rtc-add-driver-for-mxcs-internal-rtc-module-fix.patch removed from -mm tree
Date: Tue, 22 Sep 2009 14:47:31 -0700
Message-ID: <200909222147.n8MLlVhg008669@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50911 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752408AbZIVVsx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 17:48:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.zummo@towertech.it, daniel@caiaq.de, s.hauer@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     rtc-add-driver-for-mxcs-internal-rtc-module-fix
has been removed from the -mm tree.  Its filename was
     rtc-add-driver-for-mxcs-internal-rtc-module-fix.patch

This patch was dropped because it was folded into rtc-add-driver-for-mxcs-internal-rtc-module.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-add-driver-for-mxcs-internal-rtc-module-fix
From: Andrew Morton <akpm@linux-foundation.org>

Make PIE_BIT_DEF[] static

Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Daniel Mack <daniel@caiaq.de>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-mxc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-mxc.c~rtc-add-driver-for-mxcs-internal-rtc-module-fix drivers/rtc/rtc-mxc.c
--- a/drivers/rtc/rtc-mxc.c~rtc-add-driver-for-mxcs-internal-rtc-module-fix
+++ a/drivers/rtc/rtc-mxc.c
@@ -42,7 +42,7 @@
 
 #define MAX_PIE_NUM     9
 #define MAX_PIE_FREQ    512
-const u32 PIE_BIT_DEF[MAX_PIE_NUM][2] = {
+statix const u32 PIE_BIT_DEF[MAX_PIE_NUM][2] = {
 	{ 2,		RTC_2HZ_BIT },
 	{ 4,		RTC_SAM0_BIT },
 	{ 8,		RTC_SAM1_BIT },
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios.patch
generic-ipi-make-struct-call_function_data-lockless.patch
proc-connector-add-event-for-process-becoming-session-leader.patch
build_bug_on-fix-it-and-a-couple-of-bogus-uses-of-it.patch
mmc-register-mmci-omap-hs-using-platform_driver_probe.patch
sdio-add-cd-disable-support.patch
sdio-add-mmc_quirk_lenient_fn0.patch
at91-atmel-mci-platform-configuration-to-the-the-atmel-mci-driver.patch
mmc-core-sdio-suspend-resume-support.patch
procfs-provide-stack-information-for-threads-v08.patch
kcore-register-vmemmap-range.patch
rtc-add-driver-for-mxcs-internal-rtc-module.patch
rtc-add-driver-for-mxcs-internal-rtc-module-fix.patch
rtc-add-driver-for-mxcs-internal-rtc-module-fix-fix.patch
davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx.patch
davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx-v4-cleanup.patch
drivers-video-add-kmalloc-null-tests-fix.patch
drivers-video-tmiofbc-fix-uninitialised-return-value.patch
v3-minixfs-add-missing-directory-type-checking-checkpatch-fixes.patch


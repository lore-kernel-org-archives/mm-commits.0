From: akpm@linux-foundation.org
Subject: [folded] leds-lp5521-support-led-pattern-data-checkpatch-fixes.patch removed from -mm tree
Date: Fri, 23 Mar 2012 14:25:15 -0700
Message-ID: <20120323212515.3DBBFA0395@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:64027 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281Ab2CWVZR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 23 Mar 2012 17:25:17 -0400
Received: by lbbgj3 with SMTP id gj3so187857lbb.1
        for <mm-commits@vger.kernel.org>; Fri, 23 Mar 2012 14:25:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, Milo.Kim@ti.com, arun.murthy@stericsson.com, linus.walleij@linaro.org, milo.kim@ti.com, rpurdie@rpsys.net, srinidhi.kasagar@stericsson.com, mm-commits@vger.kernel.org


The patch titled
     Subject: leds-lp5521-support-led-pattern-data-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     leds-lp5521-support-led-pattern-data-checkpatch-fixes.patch

This patch was dropped because it was folded into leds-lp5521-support-led-pattern-data.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: leds-lp5521-support-led-pattern-data-checkpatch-fixes

Cc: "Kim, Milo" <Milo.Kim@ti.com>

WARNING: strict_strtoul is obsolete, use kstrtoul instead
#192: FILE: drivers/leds/leds-lp5521.c:616:
+	ret = strict_strtoul(buf, 16, &val);

total: 0 errors, 1 warnings, 194 lines checked

./patches/leds-lp5521-support-led-pattern-data.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: "Kim, Milo" <Milo.Kim@ti.com>
Cc: Arun MURTHY <arun.murthy@stericsson.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Milo(Woogyom) Kim <milo.kim@ti.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-lp5521.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/leds/leds-lp5521.c~leds-lp5521-support-led-pattern-data-checkpatch-fixes drivers/leds/leds-lp5521.c
--- a/drivers/leds/leds-lp5521.c~leds-lp5521-support-led-pattern-data-checkpatch-fixes
+++ a/drivers/leds/leds-lp5521.c
@@ -496,7 +496,7 @@ static ssize_t store_current(struct devi
 	ssize_t ret;
 	unsigned long curr;
 
-	if (strict_strtoul(buf, 0, &curr))
+	if (kstrtoul(buf, 0, &curr))
 		return -EINVAL;
 
 	if (curr > led->max_current)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision.patch
kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any.patch
kernel-watchdogc-convert-to-pr_foo.patch
kernel-watchdogc-add-comment-to-watchdog-exit-path.patch
backlight-use-id-driver_data-to-differentiate-lp855x-chips.patch
backlight-add-driver-for-bachmanns-ot200.patch
leds-lp5521-support-led-pattern-data.patch
drivers-leds-leds-lp5523c-constify-some-data.patch
drivers-leds-add-driver-for-pca9663-i2c-chip-fix.patch
leds-lm3530-replace-i2c_client-with-led_classdev-fix.patch
drivers-leds-leds-lm3530c-move-the-code-setting-gen_config-to-one-place-fix.patch
crc32-move-long-comment-about-crc32-fundamentals-to-documentation-fix.patch
rtc-rtc-driver-for-da9052-53-pmic-v1-fix.patch
coredump-add-vm_nodump-madv_nodump-madv_clear_nodump-fix.patch
coredump-add-vm_nodump-madv_nodump-madv_clear_nodump-fix-fix.patch
procfs-add-num_to_str-to-speed-up-proc-stat-fix.patch
procfs-speed-up-proc-pid-stat-statm-checkpatch-fixes.patch
seq_file-add-seq_set_overflow-seq_overflow-fix.patch


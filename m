From: akpm@linux-foundation.org
Subject: [folded] backlight-use-id-driver_data-to-differentiate-lp855x-chips-fix.patch removed from -mm tree
Date: Fri, 23 Mar 2012 14:22:18 -0700
Message-ID: <20120323212218.65B94A00AE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:62198 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956Ab2CWVWU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 23 Mar 2012 17:22:20 -0400
Received: by wgbdt11 with SMTP id dt11so119803wgb.1
        for <mm-commits@vger.kernel.org>; Fri, 23 Mar 2012 14:22:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, axel.lin@gmail.com, milo.kim@ti.com, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight-use-id-driver_data-to-differentiate-lp855x-chips-fix
has been removed from the -mm tree.  Its filename was
     backlight-use-id-driver_data-to-differentiate-lp855x-chips-fix.patch

This patch was dropped because it was folded into backlight-use-id-driver_data-to-differentiate-lp855x-chips.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: backlight-use-id-driver_data-to-differentiate-lp855x-chips-fix

simplify boolean return expression

Cc: Axel Lin <axel.lin@gmail.com>
Cc: Milo (Woogyom) Kim <milo.kim@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/lp855x_bl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/backlight/lp855x_bl.c~backlight-use-id-driver_data-to-differentiate-lp855x-chips-fix drivers/video/backlight/lp855x_bl.c
--- a/drivers/video/backlight/lp855x_bl.c~backlight-use-id-driver_data-to-differentiate-lp855x-chips-fix
+++ a/drivers/video/backlight/lp855x_bl.c
@@ -82,7 +82,7 @@ static bool lp855x_is_valid_rom_area(str
 		return false;
 	}
 
-	return (addr >= start && addr <= end) ? true : false;
+	return (addr >= start && addr <= end);
 }
 
 static int lp855x_init_registers(struct lp855x *lp)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision.patch
kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any.patch
kernel-watchdogc-convert-to-pr_foo.patch
kernel-watchdogc-add-comment-to-watchdog-exit-path.patch
backlight-use-id-driver_data-to-differentiate-lp855x-chips.patch
backlight-add-driver-for-bachmanns-ot200-fix.patch
leds-lp5521-support-led-pattern-data-checkpatch-fixes.patch
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


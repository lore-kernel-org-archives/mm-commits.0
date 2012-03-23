From: akpm@linux-foundation.org
Subject: [folded] drivers-leds-add-driver-for-pca9663-i2c-chip-fix.patch removed from -mm tree
Date: Fri, 23 Mar 2012 14:26:09 -0700
Message-ID: <20120323212609.ACCE9A0395@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:44135 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755157Ab2CWV0K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 23 Mar 2012 17:26:10 -0400
Received: by yhgm50 with SMTP id m50so567241yhg.1
        for <mm-commits@vger.kernel.org>; Fri, 23 Mar 2012 14:26:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, lars@metafoo.de, p.meerwald@bct-electronic.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers-leds-add-driver-for-pca9663-i2c-chip-fix
has been removed from the -mm tree.  Its filename was
     drivers-leds-add-driver-for-pca9663-i2c-chip-fix.patch

This patch was dropped because it was folded into drivers-leds-add-driver-for-pca9663-i2c-chip.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers-leds-add-driver-for-pca9663-i2c-chip-fix

fix kcalloc() call

Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Peter Meerwald <p.meerwald@bct-electronic.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-pca9633.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/leds/leds-pca9633.c~drivers-leds-add-driver-for-pca9663-i2c-chip-fix drivers/leds/leds-pca9633.c
--- a/drivers/leds/leds-pca9633.c~drivers-leds-add-driver-for-pca9663-i2c-chip-fix
+++ a/drivers/leds/leds-pca9633.c
@@ -110,7 +110,7 @@ static int __devinit pca9633_probe(struc
 		}
 	}
 
-	pca9633 = kcalloc(sizeof(*pca9633) * 4, GFP_KERNEL);
+	pca9633 = kcalloc(sizeof(*pca9633), 4, GFP_KERNEL);
 	if (!pca9633)
 		return -ENOMEM;
 
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
drivers-leds-add-driver-for-pca9663-i2c-chip.patch
leds-lm3530-replace-i2c_client-with-led_classdev-fix.patch
drivers-leds-leds-lm3530c-move-the-code-setting-gen_config-to-one-place-fix.patch
crc32-move-long-comment-about-crc32-fundamentals-to-documentation-fix.patch
rtc-rtc-driver-for-da9052-53-pmic-v1-fix.patch
coredump-add-vm_nodump-madv_nodump-madv_clear_nodump-fix.patch
coredump-add-vm_nodump-madv_nodump-madv_clear_nodump-fix-fix.patch
procfs-add-num_to_str-to-speed-up-proc-stat-fix.patch
procfs-speed-up-proc-pid-stat-statm-checkpatch-fixes.patch
seq_file-add-seq_set_overflow-seq_overflow-fix.patch


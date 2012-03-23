From: akpm@linux-foundation.org
Subject: [folded] drivers-leds-leds-lm3530c-move-the-code-setting-gen_config-to-one-place-fix.patch removed from -mm tree
Date: Fri, 23 Mar 2012 14:27:47 -0700
Message-ID: <20120323212747.D42E8A0395@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:37371 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754526Ab2CWV1s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 23 Mar 2012 17:27:48 -0400
Received: by yhgm50 with SMTP id m50so567401yhg.1
        for <mm-commits@vger.kernel.org>; Fri, 23 Mar 2012 14:27:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, axel.lin@gmail.com, linus.walleij@linaro.org, milo.kim@ti.com, rpurdie@rpsys.net, shreshthakumar.sahu@stericsson.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers-leds-leds-lm3530c-move-the-code-setting-gen_config-to-one-place-fix
has been removed from the -mm tree.  Its filename was
     drivers-leds-leds-lm3530c-move-the-code-setting-gen_config-to-one-place-fix.patch

This patch was dropped because it was folded into drivers-leds-leds-lm3530c-move-the-code-setting-gen_config-to-one-place.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers-leds-leds-lm3530c-move-the-code-setting-gen_config-to-one-place-fix

fix some patch skew

Cc: "Milo(Woogyom) Kim" <milo.kim@ti.com>
Cc: Axel Lin <axel.lin@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-lm3530.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/leds/leds-lm3530.c~drivers-leds-leds-lm3530c-move-the-code-setting-gen_config-to-one-place-fix drivers/leds/leds-lm3530.c
--- a/drivers/leds/leds-lm3530.c~drivers-leds-leds-lm3530c-move-the-code-setting-gen_config-to-one-place-fix
+++ a/drivers/leds/leds-lm3530.c
@@ -167,7 +167,7 @@ static int lm3530_init_registers(struct 
 		break;
 	case LM3530_BL_MODE_PWM:
 		gen_config |= LM3530_ENABLE_PWM | LM3530_ENABLE_PWM_SIMPLE |
-			      (pltfm->pwm_pol_hi << LM3530_PWM_POL_SHIFT);
+			      (pdata->pwm_pol_hi << LM3530_PWM_POL_SHIFT);
 		break;
 	}
 
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
leds-lm3530-replace-i2c_client-with-led_classdev.patch
drivers-leds-leds-lm3530c-move-the-code-setting-gen_config-to-one-place.patch
crc32-move-long-comment-about-crc32-fundamentals-to-documentation-fix.patch
rtc-rtc-driver-for-da9052-53-pmic-v1-fix.patch
coredump-add-vm_nodump-madv_nodump-madv_clear_nodump-fix.patch
coredump-add-vm_nodump-madv_nodump-madv_clear_nodump-fix-fix.patch
procfs-add-num_to_str-to-speed-up-proc-stat-fix.patch
procfs-speed-up-proc-pid-stat-statm-checkpatch-fixes.patch
seq_file-add-seq_set_overflow-seq_overflow-fix.patch


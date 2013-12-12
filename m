From: akpm@linux-foundation.org
Subject: + rtc-rtc-cmos-remove-superfluous-name-cast.patch added to -mm
 tree
Date: Wed, 11 Dec 2013 16:24:26 -0800
Message-ID: <52a9023a.jiaexMmSOkEkHLEz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50669 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab3LLAY1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Dec 2013 19:24:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, a.zummo@towertech.it, geert@linux-m68k.org

Subject: + rtc-rtc-cmos-remove-superfluous-name-cast.patch added to -mm tree
To: geert@linux-m68k.org,a.zummo@towertech.it
From: akpm@linux-foundation.org
Date: Wed, 11 Dec 2013 16:24:26 -0800


The patch titled
     Subject: drivers/rtc/rtc-cmos.c: remove superfluous name cast
has been added to the -mm tree.  Its filename is
     rtc-rtc-cmos-remove-superfluous-name-cast.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-rtc-cmos-remove-superfluous-name-cast.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-rtc-cmos-remove-superfluous-name-cast.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: drivers/rtc/rtc-cmos.c: remove superfluous name cast

device_driver.name is "const char *"

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-cmos.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-cmos.c~rtc-rtc-cmos-remove-superfluous-name-cast drivers/rtc/rtc-cmos.c
--- a/drivers/rtc/rtc-cmos.c~rtc-rtc-cmos-remove-superfluous-name-cast
+++ a/drivers/rtc/rtc-cmos.c
@@ -1127,7 +1127,7 @@ static struct platform_driver cmos_platf
 	.remove		= __exit_p(cmos_platform_remove),
 	.shutdown	= cmos_platform_shutdown,
 	.driver = {
-		.name		= (char *) driver_name,
+		.name		= driver_name,
 #ifdef CONFIG_PM
 		.pm		= &cmos_pm_ops,
 #endif
_

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
drivers-rtc-rtc-s5mc-fix-info-rtc-assignment.patch
rtc-s5m-fix-unsuccesful-irq-request-during-probe.patch
rtc-s5m-limit-endless-loop-waiting-for-register-update.patch
rtc-s5m-enable-irq-wake-during-suspend.patch
mfd-rtc-s5m-fix-register-updating-by-adding-regmap-for-rtc.patch
inith-add-missing-initcall-variants.patch
futex-switch-to-user_ds-for-futex-test.patch
sh-always-link-in-helper-functions-extracted-from-libgcc.patch
drivers-gpu-drm-drm_edid_loadc-make-edid_load-return-a-void.patch
asm-typesh-remove-include-asm-generic-int-l64h.patch
maintainers-add-an-entry-for-the-macintosh-hfsplus-filesystem.patch
init-mainc-remove-unused-declaration-of-tc_init.patch
rtc-rtc-cmos-remove-superfluous-name-cast.patch
m68k-atari-hide-rtc_port-macro-from-rtc-cmos.patch
rtc-disable-rtc_drv_cmos-on-atari.patch
proc-cleanup-simplify-get_task_state-task_state_array.patch
linux-next.patch


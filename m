From: akpm@linux-foundation.org
Subject: + rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc-fix.patch added to -mm tree
Date: Fri, 06 Apr 2012 14:56:09 -0700
Message-ID: <20120406215610.0B695A0395@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:37572 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754230Ab2DFV4L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Apr 2012 17:56:11 -0400
Received: by yhgm50 with SMTP id m50so314421yhg.1
        for <mm-commits@vger.kernel.org>; Fri, 06 Apr 2012 14:56:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, a.zummo@towertech.it, fabio.estevam@freescale.com, festevam@gmail.com, w.sang@pengutronix.de


The patch titled
     Subject: rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc-fix
has been added to the -mm tree.  Its filename is
     rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc-fix

Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Fabio Estevam <fabio.estevam@freescale.com>
Cc: Fabio Estevam <festevam@gmail.com>
Cc: Wolfram Sang <w.sang@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/configs/imx_v6_v7_defconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/arm/configs/imx_v6_v7_defconfig~rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc-fix arch/arm/configs/imx_v6_v7_defconfig
--- a/arch/arm/configs/imx_v6_v7_defconfig~rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc-fix
+++ a/arch/arm/configs/imx_v6_v7_defconfig
@@ -172,7 +172,7 @@ CONFIG_NEW_LEDS=y
 CONFIG_LEDS_CLASS=y
 CONFIG_RTC_CLASS=y
 CONFIG_RTC_INTF_DEV_UIE_EMUL=y
-CONFIG_RTC_MXC=y
+CONFIG_RTC_DRV_MXC=y
 CONFIG_DMADEVICES=y
 CONFIG_IMX_SDMA=y
 CONFIG_EXT2_FS=y
_
Subject: Subject: rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc-fix

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
drivers-xen-kconfig-fix-kconfig-layout.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs-fix.patch
percpu-remove-percpu_xxx-functions-fix.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
brlocks-lglocks-cleanups.patch
mm.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
security-keys-keyctlc-suppress-memory-allocation-failure-warning.patch
spinlockstxt-add-a-discussion-on-why-spin_is_locked-is-bad-fix.patch
vsprintf-further-optimize-decimal-conversion-checkpatch-fixes.patch
leds-led-module-for-da9052-53-pmic-v2-fix.patch
leds-add-led-driver-for-lm3556-chip-fix-2.patch
leds-add-led-driver-for-lm3556-chip-checkpatch-fixes.patch
leds-add-led-driver-for-lm3556-chip-fix.patch
rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc-fix.patch
kmod-avoid-deadlock-by-recursive-kmod-call.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix-2.patch
c-r-prctl-add-ability-to-get-clear_tid_address-fix.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch


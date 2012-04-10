From: akpm@linux-foundation.org
Subject: + leds-add-led-driver-for-lm3556-chip-checkpatch-fixes.patch added to -mm tree
Date: Tue, 10 Apr 2012 12:45:29 -0700
Message-ID: <20120410194529.662D7A01B8@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:44209 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758740Ab2DJTpb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Apr 2012 15:45:31 -0400
Received: by faaa19 with SMTP id a19so13500faa.1
        for <mm-commits@vger.kernel.org>; Tue, 10 Apr 2012 12:45:30 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, gshark.jeong@gmail.com


The patch titled
     Subject: leds-add-led-driver-for-lm3556-chip-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     leds-add-led-driver-for-lm3556-chip-checkpatch-fixes.patch

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
Subject: leds-add-led-driver-for-lm3556-chip-checkpatch-fixes

WARNING: please write a paragraph that describes the config symbol fully
#35: FILE: drivers/leds/Kconfig:405:
+config LEDS_LM3556

ERROR: "foo * bar" should be "foo *bar"
#204: FILE: drivers/leds/leds-lm3556.c:142:
+static int lm3556_read_reg(struct i2c_client *client, u8 reg, u8 * val)

total: 1 errors, 1 warnings, 736 lines checked

./patches/leds-add-led-driver-for-lm3556-chip.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Geon Si Jeong <gshark.jeong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-lm3556.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/leds/leds-lm3556.c~leds-add-led-driver-for-lm3556-chip-checkpatch-fixes drivers/leds/leds-lm3556.c
--- a/drivers/leds/leds-lm3556.c~leds-add-led-driver-for-lm3556-chip-checkpatch-fixes
+++ a/drivers/leds/leds-lm3556.c
@@ -139,7 +139,7 @@ static struct indicator indicator_patter
 };
 
 /* i2c access*/
-static int lm3556_read_reg(struct i2c_client *client, u8 reg, u8 * val)
+static int lm3556_read_reg(struct i2c_client *client, u8 reg, u8 *val)
 {
 	int ret;
 
_
Subject: Subject: leds-add-led-driver-for-lm3556-chip-checkpatch-fixes

Patches currently in -mm which might be from akpm@linux-foundation.org are

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
leds-add-led-driver-for-lm3556-chip-checkpatch-fixes.patch
rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc-fix.patch
kmod-avoid-deadlock-by-recursive-kmod-call.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
c-r-prctl-add-ability-to-get-clear_tid_address.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch


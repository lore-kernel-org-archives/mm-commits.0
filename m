From: akpm@linux-foundation.org
Subject: + panic-allow-taint-flag-for-warnings-to-be-changed-from-taint_warn-checkpatch-fixes.patch added to -mm tree
Date: Mon, 22 Mar 2010 22:50:00 -0400
Message-ID: <201003230550.o2N5oph5016716@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51225 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754020Ab0CWFvF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Mar 2010 01:51:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, ben@decadent.org.uk


The patch titled
     panic-allow-taint-flag-for-warnings-to-be-changed-from-taint_warn-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     panic-allow-taint-flag-for-warnings-to-be-changed-from-taint_warn-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: panic-allow-taint-flag-for-warnings-to-be-changed-from-taint_warn-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: please, no space before tabs
#54: FILE: arch/parisc/include/asm/bug.h:57:
+^I^I^I     "i" (BUGFLAG_TAINT(taint)), ^I^I\$

Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/include/asm/bug.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/parisc/include/asm/bug.h~panic-allow-taint-flag-for-warnings-to-be-changed-from-taint_warn-checkpatch-fixes arch/parisc/include/asm/bug.h
--- a/arch/parisc/include/asm/bug.h~panic-allow-taint-flag-for-warnings-to-be-changed-from-taint_warn-checkpatch-fixes
+++ a/arch/parisc/include/asm/bug.h
@@ -54,7 +54,7 @@
 			     "\t.org 2b+%c3\n"				\
 			     "\t.popsection"				\
 			     : : "i" (__FILE__), "i" (__LINE__),	\
-			     "i" (BUGFLAG_TAINT(taint)), 		\
+			     "i" (BUGFLAG_TAINT(taint)),		\
 			     "i" (sizeof(struct bug_entry)) );		\
 	} while(0)
 #else
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-i2c-busses-i2c-xiicc-is-borked.patch
rtc-davinci-rtc-driver-checkpatch-fixes.patch
c2port-fix-device_create-return-value-check-fix.patch
ratelimit-annotate-___ratelimit-fix.patch
drivers-acpi-use-kasprintf-fix.patch
arch-arm-include-asm-elfh-forward-declare-the-task-struct.patch
cpufreq-ondemand-dont-synchronize-sample-rate-unless-mulitple-cpus-present.patch
fs-fscache-object-listc-fix-warning-on-32-bit.patch
hpet-factor-timer-allocate-from-open-fix.patch
of-gpio-implement-gpiolib-notifier-hooks-fix.patch
of-gpio-implement-gpiolib-notifier-hooks-fix-fix2.patch
led-driver-for-the-soekris-net5501-board-checkpatch-fixes.patch
bitops-rename-for_each_bit-to-for_each_set_bit-mtd.patch
3x59x-fix-pci-resource-management.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
davinci-mmc-updates-to-suspend-resume-implementation-checkpatch-fixes.patch
checkpatch-add-check-for-too-short-kconfig-descriptions-checkpatch-fixes.patch
hwmon-driver-for-ti-tmp102-temperature-sensor.patch
memcg-oom-kill-disable-and-oom-status-update-checkpatch-fixes.patch
fault-injection-add-cpu-notifier-error-injection-module-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
panic-allow-taint-flag-for-warnings-to-be-changed-from-taint_warn-checkpatch-fixes.patch
bitops-remove-temporary-for_each_bit.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-fixups.patch
reiser4-broke.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
notify_change-callers-must-hold-i_mutex.patch


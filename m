From: akpm@linux-foundation.org
Subject: + treewide-convert-uses-of-attrib_noreturn-to-__noreturn-checkpatch-fixes.patch added to -mm tree
Date: Thu, 10 Nov 2011 14:42:36 -0800
Message-ID: <201111102242.pAAMgbw3003082@wpaz33.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fx0-f74.google.com ([209.85.161.74]:47503 "EHLO
	mail-fx0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377Ab1KJWtL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Nov 2011 17:49:11 -0500
Received: by faas12 with SMTP id s12so82608faa.1
        for <mm-commits@vger.kernel.org>; Thu, 10 Nov 2011 14:49:10 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, benh@kernel.crashing.org, joe@perches.com


The patch titled
     Subject: treewide-convert-uses-of-attrib_noreturn-to-__noreturn-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     treewide-convert-uses-of-attrib_noreturn-to-__noreturn-checkpatch-fixes.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: treewide-convert-uses-of-attrib_noreturn-to-__noreturn-checkpatch-fixes

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>

WARNING: please, no spaces at the start of a line
#57: FILE: arch/m68k/amiga/config.c:515:
+    __noreturn;$

total: 0 errors, 1 warnings, 106 lines checked

./patches/treewide-convert-uses-of-attrib_noreturn-to-__noreturn.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/amiga/config.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN arch/m68k/amiga/config.c~treewide-convert-uses-of-attrib_noreturn-to-__noreturn-checkpatch-fixes arch/m68k/amiga/config.c
--- a/arch/m68k/amiga/config.c~treewide-convert-uses-of-attrib_noreturn-to-__noreturn-checkpatch-fixes
+++ a/arch/m68k/amiga/config.c
@@ -511,8 +511,7 @@ static unsigned long amiga_gettimeoffset
 	return ticks + offset;
 }
 
-static void amiga_reset(void)
-    __noreturn;
+static void amiga_reset(void)  __noreturn;
 
 static void amiga_reset(void)
 {
_
Subject: Subject: treewide-convert-uses-of-attrib_noreturn-to-__noreturn-checkpatch-fixes

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
mrst-battery-fixes-fix.patch
x86-reduce-clock-calibration-time-during-slave-cpu-startup-fix.patch
drivers-net-ethernet-oki-semi-pch_gbe-pch_gbeh-remove-unused-macro-pr_fmt.patch
debugobjects-extend-to-assert-that-an-object-is-initialized.patch
kernel-timerc-use-debugobjects-to-catch-deletion-of-uninitialized-timers.patch
drivers-message-fusion-mptbasec-ensure-nul-termination-of-mptcallbacksname-elements.patch
mm.patch
vmscan-use-atomic-long-for-shrinker-batching-fix.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
include-linux-securityh-fix-security_inode_init_security-arg.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
treewide-convert-uses-of-attrib_noreturn-to-__noreturn-checkpatch-fixes.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
leds-route-kbd-leds-through-the-generic-leds-layer-fix.patch
cgroup-fix-task-counter-common-ancestor-logic-checkpatch-fixes.patch
mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned-checkpatch-fixes.patch
procfs-introduce-the-proc-pid-map_files-directory-checkpatch-fixes.patch
kexec-remove-kmsg_dump_kexec.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
memstick-add-support-for-legacy-memorysticks-fix.patch
dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fixes.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch


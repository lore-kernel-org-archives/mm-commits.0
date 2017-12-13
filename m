From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Wed, 13 Dec 2017 14:25:47 -0800
Message-ID: <20171213222547.mFTj66Kp1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35652 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750992AbdLMWZt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Dec 2017 17:25:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

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
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/platform/x86/dell-laptop.c~linux-next-git-rejects drivers/platform/x86/dell-laptop.c
--- a/drivers/platform/x86/dell-laptop.c~linux-next-git-rejects
+++ a/drivers/platform/x86/dell-laptop.c
@@ -36,13 +36,8 @@
 #include "dell-smbios.h"
 
 struct quirk_entry {
-<<<<<<< HEAD
-	u8 touchpad_led;
-	u8 kbd_led_levels_off_1;
-=======
 	bool touchpad_led;
 	bool kbd_led_levels_off_1;
->>>>>>> linux-next/akpm-base
 
 	bool needs_kbd_timeouts;
 	/*
@@ -74,11 +69,7 @@ static struct quirk_entry quirk_dell_xps
 };
 
 static struct quirk_entry quirk_dell_latitude_e6410 = {
-<<<<<<< HEAD
-	.kbd_led_levels_off_1 = 1,
-=======
 	.kbd_led_levels_off_1 = true,
->>>>>>> linux-next/akpm-base
 };
 
 static struct platform_driver platform_driver = {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
mm-kmemleakc-make-cond_resched-rate-limiting-more-efficient.patch
stringh-work-around-for-increased-stack-usage-fix.patch
mm-memoryc-mark-wp_huge_pmd-inline-to-prevent-build-failure-fix.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-terminate-shrink_slab-loop-if-signal-is-pending-fix.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-split-deferred_init_range-into-initializing-and-freeing-parts-fix.patch
mm-do-not-stall-register_shrinker-fix.patch
selftest-vm-move-128tb-mmap-boundary-test-to-generic-directory-fix.patch
list_lru-prefetch-neighboring-list-entries-before-acquiring-lock-fix.patch
mm-oom-cgroup-aware-oom-killer-fix.patch
lib-ubsanc-s-missaligned-misaligned.patch
linux-next-rejects.patch
tools-objtool-makefile-dont-assume-sync-checksh-is-executable.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch
linux-next-git-rejects.patch


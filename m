From: akpm@linux-foundation.org
Subject: + input-route-kbd-leds-through-the-generic-leds-layer-fix.patch
 added to -mm tree
Date: Mon, 25 Nov 2013 13:28:29 -0800
Message-ID: <5293c0fd.nldLZl+tRXxizwB/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56591 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887Ab3KYV2a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Nov 2013 16:28:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, samuel.thibault@ens-lyon.org, fengguang.wu@intel.com, dmitry.torokhov@gmail.com, akpm@linux-foundation.org

Subject: + input-route-kbd-leds-through-the-generic-leds-layer-fix.patch added to -mm tree
To: akpm@linux-foundation.org,dmitry.torokhov@gmail.com,fengguang.wu@intel.com,samuel.thibault@ens-lyon.org
From: akpm@linux-foundation.org
Date: Mon, 25 Nov 2013 13:28:29 -0800


The patch titled
     Subject: input-route-kbd-leds-through-the-generic-leds-layer-fix
has been added to the -mm tree.  Its filename is
     input-route-kbd-leds-through-the-generic-leds-layer-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/input-route-kbd-leds-through-the-generic-leds-layer-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/input-route-kbd-leds-through-the-generic-leds-layer-fix.patch

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
Subject: input-route-kbd-leds-through-the-generic-leds-layer-fix

remove unneeded `extern', fix comment layout

Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/leds.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN drivers/input/leds.c~input-route-kbd-leds-through-the-generic-leds-layer-fix drivers/input/leds.c
--- a/drivers/input/leds.c~input-route-kbd-leds-through-the-generic-leds-layer-fix
+++ a/drivers/input/leds.c
@@ -211,9 +211,11 @@ err:
 	return error;
 }
 
-/* Disconnected input device. Clean it, and deregister now-useless VT LEDs
- * and triggers.  */
-extern void input_led_disconnect(struct input_dev *dev)
+/*
+ * Disconnected input device. Clean it, and deregister now-useless VT LEDs and
+ * triggers.
+ */
+void input_led_disconnect(struct input_dev *dev)
 {
 	int i;
 	struct led_classdev *leds = dev->leds;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
input-route-kbd-leds-through-the-generic-leds-layer-fix.patch
drivers-block-ccissc-cciss_init_one-use-proper-errnos.patch
block-blk-mq-cpuc-use-hotcpu_notifier.patch
mtd-cmdlinepart-use-cmdline-partition-parser-lib-fix-fix.patch
posix_acl-uninlining.patch
mm.patch
mm-hugetlbc-simplify-pageheadhuge-and-pagehuge.patch
mm-swapc-reorganize-put_compound_page.patch
mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve-fix.patch
mm-memory-failure-fix-the-typo-in-me_pagecache_dirty-fix.patch
arch-um-kernel-sysrqc-rename-print_stack_trace.patch
lib-parserc-put-export_symbols-in-the-conventional-place.patch
kernel-paramsc-improve-standard-definitions-checkpatch-fixes.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch


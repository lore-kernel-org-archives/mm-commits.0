From: akpm@linux-foundation.org
Subject: [to-be-updated] leds-route-kbd-leds-through-the-generic-leds-layer-fix.patch removed from -mm tree
Date: Mon, 14 Nov 2011 15:13:06 -0800
Message-ID: <201111142313.pAEND6DR007929@wpaz17.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fx0-f74.google.com ([209.85.161.74]:48419 "EHLO
	mail-fx0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756545Ab1KNXNK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Nov 2011 18:13:10 -0500
Received: by faap16 with SMTP id p16so82758faa.1
        for <mm-commits@vger.kernel.org>; Mon, 14 Nov 2011 15:13:09 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dmitry.torokhov@gmail.com, samuel.thibault@ens-lyon.org, mm-commits@vger.kernel.org


The patch titled
     Subject: leds-route-kbd-leds-through-the-generic-leds-layer-fix
has been removed from the -mm tree.  Its filename was
     leds-route-kbd-leds-through-the-generic-leds-layer-fix.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: leds-route-kbd-leds-through-the-generic-leds-layer-fix

x86_64 allmodconfig:

drivers/leds/leds-input.c:304: error: expected declaration specifiers or '...' before string constant
drivers/leds/leds-input.c:304: warning: data definition has no type or storage class
drivers/leds/leds-input.c:304: warning: type defaults to 'int' in declaration of 'MODULE_LICENSE'
drivers/leds/leds-input.c:304: warning: function declaration isn't a prototype
drivers/leds/leds-input.c:305: error: expected declaration specifiers or '...' before string constant
drivers/leds/leds-input.c:305: warning: data definition has no type or storage class
drivers/leds/leds-input.c:305: warning: type defaults to 'int' in declaration of 'MODULE_DESCRIPTION'
drivers/leds/leds-input.c:305: warning: function declaration isn't a prototype
drivers/leds/leds-input.c:306: error: expected declaration specifiers or '...' before string constant
drivers/leds/leds-input.c:306: warning: data definition has no type or storage class
drivers/leds/leds-input.c:306: warning: type defaults to 'int' in declaration of 'MODULE_AUTHOR'
drivers/leds/leds-input.c:306: warning: function declaration isn't a prototype

Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-input.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/leds/leds-input.c~leds-route-kbd-leds-through-the-generic-leds-layer-fix drivers/leds/leds-input.c
--- a/drivers/leds/leds-input.c~leds-route-kbd-leds-through-the-generic-leds-layer-fix
+++ a/drivers/leds/leds-input.c
@@ -13,6 +13,7 @@
 #include <linux/slab.h>
 #include <linux/leds.h>
 #include <linux/input.h>
+#include <linux/module.h>
 
 #include "leds.h"
 
_

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
mm-avoid-livelock-on-__gfp_fs-allocations-fix.patch
include-linux-securityh-fix-security_inode_init_security-arg.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
treewide-convert-uses-of-attrib_noreturn-to-__noreturn-checkpatch-fixes.patch
cgroup-fix-task-counter-common-ancestor-logic-checkpatch-fixes.patch
mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned-checkpatch-fixes.patch
procfs-introduce-the-proc-pid-map_files-directory-checkpatch-fixes.patch
workqueue-make-alloc_workqueue-take-printf-fmt-and-args-for-name-fix.patch
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


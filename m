From: akpm@linux-foundation.org
Subject: + drivers-video-mb862xx-mb862xxfbdrvc-needs-uaccessh.patch added to -mm tree
Date: Wed, 25 May 2011 16:09:24 -0700
Message-ID: <201105252346.p4PNk9kQ025237@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37437 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753508Ab1EYXqS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 19:46:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, agust@denx.de, lethal@linux-sh.org


The patch titled
     drivers/video/mb862xx/mb862xxfbdrv.c needs uaccess.h
has been added to the -mm tree.  Its filename is
     drivers-video-mb862xx-mb862xxfbdrvc-needs-uaccessh.patch

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
Subject: drivers/video/mb862xx/mb862xxfbdrv.c needs uaccess.h
From: Andrew Morton <akpm@linux-foundation.org>

alpha allmodconfig:

drivers/video/mb862xx/mb862xxfbdrv.c: In function 'mb862xxfb_ioctl':
drivers/video/mb862xx/mb862xxfbdrv.c:323: error: implicit declaration of function 'copy_to_user'
drivers/video/mb862xx/mb862xxfbdrv.c:327: error: implicit declaration of function 'copy_from_user'

Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Anatolij Gustschin <agust@denx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/mb862xx/mb862xxfbdrv.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/video/mb862xx/mb862xxfbdrv.c~drivers-video-mb862xx-mb862xxfbdrvc-needs-uaccessh drivers/video/mb862xx/mb862xxfbdrv.c
--- a/drivers/video/mb862xx/mb862xxfbdrv.c~drivers-video-mb862xx-mb862xxfbdrvc-needs-uaccessh
+++ a/drivers/video/mb862xx/mb862xxfbdrv.c
@@ -16,6 +16,7 @@
 
 #include <linux/fb.h>
 #include <linux/delay.h>
+#include <linux/uaccess.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/pci.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
drivers-video-mb862xx-mb862xx-i2cc-needs-delayh.patch
drivers-video-mb862xx-mb862xxfbdrvc-needs-uaccessh.patch
drivers-bcma-host_pcic-needs-slabh.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
checkpatch-suggest-using-min_t-or-max_t.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
drivers-rtc-rtc-mrstc-use-release_mem_region-after-request_mem_region-fix.patch
rtc-driver-for-pt7c4338-chip-checkpatch-fixes.patch
rtc-driver-for-pt7c4338-chip-fix.patch
drivers-rtc-rtc-mxcc-remove-defines-already-included-in-rtch-fix.patch
documentation-accounting-getdelaysc-handle-sendto-failures.patch
documentation-configfs-examples-crash-fix-checkpatch-fixes.patch
mm-move-enum-vm_event_item-into-a-standalone-header-file.patch
memcg-reclaim-memory-from-nodes-in-round-robin-fix.patch
add-the-pagefault-count-into-memcg-stats.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily-fix.patch
fs-partitions-efic-corrupted-guid-partition-tables-can-cause-kernel-oops-fix.patch
kernel-profilec-remove-some-duplicate-code-from-profile_hits-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
w1-add-maxim-dallas-ds2780-stand-alone-fuel-gauge-ic-support-v3-fix.patch
kexec-remove-kmsg_dump_kexec-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch


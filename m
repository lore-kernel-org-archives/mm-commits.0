From: akpm@linux-foundation.org
Subject: + mmc-recognize-csd-structure-fix.patch added to -mm tree
Date: Fri, 04 Jun 2010 16:22:10 -0700
Message-ID: <201006042322.o54NMA3C024331__17141.3642973222$1275693754$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37779 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757065Ab0FDXWZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Jun 2010 19:22:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, adrian.hunter@nokia.com, cjb@laptop.org, kmpark@infradead.org, kyungmin.park@samsung.com, linux-mmc@vger.kernel.org


The patch titled
     mmc-recognize-csd-structure-fix
has been added to the -mm tree.  Its filename is
     mmc-recognize-csd-structure-fix.patch

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
Subject: mmc-recognize-csd-structure-fix
From: Andrew Morton <akpm@linux-foundation.org>

fix comment, per Chris Ball

Cc: <linux-mmc@vger.kernel.org>
Cc: Adrian Hunter <adrian.hunter@nokia.com>
Cc: Chris Ball <cjb@laptop.org>
Cc: Kyungmin Park <kmpark@infradead.org>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/core/mmc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mmc/core/mmc.c~mmc-recognize-csd-structure-fix drivers/mmc/core/mmc.c
--- a/drivers/mmc/core/mmc.c~mmc-recognize-csd-structure-fix
+++ a/drivers/mmc/core/mmc.c
@@ -120,7 +120,7 @@ static int mmc_decode_csd(struct mmc_car
 	/*
 	 * We only understand CSD structure v1.1 and v1.2.
 	 * v1.2 has extra information in bits 15, 11 and 10.
-	 * also support the for eMMC v4.4 & v4.41.
+	 * We also support eMMC v4.4 & v4.41.
 	 */
 	csd->structure = UNSTUFF_BITS(resp, 126, 2);
 	if (csd->structure == 0) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
intel_menlow-fix-memory-leaks-in-error-path-fix.patch
x86-cpufreq-make-trace_power_frequency-cpufreq-driver-independent-fix.patch
compal-laptop-added-jhl90-battery-hwmon-interface.patch
dib3000mc-reduce-large-stack-usage-fix.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
3x59x-fix-pci-resource-management.patch
altera_uart-simplify-altera_uart_console_putc-checkpatch-fixes.patch
scsi-remove-private-bit-macros.patch
vfs-use-kmalloc-to-allocate-fdmem-if-possible.patch
tmpfs-quick-token-library-to-allow-scalable-retrieval-of-tokens-from-token-jar-fix.patch
mm-vmap-area-cache-fix.patch
mm-track-the-root-oldest-anon_vma-fix.patch
buffer_head-remove-redundant-test-from-wait_on_buffer-fix.patch
wait_on_buffer-remove-the-buffer_locked-test.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
include-linux-compiler-gcch-use-__same_type-in-__must_be_array.patch
printk-fix-delayed-messages-from-cpu-hotplug-events-fix.patch
mmc-recognize-csd-structure-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
kfifo-add-example-files-to-the-kernel-sample-directory-checkpatch-fixes.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-fixups.patch
reiser4-broke.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch


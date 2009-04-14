From: akpm@linux-foundation.org
Subject: + rb_tree-reorganize-code-in-rb_erase-for-additional-changes-checkpatch-fixes.patch added to -mm tree
Date: Tue, 14 Apr 2009 16:41:46 -0700
Message-ID: <200904142341.n3ENfk1G031494@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34408 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752123AbZDNXnb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Apr 2009 19:43:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, a.p.zijlstra@chello.nl, wstrepp@gmx.de


The patch titled
     rb_tree-reorganize-code-in-rb_erase-for-additional-changes-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     rb_tree-reorganize-code-in-rb_erase-for-additional-changes-checkpatch-fixes.patch

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
Subject: rb_tree-reorganize-code-in-rb_erase-for-additional-changes-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: that open brace { should be on the previous line
#21: FILE: lib/rbtree.c:235:
+		if (rb_parent(old))
+		{

total: 1 errors, 0 warnings, 31 lines checked

./patches/rb_tree-reorganize-code-in-rb_erase-for-additional-changes.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: "Wolfram Strepp" <wstrepp@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Wolfram Strepp <wstrepp@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/rbtree.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN lib/rbtree.c~rb_tree-reorganize-code-in-rb_erase-for-additional-changes-checkpatch-fixes lib/rbtree.c
--- a/lib/rbtree.c~rb_tree-reorganize-code-in-rb_erase-for-additional-changes-checkpatch-fixes
+++ a/lib/rbtree.c
@@ -232,8 +232,7 @@ void rb_erase(struct rb_node *node, stru
 		while ((left = node->rb_left) != NULL)
 			node = left;
 
-		if (rb_parent(old))
-		{
+		if (rb_parent(old)) {
 			if (rb_parent(old)->rb_left == old)
 				rb_parent(old)->rb_left = node;
 			else
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i2c-too-much-compiler-noise.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts.patch
arch-x86-kernel-acpi-cstatec-avoid-using-work_on_cpu.patch
clocksource-pass-clocksource-to-read-callback.patch
input-bcm5974-declare-alignment-usage.patch
input-keyboard-introduce-lm8323-driver.patch
drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-checkpatch-fixes.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality-checkpatch-fixes.patch
mips-cacheflush-system-call-not-returning-einval-checkpatch-fixes.patch
mtd-flex-onenand-support.patch
misdn-l1oip-reduce-stack-memory-footprint.patch
drivers-net-82596c-suppress-warnings.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
vfs-kill-vfs_stat_fd-vfs_lstat_fd-fix.patch
xtensa-add-flat-support-checkpatch-fixes.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
input-add-a-dmi-table-for-the-i8042reset-option-make-msi-wind-u-100-work.patch
squashfs-fix-breakage-when-pagesize-blocksize-checkpatch-fixes.patch
mm-consolidate-init_mm-definition-fix.patch
readahead-record-mmap-read-around-states-in-file_ra_state-checkpatch-fixes.patch
readahead-introduce-context-readahead-algorithm-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
rb_tree-reorganize-code-in-rb_erase-for-additional-changes-checkpatch-fixes.patch
flat-fix-data-sections-alignment.patch
gru-support-for-asynchronous-gru-instructions-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch


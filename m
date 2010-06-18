From: akpm@linux-foundation.org
Subject: + radix-tree-implement-function-radix_tree_range_tag_if_tagged-checkpatch-fixes.patch added to -mm tree
Date: Fri, 18 Jun 2010 15:22:43 -0700
Message-ID: <201006182222.o5IMMiFX026628@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45423 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754021Ab0FRWXR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Jun 2010 18:23:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, jack@suse.cz


The patch titled
     radix-tree-implement-function-radix_tree_range_tag_if_tagged-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     radix-tree-implement-function-radix_tree_range_tag_if_tagged-checkpatch-fixes.patch

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
Subject: radix-tree-implement-function-radix_tree_range_tag_if_tagged-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: please, no space before tabs
#46: FILE: lib/radix-tree.c:618:
+ * @iftag: ^I^Itag index to test$

ERROR: code indent should use tabs where possible
#58: FILE: lib/radix-tree.c:630:
+                unsigned long *first_indexp, unsigned long last_index,$

ERROR: code indent should use tabs where possible
#59: FILE: lib/radix-tree.c:631:
+                unsigned long nr_to_tag,$

total: 2 errors, 1 warnings, 108 lines checked

./patches/radix-tree-implement-function-radix_tree_range_tag_if_tagged.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN lib/radix-tree.c~radix-tree-implement-function-radix_tree_range_tag_if_tagged-checkpatch-fixes lib/radix-tree.c
--- a/lib/radix-tree.c~radix-tree-implement-function-radix_tree_range_tag_if_tagged-checkpatch-fixes
+++ a/lib/radix-tree.c
@@ -615,7 +615,7 @@ EXPORT_SYMBOL(radix_tree_tag_get);
  * @first_indexp:	pointer to a starting index of a range to scan
  * @last_index:		last index of a range to scan
  * @nr_to_tag:		maximum number items to tag
- * @iftag: 		tag index to test
+ * @iftag:		tag index to test
  * @settag:		tag index to set if tested tag is set
  *
  * This function scans range of radix tree from first_index to last_index
@@ -627,8 +627,8 @@ EXPORT_SYMBOL(radix_tree_tag_get);
  * *first_indexp to the first unscanned index.
  */
 unsigned long radix_tree_range_tag_if_tagged(struct radix_tree_root *root,
-                unsigned long *first_indexp, unsigned long last_index,
-                unsigned long nr_to_tag,
+		unsigned long *first_indexp, unsigned long last_index,
+		unsigned long nr_to_tag,
 		unsigned int iftag, unsigned int settag)
 {
 	unsigned int height = root->height, shift;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
cpuidle-avoid-using-smp_processor_id-in-preemptible-code-nr_iowait_cpu-v4-fix.patch
cpuidle-avoid-using-smp_processor_id-in-preemptible-code-nr_iowait_cpu-v4-fix-fix.patch
cpuidle-avoid-using-smp_processor_id-in-preemptible-code-nr_iowait_cpu-v4-fix-fix-fix.patch
fs-fcntlc-kill_fasync_rcu-fa_lock-must-be-irq-safe.patch
intel_menlow-fix-memory-leaks-in-error-path-fix.patch
x86-cpufreq-make-trace_power_frequency-cpufreq-driver-independent-fix.patch
compal-laptop-added-jhl90-battery-hwmon-interface.patch
dib3000mc-reduce-large-stack-usage-fix.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
3x59x-fix-pci-resource-management.patch
altera_uart-simplify-altera_uart_console_putc-checkpatch-fixes.patch
serial-mcf-dont-take-spinlocks-in-already-protected-functions-fix.patch
scsi-remove-private-bit-macros.patch
vfs-use-kmalloc-to-allocate-fdmem-if-possible.patch
mm.patch
tmpfs-quick-token-library-to-allow-scalable-retrieval-of-tokens-from-token-jar.patch
mm-vmap-area-cache-fix.patch
mm-track-the-root-oldest-anon_vma-fix.patch
oom-improve-commentary-in-dump_tasks.patch
oom-sacrifice-child-with-highest-badness-score-for-parent-protect-dereferencing-of-tasks-comm.patch
oom-select-task-from-tasklist-for-mempolicy-ooms-add-has_intersects_mems_allowed-uma-variant.patch
mempolicy-reduce-stack-size-of-migrate_pages-fix.patch
radix-tree-implement-function-radix_tree_range_tag_if_tagged-checkpatch-fixes.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
include-linux-compiler-gcch-use-__same_type-in-__must_be_array.patch
mmc-recognize-csd-structure-fix.patch
mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume-fix.patch
fix-vc-vc_origin-on-take_over_console-checkpatch-fixes.patch
rtc-fixes-and-new-functionality-for-fm3130-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
kfifo-add-example-files-to-the-kernel-sample-directory-checkpatch-fixes.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4-export-find_get_pages.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-fixups.patch
reiser4-broke.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch


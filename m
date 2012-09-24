From: akpm@linux-foundation.org
Subject: + hfsplus-add-support-of-manipulation-by-attributes-file-checkpatch-fixes.patch added to -mm tree
Date: Mon, 24 Sep 2012 15:50:13 -0700
Message-ID: <20120924225013.E3BA7200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:39553 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541Ab2IXWuQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 24 Sep 2012 18:50:16 -0400
Received: by weyr1 with SMTP id r1so397377wey.1
        for <mm-commits@vger.kernel.org>; Mon, 24 Sep 2012 15:50:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, slava@dubeyko.com


The patch titled
     Subject: hfsplus-add-support-of-manipulation-by-attributes-file-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     hfsplus-add-support-of-manipulation-by-attributes-file-checkpatch-fixes.patch

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
Subject: hfsplus-add-support-of-manipulation-by-attributes-file-checkpatch-fixes

WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...
#280: FILE: fs/hfsplus/btree.c:103:
+			printk(KERN_ERR "hfs: invalid attributes max_key_len %d\n",

WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...
#589: FILE: fs/hfsplus/inode.c:353:
+			printk(KERN_ERR "hfs: sync non-existent attributes tree\n");

WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...
#643: FILE: fs/hfsplus/super.c:482:
+			printk(KERN_ERR "hfs: failed to load attributes file\n");

ERROR: code indent should use tabs where possible
#686: FILE: fs/hfsplus/super.c:660:
+ ^Ireturn err;$

WARNING: please, no space before tabs
#686: FILE: fs/hfsplus/super.c:660:
+ ^Ireturn err;$

WARNING: please, no spaces at the start of a line
#686: FILE: fs/hfsplus/super.c:660:
+ ^Ireturn err;$

total: 1 errors, 5 warnings, 616 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

./patches/hfsplus-add-support-of-manipulation-by-attributes-file.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Vyacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/hfsplus/super.c~hfsplus-add-support-of-manipulation-by-attributes-file-checkpatch-fixes fs/hfsplus/super.c
--- a/fs/hfsplus/super.c~hfsplus-add-support-of-manipulation-by-attributes-file-checkpatch-fixes
+++ a/fs/hfsplus/super.c
@@ -657,7 +657,7 @@ destroy_attr_tree_cache:
 destroy_inode_cache:
 	kmem_cache_destroy(hfsplus_inode_cachep);
 
- 	return err;
+	return err;
 }
 
 static void __exit exit_hfsplus_fs(void)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
linux-next-unbork.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
idr-rename-max_level-to-max_idr_level-fix-3.patch
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
audith-replace-defines-with-c-stubs.patch
mm.patch
x86-pat-separate-the-pfn-attribute-tracking-for-remap_pfn_range-and-vm_insert_pfn-fix.patch
mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix-fix.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures-fix.patch
mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host-fix.patch
rbtree-performance-and-correctness-test-fix.patch
mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration-fix-fix.patch
mm-fix-tracing-in-free_pcppages_bulk-fix.patch
cma-count-free-cma-pages-fix.patch
memory-hotplug-fix-pages-missed-by-race-rather-than-failng-fix.patch
atomic-implement-generic-atomic_dec_if_positive-fix.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix-2.patch
mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc-checkpatch-fixes.patch
mm-fix-invalidate_complete_page2-lock-ordering.patch
mm-numa-reclaim-from-all-nodes-within-reclaim-distance-fix.patch
mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock.patch
sections-fix-section-conflicts-in-arch-h8300-checkpatch-fixes.patch
sections-fix-section-conflicts-in-drivers-macintosh-checkpatch-fixes.patch
sectons-fix-const-sections-for-crc32-table-checkpatch-fixes.patch
drivers-misc-lis3lv02d-lis3lv02d_spic-add-dt-matching-table-passthru-code-fix-fix.patch
drivers-misc-lis3lv02d-lis3lv02d_spic-add-lis3lv02d-device-tree-init-fix.patch
drivers-misc-lis3lv02d-lis3lv02d_i2cc-add-lis3lv02d-device-tree-init-fix.patch
backlight-add-backlight-driver-for-lm3630-chip-fix.patch
backlight-add-new-lm3639-backlight-driver-fix.patch
backlight-platform-lcd-add-support-for-device-tree-based-probe-fix.patch
idr-rename-max_level-to-max_idr_level-fix.patch
idr-rename-max_level-to-max_idr_level-fix-fix-2.patch
lib-parserc-avoid-overflow-in-match_number-fix.patch
lib-spinlock_debug-avoid-livelock-in-do_raw_spin_lock-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
rtc-add-dallas-ds2404-driver-fix.patch
rtc-snvs-add-freescale-rtc-snvs-driver-fix.patch
hfsplus-add-support-of-manipulation-by-attributes-file-checkpatch-fixes.patch
fs-fat-fix-all-other-checkpatch-issues-in-dirc-fix.patch
fat-simplify-writeback_inode-checkpatch-fixes.patch
fat-simplify-writeback_inode-checkpatch-fixes-fix.patch
coredump-make-core-dump-functionality-optional-fix-fix.patch
coredump-use-suid_dumpable_enabled-rather-than-hardcoded-1-checkpatch-fixes.patch
proc-use-kzalloc-instead-of-kmalloc-and-memset-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch


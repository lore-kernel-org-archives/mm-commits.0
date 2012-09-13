From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Thu, 13 Sep 2012 11:18:47 -0700
Message-ID: <20120913181848.510131E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:55053 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab2IMSSu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Sep 2012 14:18:50 -0400
Received: by qcqs25 with SMTP id s25so350568qcq.1
        for <mm-commits@vger.kernel.org>; Thu, 13 Sep 2012 11:18:50 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

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

 arch/arm/mm/mmu.c |   11 -----------
 1 file changed, 11 deletions(-)

diff -puN arch/arm/mm/mmu.c~linux-next-git-rejects arch/arm/mm/mmu.c
--- a/arch/arm/mm/mmu.c~linux-next-git-rejects
+++ a/arch/arm/mm/mmu.c
@@ -805,18 +805,7 @@ void __init vm_reserve_area_early(unsign
 
 static void __init pmd_empty_section_gap(unsigned long addr)
 {
-<<<<<<< HEAD
-	struct vm_struct *vm;
-
-	vm = early_alloc_aligned(sizeof(*vm), __alignof__(*vm));
-	vm->addr = (void *)addr;
-	vm->size = SECTION_SIZE;
-	vm->flags = VM_IOREMAP | VM_ARM_EMPTY_MAPPING;
-	vm->caller = pmd_empty_section_gap;
-	vm_area_add_early(vm);
-=======
 	vm_reserve_area_early(addr, SECTION_SIZE, pmd_empty_section_gap);
->>>>>>> linux-next/akpm-base
 }
 
 static void __init fill_pmd_gaps(void)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

idr-rename-max_level-to-max_idr_level-fix.patch
idr-rename-max_level-to-max_idr_level-fix-fix-2.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
idr-rename-max_level-to-max_idr_level-fix-3.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
audith-replace-defines-with-c-stubs.patch
slab-fix-debug==0-warning.patch
mm.patch
x86-pat-separate-the-pfn-attribute-tracking-for-remap_pfn_range-and-vm_insert_pfn-fix.patch
mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix-fix.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures-fix.patch
mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host-fix.patch
rbtree-performance-and-correctness-test-fix.patch
mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock-fix.patch
memory-hotplug-fix-pages-missed-by-race-rather-than-failng-fix.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix.patch
mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc-checkpatch-fixes.patch
backlight-add-backlight-driver-for-lm3630-chip-fix.patch
backlight-add-new-lm3639-backlight-driver-fix.patch
lib-parserc-avoid-overflow-in-match_number-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
rtc-add-dallas-ds2404-driver-fix.patch
rtc-snvs-add-freescale-rtc-snvs-driver-fix.patch
fs-fat-fix-all-other-checkpatch-issues-in-dirc-fix.patch
fat-simplify-writeback_inode-checkpatch-fixes.patch
fat-simplify-writeback_inode-checkpatch-fixes-fix.patch
coredump-make-core-dump-functionality-optional-fix-fix.patch
proc-use-kzalloc-instead-of-kmalloc-and-memset-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch


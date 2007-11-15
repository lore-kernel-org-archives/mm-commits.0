From: akpm@linux-foundation.org
Subject: - uml-update-address-space-affected-by-pud_clear-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 14 Nov 2007 16:40:26 -0800
Message-ID: <200711150040.lAF0eQFi001839@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43269 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756799AbXKOAlK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Nov 2007 19:41:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml-update-address-space-affected-by-pud_clear-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     uml-update-address-space-affected-by-pud_clear-checkpatch-fixes.patch

This patch was dropped because it was folded into uml-update-address-space-affected-by-pud_clear.patch

------------------------------------------------------
Subject: uml-update-address-space-affected-by-pud_clear-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: use tabs not spaces
#30: FILE: include/asm-um/pgtable-3level.h:74:
+        set_pud(pud, __pud(_PAGE_NEWPAGE));$

total: 1 errors, 0 warnings, 8 lines checked
Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Jeff Dike <jdike@addtoit.com>
Cc: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-um/pgtable-3level.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN include/asm-um/pgtable-3level.h~uml-update-address-space-affected-by-pud_clear-checkpatch-fixes include/asm-um/pgtable-3level.h
--- a/include/asm-um/pgtable-3level.h~uml-update-address-space-affected-by-pud_clear-checkpatch-fixes
+++ a/include/asm-um/pgtable-3level.h
@@ -1,3 +1,4 @@
+
 /*
  * Copyright 2003 PathScale Inc
  * Derived from include/asm-i386/pgtable.h
@@ -71,7 +72,7 @@ static inline pmd_t *pmd_alloc_one(struc
 
 static inline void pud_clear (pud_t *pud)
 {
-        set_pud(pud, __pud(_PAGE_NEWPAGE));
+	set_pud(pud, __pud(_PAGE_NEWPAGE));
 }
 
 #define pud_page(pud) phys_to_page(pud_val(pud) & PAGE_MASK)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
uml-update-address-space-affected-by-pud_clear.patch
uml-update-address-space-affected-by-pud_clear-checkpatch-fixes.patch
improve-cgroup-printks-fix.patch
proc-fix-proc_kill_inodes-to-kill-dentries-on-all-proc-superblocks-checkpatch-fixes.patch
acpi-make-acpi_procfs-default-to-y.patch
hugetlb-split-alloc_huge_page-into-private-and-shared-components-checkpatch-fixes.patch
revert-task-control-groups-example-cpu-accounting-subsystem.patch
mips-undo-locking-on-error-path-returns-checkpatch-fixes.patch
pidns-place-under-config_experimental-checkpatch-fixes.patch
fix-64kb-blocksize-in-ext3-directories-checkpatch-fixes.patch
file-capabilities-allow-sigcont-within-session-v2-checkpatch-fixes.patch
x86-disable-preemption-in-delay_tsc.patch
aic94xx_sds-rename-flash_size.patch
mips-pcspkr-build-fix.patch

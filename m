From: akpm@linux-foundation.org
Subject: - hugetlb-split-alloc_huge_page-into-private-and-shared-components-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 14 Nov 2007 16:43:50 -0800
Message-ID: <200711150043.lAF0hojP002013@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40488 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754905AbXKOAoz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Nov 2007 19:44:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, agl@us.ibm.com, apw@shadowen.org, haveblue@us.ibm.com, hermes@gibson.dropbear.id.au, kenchen@google.com, wli@holomorphy.com, mm-commits@vger.kernel.org


The patch titled
     hugetlb-split-alloc_huge_page-into-private-and-shared-components-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     hugetlb-split-alloc_huge_page-into-private-and-shared-components-checkpatch-fixes.patch

This patch was dropped because it was folded into hugetlb-split-alloc_huge_page-into-private-and-shared-components.patch

------------------------------------------------------
Subject: hugetlb-split-alloc_huge_page-into-private-and-shared-components-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: use tabs not spaces
#32: FILE: mm/hugetlb.c:358:
+^I^I^I ^I^I^Iunsigned long addr)$

ERROR: use tabs not spaces
#54: FILE: mm/hugetlb.c:369:
+^I^I^I ^I^I^Iunsigned long addr)$

total: 2 errors, 0 warnings, 62 lines checked
Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Adam Litke <agl@us.ibm.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: David Gibson <hermes@gibson.dropbear.id.au>
Cc: Ken Chen <kenchen@google.com>
Cc: William Lee Irwin III <wli@holomorphy.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/hugetlb.c~hugetlb-split-alloc_huge_page-into-private-and-shared-components-checkpatch-fixes mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-split-alloc_huge_page-into-private-and-shared-components-checkpatch-fixes
+++ a/mm/hugetlb.c
@@ -355,7 +355,7 @@ void return_unused_surplus_pages(unsigne
 
 
 static struct page *alloc_huge_page_shared(struct vm_area_struct *vma,
-			 			unsigned long addr)
+						unsigned long addr)
 {
 	struct page *page;
 
@@ -366,7 +366,7 @@ static struct page *alloc_huge_page_shar
 }
 
 static struct page *alloc_huge_page_private(struct vm_area_struct *vma,
-			 			unsigned long addr)
+						unsigned long addr)
 {
 	struct page *page = NULL;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
uml-update-address-space-affected-by-pud_clear.patch
proc-fix-proc_kill_inodes-to-kill-dentries-on-all-proc-superblocks.patch
acpi-make-acpi_procfs-default-to-y.patch
hugetlb-split-alloc_huge_page-into-private-and-shared-components.patch
hugetlb-split-alloc_huge_page-into-private-and-shared-components-checkpatch-fixes.patch
revert-task-control-groups-example-cpu-accounting-subsystem.patch
mips-undo-locking-on-error-path-returns-checkpatch-fixes.patch
pidns-place-under-config_experimental-checkpatch-fixes.patch
fix-64kb-blocksize-in-ext3-directories-checkpatch-fixes.patch
file-capabilities-allow-sigcont-within-session-v2-checkpatch-fixes.patch
x86-disable-preemption-in-delay_tsc.patch
aic94xx_sds-rename-flash_size.patch
mips-pcspkr-build-fix.patch

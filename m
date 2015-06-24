From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-fix-mprotect-behaviour-on-vm_locked-vmas-fix.patch removed from -mm tree
Date: Wed, 24 Jun 2015 16:45:34 -0700
Message-ID: <558b411e.iJ/14oQlt60GeRRx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40545 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815AbbFXXpf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Jun 2015 19:45:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-fix-mprotect-behaviour-on-vm_locked-vmas-fix
has been removed from the -mm tree.  Its filename was
     mm-fix-mprotect-behaviour-on-vm_locked-vmas-fix.patch

This patch was dropped because it was folded into mm-fix-mprotect-behaviour-on-vm_locked-vmas.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-fix-mprotect-behaviour-on-vm_locked-vmas-fix

tweak comment text

Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/mprotect.c~mm-fix-mprotect-behaviour-on-vm_locked-vmas-fix mm/mprotect.c
--- a/mm/mprotect.c~mm-fix-mprotect-behaviour-on-vm_locked-vmas-fix
+++ a/mm/mprotect.c
@@ -325,7 +325,7 @@ success:
 			  dirty_accountable, 0);
 
 	/*
-	 * Private VM_LOCKED VMA become writable: trigger COW to avoid major
+	 * Private VM_LOCKED VMA becoming writable: trigger COW to avoid major
 	 * fault on access.
 	 */
 	if ((oldflags & (VM_WRITE | VM_SHARED | VM_LOCKED)) == VM_LOCKED &&
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
ocfs2-reduce-object-size-of-mlog-uses.patch
ocfs2-remove-__mlog_cpu_guess.patch
ocfs2-fix-null-pointer-dereference-in-function-ocfs2_abort_trigger.patch
mm-slab_common-support-the-slub_debug-boot-option-on-specific-object-size.patch
mm-fix-mprotect-behaviour-on-vm_locked-vmas.patch
mm-new-mm-hook-framework.patch
mm-memory-failure-introduce-get_hwpoison_page-for-consistent-refcount-handling-fix.patch
rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list-fix.patch
rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list-fix-fix.patch
hugetlb-do-not-account-hugetlb-pages-as-nr_file_pages-fix.patch
mm-do-not-ignore-mapping_gfp_mask-in-page-cache-allocation-paths-checkpatch-fixes.patch


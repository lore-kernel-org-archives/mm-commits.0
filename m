From: akpm@linux-foundation.org
Subject: + mm-fix-mprotect-behaviour-on-vm_locked-vmas-fix.patch added to
 -mm tree
Date: Wed, 22 Apr 2015 15:29:47 -0700
Message-ID: <553820db.iMBf78HwXGmwjpnC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50340 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933097AbbDVW3s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Apr 2015 18:29:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-fix-mprotect-behaviour-on-vm_locked-vmas-fix
has been added to the -mm tree.  Its filename is
     mm-fix-mprotect-behaviour-on-vm_locked-vmas-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-mprotect-behaviour-on-vm_locked-vmas-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-mprotect-behaviour-on-vm_locked-vmas-fix.patch

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
arch-alpha-kernel-systblss-remove-debug-check.patch
revert-zram-move-compact_store-to-sysfs-functions-area.patch
mm.patch
slub-bulk-allocation-from-per-cpu-partial-pages-fix.patch
mm-fix-mprotect-behaviour-on-vm_locked-vmas-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
rtc-omap-add-external-32k-clock-feature-fix.patch
linux-next.patch
linux-next-git-rejects.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch


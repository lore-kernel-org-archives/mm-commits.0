From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-replace-remap_file_pages-syscall-with-emulation-fix.patch removed from
 -mm tree
Date: Tue, 12 Aug 2014 13:35:14 -0700
Message-ID: <53ea7a82.BXd6VxE47n7beLdg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:48807 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754578AbaHLUfP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 16:35:15 -0400
Received: by mail-vc0-f202.google.com with SMTP id hq11so1314658vcb.5
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 13:35:14 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arigo@tunes.org, davej@redhat.com, kirill.shutemov@linux.intel.com, mingo@kernel.org, peterz@infradead.org, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-replace-remap_file_pages-syscall-with-emulation-fix
has been removed from the -mm tree.  Its filename was
     mm-replace-remap_file_pages-syscall-with-emulation-fix.patch

This patch was dropped because it was folded into mm-replace-remap_file_pages-syscall-with-emulation.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-replace-remap_file_pages-syscall-with-emulation-fix

fix spello

Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Armin Rigo <arigo@tunes.org>
Cc: Dave Jones <davej@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/mmap.c~mm-replace-remap_file_pages-syscall-with-emulation-fix mm/mmap.c
--- a/mm/mmap.c~mm-replace-remap_file_pages-syscall-with-emulation-fix
+++ a/mm/mmap.c
@@ -2617,7 +2617,7 @@ SYSCALL_DEFINE5(remap_file_pages, unsign
 	unsigned long populate;
 	unsigned long ret = -EINVAL;
 
-	pr_warn_once("%s (%d) uses depricated remap_file_pages() syscall. "
+	pr_warn_once("%s (%d) uses deprecated remap_file_pages() syscall. "
 			"See Documentation/vm/remap_file_pages.txt.\n",
 			current->comm, current->pid);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
maintainers-akpm-maintenance.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-free-inode-when-i_count-becomes-zero.patch
mm.patch
mm-hugetlb-remove-unused-argument-of-follow_huge_pmdpud.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch


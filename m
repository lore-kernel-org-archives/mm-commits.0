From: akpm@linux-foundation.org
Subject: + mm-page_allocc-unexport-alloc_pages_exact_nid.patch added to
 -mm tree
Date: Tue, 10 Jun 2014 16:04:37 -0700
Message-ID: <53978f05.IUUhj8szyVMELiXu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40810 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568AbaFJXEi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jun 2014 19:04:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, fabf@skynet.be, akpm@linux-foundation.org

Subject: + mm-page_allocc-unexport-alloc_pages_exact_nid.patch added to -mm tree
To: akpm@linux-foundation.org,fabf@skynet.be,rientjes@google.com
From: akpm@linux-foundation.org
Date: Tue, 10 Jun 2014 16:04:37 -0700


The patch titled
     Subject: mm/page_alloc.c: unexport alloc_pages_exact_nid()
has been added to the -mm tree.  Its filename is
     mm-page_allocc-unexport-alloc_pages_exact_nid.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_allocc-unexport-alloc_pages_exact_nid.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_allocc-unexport-alloc_pages_exact_nid.patch

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
Subject: mm/page_alloc.c: unexport alloc_pages_exact_nid()

It is only called by mm/page_cgroup.c whcih cannot be modular.

Reported-by: David Rientjes <rientjes@google.com>
Cc: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/page_alloc.c~mm-page_allocc-unexport-alloc_pages_exact_nid mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_allocc-unexport-alloc_pages_exact_nid
+++ a/mm/page_alloc.c
@@ -2957,7 +2957,6 @@ void * __meminit alloc_pages_exact_nid(i
 		return NULL;
 	return make_alloc_exact((unsigned long)page_address(p), order, size);
 }
-EXPORT_SYMBOL(alloc_pages_exact_nid);
 
 /**
  * free_pages_exact - release memory allocated via alloc_pages_exact()
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
maintainers-akpm-maintenance.patch
cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline.patch
x86-vdso-remove-one-final-use-of-htole16.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch
mm.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range-fix.patch
pagewalk-update-page-table-walker-core-fix.patch
pagemap-redefine-callback-functions-for-page-table-walker-fix.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-page_ioc-work-around-gcc-bug.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
memcg-deprecate-memoryforce_empty-knob-fix.patch
kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fix.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch


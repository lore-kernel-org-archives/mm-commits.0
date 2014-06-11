From: akpm@linux-foundation.org
Subject: +
 list-fix-order-of-arguments-for-hlist_add_after_rcu-checkpatch-fixes.patch
 added to -mm tree
Date: Wed, 11 Jun 2014 14:18:25 -0700
Message-ID: <5398c7a1.++/8pXNBZ6LImtJz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51151 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbaFKVS0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jun 2014 17:18:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, kenhelias@firemail.de, akpm@linux-foundation.org

Subject: + list-fix-order-of-arguments-for-hlist_add_after_rcu-checkpatch-fixes.patch added to -mm tree
To: akpm@linux-foundation.org,kenhelias@firemail.de
From: akpm@linux-foundation.org
Date: Wed, 11 Jun 2014 14:18:25 -0700


The patch titled
     Subject: list-fix-order-of-arguments-for-hlist_add_after_rcu-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     list-fix-order-of-arguments-for-hlist_add_after_rcu-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/list-fix-order-of-arguments-for-hlist_add_after_rcu-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/list-fix-order-of-arguments-for-hlist_add_after_rcu-checkpatch-fixes.patch

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
Subject: list-fix-order-of-arguments-for-hlist_add_after_rcu-checkpatch-fixes

ERROR: code indent should use tabs where possible
#177: FILE: include/linux/rculist.h:453:
+^I^I^I^I        struct hlist_node *prev)$

total: 1 errors, 0 warnings, 0 checks, 151 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

./patches/list-fix-order-of-arguments-for-hlist_add_after_rcu.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Ken Helias <kenhelias@firemail.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rculist.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/rculist.h~list-fix-order-of-arguments-for-hlist_add_after_rcu-checkpatch-fixes include/linux/rculist.h
--- a/include/linux/rculist.h~list-fix-order-of-arguments-for-hlist_add_after_rcu-checkpatch-fixes
+++ a/include/linux/rculist.h
@@ -450,7 +450,7 @@ static inline void hlist_add_before_rcu(
  * problems on Alpha CPUs.
  */
 static inline void hlist_add_behind_rcu(struct hlist_node *n,
-				        struct hlist_node *prev)
+					struct hlist_node *prev)
 {
 	n->next = prev->next;
 	n->pprev = &prev->next;
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
list-fix-order-of-arguments-for-hlist_add_after_rcu-checkpatch-fixes.patch
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


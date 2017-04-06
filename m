From: akpm@linux-foundation.org
Subject: + docs-vm-transhuge-fix-few-trivial-typos-fix.patch added to -mm
 tree
Date: Thu, 06 Apr 2017 14:16:21 -0700
Message-ID: <58e6b025.0z+dpsHnOKHDC5pl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40234 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751922AbdDFVQW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Apr 2017 17:16:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, corbet@lwn.net, rdunlap@infradead.org, sj38.park@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: docs-vm-transhuge-fix-few-trivial-typos-fix
has been added to the -mm tree.  Its filename is
     docs-vm-transhuge-fix-few-trivial-typos-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/docs-vm-transhuge-fix-few-trivial-typos-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/docs-vm-transhuge-fix-few-trivial-typos-fix.patch

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
Subject: docs-vm-transhuge-fix-few-trivial-typos-fix

fixes per Randy

Cc: Jonathan Corbet <corbet@lwn.net>
Cc: SeongJae Park <sj38.park@gmail.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/transhuge.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/vm/transhuge.txt~docs-vm-transhuge-fix-few-trivial-typos-fix Documentation/vm/transhuge.txt
--- a/Documentation/vm/transhuge.txt~docs-vm-transhuge-fix-few-trivial-typos-fix
+++ a/Documentation/vm/transhuge.txt
@@ -520,7 +520,7 @@ comes. Splitting will free up unused sub
 Splitting the page right away is not an option due to locking context in
 the place where we can detect partial unmap. It's also might be
 counterproductive since in many cases partial unmap happens during exit(2) if
-an THP crosses VMA boundary.
+a THP crosses a VMA boundary.
 
 Function deferred_split_huge_page() is used to queue page for splitting.
 The splitting itself will happen when we get memory pressure via shrinker
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
ptrace-fix-ptrace_listen-race-corrupting-task-state-checkpatch-fixes.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-move-madv_free-pages-into-lru_inactive_file-list-checkpatch-fixes.patch
mm-use-is_migrate_highatomic-to-simplify-the-code-fix.patch
mm-introduce-memalloc_nofs_saverestore-api-fix.patch
jbd2-mark-the-transaction-context-with-the-scope-gfp_nofs-context-fix.patch
jbd2-make-the-whole-kjournald2-kthread-nofs-safe-checkpatch-fixes.patch
mm-page_alloc-count-movable-pages-when-stealing-from-pageblock-fix.patch
swap-add-warning-if-swap-slots-cache-failed-to-initialize-fix.patch
checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions-fix.patch
checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions-fix-fix.patch
taskstats-add-e-u-stime-for-tgid-command-fix.patch
taskstats-add-e-u-stime-for-tgid-command-fix-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
fault-inject-support-systematic-fault-injection-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
drm-use-set_memoryh-header-fix.patch
drivers-staging-media-atomisp-pci-atomisp2-use-set_memoryh.patch
docs-vm-transhuge-fix-few-trivial-typos-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch


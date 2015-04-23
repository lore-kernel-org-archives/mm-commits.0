From: akpm@linux-foundation.org
Subject: + ocfs2-remove-__mlog_cpu_guess-fix.patch added to -mm tree
Date: Thu, 23 Apr 2015 15:52:27 -0700
Message-ID: <553977ab.aRtU/OicyM/5TAIK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36324 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754065AbbDWWw2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 Apr 2015 18:52:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jlbec@evilplan.org, joe@perches.com, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2-remove-__mlog_cpu_guess-fix
has been added to the -mm tree.  Its filename is
     ocfs2-remove-__mlog_cpu_guess-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-remove-__mlog_cpu_guess-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-remove-__mlog_cpu_guess-fix.patch

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
Subject: ocfs2-remove-__mlog_cpu_guess-fix

printk warning

Cc: Joe Perches <joe@perches.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/masklog.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ocfs2/cluster/masklog.c~ocfs2-remove-__mlog_cpu_guess-fix fs/ocfs2/cluster/masklog.c
--- a/fs/ocfs2/cluster/masklog.c~ocfs2-remove-__mlog_cpu_guess-fix
+++ a/fs/ocfs2/cluster/masklog.c
@@ -90,7 +90,7 @@ void __mlog_printk(const u64 *mask, cons
 	vaf.fmt = fmt;
 	vaf.va = &args;
 
-	printk("%s(%s,%u,%lu):%s:%d %s%pV",
+	printk("%s(%s,%u,%u):%s:%d %s%pV",
 	       level, current->comm, task_pid_nr(current),
 	       raw_smp_processor_id(), func, line, prefix, &vaf);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
revert-zram-move-compact_store-to-sysfs-functions-area.patch
ocfs2-reduce-object-size-of-mlog-uses-fix.patch
ocfs2-remove-__mlog_cpu_guess.patch
ocfs2-remove-__mlog_cpu_guess-fix.patch
mm.patch
mm-slab_common-support-the-slub_debug-boot-option-on-specific-object-size-fix.patch
slub-bulk-allocation-from-per-cpu-partial-pages-fix.patch
mm-fix-mprotect-behaviour-on-vm_locked-vmas-fix.patch
mm-new-mm-hook-framework.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
rtc-omap-add-external-32k-clock-feature-fix.patch
linux-next.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch


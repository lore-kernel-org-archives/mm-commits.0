From: akpm@linux-foundation.org
Subject: [folded-merged] ocfs2-remove-__mlog_cpu_guess-fix.patch removed
 from -mm tree
Date: Wed, 24 Jun 2015 16:42:46 -0700
Message-ID: <558b4076.ripYcpHt/nf5+yAd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40506 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbbFXXmq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Jun 2015 19:42:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jlbec@evilplan.org, joe@perches.com, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2-remove-__mlog_cpu_guess-fix
has been removed from the -mm tree.  Its filename was
     ocfs2-remove-__mlog_cpu_guess-fix.patch

This patch was dropped because it was folded into ocfs2-remove-__mlog_cpu_guess.patch

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
ocfs2-reduce-object-size-of-mlog-uses.patch
ocfs2-remove-__mlog_cpu_guess.patch
ocfs2-fix-null-pointer-dereference-in-function-ocfs2_abort_trigger-fix.patch
mm-slab_common-support-the-slub_debug-boot-option-on-specific-object-size-fix.patch
mm-fix-mprotect-behaviour-on-vm_locked-vmas-fix.patch
mm-new-mm-hook-framework.patch
mm-memory-failure-introduce-get_hwpoison_page-for-consistent-refcount-handling-fix.patch
rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list-fix.patch
rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list-fix-fix.patch
hugetlb-do-not-account-hugetlb-pages-as-nr_file_pages-fix.patch
mm-do-not-ignore-mapping_gfp_mask-in-page-cache-allocation-paths-checkpatch-fixes.patch


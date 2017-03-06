From: akpm@linux-foundation.org
Subject: + taskstats-add-e-u-stime-for-tgid-command-fix-fix.patch added to -mm tree
Date: Mon, 06 Mar 2017 15:18:51 -0800
Message-ID: <58bdee5b.Bhr07I3Qsuy6sXC7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:32898 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754122AbdCFX0U (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Mar 2017 18:26:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bsingharora@gmail.com, oleg@redhat.com, xiao.zhang@windriver.com, mm-commits@vger.kernel.org


The patch titled
     Subject: taskstats-add-e-u-stime-for-tgid-command-fix-fix
has been added to the -mm tree.  Its filename is
     taskstats-add-e-u-stime-for-tgid-command-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/taskstats-add-e-u-stime-for-tgid-command-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/taskstats-add-e-u-stime-for-tgid-command-fix-fix.patch

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
Subject: taskstats-add-e-u-stime-for-tgid-command-fix-fix

include linux/sched/cputime.h for task_cputime()

Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Zhang Xiao <xiao.zhang@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/taskstats.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/taskstats.c~taskstats-add-e-u-stime-for-tgid-command-fix-fix kernel/taskstats.c
--- a/kernel/taskstats.c~taskstats-add-e-u-stime-for-tgid-command-fix-fix
+++ a/kernel/taskstats.c
@@ -30,6 +30,7 @@
 #include <linux/pid_namespace.h>
 #include <net/genetlink.h>
 #include <linux/atomic.h>
+#include <linux/sched/cputime.h>
 
 /*
  * Maximum length of a cpumask that can be specified in
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-move-madv_free-pages-into-lru_inactive_file-list-checkpatch-fixes.patch
mm-use-is_migrate_highatomic-to-simplify-the-code-fix.patch
mm-introduce-memalloc_nofs_saverestore-api-fix.patch
jbd2-mark-the-transaction-context-with-the-scope-gfp_nofs-context-fix.patch
jbd2-make-the-whole-kjournald2-kthread-nofs-safe-checkpatch-fixes.patch
checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions-fix.patch
checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions-fix-fix.patch
taskstats-add-e-u-stime-for-tgid-command-fix.patch
taskstats-add-e-u-stime-for-tgid-command-fix-fix.patch
linux-next-rejects.patch
treewide-move-set_memory_-functions-away-from-cacheflushh-fix.patch
arm64-use-set_memoryh-header-fix.patch
treewide-decouple-cacheflushh-and-set_memoryh-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch


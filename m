From: akpm@linux-foundation.org
Subject: + gcov-support-gcc-71-v2-checkpatch-fixes.patch added to -mm tree
Date: Mon, 08 May 2017 14:42:10 -0700
Message-ID: <5910e632.5jprD8i993MWdUjO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35098 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751274AbdEHVmM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 May 2017 17:42:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mliska@suse.cz, oberpar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: gcov-support-gcc-71-v2-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     gcov-support-gcc-71-v2-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/gcov-support-gcc-71-v2-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/gcov-support-gcc-71-v2-checkpatch-fixes.patch

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
Subject: gcov-support-gcc-71-v2-checkpatch-fixes

Cc: Martin Liska <mliska@suse.cz>
Cc: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/gcov/base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/gcov/base.c~gcov-support-gcc-71-v2-checkpatch-fixes kernel/gcov/base.c
--- a/kernel/gcov/base.c~gcov-support-gcc-71-v2-checkpatch-fixes
+++ a/kernel/gcov/base.c
@@ -98,7 +98,7 @@ void __gcov_merge_icall_topn(gcov_type *
 }
 EXPORT_SYMBOL(__gcov_merge_icall_topn);
 
-void __gcov_exit (void)
+void __gcov_exit(void)
 {
 	/* Unused. */
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
gcov-support-gcc-71-v2-checkpatch-fixes.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-page_alloc-count-movable-pages-when-stealing-from-pageblock-fix.patch
checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions-fix.patch
checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions-fix-fix.patch
taskstats-add-e-u-stime-for-tgid-command-fix.patch
taskstats-add-e-u-stime-for-tgid-command-fix-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
fault-inject-support-systematic-fault-injection-fix.patch
drm-use-set_memoryh-header-fix.patch
drivers-staging-media-atomisp-pci-atomisp2-use-set_memoryh.patch
docs-vm-transhuge-fix-few-trivial-typos-fix.patch
dax-add-tracepoint-to-dax_writeback_one-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch


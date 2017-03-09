From: akpm@linux-foundation.org
Subject: + drm-use-set_memoryh-header-fix.patch added to -mm tree
Date: Thu, 09 Mar 2017 15:22:34 -0800
Message-ID: <58c1e3ba.+T5CP2yjqysaOQoD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45734 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751013AbdCIXWg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Mar 2017 18:22:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, labbott@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drm-use-set_memoryh-header-fix
has been added to the -mm tree.  Its filename is
     drm-use-set_memoryh-header-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drm-use-set_memoryh-header-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drm-use-set_memoryh-header-fix.patch

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
Subject: drm-use-set_memoryh-header-fix

track drivers/gpu/drm/i915/i915_gem_gtt.c linux-next changes

Cc: Laura Abbott <labbott@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/i915_gem_gtt.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/gpu/drm/i915/i915_gem_gtt.c~drm-use-set_memoryh-header-fix drivers/gpu/drm/i915/i915_gem_gtt.c
--- a/drivers/gpu/drm/i915/i915_gem_gtt.c~drm-use-set_memoryh-header-fix
+++ a/drivers/gpu/drm/i915/i915_gem_gtt.c
@@ -31,6 +31,8 @@
 #include <linux/seq_file.h>
 #include <linux/stop_machine.h>
 
+#include <asm/set_memory.h>
+
 #include <drm/drmP.h>
 #include <drm/i915_drm.h>
 
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
drm-use-set_memoryh-header-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch


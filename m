From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 ipc-utilc-sysvipc_find_ipc-incorrectly-updates-position-index-fix.patch
 added to -mm tree
Date: Fri, 08 May 2020 13:46:53 -0700
Message-ID: <20200508204653.vUfFWDJl2%akpm@linux-foundation.org>
References: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726817AbgEHUqz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 8 May 2020 16:46:55 -0400
In-Reply-To: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dave@stgolabs.net, longman@redhat.com, manfred@colorfullife.com, mingo@redhat.com, mm-commits@vger.kernel.org, neilb@suse.com, oberpar@linux.ibm.com, rostedt@goodmis.org, schwab@suse.de, vvs@virtuozzo.com


The patch titled
     Subject: ipc-utilc-sysvipc_find_ipc-incorrectly-updates-position-index-fix
has been added to the -mm tree.  Its filename is
     ipc-utilc-sysvipc_find_ipc-incorrectly-updates-position-index-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-utilc-sysvipc_find_ipc-incorrectly-updates-position-index-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-utilc-sysvipc_find_ipc-incorrectly-updates-position-index-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ipc-utilc-sysvipc_find_ipc-incorrectly-updates-position-index-fix

fix conflict resolution fix

Cc: Andreas Schwab <schwab@suse.de>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: NeilBrown <neilb@suse.com>
Cc: Peter Oberparleiter <oberpar@linux.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Vasily Averin <vvs@virtuozzo.com>
Cc: Waiman Long <longman@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/util.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/ipc/util.c~ipc-utilc-sysvipc_find_ipc-incorrectly-updates-position-index-fix
+++ a/ipc/util.c
@@ -777,7 +777,7 @@ static struct kern_ipc_perm *sysvipc_fin
 		}
 	}
 out:
-	*new_pos = pos + 1;
+	*new_pos = index + 1;
 	return ipc;
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

ipc-utilc-sysvipc_find_ipc-incorrectly-updates-position-index-fix.patch
squashfs-migrate-from-ll_rw_block-usage-to-bio-fix.patch
drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
mm-slub-fix-corrupted-freechain-in-deactivate_slab-fix.patch
mm-slub-add-panic_on_error-to-the-debug-facilities-fix.patch
mm-gupc-updating-the-documentation-fix.patch
mm-swapfilec-classify-swap_map_xxx-to-make-it-more-readable-fix.patch
mm-remove-__vmalloc_node_flags_caller-fix.patch
mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node-fix.patch
mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node-fix-fix.patch
mm-remove-vmalloc_user_node_flags-fix.patch
arch-kunmap-remove-duplicate-kunmap-implementations-fix.patch
arch-kmap_atomic-consolidate-duplicate-code-checkpatch-fixes.patch
arch-kunmap_atomic-consolidate-duplicate-code-checkpatch-fixes.patch
kmap-consolidate-kmap_prot-definitions-checkpatch-fixes.patch
mm-add-debug_wx-support-fixpatch-added-to-mm-tree.patch
riscv-support-debug_wx-fix.patch
mm-replace-zero-length-array-with-flexible-array-member-fix.patch
mm-hugetlb-fix-a-typo-in-comment-manitained-maintained-v2-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
arch-x86-makefile-use-config_shell.patch
kernel-forkc-export-kernel_thread-to-modules.patch

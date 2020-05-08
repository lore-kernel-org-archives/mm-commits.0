From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 =?US-ASCII?Q?doc-cgroup-update-note-about-conditions-when-oom-killer-is-i?=
 =?US-ASCII?Q?nvoked-fix.patch?= added to -mm tree
Date: Fri, 08 May 2020 16:43:25 -0700
Message-ID: <20200508234325.10AGN1YBq%akpm@linux-foundation.org>
References: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728051AbgEHXn0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 8 May 2020 19:43:26 -0400
In-Reply-To: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, guro@fb.com, khlebnikov@yandex-team.ru, mhocko@suse.com, mm-commits@vger.kernel.org, rdunlap@infradead.org


The patch titled
     Subject: doc-cgroup-update-note-about-conditions-when-oom-killer-is-invoked-fix
has been added to the -mm tree.  Its filename is
     doc-cgroup-update-note-about-conditions-when-oom-killer-is-invoked-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/doc-cgroup-update-note-about-conditions-when-oom-killer-is-invoked-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/doc-cgroup-update-note-about-conditions-when-oom-killer-is-invoked-fix.patch

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
Subject: doc-cgroup-update-note-about-conditions-when-oom-killer-is-invoked-fix

fixes per Randy

Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Roman Gushchin <guro@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v2.rst |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/cgroup-v2.rst~doc-cgroup-update-note-about-conditions-when-oom-killer-is-invoked-fix
+++ a/Documentation/admin-guide/cgroup-v2.rst
@@ -1172,8 +1172,8 @@ PAGE_SIZE multiple when read back.
 	Under certain circumstances, the usage may go over the limit
 	temporarily.
 
-	In default configuration regular 0-order allocation always
-	succeed unless OOM killer choose current task as a victim.
+	In default configuration regular 0-order allocations always
+	succeed unless OOM killer chooses current task as a victim.
 
 	Some kinds of allocations don't invoke the OOM killer.
 	Caller could retry them differently, return into userspace
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
doc-cgroup-update-note-about-conditions-when-oom-killer-is-invoked-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

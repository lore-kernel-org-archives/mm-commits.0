From: akpm@linux-foundation.org
Subject: [folded-merged]
 prctl-remove-one-shot-limitation-for-changing-exe-link-fix.patch removed
 from -mm tree
Date: Mon, 12 Dec 2016 16:20:50 -0800
Message-ID: <584f3ee2.d1uG/GL17o8lbOq0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37122 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752707AbcLMAUH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2016 19:20:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ebiederm@xmission.com, gorcunov@openvz.org, john.stultz@linaro.org, keescook@chromium.org, luto@amacapital.net, matthltc@us.ibm.com, mhocko@suse.com, mingo@redhat.com, oleg@redhat.com, peterz@infradead.org, skinsbursky@virtuozzo.com, vbabka@suse.cz, xemul@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: prctl-remove-one-shot-limitation-for-changing-exe-link-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     prctl-remove-one-shot-limitation-for-changing-exe-link-fix.patch

This patch was dropped because it was folded into prctl-remove-one-shot-limitation-for-changing-exe-link.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: prctl-remove-one-shot-limitation-for-changing-exe-link-checkpatch-fixes

fix up comment

Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Matt Helsley <matthltc@us.ibm.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Pavel Emelyanov <xemul@virtuozzo.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stanislav Kinsburskiy <skinsbursky@virtuozzo.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN include/linux/sched.h~prctl-remove-one-shot-limitation-for-changing-exe-link-fix include/linux/sched.h
--- a/include/linux/sched.h~prctl-remove-one-shot-limitation-for-changing-exe-link-fix
+++ a/include/linux/sched.h
@@ -520,8 +520,10 @@ static inline int get_dumpable(struct mm
 					/* leave room for more dump flags */
 #define MMF_VM_MERGEABLE	16	/* KSM may merge identical pages */
 #define MMF_VM_HUGEPAGE		17	/* set when VM_HUGEPAGE is set on vma */
-/* This ine-shot flag is droped due to necessivity of changing exe once again
- * on NFS restore */
+/*
+ * This one-shot flag is dropped due to necessity of changing exe once again
+ * on NFS restore
+ */
 //#define MMF_EXE_FILE_CHANGED	18	/* see prctl_set_mm_exe_file() */
 
 #define MMF_HAS_UPROBES		19	/* has uprobes */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

prctl-remove-one-shot-limitation-for-changing-exe-link.patch
mm-mempolicy-clean-up-__gfp_thisnode-confusion-in-policy_zonelist-checkpatch-fixes.patch
mm-disable-numa-migration-faults-for-dax-vmas-fix.patch
filemap-add-comment-for-confusing-logic-in-page_cache_tree_insert-fix.patch
include-linux-backing-dev-defsh-shrink-struct-backing_dev_info.patch
mm-add-vfree_atomic-fix-fix.patch
mm-thp-page-cache-support-for-ppc64-fix.patch
mm-rmap-handle-anon_vma_prepare-common-case-inline-checkpatch-fixes.patch
scripts-checkpatchpl-fix-spelling.patch
init-reduce-rootwait-polling-interval-time-to-5ms-fix.patch


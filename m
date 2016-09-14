From: akpm@linux-foundation.org
Subject: +
 mm-memcontrol-consolidate-cgroup-socket-tracking-checkpatch-fixes.patch
 added to -mm tree
Date: Wed, 14 Sep 2016 13:42:58 -0700
Message-ID: <57d9b652.8I1eteXdVxTM516k%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41062 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756664AbcINUm7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Sep 2016 16:42:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memcontrol-consolidate-cgroup-socket-tracking-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     mm-memcontrol-consolidate-cgroup-socket-tracking-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-consolidate-cgroup-socket-tracking-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-consolidate-cgroup-socket-tracking-checkpatch-fixes.patch

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
Subject: mm-memcontrol-consolidate-cgroup-socket-tracking-checkpatch-fixes

WARNING: line over 80 characters
#49: FILE: mm/memcontrol.c:2942:
+		 * function is the last one to run. See mem_cgroup_sk_alloc() for

total: 0 errors, 1 warnings, 0 checks, 105 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/mm-memcontrol-consolidate-cgroup-socket-tracking.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-consolidate-cgroup-socket-tracking-checkpatch-fixes mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-consolidate-cgroup-socket-tracking-checkpatch-fixes
+++ a/mm/memcontrol.c
@@ -2939,9 +2939,9 @@ static int memcg_update_tcp_limit(struct
 		/*
 		 * The active flag needs to be written after the static_key
 		 * update. This is what guarantees that the socket activation
-		 * function is the last one to run. See mem_cgroup_sk_alloc() for
-		 * details, and note that we don't mark any socket as belonging
-		 * to this memcg until that flag is up.
+		 * function is the last one to run. See mem_cgroup_sk_alloc()
+		 * for details, and note that we don't mark any socket as
+		 * belonging to this memcg until that flag is up.
 		 *
 		 * We need to do this, because static_keys will span multiple
 		 * sites, but we can't control their order. If we mark a socket
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-vmalloc-fix-align-value-calculation-error-fix.patch
mm-vmalloc-fix-align-value-calculation-error-v2-fix.patch
mm-vmalloc-fix-align-value-calculation-error-v2-fix-fix.patch
mm-compaction-make-whole_zone-flag-ignore-cached-scanner-positions-checkpatch-fixes.patch
mm-swap-add-swap_cluster_list-checkpatch-fixes.patch
mm-mlock-check-against-vma-for-actual-mlock-size-fix.patch
mm-page_ioc-replace-some-bug_ons-with-vm_bug_on_page.patch
fs-use-mapping_set_error-instead-of-opencoded-set_bit-fix.patch
mm-memcontrol-consolidate-cgroup-socket-tracking-checkpatch-fixes.patch
seq-proc-modify-seq_put_decimal_ll-to-take-a-const-char-not-char-fix.patch
lib-bitmapc-enhance-bitmap-syntax-fix.patch
relay-use-irq_work-instead-of-plain-timer-for-deferred-wakeup-checkpatch-fixes.patch
ipc-msg-avoid-waking-sender-upon-full-queue-checkpatch-fixes.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
include-linux-mlx5-deviceh-kill-build_bug_ons.patch
hung_task-allow-hung_task_panic-when-hung_task_warnings-is-0-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch


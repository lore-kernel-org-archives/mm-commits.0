From: akpm@linux-foundation.org
Subject: + mm-oom_reaper-report-success-failure-fix-fix.patch added to -mm tree
Date: Wed, 09 Mar 2016 13:18:55 -0800
Message-ID: <56e0933f.wYCJJ1/dClYoKzxp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55437 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934101AbcCIVS4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Mar 2016 16:18:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-oom_reaper-report-success-failure-fix-fix
has been added to the -mm tree.  Its filename is
     mm-oom_reaper-report-success-failure-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-oom_reaper-report-success-failure-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-oom_reaper-report-success-failure-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm-oom_reaper-report-success-failure-fix-fix

typo fix

Signed-off-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/oom_kill.c~mm-oom_reaper-report-success-failure-fix-fix mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom_reaper-report-success-failure-fix-fix
+++ a/mm/oom_kill.c
@@ -481,7 +481,7 @@ static bool __oom_reap_task(struct task_
 		}
 	}
 	tlb_finish_mmu(&tlb, 0, -1);
-	pr_info("oom_reaper: reaped process %d (%s), now anon-rss:%lukB, file-rss:%lukB, shmem-rss:%lulB\n",
+	pr_info("oom_reaper: reaped process %d (%s), now anon-rss:%lukB, file-rss:%lukB, shmem-rss:%lukB\n",
 			task_pid_nr(tsk), tsk->comm,
 			K(get_mm_counter(mm, MM_ANONPAGES)),
 			K(get_mm_counter(mm, MM_FILEPAGES)),
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-vmscan-make-zone_reclaimable_pages-more-precise.patch
mm-oom-introduce-oom-reaper.patch
oom-reaper-handle-mlocked-pages.patch
oom-clear-tif_memdie-after-oom_reaper-managed-to-unmap-the-address-space.patch
mm-oom_reaper-report-success-failure.patch
mm-oom_reaper-report-success-failure-fix-2.patch
mm-oom_reaper-report-success-failure-fix-fix.patch
mm-oom_reaper-implement-oom-victims-queuing.patch
oom-make-oom_reaper-freezable.patch
oom-oom_reaper-disable-oom_reaper-for-oom_kill_allocating_task.patch
mm-remove-__gfp_nofail-is-deprecated-comment.patch
mm-oom-rework-oom-detection.patch
mm-throttle-on-io-only-when-there-are-too-many-dirty-and-writeback-pages.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations.patch


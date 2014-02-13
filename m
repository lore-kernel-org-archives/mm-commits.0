From: akpm@linux-foundation.org
Subject: + linux-next-rejects.patch added to -mm tree
Date: Thu, 13 Feb 2014 12:59:52 -0800
Message-ID: <52fd3248./KYJ7aBB2xyTzUoa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35966 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbaBMU7x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Feb 2014 15:59:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, akpm@linux-foundation.org

Subject: + linux-next-rejects.patch added to -mm tree
To: akpm@linux-foundation.org
From: akpm@linux-foundation.org
Date: Thu, 13 Feb 2014 12:59:52 -0800


The patch titled
     Subject: linux-next-rejects
has been added to the -mm tree.  Its filename is
     linux-next-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-rejects.patch

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
Subject: linux-next-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff -puN mm/memcontrol.c~linux-next-rejects mm/memcontrol.c
--- a/mm/memcontrol.c~linux-next-rejects
+++ a/mm/memcontrol.c
@@ -1683,15 +1683,8 @@ static void move_unlock_mem_cgroup(struc
  */
 void mem_cgroup_print_oom_info(struct mem_cgroup *memcg, struct task_struct *p)
 {
-	/*
-	 * protects memcg_name and makes sure that parallel ooms do not
-	 * interleave
-	 */
+	/* oom_info_lock ensures that parallel ooms do not interleave */
 	static DEFINE_MUTEX(oom_info_lock);
-	struct cgroup *task_cgrp;
-	struct cgroup *mem_cgrp;
-	static char memcg_name[PATH_MAX];
-	int ret;
 	struct mem_cgroup *iter;
 	unsigned int i;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
jffs2-avoid-soft-lockup-in-jffs2_reserve_space_gc.patch
mm.patch
mm-hugetlb-improve-page-fault-scalability-fix.patch
mm-vmstat-fix-up-zone-state-accounting-fix.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix.patch
drop_caches-add-some-documentation-and-info-message.patch
include-linux-syscallsh-add-sys32_quotactl-prototype-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix.patch
kernel-panicc-display-reason-at-end-pr_emerg-fix.patch
linux-next.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
drivers-spi-spic-fix-max-warning.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch


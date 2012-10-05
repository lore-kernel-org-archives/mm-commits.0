From: akpm@linux-foundation.org
Subject: [merged] sections-fix-section-conflicts-in-arch-score.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:12:32 -0700
Message-ID: <20121005201233.1DA5420004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:57713 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932567Ab2JEUMf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:12:35 -0400
Received: by mail-we0-f202.google.com with SMTP id x43so139507wey.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:12:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, lennox.wu@gmail.com, liqin.chen@sunplusct.com, mm-commits@vger.kernel.org


The patch titled
     Subject: sections: fix section conflicts in arch/score
has been removed from the -mm tree.  Its filename was
     sections-fix-section-conflicts-in-arch-score.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andi Kleen <ak@linux.intel.com>
Subject: sections: fix section conflicts in arch/score

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Chen Liqin <liqin.chen@sunplusct.com>
Cc: Lennox Wu <lennox.wu@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/score/kernel/sys_score.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/score/kernel/sys_score.c~sections-fix-section-conflicts-in-arch-score arch/score/kernel/sys_score.c
--- a/arch/score/kernel/sys_score.c~sections-fix-section-conflicts-in-arch-score
+++ a/arch/score/kernel/sys_score.c
@@ -112,6 +112,7 @@ score_execve(struct pt_regs *regs)
  * Do a system call from kernel instead of calling sys_execve so we
  * end up with proper pt_regs.
  */
+asmlinkage
 int kernel_execve(const char *filename,
 		  const char *const argv[],
 		  const char *const envp[])
_

Patches currently in -mm which might be from ak@linux.intel.com are

origin.patch
linux-next.patch
thp-x86-introduce-have_arch_transparent_hugepage.patch
thp-remove-assumptions-on-pgtable_t-type.patch
thp-introduce-pmdp_invalidate.patch
thp-make-madv_hugepage-check-for-mm-def_flags.patch
thp-s390-thp-splitting-backend-for-s390.patch
thp-s390-thp-pagetable-pre-allocation-for-s390.patch
thp-s390-disable-thp-for-kvm-host-on-s390.patch
thp-s390-architecture-backend-for-thp-on-s390.patch


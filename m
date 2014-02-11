From: akpm@linux-foundation.org
Subject: + include-linux-syscallsh-add-sys32_quotactl-prototype-fix.patch
 added to -mm tree
Date: Tue, 11 Feb 2014 14:44:41 -0800
Message-ID: <52faa7d9.gy8Ey8NK7IgZYT8D%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41946 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065AbaBKWom (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Feb 2014 17:44:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rashika.kheria@gmail.com, akpm@linux-foundation.org

Subject: + include-linux-syscallsh-add-sys32_quotactl-prototype-fix.patch added to -mm tree
To: akpm@linux-foundation.org,rashika.kheria@gmail.com
From: akpm@linux-foundation.org
Date: Tue, 11 Feb 2014 14:44:41 -0800


The patch titled
     Subject: include-linux-syscallsh-add-sys32_quotactl-prototype-fix
has been added to the -mm tree.  Its filename is
     include-linux-syscallsh-add-sys32_quotactl-prototype-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/include-linux-syscallsh-add-sys32_quotactl-prototype-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/include-linux-syscallsh-add-sys32_quotactl-prototype-fix.patch

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
Subject: include-linux-syscallsh-add-sys32_quotactl-prototype-fix

Cc: Rashika Kheria <rashika.kheria@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/syscalls.h |    3 ---
 1 file changed, 3 deletions(-)

diff -puN include/linux/syscalls.h~include-linux-syscallsh-add-sys32_quotactl-prototype-fix include/linux/syscalls.h
--- a/include/linux/syscalls.h~include-linux-syscallsh-add-sys32_quotactl-prototype-fix
+++ a/include/linux/syscalls.h
@@ -198,11 +198,8 @@ extern struct trace_event_functions exit
 	}								\
 	static inline long SYSC##name(__MAP(x,__SC_DECL,__VA_ARGS__))
 
-#ifdef CONFIG_QUOTACTL_COMPAT
 asmlinkage long sys32_quotactl(unsigned int cmd, const char __user *special,
 			       qid_t id, void __user *addr);
-#endif
-
 asmlinkage long sys_time(time_t __user *tloc);
 asmlinkage long sys_stime(time_t __user *tptr);
 asmlinkage long sys_gettimeofday(struct timeval __user *tv,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
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
linux-next.patch
linux-next-git-rejects.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch


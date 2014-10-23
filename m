From: akpm@linux-foundation.org
Subject: + lib-show_mem-this-patch-adds-cma-reserved-infromation-fix.patch added to -mm tree
Date: Thu, 23 Oct 2014 12:57:47 -0700
Message-ID: <54495dbb.AjO+gMPjAxw/X5Ys%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45723 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137AbaJWT5x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 Oct 2014 15:57:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com, liwanp@linux.vnet.ibm.com, mgorman@suse.de, pintu.k@samsung.com, qiuxishi@huawei.com, rientjes@google.com, vishnu.ps@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib-show_mem-this-patch-adds-cma-reserved-infromation-fix
has been added to the -mm tree.  Its filename is
     lib-show_mem-this-patch-adds-cma-reserved-infromation-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-show_mem-this-patch-adds-cma-reserved-infromation-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-show_mem-this-patch-adds-cma-reserved-infromation-fix.patch

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
Subject: lib-show_mem-this-patch-adds-cma-reserved-infromation-fix

remove hopefully-unneeded ifdefs

Cc: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Pintu Kumar <pintu.k@samsung.com>
Cc: Vishnu Pratap Singh <vishnu.ps@samsung.com>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/show_mem.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN lib/show_mem.c~lib-show_mem-this-patch-adds-cma-reserved-infromation-fix lib/show_mem.c
--- a/lib/show_mem.c~lib-show_mem-this-patch-adds-cma-reserved-infromation-fix
+++ a/lib/show_mem.c
@@ -8,9 +8,7 @@
 #include <linux/mm.h>
 #include <linux/nmi.h>
 #include <linux/quicklist.h>
-#ifdef CONFIG_CMA
 #include <linux/cma.h>
-#endif
 
 void show_mem(unsigned int filter)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
rtc-pm8xxx-rework-to-support-pm8941-rtc-checkpatch-fixes.patch
rtc-pm8xxx-rework-to-support-pm8941-rtc-fix.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper-checkpatch-fixes.patch
ocfs2-free-inode-when-i_count-becomes-zero.patch
ocfs2-add-and-remove-inode-in-orphan-dir-in-ocfs2_direct_io-fix.patch
ocfs2-do-not-fallback-to-buffer-i-o-write-if-fill-holes-checkpatch-fixes.patch
mm.patch
mm-memcontrol-lockless-page-counters-fix.patch
mm-memcontrol-lockless-page-counters-fix-fix.patch
kernel-res_counter-remove-the-unused-api-fix.patch
mm-compaction-simplify-deferred-compaction-fix.patch
mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag-fix.patch
mm-memcontrol-fold-mem_cgroup_start_move-mem_cgroup_end_move-fix.patch
lib-show_mem-this-patch-adds-cma-reserved-infromation-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
fs-proc-use-a-rb-tree-for-the-directory-entries-fix.patch
init-allow-config_init_fallback=n-to-disable-defaults-if-init=-fails-checkpatch-fixes.patch
sysctl-terminate-strings-also-on-r-fix.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix-fix.patch
ipc-msg-increase-msgmni-remove-scaling-checkpatch-fixes.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
debugging-keep-track-of-page-owners.patch
debugging-keep-track-of-page-owners-fix.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch


From: akpm@linux-foundation.org
Subject: [folded-merged]
 lib-show_mem-this-patch-adds-cma-reserved-infromation-fix.patch removed
 from -mm tree
Date: Mon, 15 Dec 2014 15:29:04 -0800
Message-ID: <548f6ec0.SzEwirpsM85UKbns%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43939 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbaLOX3F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 15 Dec 2014 18:29:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com, mgorman@suse.de, pintu.k@samsung.com, qiuxishi@huawei.com, rientjes@google.com, vishnu.ps@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib-show_mem-this-patch-adds-cma-reserved-infromation-fix
has been removed from the -mm tree.  Its filename was
     lib-show_mem-this-patch-adds-cma-reserved-infromation-fix.patch

This patch was dropped because it was folded into lib-show_mem-this-patch-adds-cma-reserved-infromation.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib-show_mem-this-patch-adds-cma-reserved-infromation-fix

remove hopefully-unneeded ifdefs

Cc: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Pintu Kumar <pintu.k@samsung.com>
Cc: Vishnu Pratap Singh <vishnu.ps@samsung.com>
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
lib-show_mem-this-patch-adds-cma-reserved-infromation.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper.patch
ocfs2-free-inode-when-i_count-becomes-zero.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir.patch
mm.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
sysctl-terminate-strings-also-on-r-fix.patch
linux-next.patch
linux-next-git-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
tools-testing-selftests-makefile-alphasort-the-targets-list.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch


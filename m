From: akpm@linux-foundation.org
Subject: [folded-merged]
 watchdog-introduce-watchdog_suspend-and-watchdog_resume-fix.patch removed
 from -mm tree
Date: Fri, 04 Sep 2015 15:26:24 -0700
Message-ID: <55ea1a90.zbiu1A99jQCmCF6N%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53643 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760264AbbIDW0Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Sep 2015 18:26:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, uobergfe@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog-introduce-watchdog_suspend-and-watchdog_resume-fix
has been removed from the -mm tree.  Its filename was
     watchdog-introduce-watchdog_suspend-and-watchdog_resume-fix.patch

This patch was dropped because it was folded into watchdog-introduce-watchdog_suspend-and-watchdog_resume.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: watchdog-introduce-watchdog_suspend-and-watchdog_resume-fix

remove unneeded static initialization

Cc: Ulrich Obergfell <uobergfe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/watchdog.c~watchdog-introduce-watchdog_suspend-and-watchdog_resume-fix kernel/watchdog.c
--- a/kernel/watchdog.c~watchdog-introduce-watchdog_suspend-and-watchdog_resume-fix
+++ a/kernel/watchdog.c
@@ -67,7 +67,7 @@ unsigned long *watchdog_cpumask_bits = c
 #define for_each_watchdog_cpu(cpu) \
 	for_each_cpu_and((cpu), cpu_online_mask, &watchdog_cpumask)
 
-static int __read_mostly watchdog_suspended = 0;
+static int __read_mostly watchdog_suspended;
 static int __read_mostly watchdog_running;
 static u64 __read_mostly sample_period;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kernel-kthreadc-kthread_create_on_node-clarify-documentation.patch
watchdog-introduce-watchdog_suspend-and-watchdog_resume.patch
watchdog-use-suspend-resume-interface-in-fixup_ht_bug-fix.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2-fix.patch
userfaultfd-activate-syscall-fix-2.patch
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic-fix.patch
genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create-fix.patch
genalloc-add-support-of-multiple-gen_pools-per-device-fix.patch
mm-make-gup-handle-pfn-mapping-unless-foll_get-is-requested-fix.patch


From: akpm@linux-foundation.org
Subject: - oom-print-points-as-unsigned-long.patch removed from -mm tree
Date: Tue, 31 Jul 2007 16:54:48 -0700
Message-ID: <200707312354.l6VNsmWe029176@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37966 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756538AbXGaXzb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 19:55:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     oom: print points as unsigned long
has been removed from the -mm tree.  Its filename was
     oom-print-points-as-unsigned-long.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: oom: print points as unsigned long
From: David Rientjes <rientjes@google.com>

In badness(), the automatic variable 'points' is unsigned long.  Print it
as such.

Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/oom_kill.c~oom-print-points-as-unsigned-long mm/oom_kill.c
--- a/mm/oom_kill.c~oom-print-points-as-unsigned-long
+++ a/mm/oom_kill.c
@@ -157,7 +157,7 @@ unsigned long badness(struct task_struct
 	}
 
 #ifdef DEBUG
-	printk(KERN_DEBUG "OOMkill: task %d (%s) got %d points\n",
+	printk(KERN_DEBUG "OOMkill: task %d (%s) got %lu points\n",
 	p->pid, p->comm, points);
 #endif
 	return points;
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
x86_64-clean-up-apicid_to_node-declaration.patch
maps2-uninline-some-functions-in-the-page-walker.patch
maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
maps2-remove-vma-from-args-in-the-page-walker.patch
maps2-propagate-errors-from-callback-in-page-walker.patch
maps2-add-callbacks-for-each-level-to-page-walker.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-kpagemap-interface.patch

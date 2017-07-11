From: akpm@linux-foundation.org
Subject: [merged] obsoleted-comment-in-show_map_vma.patch removed
 from -mm tree
Date: Tue, 11 Jul 2017 12:24:33 -0700
Message-ID: <20170711192433.tSIg62b-g%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47932 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933703AbdGKTYe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jul 2017 15:24:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, mm-commits@vger.kernel.org, vvs@virtuozzo.com


The patch titled
     Subject: fs/proc/task_mmu.c: remove obsolete comment in show_map_vma()
has been removed from the -mm tree.  Its filename was
     obsoleted-comment-in-show_map_vma.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vasily Averin <vvs@virtuozzo.com>
Subject: fs/proc/task_mmu.c: remove obsolete comment in show_map_vma()

After 1be7107 ("mm: larger stack guard gap, between vmas") we do not hide
stack guard page in /proc/<pid>/maps

Link: http://lkml.kernel.org/r/211f3c2a-f7ef-7c13-82bf-46fd426f6e1b@virtuozzo.com
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/proc/task_mmu.c~obsoleted-comment-in-show_map_vma fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~obsoleted-comment-in-show_map_vma
+++ a/fs/proc/task_mmu.c
@@ -298,7 +298,6 @@ show_map_vma(struct seq_file *m, struct
 		pgoff = ((loff_t)vma->vm_pgoff) << PAGE_SHIFT;
 	}
 
-	/* We don't show the stack guard page in /proc/maps */
 	start = vma->vm_start;
 	end = vma->vm_end;
 
_

Patches currently in -mm which might be from vvs@virtuozzo.com are



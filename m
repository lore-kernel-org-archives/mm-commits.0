From: akpm@linux-foundation.org
Subject: + obsoleted-comment-in-show_map_vma.patch added to -mm tree
Date: Fri, 23 Jun 2017 13:07:55 -0700
Message-ID: <594d751b.CaTuyrQcTrX222qr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44838 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754851AbdFWUH4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 23 Jun 2017 16:07:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vvs@virtuozzo.com, hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/task_mmu.c: remove obsolete comment in show_map_vma()
has been added to the -mm tree.  Its filename is
     obsoleted-comment-in-show_map_vma.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/obsoleted-comment-in-show_map_vma.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/obsoleted-comment-in-show_map_vma.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

obsoleted-comment-in-show_map_vma.patch


From: akpm@linux-foundation.org
Subject: + fs-proc-meminfo-meminfo_proc_show-fix-typo-in-comment.patch
 added to -mm tree
Date: Tue, 18 Feb 2014 14:12:51 -0800
Message-ID: <5303dae3.SDuMXfORjr2YiFOi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50401 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264AbaBRWMv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Feb 2014 17:12:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, lcapitulino@redhat.com

Subject: + fs-proc-meminfo-meminfo_proc_show-fix-typo-in-comment.patch added to -mm tree
To: lcapitulino@redhat.com
From: akpm@linux-foundation.org
Date: Tue, 18 Feb 2014 14:12:51 -0800


The patch titled
     Subject: fs/proc/meminfo: meminfo_proc_show(): fix typo in comment
has been added to the -mm tree.  Its filename is
     fs-proc-meminfo-meminfo_proc_show-fix-typo-in-comment.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-proc-meminfo-meminfo_proc_show-fix-typo-in-comment.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-proc-meminfo-meminfo_proc_show-fix-typo-in-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Luiz Capitulino <lcapitulino@redhat.com>
Subject: fs/proc/meminfo: meminfo_proc_show(): fix typo in comment

It should read "reclaimable slab" and not "reclaimable swap".

Signed-off-by: Luiz Capitulino <lcapitulino@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/meminfo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/meminfo.c~fs-proc-meminfo-meminfo_proc_show-fix-typo-in-comment fs/proc/meminfo.c
--- a/fs/proc/meminfo.c~fs-proc-meminfo-meminfo_proc_show-fix-typo-in-comment
+++ a/fs/proc/meminfo.c
@@ -73,7 +73,7 @@ static int meminfo_proc_show(struct seq_
 	available += pagecache;
 
 	/*
-	 * Part of the reclaimable swap consists of items that are in use,
+	 * Part of the reclaimable slab consists of items that are in use,
 	 * and cannot be freed. Cap this estimate at the low watermark.
 	 */
 	available += global_page_state(NR_SLAB_RECLAIMABLE) -
_

Patches currently in -mm which might be from lcapitulino@redhat.com are

fs-proc-meminfo-meminfo_proc_show-fix-typo-in-comment.patch


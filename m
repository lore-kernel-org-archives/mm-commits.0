From: akpm@linux-foundation.org
Subject: [merged]
 fs-proc-meminfo-meminfo_proc_show-fix-typo-in-comment.patch removed from
 -mm tree
Date: Tue, 08 Apr 2014 14:16:16 -0700
Message-ID: <53446720.9tZGyj3oJaUcCH7x%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56885 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756627AbaDHVQR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 17:16:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, aquini@redhat.com, lcapitulino@redhat.com

Subject: [merged] fs-proc-meminfo-meminfo_proc_show-fix-typo-in-comment.patch removed from -mm tree
To: lcapitulino@redhat.com,aquini@redhat.com,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 14:16:16 -0700


The patch titled
     Subject: fs/proc/meminfo: meminfo_proc_show(): fix typo in comment
has been removed from the -mm tree.  Its filename was
     fs-proc-meminfo-meminfo_proc_show-fix-typo-in-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Luiz Capitulino <lcapitulino@redhat.com>
Subject: fs/proc/meminfo: meminfo_proc_show(): fix typo in comment

It should read "reclaimable slab" and not "reclaimable swap".

Signed-off-by: Luiz Capitulino <lcapitulino@redhat.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Acked-by: Rafael Aquini <aquini@redhat.com>
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

origin.patch


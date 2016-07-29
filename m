From: akpm@linux-foundation.org
Subject: [merged] mm-zsmalloc-add-__init__exit-attribute.patch removed
 from -mm tree
Date: Fri, 29 Jul 2016 11:56:22 -0700
Message-ID: <579ba6d6.oOx51merHP0rWs3J%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37565 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305AbcG2S4X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2016 14:56:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: opensource.ganesh@gmail.com, minchan@kernel.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zsmalloc: add __init,__exit attribute
has been removed from the -mm tree.  Its filename was
     mm-zsmalloc-add-__init__exit-attribute.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ganesh Mahendran <opensource.ganesh@gmail.com>
Subject: mm/zsmalloc: add __init,__exit attribute

Add __init,__exit attribute for function that only called in
module init/exit to save memory.

Link: http://lkml.kernel.org/r/1467882338-4300-6-git-send-email-opensource.ganesh@gmail.com
Signed-off-by: Ganesh Mahendran <opensource.ganesh@gmail.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/zsmalloc.c~mm-zsmalloc-add-__init__exit-attribute mm/zsmalloc.c
--- a/mm/zsmalloc.c~mm-zsmalloc-add-__init__exit-attribute
+++ a/mm/zsmalloc.c
@@ -1341,7 +1341,7 @@ static void zs_unregister_cpu_notifier(v
 	cpu_notifier_register_done();
 }
 
-static void init_zs_size_classes(void)
+static void __init init_zs_size_classes(void)
 {
 	int nr;
 
_

Patches currently in -mm which might be from opensource.ganesh@gmail.com are

mm-zsmalloc-add-trace-events-for-zs_compact.patch
mm-zsmalloc-add-per-class-compact-trace-event.patch


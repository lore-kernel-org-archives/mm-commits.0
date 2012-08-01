From: akpm@linux-foundation.org
Subject: [merged] mm-memcg-complete-documentation-for-tcp-memcg-files.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:14:30 -0700
Message-ID: <20120801201430.A3EF5100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:52099 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755945Ab2HAUOb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:14:31 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so5412588obb.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:14:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: liwp@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, liwp.linux@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcg: complete documentation for tcp memcg files
has been removed from the -mm tree.  Its filename was
     mm-memcg-complete-documentation-for-tcp-memcg-files.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wanpeng Li <liwp@linux.vnet.ibm.com>
Subject: mm/memcg: complete documentation for tcp memcg files

Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/memory.txt |    2 ++
 1 file changed, 2 insertions(+)

diff -puN Documentation/cgroups/memory.txt~mm-memcg-complete-documentation-for-tcp-memcg-files Documentation/cgroups/memory.txt
--- a/Documentation/cgroups/memory.txt~mm-memcg-complete-documentation-for-tcp-memcg-files
+++ a/Documentation/cgroups/memory.txt
@@ -73,6 +73,8 @@ Brief summary of control files.
 
  memory.kmem.tcp.limit_in_bytes  # set/show hard limit for tcp buf memory
  memory.kmem.tcp.usage_in_bytes  # show current tcp buf memory allocation
+ memory.kmem.tcp.failcnt            # show the number of tcp buf memory usage hits limits
+ memory.kmem.tcp.max_usage_in_bytes # show max tcp buf memory usage recorded
 
 1. History
 
_

Patches currently in -mm which might be from liwp@linux.vnet.ibm.com are

origin.patch
linux-next.patch


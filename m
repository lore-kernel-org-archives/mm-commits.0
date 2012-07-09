From: akpm@linux-foundation.org
Subject: + mm-memcg-complete-documentation-for-tcp-memcg-files.patch added to -mm tree
Date: Mon, 09 Jul 2012 15:49:02 -0700
Message-ID: <20120709224903.09190200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:57433 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab2GIWtF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2012 18:49:05 -0400
Received: by fat25 with SMTP id 25so576778fat.1
        for <mm-commits@vger.kernel.org>; Mon, 09 Jul 2012 15:49:04 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: liwp@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, liwp.linux@gmail.com


The patch titled
     Subject: mm/memcg: complete documentation for tcp memcg files
has been added to the -mm tree.  Its filename is
     mm-memcg-complete-documentation-for-tcp-memcg-files.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: mm/memcg: complete documentation for tcp memcg files

Patches currently in -mm which might be from liwp@linux.vnet.ibm.com are

linux-next.patch
mm-prepare-for-removal-of-obsolete-proc-sys-vm-nr_pdflush_threads.patch
mm-remove-unused-lru_all_evictable.patch
memcg-rename-mem_control_xxx-to-memcg_xxx.patch
mm-memcg-complete-documentation-for-tcp-memcg-files.patch


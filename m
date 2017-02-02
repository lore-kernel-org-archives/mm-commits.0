From: akpm@linux-foundation.org
Subject: + mm-fix-checkpatch-warnings-whitespace.patch added to -mm tree
Date: Thu, 02 Feb 2017 15:19:14 -0800
Message-ID: <5893be72.KB/0RbqiSofoS7pv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33066 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751585AbdBBXTP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Feb 2017 18:19:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: me@tobin.cc, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: Fix checkpatch warnings, whitespace
has been added to the -mm tree.  Its filename is
     mm-fix-checkpatch-warnings-whitespace.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-checkpatch-warnings-whitespace.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-checkpatch-warnings-whitespace.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tobin C Harding <me@tobin.cc>
Subject: mm: Fix checkpatch warnings, whitespace

Patch fixes whitespace checkpatch warnings.

Link: http://lkml.kernel.org/r/1485992240-10986-3-git-send-email-me@tobin.cc
Signed-off-by: Tobin C Harding <me@tobin.cc>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff -puN mm/memory.c~mm-fix-checkpatch-warnings-whitespace mm/memory.c
--- a/mm/memory.c~mm-fix-checkpatch-warnings-whitespace
+++ a/mm/memory.c
@@ -30,7 +30,7 @@
 
 /*
  * 05.04.94  -  Multi-page memory management added for v1.1.
- * 		Idea by Alex Bligh (alex@cconcepts.co.uk)
+ *              Idea by Alex Bligh (alex@cconcepts.co.uk)
  *
  * 16.07.99  -  Support of BIGMEM added by Gerhard Wichert, Siemens AG
  *		(Gerhard.Wichert@pdb.siemens.de)
@@ -82,9 +82,9 @@
 #ifndef CONFIG_NEED_MULTIPLE_NODES
 /* use the per-pgdat data instead for discontigmem - mbligh */
 unsigned long max_mapnr;
-struct page *mem_map;
-
 EXPORT_SYMBOL(max_mapnr);
+
+struct page *mem_map;
 EXPORT_SYMBOL(mem_map);
 #endif
 
@@ -96,7 +96,6 @@ EXPORT_SYMBOL(mem_map);
  * and ZONE_HIGHMEM.
  */
 void * high_memory;
-
 EXPORT_SYMBOL(high_memory);
 
 /*
@@ -120,10 +119,10 @@ static int __init disable_randmaps(char
 __setup("norandmaps", disable_randmaps);
 
 unsigned long zero_pfn __read_mostly;
-unsigned long highest_memmap_pfn __read_mostly;
-
 EXPORT_SYMBOL(zero_pfn);
 
+unsigned long highest_memmap_pfn __read_mostly;
+
 /*
  * CONFIG_MMU architectures set up ZERO_PAGE in their paging_init()
  */
@@ -3765,8 +3764,8 @@ int handle_mm_fault(struct vm_area_struc
                  * VM_FAULT_OOM), there is no need to kill anything.
                  * Just clean up the OOM state peacefully.
                  */
-                if (task_in_memcg_oom(current) && !(ret & VM_FAULT_OOM))
-                        mem_cgroup_oom_synchronize(false);
+		if (task_in_memcg_oom(current) && !(ret & VM_FAULT_OOM))
+			mem_cgroup_oom_synchronize(false);
 	}
 
 	/*
_

Patches currently in -mm which might be from me@tobin.cc are

mm-fix-sparse-use-plain-integer-as-null-pointer.patch
mm-fix-checkpatch-warnings-whitespace.patch
mm-fix-checkpatch-errors-whitespace-errors.patch
mm-fix-checkpatch-warning-extraneous-braces.patch


From: akpm@linux-foundation.org
Subject: + rmap-remove-__anon_vma_link.patch added to -mm tree
Date: Wed, 07 Mar 2012 15:22:21 -0800
Message-ID: <20120307232221.ADA93A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:33023 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934Ab2CGXWY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Mar 2012 18:22:24 -0500
Received: by faaa19 with SMTP id a19so251544faa.1
        for <mm-commits@vger.kernel.org>; Wed, 07 Mar 2012 15:22:22 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiaoguangrong@linux.vnet.ibm.com, rientjes@google.com


The patch titled
     Subject: rmap: remove __anon_vma_link() declaration
has been added to the -mm tree.  Its filename is
     rmap-remove-__anon_vma_link.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: rmap: remove __anon_vma_link() declaration

This declaration is not used anymore, remove it.

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN include/linux/rmap.h~rmap-remove-__anon_vma_link include/linux/rmap.h
--- a/include/linux/rmap.h~rmap-remove-__anon_vma_link
+++ a/include/linux/rmap.h
@@ -122,7 +122,6 @@ void unlink_anon_vmas(struct vm_area_str
 int anon_vma_clone(struct vm_area_struct *, struct vm_area_struct *);
 void anon_vma_moveto_tail(struct vm_area_struct *);
 int anon_vma_fork(struct vm_area_struct *, struct vm_area_struct *);
-void __anon_vma_link(struct vm_area_struct *);
 
 static inline void anon_vma_merge(struct vm_area_struct *vma,
 				  struct vm_area_struct *next)
_
Subject: Subject: rmap: remove __anon_vma_link() declaration

Patches currently in -mm which might be from xiaoguangrong@linux.vnet.ibm.com are

linux-next.patch
hugetlbfs-fix-hugetlb_get_unmapped_area.patch
hugetlb-drop-prev_vma-in-hugetlb_get_unmapped_area_topdown.patch
hugetlb-try-to-search-again-if-it-is-really-needed.patch
hugetlb-try-to-search-again-if-it-is-really-needed-fix.patch
mm-do-not-reset-cached_hole_size-when-vma-is-unmapped.patch
mm-search-from-free_area_cache-for-the-bigger-size.patch
rmap-remove-__anon_vma_link.patch
prio_tree-remove-unnecessary-code-in-prio_tree_replace.patch
prio_tree-cleanup-prio_tree_left-prio_tree_right.patch
prio_tree-simplify-prio_tree_expand.patch
prio_tree-introduce-prio_set_parent.patch


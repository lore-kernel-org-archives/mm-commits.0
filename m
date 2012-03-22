From: akpm@linux-foundation.org
Subject: [merged] rmap-remove-__anon_vma_link.patch removed from -mm tree
Date: Thu, 22 Mar 2012 13:18:18 -0700
Message-ID: <20120322201818.629ADA024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:35102 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758859Ab2CVUST (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Mar 2012 16:18:19 -0400
Received: by mail-ee0-f74.google.com with SMTP id c41so136580eek.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 13:18:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiaoguangrong@linux.vnet.ibm.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rmap: remove __anon_vma_link() declaration
has been removed from the -mm tree.  Its filename was
     rmap-remove-__anon_vma_link.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

Patches currently in -mm which might be from xiaoguangrong@linux.vnet.ibm.com are

origin.patch
linux-next.patch
prio_tree-remove-unnecessary-code-in-prio_tree_replace.patch
prio_tree-cleanup-prio_tree_left-prio_tree_right.patch
prio_tree-simplify-prio_tree_expand.patch
prio_tree-introduce-prio_set_parent.patch


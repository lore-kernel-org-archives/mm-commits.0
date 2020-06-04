From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 054/127] mm: mmap: fix a typo in comment
 "compatbility"->"compatibility"
Date: Thu, 04 Jun 2020 16:49:04 -0700
Message-ID: <20200604234904.L7skhRAOU%akpm@linux-foundation.org>
References: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725930AbgFDXtG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 19:49:06 -0400
In-Reply-To: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ethp@qq.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, rcampbell@nvidia.com, torvalds@linux-foundation.org

From: Ethon Paul <ethp@qq.com>
Subject: mm: mmap: fix a typo in comment "compatbility"->"compatibility"

There is a typo in comment, fix it.

Link: http://lkml.kernel.org/r/20200410163206.14016-1-ethp@qq.com
Signed-off-by: Ethon Paul <ethp@qq.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mmap.c~mm-mmap-fix-a-typo-in-comment-compatbility-compatibility
+++ a/mm/mmap.c
@@ -1207,7 +1207,7 @@ struct vm_area_struct *vma_merge(struct
 }
 
 /*
- * Rough compatbility check to quickly see if it's even worth looking
+ * Rough compatibility check to quickly see if it's even worth looking
  * at sharing an anon_vma.
  *
  * They need to have the same vm_file, and the flags can only differ
_

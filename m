From: akpm@linux-foundation.org
Subject: + ksm-fix-the-comment-of-try_to_unmap_one.patch added to -mm tree
Date: Wed, 07 Sep 2011 13:45:35 -0700
Message-ID: <201109072045.p87KjaXA016904@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33118 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753841Ab1IGUpo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Sep 2011 16:45:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gaowanlong@cn.fujitsu.com, hughd@google.com


The patch titled
     ksm: fix the comment of try_to_unmap_one()
has been added to the -mm tree.  Its filename is
     ksm-fix-the-comment-of-try_to_unmap_one.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ksm: fix the comment of try_to_unmap_one()
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>

try_to_unmap_one() is called by try_to_unmap_ksm(), too.

Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/rmap.c~ksm-fix-the-comment-of-try_to_unmap_one mm/rmap.c
--- a/mm/rmap.c~ksm-fix-the-comment-of-try_to_unmap_one
+++ a/mm/rmap.c
@@ -1164,7 +1164,7 @@ void page_remove_rmap(struct page *page)
 
 /*
  * Subfunctions of try_to_unmap: try_to_unmap_one called
- * repeatedly from either try_to_unmap_anon or try_to_unmap_file.
+ * repeatedly from try_to_unmap_ksm, try_to_unmap_anon or try_to_unmap_file.
  */
 int try_to_unmap_one(struct page *page, struct vm_area_struct *vma,
 		     unsigned long address, enum ttu_flags flags)
_

Patches currently in -mm which might be from gaowanlong@cn.fujitsu.com are

linux-next.patch
ksm-fix-the-comment-of-try_to_unmap_one.patch


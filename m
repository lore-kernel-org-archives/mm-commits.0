From: akpm@linux-foundation.org
Subject: + mm-add-missing-kernel-doc-in-mm-memoryc-do_set_pte.patch added
 to -mm tree
Date: Fri, 10 Jun 2016 15:02:08 -0700
Message-ID: <575b38e0.NSZYxpECPXyCQ9GV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53890 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbcFJWCJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 10 Jun 2016 18:02:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rdunlap@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add missing kernel-doc in mm/memory.c::do_set_pte()
has been added to the -mm tree.  Its filename is
     mm-add-missing-kernel-doc-in-mm-memoryc-do_set_pte.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-add-missing-kernel-doc-in-mm-memoryc-do_set_pte.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-add-missing-kernel-doc-in-mm-memoryc-do_set_pte.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: mm: add missing kernel-doc in mm/memory.c::do_set_pte()

Fix kernel-doc warning in mm/memory.c:

..//mm/memory.c:2881: warning: No description found for parameter 'old'

Link: http://lkml.kernel.org/r/575B01BD.9020809@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/memory.c~mm-add-missing-kernel-doc-in-mm-memoryc-do_set_pte mm/memory.c
--- a/mm/memory.c~mm-add-missing-kernel-doc-in-mm-memoryc-do_set_pte
+++ a/mm/memory.c
@@ -2870,6 +2870,7 @@ static int __do_fault(struct vm_area_str
  * @pte: pointer to target page table entry
  * @write: true, if new entry is writable
  * @anon: true, if it's anonymous page
+ * @old: if true, mark the PTE as old (clear _PAGE_ACCESSED for this entry)
  *
  * Caller must hold page table lock relevant for @pte.
  *
_

Patches currently in -mm which might be from rdunlap@infradead.org are

debugobjectsh-fix-trivial-kernel-doc-warning.patch
mm-add-missing-kernel-doc-in-mm-memoryc-do_set_pte.patch


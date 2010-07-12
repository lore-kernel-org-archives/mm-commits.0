From: akpm@linux-foundation.org
Subject: + mmu-notifiers-remove-mmu-notifier-calls-in-apply_to_page_range-fix.patch added to -mm tree
Date: Mon, 12 Jul 2010 16:57:42 -0700
Message-ID: <201007122357.o6CNvga1004366@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39139 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751303Ab0GLX6A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Jul 2010 19:58:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stefano.stabellini@eu.citrix.com, aarcange@redhat.com, avi@qumranet.com, jeremy.fitzhardinge@citrix.com


The patch titled
     mmu-notifiers-remove-mmu-notifier-calls-in-apply_to_page_range-fix
has been added to the -mm tree.  Its filename is
     mmu-notifiers-remove-mmu-notifier-calls-in-apply_to_page_range-fix.patch

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
Subject: mmu-notifiers-remove-mmu-notifier-calls-in-apply_to_page_range-fix
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

remove unused local `start'

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory.c~mmu-notifiers-remove-mmu-notifier-calls-in-apply_to_page_range-fix mm/memory.c
--- a/mm/memory.c~mmu-notifiers-remove-mmu-notifier-calls-in-apply_to_page_range-fix
+++ a/mm/memory.c
@@ -1996,7 +1996,7 @@ int apply_to_page_range(struct mm_struct
 {
 	pgd_t *pgd;
 	unsigned long next;
-	unsigned long start = addr, end = addr + size;
+	unsigned long end = addr + size;
 	int err;
 
 	BUG_ON(addr >= end);
_

Patches currently in -mm which might be from stefano.stabellini@eu.citrix.com are

mmu-notifiers-remove-mmu-notifier-calls-in-apply_to_page_range.patch
mmu-notifiers-remove-mmu-notifier-calls-in-apply_to_page_range-fix.patch


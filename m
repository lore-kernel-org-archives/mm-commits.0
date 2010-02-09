From: akpm@linux-foundation.org
Subject: + remove-unused-macro-vm_min_readahead.patch added to -mm tree
Date: Tue, 09 Feb 2010 15:07:15 -0800
Message-ID: <201002092307.o19N7F7Z007223@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55299 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752163Ab0BIXHU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Feb 2010 18:07:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: knikanth@suse.de


The patch titled
     mm: remove unused macro VM_MIN_READAHEAD
has been added to the -mm tree.  Its filename is
     remove-unused-macro-vm_min_readahead.patch

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
Subject: mm: remove unused macro VM_MIN_READAHEAD
From: Nikanth Karthikesan <knikanth@suse.de>

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN include/linux/mm.h~remove-unused-macro-vm_min_readahead include/linux/mm.h
--- a/include/linux/mm.h~remove-unused-macro-vm_min_readahead
+++ a/include/linux/mm.h
@@ -1289,7 +1289,6 @@ void task_dirty_inc(struct task_struct *
 
 /* readahead.c */
 #define VM_MAX_READAHEAD	128	/* kbytes */
-#define VM_MIN_READAHEAD	16	/* kbytes (includes current page) */
 
 int force_page_cache_readahead(struct address_space *mapping, struct file *filp,
 			pgoff_t offset, unsigned long nr_to_read);
_

Patches currently in -mm which might be from knikanth@suse.de are

linux-next.patch
remove-unused-macro-vm_min_readahead.patch


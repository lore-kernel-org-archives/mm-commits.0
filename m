From: akpm@linux-foundation.org
Subject: [nacked] remove-unused-macro-vm_min_readahead.patch removed from -mm tree
Date: Wed, 10 Feb 2010 21:33:12 -0800
Message-ID: <201002110533.o1B5XCI9020370@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55388 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751232Ab0BKFdR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Feb 2010 00:33:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: knikanth@suse.de, mm-commits@vger.kernel.org


The patch titled
     mm: remove unused macro VM_MIN_READAHEAD
has been removed from the -mm tree.  Its filename was
     remove-unused-macro-vm_min_readahead.patch

This patch was dropped because it was nacked

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
sysctl-remove-references-to-ctl_unnumbered-which-has-been-removed.patch


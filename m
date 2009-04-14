From: akpm@linux-foundation.org
Subject: [merged] quota-remove-obsolete-comments-in-fs-quota-makefile.patch removed from -mm tree
Date: Tue, 14 Apr 2009 12:50:59 -0700
Message-ID: <200904141950.n3EJoxCI020443@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58113 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751801AbZDNUAT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Apr 2009 16:00:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     quota: remove obsolete comments in fs/quota/Makefile
has been removed from the -mm tree.  Its filename was
     quota-remove-obsolete-comments-in-fs-quota-makefile.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: quota: remove obsolete comments in fs/quota/Makefile
From: Christoph Hellwig <hch@lst.de>

Get rid of useless comments and the equally useless obj-y
initialization.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/quota/Makefile |    9 ---------
 1 file changed, 9 deletions(-)

diff -puN fs/quota/Makefile~quota-remove-obsolete-comments-in-fs-quota-makefile fs/quota/Makefile
--- a/fs/quota/Makefile~quota-remove-obsolete-comments-in-fs-quota-makefile
+++ a/fs/quota/Makefile
@@ -1,12 +1,3 @@
-#
-# Makefile for the Linux filesystems.
-#
-# 14 Sep 2000, Christoph Hellwig <hch@infradead.org>
-# Rewritten to use lists instead of if-statements.
-#
-
-obj-y :=

From: akpm@linux-foundation.org
Subject: + quota-remove-obsolete-comments-in-fs-quota-makefile.patch added to -mm tree
Date: Thu, 09 Apr 2009 21:53:56 -0700
Message-ID: <200904100453.n3A4ru24029871@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43591 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752325AbZDJEzr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Apr 2009 00:55:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hch@lst.de, jack@suse.cz


The patch titled
     quota: remove obsolete comments in fs/quota/Makefile
has been added to the -mm tree.  Its filename is
     quota-remove-obsolete-comments-in-fs-quota-makefile.patch

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

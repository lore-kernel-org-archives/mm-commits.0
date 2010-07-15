From: akpm@linux-foundation.org
Subject: + reiserfs-remove-unused-local-wait.patch added to -mm tree
Date: Thu, 15 Jul 2010 12:27:09 -0700
Message-ID: <201007151927.o6FJR9Sn014746@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48179 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934512Ab0GOT1M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Jul 2010 15:27:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiaosuo@gmail.com


The patch titled
     reiserfs: remove unused local `wait'
has been added to the -mm tree.  Its filename is
     reiserfs-remove-unused-local-wait.patch

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
Subject: reiserfs: remove unused local `wait'
From: Changli Gao <xiaosuo@gmail.com>

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/journal.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/reiserfs/journal.c~reiserfs-remove-unused-local-wait fs/reiserfs/journal.c
--- a/fs/reiserfs/journal.c~reiserfs-remove-unused-local-wait
+++ a/fs/reiserfs/journal.c
@@ -983,7 +983,6 @@ static int flush_older_commits(struct su
 
 static int reiserfs_async_progress_wait(struct super_block *s)
 {
-	DEFINE_WAIT(wait);
 	struct reiserfs_journal *j = SB_JOURNAL(s);
 
 	if (atomic_read(&j->j_async_throttle)) {
_

Patches currently in -mm which might be from xiaosuo@gmail.com are

linux-next.patch
vfs-use-kmalloc-to-allocate-fdmem-if-possible.patch
reiserfs-remove-unused-local-wait.patch


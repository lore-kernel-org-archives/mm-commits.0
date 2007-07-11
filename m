From: akpm@linux-foundation.org
Subject: + relay-fix-subbuf_splice_actor-comment.patch added to -mm tree
Date: Wed, 11 Jul 2007 13:58:42 -0700
Message-ID: <200707112058.l6BKwgSk016394@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36595 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933058AbXGKU7k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Jul 2007 16:59:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zanussi@us.ibm.com, jens.axboe@oracle.com


The patch titled
     relay: fix subbuf_splice_actor() comment
has been added to the -mm tree.  Its filename is
     relay-fix-subbuf_splice_actor-comment.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: relay: fix subbuf_splice_actor() comment
From: Tom Zanussi <zanussi@us.ibm.com>

Change comment from kerneldoc to normal.

Signed-off-by: Tom Zanussi <zanussi@us.ibm.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/relay.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/relay.c~relay-fix-subbuf_splice_actor-comment kernel/relay.c
--- a/kernel/relay.c~relay-fix-subbuf_splice_actor-comment
+++ a/kernel/relay.c
@@ -1061,7 +1061,7 @@ static struct pipe_buf_operations relay_
 	.get = generic_pipe_buf_get,
 };
 
-/**
+/*
  *	subbuf_splice_actor - splice up to one subbuf's worth of data
  */
 static int subbuf_splice_actor(struct file *in,
_

Patches currently in -mm which might be from zanussi@us.ibm.com are

git-block.patch
relay-fix-subbuf_splice_actor-comment.patch
relay-fix-bogus-cast-in-subbuf_splice_actor.patch
kernel-relayc-make-functions-static.patch

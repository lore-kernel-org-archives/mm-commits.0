From: akpm@linux-foundation.org
Subject: - relay-fix-subbuf_splice_actor-comment.patch removed from -mm tree
Date: Fri, 13 Jul 2007 15:33:12 -0700
Message-ID: <200707132233.l6DMXCEC025062@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56536 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S937068AbXGMWpI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Jul 2007 18:45:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zanussi@us.ibm.com, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     relay: fix subbuf_splice_actor() comment
has been removed from the -mm tree.  Its filename was
     relay-fix-subbuf_splice_actor-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
kernel-relayc-make-functions-static.patch

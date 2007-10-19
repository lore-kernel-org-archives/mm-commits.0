From: akpm@linux-foundation.org
Subject: - whitespace-fixes-relayfs.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:43:36 -0700
Message-ID: <200710190343.l9J3ha7r013075@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43322 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966520AbXJSD4A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:56:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalker@mvista.com, zanussi@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     whitespace fixes: relayfs
has been removed from the -mm tree.  Its filename was
     whitespace-fixes-relayfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: whitespace fixes: relayfs
From: Daniel Walker <dwalker@mvista.com>

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Cc: Tom Zanussi <zanussi@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/relay.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN kernel/relay.c~whitespace-fixes-relayfs kernel/relay.c
--- a/kernel/relay.c~whitespace-fixes-relayfs
+++ a/kernel/relay.c
@@ -370,7 +370,7 @@ void relay_reset(struct rchan *chan)
 	if (!chan)
 		return;
 
- 	if (chan->is_global && chan->buf[0]) {
+	if (chan->is_global && chan->buf[0]) {
 		__relay_reset(chan->buf[0], 0);
 		return;
 	}
@@ -850,13 +850,13 @@ static int relay_file_read_avail(struct 
 		buf->subbufs_consumed = consumed;
 		buf->bytes_consumed = 0;
 	}
-	
+
 	produced = (produced % n_subbufs) * subbuf_size + buf->offset;
 	consumed = (consumed % n_subbufs) * subbuf_size + buf->bytes_consumed;
 
 	if (consumed > produced)
 		produced += n_subbufs * subbuf_size;
-	
+
 	if (consumed == produced)
 		return 0;
 
_

Patches currently in -mm which might be from dwalker@mvista.com are

origin.patch
whitespace-fixes-task-exit-handling.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch

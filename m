From: akpm@linux-foundation.org
Subject: + whitespace-fixes-relayfs.patch added to -mm tree
Date: Fri, 20 Jul 2007 17:18:42 -0700
Message-ID: <200707210018.l6L0Igk8023856@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50610 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758142AbXGUAUN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 20:20:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dwalker@mvista.com, zanussi@us.ibm.com


The patch titled
     whitespace fixes: relayfs
has been added to the -mm tree.  Its filename is
     whitespace-fixes-relayfs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: whitespace fixes: relayfs
From: Daniel Walker <dwalker@mvista.com>

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Cc: Tom Zanussi <zanussi@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/relay.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

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

whitespace-fixes-time-syscalls.patch
whitespace-fixes-process-accounting.patch
whitespace-fixes-cpuset.patch
whitespace-fixes-relayfs.patch
whitespace-fixes-audit-filtering.patch
whitespace-fixes-dma-channel-allocator.patch
whitespace-fixes-fork.patch
whitespace-fixes-module-loading.patch
whitespace-fixes-panic-handling.patch
whitespace-fixes-capability-syscalls.patch
whitespace-fixes-syscall-auditing.patch
whitespace-fixes-compat-syscalls.patch
whitespace-fixes-system-auditing.patch
whitespace-fixes-execution-domains.patch
whitespace-fixes-interval-timers.patch
whitespace-fixes-system-timers.patch
whitespace-fixes-task-exit-handling.patch
profile-likely-unlikely-macros.patch

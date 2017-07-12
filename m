From: akpm@linux-foundation.org
Subject: [folded-merged]
 ipc-semc-remove-sem_base-embed-struct-sem-v3.patch removed from -mm tree
Date: Wed, 12 Jul 2017 14:17:10 -0700
Message-ID: <596691d6.uxuve+w/JcIVsGub%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52156 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753976AbdGLVRQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jul 2017 17:17:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: manfred@colorfullife.com, dave@stgolabs.net, hch@infradead.org, keescook@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc-semc-remove-sem_base-embed-struct-sem-v3
has been removed from the -mm tree.  Its filename was
     ipc-semc-remove-sem_base-embed-struct-sem-v3.patch

This patch was dropped because it was folded into ipc-semc-remove-sem_base-embed-struct-sem.patch

------------------------------------------------------
From: Manfred Spraul <manfred@colorfullife.com>
Subject: ipc-semc-remove-sem_base-embed-struct-sem-v3

s/[0]/[]/, per hch

Link: http://lkml.kernel.org/r/20170525185107.12869-2-manfred@colorfullife.com
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sem.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/sem.h~ipc-semc-remove-sem_base-embed-struct-sem-v3 include/linux/sem.h
--- a/include/linux/sem.h~ipc-semc-remove-sem_base-embed-struct-sem-v3
+++ a/include/linux/sem.h
@@ -40,7 +40,7 @@ struct sem_array {
 	int			complex_count;	/* pending complex operations */
 	unsigned int		use_global_lock;/* >0: global lock required */
 
-	struct sem		sems[0];
+	struct sem		sems[];
 };
 
 #ifdef CONFIG_SYSVIPC
_

Patches currently in -mm which might be from manfred@colorfullife.com are

ipc-semc-remove-sem_base-embed-struct-sem.patch
ipc-merge-ipc_rcu-and-kern_ipc_perm.patch
ipc-merge-ipc_rcu-and-kern_ipc_perm-fix.patch
include-linux-semh-correctly-document-sem_ctime.patch
ipc-semc-avoid-ipc_rcu_putref-for-failed-ipc_addid.patch
ipc-shmc-avoid-ipc_rcu_putref-for-failed-ipc_addid.patch
ipc-msgc-avoid-ipc_rcu_putref-for-failed-ipc_addid.patch
ipc-utilh-update-documentation-for-ipc_getref-and-ipc_putref.patch


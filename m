From: akpm@linux-foundation.org
Subject: - security-keys-remove-unused-key_alloc_sem.patch removed from -mm tree
Date: Sun, 08 Jun 2008 12:48:26 -0700
Message-ID: <200806081948.m58JmQe0017507@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51360 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754763AbYFHTyR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 15:54:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalker@mvista.com, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     keys: remove unused key_alloc_sem
has been removed from the -mm tree.  Its filename was
     security-keys-remove-unused-key_alloc_sem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: keys: remove unused key_alloc_sem
From: Daniel Walker <dwalker@mvista.com>

This semaphore doesn't appear to be used, so remove it.

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/keys/internal.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN security/keys/internal.h~security-keys-remove-unused-key_alloc_sem security/keys/internal.h
--- a/security/keys/internal.h~security-keys-remove-unused-key_alloc_sem
+++ a/security/keys/internal.h
@@ -78,7 +78,6 @@ extern unsigned key_quota_maxbytes;
 
 extern struct rb_root key_serial_tree;
 extern spinlock_t key_serial_lock;
-extern struct semaphore key_alloc_sem;
 extern struct mutex key_construction_mutex;
 extern wait_queue_head_t request_key_conswq;
 
_

Patches currently in -mm which might be from dwalker@mvista.com are

origin.patch
linux-next.patch
macintosh-therm_windtunnel-semaphore-to-mutex.patch
macintosh-media-bay-semaphore-to-mutex.patch
profile-likely-unlikely-macros.patch
likely_prof-changed-to-use-proc_create.patch
likeliness-accounting-change-and-cleanup.patch


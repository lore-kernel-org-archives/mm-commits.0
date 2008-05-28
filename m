From: akpm@linux-foundation.org
Subject: + security-keys-remove-unused-key_alloc_sem.patch added to -mm tree
Date: Tue, 27 May 2008 21:51:23 -0700
Message-ID: <200805280451.m4S4pNQu029599@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49328 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751271AbYE1Ezy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 May 2008 00:55:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dwalker@mvista.com, dhowells@redhat.com


The patch titled
     keys: remove unused key_alloc_sem
has been added to the -mm tree.  Its filename is
     security-keys-remove-unused-key_alloc_sem.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
macintosh-therm_windtunnel-semaphore-to-mutex.patch
macintosh-media-bay-semaphore-to-mutex.patch
security-keys-remove-unused-key_alloc_sem.patch
profile-likely-unlikely-macros.patch
likely_prof-changed-to-use-proc_create.patch
likeliness-accounting-change-and-cleanup.patch


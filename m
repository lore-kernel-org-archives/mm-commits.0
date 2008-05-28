From: akpm@linux-foundation.org
Subject: + mn10300-fix-typo-in-header-guard.patch added to -mm tree
Date: Wed, 28 May 2008 11:58:03 -0700
Message-ID: <200805281858.m4SIw3M4027570@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58609 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752138AbYE1S7I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 May 2008 14:59:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, vegard.nossum@gmail.com


The patch titled
     From: David Howells <dhowells@redhat.com>
has been added to the -mm tree.  Its filename is
     mn10300-fix-typo-in-header-guard.patch

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
Subject: From: David Howells <dhowells@redhat.com>
From: Vegard Nossum <vegard.nossum@gmail.com>


Fix a typo in the header guard of asm/ipc.h.

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

index efbbef8..f6f63d4 100644
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-mn10300/ipcbuf.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-mn10300/ipcbuf.h~mn10300-fix-typo-in-header-guard include/asm-mn10300/ipcbuf.h
--- a/include/asm-mn10300/ipcbuf.h~mn10300-fix-typo-in-header-guard
+++ a/include/asm-mn10300/ipcbuf.h
@@ -1,4 +1,4 @@
-#ifndef _ASM_IPCBUF_H_
+#ifndef _ASM_IPCBUF_H
 #define _ASM_IPCBUF_H
 
 /*
_

Patches currently in -mm which might be from dhowells@redhat.com are

mn10300-fix-typo-in-header-guard.patch
linux-next.patch
git-unionfs.patch
security-keys-remove-unused-key_alloc_sem.patch
frv-dont-offer-binfmt_flat.patch
frv-use-the-common-ascii-hex-helpers.patch
mn10300-use-the-common-ascii-hex-helpers.patch
mutex-subsystem-synchro-test-module.patch


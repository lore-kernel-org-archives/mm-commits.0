From: akpm@linux-foundation.org
Subject: - revoke-special-mmap-handling-vs-fault-vs-invalidate.patch removed from -mm tree
Date: Mon, 26 Nov 2007 11:36:09 -0800
Message-ID: <200711261936.lAQJa995019277@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48944 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754158AbXKZTgN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Nov 2007 14:36:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michal.k.k.piotrowski@gmail.com, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     revoke-special-mmap-handling-vs-fault-vs-invalidate
has been removed from the -mm tree.  Its filename was
     revoke-special-mmap-handling-vs-fault-vs-invalidate.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: revoke-special-mmap-handling-vs-fault-vs-invalidate
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Acked-by: Pekka J Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/mm.h~revoke-special-mmap-handling-vs-fault-vs-invalidate include/linux/mm.h
--- a/include/linux/mm.h~revoke-special-mmap-handling-vs-fault-vs-invalidate
+++ a/include/linux/mm.h
@@ -104,9 +104,9 @@ extern unsigned int kobjsize(const void 
 #define VM_MAPPED_COPY	0x01000000	/* T if mapped copy of data (nommu mmap) */
 #define VM_INSERTPAGE	0x02000000	/* The vma has had "vm_insert_page()" done on it */
 #define VM_ALWAYSDUMP	0x04000000	/* Always include in core dumps */
-#define VM_REVOKED	0x08000000	/* Mapping has been revoked */
 
 #define VM_CAN_NONLINEAR 0x08000000	/* Has ->fault & does nonlinear pages */
+#define VM_REVOKED	0x10000000	/* Mapping has been revoked */
 
 #ifndef VM_STACK_DEFAULT_FLAGS		/* arch can override this */
 #define VM_STACK_DEFAULT_FLAGS VM_DATA_DEFAULT_FLAGS
_

Patches currently in -mm which might be from michal.k.k.piotrowski@gmail.com are

git-kvm.patch
revoke-special-mmap-handling-vs-fault-vs-invalidate.patch
reiser4.patch

From: akpm@linux-foundation.org
Subject: - some-grammatical-fixups-and-additions-to-atomich-kernel-doc.patch removed from -mm tree
Date: Tue, 08 May 2007 19:55:46 -0700
Message-ID: <200705090255.l492tka4009965@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38184 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032352AbXEICzz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:55:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Some grammatical fixups and additions to atomic.h kernel-doc content
has been removed from the -mm tree.  Its filename was
     some-grammatical-fixups-and-additions-to-atomich-kernel-doc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Some grammatical fixups and additions to atomic.h kernel-doc content
From: "Robert P. J. Day" <rpjday@mindspring.com>

Tweak and add content for extractable documentation in asm-i386/atomic.h.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-i386/atomic.h |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff -puN include/asm-i386/atomic.h~some-grammatical-fixups-and-additions-to-atomich-kernel-doc include/asm-i386/atomic.h
--- a/include/asm-i386/atomic.h~some-grammatical-fixups-and-additions-to-atomich-kernel-doc
+++ a/include/asm-i386/atomic.h
@@ -52,7 +52,7 @@ static __inline__ void atomic_add(int i,
 }
 
 /**
- * atomic_sub - subtract the atomic variable
+ * atomic_sub - subtract integer from atomic variable
  * @i: integer value to subtract
  * @v: pointer of type atomic_t
  * 
@@ -171,7 +171,7 @@ static __inline__ int atomic_add_negativ
 }
 
 /**
- * atomic_add_return - add and return
+ * atomic_add_return - add integer and return
  * @v: pointer of type atomic_t
  * @i: integer value to add
  *
@@ -203,6 +203,13 @@ no_xadd: /* Legacy 386 processor */
 #endif
 }
 
+/**
+ * atomic_sub_return - subtract integer and return
+ * @v: pointer of type atomic_t
+ * @i: integer value to subtract
+ *
+ * Atomically subtracts @i from @v and returns @v - @i
+ */
 static __inline__ int atomic_sub_return(int i, atomic_t *v)
 {
 	return atomic_add_return(-i,v);
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
git-alsa.patch
remove-unused-header-file-arch-arm-mach-s3c2410-basth.patch
arm-remove-useless-config-option-generic_bust_spinlock.patch
git-avr32.patch
git-dvb.patch
git-ieee1394.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc.patch

From: akpm@linux-foundation.org
Subject: + m68knommu-use-tabs-not-spaces-in-cacheflushh.patch added to -mm tree
Date: Thu, 14 Feb 2008 13:08:00 -0800
Message-ID: <200802142108.m1EL80uj002890@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56172 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933764AbYBNVIg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Feb 2008 16:08:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gerg@snapgear.com, gerg@uclinux.org


The patch titled
     m68knommu: use tabs not spaces in cacheflush.h
has been added to the -mm tree.  Its filename is
     m68knommu-use-tabs-not-spaces-in-cacheflushh.patch

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
Subject: m68knommu: use tabs not spaces in cacheflush.h
From: Greg Ungerer <gerg@snapgear.com>

Use tabs instead of spaces.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-m68knommu/cacheflush.h |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN include/asm-m68knommu/cacheflush.h~m68knommu-use-tabs-not-spaces-in-cacheflushh include/asm-m68knommu/cacheflush.h
--- a/include/asm-m68knommu/cacheflush.h~m68knommu-use-tabs-not-spaces-in-cacheflushh
+++ a/include/asm-m68knommu/cacheflush.h
@@ -54,28 +54,28 @@ static inline void __flush_cache_all(voi
 #if defined(CONFIG_M527x) || defined(CONFIG_M528x)
 	__asm__ __volatile__ (
 		"movel	#0x81000200, %%d0\n\t"
-        	"movec	%%d0, %%CACR\n\t"
+		"movec	%%d0, %%CACR\n\t"
 		"nop\n\t"
 		: : : "d0" );
 #endif /* CONFIG_M527x || CONFIG_M528x */
 #if defined(CONFIG_M5206) || defined(CONFIG_M5206e) || defined(CONFIG_M5272)
 	__asm__ __volatile__ (
-        	"movel	#0x81000100, %%d0\n\t"
-        	"movec	%%d0, %%CACR\n\t"
+		"movel	#0x81000100, %%d0\n\t"
+		"movec	%%d0, %%CACR\n\t"
 		"nop\n\t"
 		: : : "d0" );
 #endif /* CONFIG_M5206 || CONFIG_M5206e || CONFIG_M5272 */
 #ifdef CONFIG_M5249
 	__asm__ __volatile__ (
-        	"movel	#0xa1000200, %%d0\n\t"
-        	"movec	%%d0, %%CACR\n\t"
+		"movel	#0xa1000200, %%d0\n\t"
+		"movec	%%d0, %%CACR\n\t"
 		"nop\n\t"
 		: : : "d0" );
 #endif /* CONFIG_M5249 */
 #ifdef CONFIG_M532x
 	__asm__ __volatile__ (
-        	"movel	#0x81000200, %%d0\n\t"
-        	"movec	%%d0, %%CACR\n\t"
+		"movel	#0x81000200, %%d0\n\t"
+		"movec	%%d0, %%CACR\n\t"
 		"nop\n\t"
 		: : : "d0" );
 #endif /* CONFIG_M532x */
_

Patches currently in -mm which might be from gerg@snapgear.com are

m68knommu-avoid-unneccessary-use-of-xchg-in-set_mb.patch
m68knommu-use-asflags-instead-of-extra_aflags.patch
m68knommu-use-tabs-not-spaces-in-cacheflushh.patch

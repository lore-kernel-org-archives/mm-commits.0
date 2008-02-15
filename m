From: akpm@linux-foundation.org
Subject: - m68knommu-use-tabs-not-spaces-in-cacheflushh.patch removed from -mm tree
Date: Thu, 14 Feb 2008 19:16:22 -0500
Message-ID: <200802150719.m1F7JiM8025730@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44185 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763261AbYBOHUy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 02:20:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gerg@snapgear.com, gerg@uclinux.org, mm-commits@vger.kernel.org


The patch titled
     m68knommu: use tabs not spaces in cacheflush.h
has been removed from the -mm tree.  Its filename was
     m68knommu-use-tabs-not-spaces-in-cacheflushh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

From: akpm@linux-foundation.org
Subject: - m68k-asm-scatterlisth-needs-linux-typesh.patch removed from -mm tree
Date: Wed, 09 May 2007 01:42:41 -0700
Message-ID: <200705090842.l498gflC018223@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:50240 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754343AbXEIImv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 04:42:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     m68k: <asm/scatterlist.h> needs <linux/types.h>
has been removed from the -mm tree.  Its filename was
     m68k-asm-scatterlisth-needs-linux-typesh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: m68k: <asm/scatterlist.h> needs <linux/types.h>
From: Geert Uytterhoeven <geert@linux-m68k.org>

The recent <linux/pci.h> cleanup uncovered that include/asm-m68k/scatterlist.h
needs to include <linux/types.h>

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-m68k/scatterlist.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/asm-m68k/scatterlist.h~m68k-asm-scatterlisth-needs-linux-typesh include/asm-m68k/scatterlist.h
--- a/include/asm-m68k/scatterlist.h~m68k-asm-scatterlisth-needs-linux-typesh
+++ a/include/asm-m68k/scatterlist.h
@@ -1,6 +1,8 @@
 #ifndef _M68K_SCATTERLIST_H
 #define _M68K_SCATTERLIST_H
 
+#include <linux/types.h>
+
 struct scatterlist {
 	struct page *page;
 	unsigned int offset;
_

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
git-net.patch
allow-arch-to-initialize-arch-field-of-the-module-structure.patch

From: akpm@linux-foundation.org
Subject: + m68k-asm-scatterlisth-needs-linux-typesh.patch added to -mm tree
Date: Tue, 08 May 2007 14:19:08 -0700
Message-ID: <200705082119.l48LJ8ep001979@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49830 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031654AbXEHVTR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 17:19:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geert@linux-m68k.org, zippel@linux-m68k.org


The patch titled
     m68k: <asm/scatterlist.h> needs <linux/types.h>
has been added to the -mm tree.  Its filename is
     m68k-asm-scatterlisth-needs-linux-typesh.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 2 insertions(+)

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
mac80211-include-linux-delayh-instead-of-asm-delayh.patch
m68k-asm-scatterlisth-needs-linux-typesh.patch
allow-arch-to-initialize-arch-field-of-the-module-structure.patch

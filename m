From: akpm@linux-foundation.org
Subject: - cris-tlbh-should-include-linux-pagemaph.patch removed from -mm tree
Date: Thu, 15 Nov 2007 13:12:15 -0800
Message-ID: <200711152112.lAFLCFhF015850@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36304 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751986AbXKOVRA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 16:17:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.nilsson@axis.com, mikael.starvik@axis.com, mm-commits@vger.kernel.org


The patch titled
     CRIS tlb.h should include linux/pagemap.h
has been removed from the -mm tree.  Its filename was
     cris-tlbh-should-include-linux-pagemaph.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: CRIS tlb.h should include linux/pagemap.h
From: Jesper Nilsson <jesper.nilsson@axis.com>

Include linux/pagemap.h for release_pages and page_cache_release.

Fixes compilation error in arch/cris/mm/init.c when CONFIG_SWAP is unset.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Mikael Starvik <mikael.starvik@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-cris/tlb.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/asm-cris/tlb.h~cris-tlbh-should-include-linux-pagemaph include/asm-cris/tlb.h
--- a/include/asm-cris/tlb.h~cris-tlbh-should-include-linux-pagemaph
+++ a/include/asm-cris/tlb.h
@@ -1,6 +1,8 @@
 #ifndef _CRIS_TLB_H
 #define _CRIS_TLB_H
 
+#include <linux/pagemap.h>
+
 #include <asm/arch/tlb.h>
 
 /*
_

Patches currently in -mm which might be from jesper.nilsson@axis.com are

origin.patch
cris-build-fixes-atomich-needs-compilerh.patch
git-mtd.patch

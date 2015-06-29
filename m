From: akpm@linux-foundation.org
Subject: [merged] zsmalloc-remove-obsolete-zsmalloc_debug.patch removed
 from -mm tree
Date: Mon, 29 Jun 2015 13:39:51 -0700
Message-ID: <5591ad17.dG750FPOcivmgKbY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50599 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512AbbF2Ujw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:39:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.jabrzyk@samsung.com, minchan@kernel.org, ngupta@vflare.org, sergey.senozhatsky.work@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: remove obsolete ZSMALLOC_DEBUG
has been removed from the -mm tree.  Its filename was
     zsmalloc-remove-obsolete-zsmalloc_debug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Marcin Jabrzyk <m.jabrzyk@samsung.com>
Subject: zsmalloc: remove obsolete ZSMALLOC_DEBUG

The DEBUG define in zsmalloc is useless, there is no usage of it at all.

Signed-off-by: Marcin Jabrzyk <m.jabrzyk@samsung.com>
Acked-by: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN mm/zsmalloc.c~zsmalloc-remove-obsolete-zsmalloc_debug mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-remove-obsolete-zsmalloc_debug
+++ a/mm/zsmalloc.c
@@ -45,10 +45,6 @@
  *
  */
 
-#ifdef CONFIG_ZSMALLOC_DEBUG
-#define DEBUG
-#endif

From: akpm@linux-foundation.org
Subject: [merged] aoe-remove-unused-code.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:22:05 -0700
Message-ID: <20121005202206.12CA95C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:52573 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319Ab2JEUWH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:22:07 -0400
Received: by mail-we0-f202.google.com with SMTP id x43so139753wey.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:22:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ecashin@coraid.com, mm-commits@vger.kernel.org


The patch titled
     Subject: aoe: remove unused code
has been removed from the -mm tree.  Its filename was
     aoe-remove-unused-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ed Cashin <ecashin@coraid.com>
Subject: aoe: remove unused code

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoe.h |    4 ----
 1 file changed, 4 deletions(-)

diff -puN drivers/block/aoe/aoe.h~aoe-remove-unused-code drivers/block/aoe/aoe.h
--- a/drivers/block/aoe/aoe.h~aoe-remove-unused-code
+++ a/drivers/block/aoe/aoe.h
@@ -10,9 +10,6 @@
 #define AOE_PARTITIONS (16)
 #endif
 
-#define SYSMINOR(aoemajor, aoeminor) ((aoemajor) * NPERSHELF + (aoeminor))
-#define AOEMAJOR(sysminor) ((sysminor) / NPERSHELF)
-#define AOEMINOR(sysminor) ((sysminor) % NPERSHELF)
 #define WHITESPACE " \t\v\f\n"
 
 enum {
@@ -82,7 +79,6 @@ enum {
 
 enum {
 	DEFAULTBCNT = 2 * 512,	/* 2 sectors */
-	NPERSHELF = 16,		/* number of slots per shelf address */
 	MIN_BUFS = 16,
 	NTARGETS = 8,
 	NAOEIFS = 8,
_

Patches currently in -mm which might be from ecashin@coraid.com are

origin.patch


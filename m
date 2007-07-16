From: akpm@linux-foundation.org
Subject: - drivers-block-z2ram-remove-true-false-defines.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:54:00 -0700
Message-ID: <200707162054.l6GKs0jq001700@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43340 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756696AbXGPVSr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:18:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ricknu-0@student.ltu.se, mm-commits@vger.kernel.org


The patch titled
     drivers/block/z2ram: Remove TRUE/FALSE defines
has been removed from the -mm tree.  Its filename was
     drivers-block-z2ram-remove-true-false-defines.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/block/z2ram: Remove TRUE/FALSE defines
From: Richard Knutsson <ricknu-0@student.ltu.se>

Remove defines of TRUE and FALSE
  * not used in the file
  * the file is not included somewhere else

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/z2ram.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN drivers/block/z2ram.c~drivers-block-z2ram-remove-true-false-defines drivers/block/z2ram.c
--- a/drivers/block/z2ram.c~drivers-block-z2ram-remove-true-false-defines
+++ a/drivers/block/z2ram.c
@@ -44,9 +44,6 @@
 extern int m68k_realnum_memory;
 extern struct mem_info m68k_memory[NUM_MEMINFO];
 
-#define TRUE                  (1)
-#define FALSE                 (0)
-
 #define Z2MINOR_COMBINED      (0)
 #define Z2MINOR_Z2ONLY        (1)
 #define Z2MINOR_CHIPONLY      (2)
_

Patches currently in -mm which might be from ricknu-0@student.ltu.se are

origin.patch
git-alsa.patch

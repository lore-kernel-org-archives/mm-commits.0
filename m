From: akpm@linux-foundation.org
Subject: + drivers-block-z2ram-remove-true-false-defines.patch added to -mm tree
Date: Sun, 20 May 2007 20:50:17 -0700
Message-ID: <200705210350.l4L3oGvP001823@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33925 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754303AbXEUDvw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 20 May 2007 23:51:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ricknu-0@student.ltu.se


The patch titled
     drivers/block/z2ram: Remove TRUE/FALSE defines
has been added to the -mm tree.  Its filename is
     drivers-block-z2ram-remove-true-false-defines.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

git-alsa.patch
drivers-block-z2ram-remove-true-false-defines.patch

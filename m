From: akpm@linux-foundation.org
Subject: [folded-merged] mm-limit-growth-of-3%-hardcoded-other-user-reserve-v7.patch removed from -mm tree
Date: Mon, 08 Apr 2013 12:29:45 -0700
Message-ID: <20130408192945.B31A431C1B0@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ie0-f202.google.com ([209.85.223.202]:32793 "EHLO
	mail-ie0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935467Ab3DHT3s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Apr 2013 15:29:48 -0400
Received: by mail-ie0-f202.google.com with SMTP id qd14so1553396ieb.1
        for <mm-commits@vger.kernel.org>; Mon, 08 Apr 2013 12:29:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: agshew@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-limit-growth-of-3%-hardcoded-other-user-reserve-v7
has been removed from the -mm tree.  Its filename was
     mm-limit-growth-of-3%-hardcoded-other-user-reserve-v7.patch

This patch was dropped because it was folded into mm-limit-growth-of-3%-hardcoded-other-user-reserve.patch

------------------------------------------------------
From: Andrew Shewmaker <agshew@gmail.com>
Subject: mm-limit-growth-of-3%-hardcoded-other-user-reserve-v7

 * Removed sysctl.h include. It wasn't needed since I removed my
   custom handler in v5

Signed-off-by: Andrew Shewmaker <agshew@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c  |    1 -
 mm/nommu.c |    1 -
 2 files changed, 2 deletions(-)

diff -puN mm/mmap.c~mm-limit-growth-of-3%-hardcoded-other-user-reserve-v7 mm/mmap.c
--- a/mm/mmap.c~mm-limit-growth-of-3%-hardcoded-other-user-reserve-v7
+++ a/mm/mmap.c
@@ -33,7 +33,6 @@
 #include <linux/uprobes.h>
 #include <linux/rbtree_augmented.h>
 #include <linux/sched/sysctl.h>
-#include <linux/sysctl.h>
 
 #include <asm/uaccess.h>
 #include <asm/cacheflush.h>
diff -puN mm/nommu.c~mm-limit-growth-of-3%-hardcoded-other-user-reserve-v7 mm/nommu.c
--- a/mm/nommu.c~mm-limit-growth-of-3%-hardcoded-other-user-reserve-v7
+++ a/mm/nommu.c
@@ -30,7 +30,6 @@
 #include <linux/syscalls.h>
 #include <linux/audit.h>
 #include <linux/sched/sysctl.h>
-#include <linux/sysctl.h>
 
 #include <asm/uaccess.h>
 #include <asm/tlb.h>
_

Patches currently in -mm which might be from agshew@gmail.com are

mm-limit-growth-of-3%-hardcoded-other-user-reserve.patch
mm-replace-hardcoded-3%-with-admin_reserve_pages-knob.patch
mm-replace-hardcoded-3%-with-admin_reserve_pages-knob-checkpatch-fixes.patch


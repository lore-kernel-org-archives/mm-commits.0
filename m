From: akpm@linux-foundation.org
Subject: + mm-limit-growth-of-3%-hardcoded-other-user-reserve-v7.patch added to -mm tree
Date: Wed, 27 Mar 2013 15:01:00 -0700
Message-ID: <20130327220100.C4A5531C26E@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:36131 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774Ab3C0WBC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Mar 2013 18:01:02 -0400
Received: by mail-qe0-f74.google.com with SMTP id 7so588591qeb.5
        for <mm-commits@vger.kernel.org>; Wed, 27 Mar 2013 15:01:01 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: agshew@gmail.com


The patch titled
     Subject: mm-limit-growth-of-3%-hardcoded-other-user-reserve-v7
has been added to the -mm tree.  Its filename is
     mm-limit-growth-of-3%-hardcoded-other-user-reserve-v7.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mm-limit-growth-of-3%-hardcoded-other-user-reserve-checkpatch-fixes.patch
mm-limit-growth-of-3%-hardcoded-other-user-reserve-v7.patch
mm-replace-hardcoded-3%-with-admin_reserve_pages-knob.patch
mm-replace-hardcoded-3%-with-admin_reserve_pages-knob-checkpatch-fixes.patch


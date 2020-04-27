From: akpm@linux-foundation.org
Subject: +
 mm-support-vector-address-ranges-for-process_madvise-fix-fix.patch added to
 -mm tree
Date: Mon, 27 Apr 2020 13:44:05 -0700
Message-ID: <20200427204405.zEMtEWtKD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726315AbgD0UoG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 27 Apr 2020 16:44:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, mm-commits@vger.kernel.org, rdunlap@infradead.org


The patch titled
     Subject: mm-support-vector-address-ranges-for-process_madvise-fix-fix
has been added to the -mm tree.  Its filename is
     mm-support-vector-address-ranges-for-process_madvise-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-support-vector-address-ranges-for-process_madvise-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-support-vector-address-ranges-for-process_madvise-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: mm-support-vector-address-ranges-for-process_madvise-fix-fix

fix process_madvise prototype

Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/syscalls.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/syscalls.h~mm-support-vector-address-ranges-for-process_madvise-fix-fix
+++ a/include/linux/syscalls.h
@@ -876,9 +876,9 @@ asmlinkage long sys_munlockall(void);
 asmlinkage long sys_mincore(unsigned long start, size_t len,
 				unsigned char __user * vec);
 asmlinkage long sys_madvise(unsigned long start, size_t len, int behavior);

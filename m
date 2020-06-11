From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-support-vector-address-ranges-for-process_madvise-fix-fix.patch removed
 from -mm tree
Date: Wed, 10 Jun 2020 18:23:59 -0700
Message-ID: <20200611012359.1llamDJHw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726265AbgFKBYB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Jun 2020 21:24:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, mm-commits@vger.kernel.org, rdunlap@infradead.org


The patch titled
     Subject: mm-support-vector-address-ranges-for-process_madvise-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-support-vector-address-ranges-for-process_madvise-fix-fix.patch

This patch was dropped because it was folded into mm-support-vector-address-ranges-for-process_madvise.patch

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
@@ -879,9 +879,9 @@ asmlinkage long sys_munlockall(void);
 asmlinkage long sys_mincore(unsigned long start, size_t len,
 				unsigned char __user * vec);
 asmlinkage long sys_madvise(unsigned long start, size_t len, int behavior);

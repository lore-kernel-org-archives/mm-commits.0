From: akpm@linux-foundation.org
Subject: [folded-merged] gcov-support-gcc-71-v2-checkpatch-fixes.patch
 removed from -mm tree
Date: Fri, 12 May 2017 15:41:01 -0700
Message-ID: <591639fd.6EhC72aT+RfwkzjV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38360 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753257AbdELWlC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 12 May 2017 18:41:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mliska@suse.cz, oberpar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: gcov-support-gcc-71-v2-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     gcov-support-gcc-71-v2-checkpatch-fixes.patch

This patch was dropped because it was folded into gcov-support-gcc-71.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: gcov-support-gcc-71-v2-checkpatch-fixes

Cc: Martin Liska <mliska@suse.cz>
Cc: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/gcov/base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/gcov/base.c~gcov-support-gcc-71-v2-checkpatch-fixes kernel/gcov/base.c
--- a/kernel/gcov/base.c~gcov-support-gcc-71-v2-checkpatch-fixes
+++ a/kernel/gcov/base.c
@@ -98,7 +98,7 @@ void __gcov_merge_icall_topn(gcov_type *
 }
 EXPORT_SYMBOL(__gcov_merge_icall_topn);
 
-void __gcov_exit (void)
+void __gcov_exit(void)
 {
 	/* Unused. */
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

gcov-support-gcc-71.patch
mm-vmalloc-fix-vmalloc-users-tracking-properly-checkpatch-fixes.patch
tigran-has-moved.patch
mm-vmscan-scan-until-it-founds-eligible-pages-fix.patch


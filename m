From: akpm@linux-foundation.org
Subject: [merged] fault-injection-do-not-include-unneeded-header.patch removed from -mm tree
Date: Wed, 27 Jul 2011 12:29:36 -0700
Message-ID: <201107271928.p6RJSNOa003299@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57309 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754995Ab1G0T2k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jul 2011 15:28:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fault-injection: do not include unneeded header
has been removed from the -mm tree.  Its filename was
     fault-injection-do-not-include-unneeded-header.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fault-injection: do not include unneeded header
From: Akinobu Mita <akinobu.mita@gmail.com>

No need to include linux/kallsyms.h.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/fault-inject.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN lib/fault-inject.c~fault-injection-do-not-include-unneeded-header lib/fault-inject.c
--- a/lib/fault-inject.c~fault-injection-do-not-include-unneeded-header
+++ a/lib/fault-inject.c
@@ -8,7 +8,6 @@
 #include <linux/module.h>
 #include <linux/interrupt.h>
 #include <linux/stacktrace.h>
-#include <linux/kallsyms.h>
 #include <linux/fault-inject.h>
 
 /*
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
fault-injection-add-ability-to-export-fault_attr-in-arbitrary-directory.patch
linux-next.patch
ext4-use-proper-little-endian-bitops.patch
ocfs2-avoid-unaligned-access-to-dqc_bitmap.patch


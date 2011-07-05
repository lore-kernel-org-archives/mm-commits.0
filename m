From: akpm@linux-foundation.org
Subject: + fault-injection-do-not-include-unneeded-header.patch added to -mm tree
Date: Tue, 05 Jul 2011 14:24:36 -0700
Message-ID: <201107052124.p65LOaCE024959@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59944 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751608Ab1GEVYi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jul 2011 17:24:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com


The patch titled
     fault-injection: do not include unneeded header
has been added to the -mm tree.  Its filename is
     fault-injection-do-not-include-unneeded-header.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
ext4-use-proper-little-endian-bitops.patch
ocfs2-avoid-unaligned-access-to-dqc_bitmap.patch
reiserfs-use-proper-little-endian-bitops.patch
reiserfs-use-hweight_long.patch
fault-injection-do-not-include-unneeded-header.patch
fault-injection-remove-nonexistent-function-extern.patch
fault-injection-cleanup-simple-attribute-of-stacktrace_depth.patch
fault-injection-use-debugfs_remove_recursive.patch
failslab-simplify-debugfs-initialization.patch
fail_page_alloc-simplify-debugfs-initialization.patch
fail_make_request-cleanup-should_fail_request.patch
asm-generic-add-another-generic-ext2-atomic-bitops.patch


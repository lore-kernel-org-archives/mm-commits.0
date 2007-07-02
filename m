From: akpm@linux-foundation.org
Subject: - frv-fix-fallout-from-remove-schedh-from-mmh-patch.patch removed from -mm tree
Date: Mon, 02 Jul 2007 13:16:29 -0700
Message-ID: <200707022016.l62KGTWW004782@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54471 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754585AbXGBUR4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Jul 2007 16:17:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@sw.ru, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     frv: fix fallout from "remove sched.h from mm.h" patch
has been removed from the -mm tree.  Its filename was
     frv-fix-fallout-from-remove-schedh-from-mmh-patch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: frv: fix fallout from "remove sched.h from mm.h" patch
From: Alexey Dobriyan <adobriyan@sw.ru>

/home/rpjday/AMD/k/topics/0_hi/hi1.c:15: error: dereferencing pointer to incomplete type
/home/rpjday/AMD/k/topics/0_hi/hi1.c:16: error: dereferencing pointer to incomplete type

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-frv/pgtable.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-frv/pgtable.h~frv-fix-fallout-from-remove-schedh-from-mmh-patch include/asm-frv/pgtable.h
--- a/include/asm-frv/pgtable.h~frv-fix-fallout-from-remove-schedh-from-mmh-patch
+++ a/include/asm-frv/pgtable.h
@@ -25,7 +25,7 @@
 #include <linux/slab.h>
 #include <linux/list.h>
 #include <linux/spinlock.h>
-struct mm_struct;
+#include <linux/sched.h>
 struct vm_area_struct;
 #endif
 
_

Patches currently in -mm which might be from adobriyan@sw.ru are

make-proc-slabinfo-use-seq_list_xxx-helpers-fix.patch
fix-rmmod-read-write-races-in-proc-entries.patch
fix-rmmod-read-write-races-in-proc-entries-cleanup.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
proc-environ-wrong-placing-of-ptrace_may_attach-check.patch
mutex_unlock-later-in-seq_lseek.patch
seq_file-more-atomicity-in-traverse.patch

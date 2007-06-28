From: akpm@linux-foundation.org
Subject: + frv-fix-fallout-from-remove-schedh-from-mmh-patch.patch added to -mm tree
Date: Thu, 28 Jun 2007 15:12:27 -0700
Message-ID: <200706282212.l5SMCRW3002658@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40733 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763009AbXF1WNQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Jun 2007 18:13:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@sw.ru, dhowells@redhat.com


The patch titled
     frv: fix fallout from "remove sched.h from mm.h" patch
has been added to the -mm tree.  Its filename is
     frv-fix-fallout-from-remove-schedh-from-mmh-patch.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: frv: fix fallout from "remove sched.h from mm.h" patch
From: Alexey Dobriyan <adobriyan@sw.ru>

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-frv/pgtable.h |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

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

frv-fix-fallout-from-remove-schedh-from-mmh-patch.patch
sparc64-add-linux-pagemaph-to-asm-tlbh.patch
make-proc-slabinfo-use-seq_list_xxx-helpers-fix.patch
fix-rmmod-read-write-races-in-proc-entries.patch
fix-rmmod-read-write-races-in-proc-entries-cleanup.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
proc-environ-wrong-placing-of-ptrace_may_attach-check.patch
mutex_unlock-later-in-seq_lseek.patch
seq_file-more-atomicity-in-traverse.patch

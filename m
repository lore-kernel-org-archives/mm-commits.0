From: akpm@linux-foundation.org
Subject: - coredump_filter-add-description-of-bit-4.patch removed from -mm tree
Date: Thu, 18 Sep 2008 13:55:43 -0700
Message-ID: <200809182055.m8IKthLH019125@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50562 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754543AbYIRU4J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Sep 2008 16:56:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hidehiro.kawai.ez@hitachi.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     coredump_filter: add description of bit 4
has been removed from the -mm tree.  Its filename was
     coredump_filter-add-description-of-bit-4.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: coredump_filter: add description of bit 4
From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>

There is no description of bit 4 of coredump_filter in the
documentation.  This patch adds it.

Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |    2 ++
 1 file changed, 2 insertions(+)

diff -puN Documentation/filesystems/proc.txt~coredump_filter-add-description-of-bit-4 Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~coredump_filter-add-description-of-bit-4
+++ a/Documentation/filesystems/proc.txt
@@ -2413,6 +2413,8 @@ The following 4 memory types are support
   - (bit 1) anonymous shared memory
   - (bit 2) file-backed private memory
   - (bit 3) file-backed shared memory
+  - (bit 4) ELF header pages in file-backed private memory areas (it is
+            effective only if the bit 2 is cleared)
 
   Note that MMIO pages such as frame buffer are never dumped and vDSO pages
   are always dumped regardless of the bitmask status.
_

Patches currently in -mm which might be from hidehiro.kawai.ez@hitachi.com are

origin.patch
jbd-abort-when-failed-to-log-metadata-buffers.patch
jbd-fix-error-handling-for-checkpoint-io.patch
ext3-add-checks-for-errors-from-jbd.patch
jbd-dont-dirty-original-metadata-buffer-on-abort.patch
jbd-test-bh_write_eio-to-detect-errors-on-metadata-buffers.patch
ext3-add-an-option-to-control-error-handling-on-file-data.patch
jbd-ordered-data-integrity-fix.patch


From: akpm@linux-foundation.org
Subject: + coredump_filter-add-description-of-bit-4.patch added to -mm tree
Date: Mon, 08 Sep 2008 16:19:43 -0700
Message-ID: <200809082319.m88NJhhg015364@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51338 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754088AbYIHXU4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Sep 2008 19:20:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hidehiro.kawai.ez@hitachi.com, mel@csn.ul.ie, roland@redhat.com


The patch titled
     coredump_filter: add description of bit 4
has been added to the -mm tree.  Its filename is
     coredump_filter-add-description-of-bit-4.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: coredump_filter: add description of bit 4
From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>

There is no description of bit 4 of coredump_filter in the
documentation.  This patch adds it.

Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Cc: Roland McGrath <roland@redhat.com>
Cc:  Mel Gorman <mel@csn.ul.ie>
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

coredump_filter-add-description-of-bit-4.patch
jbd-abort-when-failed-to-log-metadata-buffers.patch
jbd-fix-error-handling-for-checkpoint-io.patch
ext3-add-checks-for-errors-from-jbd.patch
jbd-dont-dirty-original-metadata-buffer-on-abort.patch


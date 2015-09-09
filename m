From: akpm@linux-foundation.org
Subject: [folded-merged] proc-export-idle-flag-via-kpageflags-fix.patch
 removed from -mm tree
Date: Wed, 09 Sep 2015 15:07:41 -0700
Message-ID: <55f0adad.TcBDxL6Ch423ER0r%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56085 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020AbbIIWHm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 18:07:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc-export-idle-flag-via-kpageflags-fix
has been removed from the -mm tree.  Its filename was
     proc-export-idle-flag-via-kpageflags-fix.patch

This patch was dropped because it was folded into proc-export-idle-flag-via-kpageflags.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: proc-export-idle-flag-via-kpageflags-fix

Cc: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/pagemap.txt |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN Documentation/vm/pagemap.txt~proc-export-idle-flag-via-kpageflags-fix Documentation/vm/pagemap.txt
--- a/Documentation/vm/pagemap.txt~proc-export-idle-flag-via-kpageflags-fix
+++ a/Documentation/vm/pagemap.txt
@@ -122,9 +122,10 @@ Short descriptions to the page flags:
     zero page for pfn_zero or huge_zero page
 
 25. IDLE
-    page has not been accessed since it was marked idle (see /proc/kpageidle)
-    Note that this flag may be stale in case the page was accessed via a PTE.
-    To make sure the flag is up-to-date one has to read /proc/kpageidle first.
+    page has not been accessed since it was marked idle (see
+    Documentation/vm/idle_page_tracking.txt). Note that this flag may be
+    stale in case the page was accessed via a PTE. To make sure the flag
+    is up-to-date one has to read /sys/kernel/mm/page_idle/bitmap first.
 
     [IO related page flags]
  1. ERROR     IO error occurred
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

proc-export-idle-flag-via-kpageflags.patch
procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix.patch
procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix-fix.patch
fs-coda-fix-readlink-buffer-overflow-checkpatch-fixes.patch
kexec-split-kexec_file-syscall-code-to-kexec_filec-fix.patch
kexec-split-kexec_file-syscall-code-to-kexec_filec-fix-2.patch
kexec-split-kexec_file-syscall-code-to-kexec_filec-fix-2-fix.patch
kexec-split-kexec_file-syscall-code-to-kexec_filec-fix-2-fix-fix.patch
kexec-split-kexec_load-syscall-from-kexec-core-code-checkpatch-fixes.patch
align-crash_notes-allocation-to-make-it-be-inside-one-physical-page-fix.patch
mm-mpx-add-vm_flags_t-vm_flags-arg-to-do_mmap_pgoff-fix-checkpatch-fixes.patch


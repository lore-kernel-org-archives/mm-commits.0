From: akpm@linux-foundation.org
Subject: [folded-merged] proc-add-kpageidle-file-fix-99.patch removed from -mm tree
Date: Wed, 09 Sep 2015 15:06:21 -0700
Message-ID: <55f0ad5d.b/ilNA7lWnMdjfwd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55717 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216AbbIIWGW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 18:06:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hughd@google.com, kirill.shutemov@linux.intel.com, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kpageidle: decouple from page-flags rework
has been removed from the -mm tree.  Its filename was
     proc-add-kpageidle-file-fix-99.patch

This patch was dropped because it was folded into proc-add-kpageidle-file.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kpageidle: decouple from page-flags rework

Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN include/linux/page-flags.h~proc-add-kpageidle-file-fix-99 include/linux/page-flags.h
--- a/include/linux/page-flags.h~proc-add-kpageidle-file-fix-99
+++ a/include/linux/page-flags.h
@@ -294,10 +294,10 @@ PAGEFLAG_FALSE(HWPoison)
 #endif
 
 #if defined(CONFIG_IDLE_PAGE_TRACKING) && defined(CONFIG_64BIT)
-TESTPAGEFLAG(Young, young, PF_ANY)
-SETPAGEFLAG(Young, young, PF_ANY)
-TESTCLEARFLAG(Young, young, PF_ANY)
-PAGEFLAG(Idle, idle, PF_ANY)
+TESTPAGEFLAG(Young, young)
+SETPAGEFLAG(Young, young)
+TESTCLEARFLAG(Young, young)
+PAGEFLAG(Idle, idle)
 #endif
 
 /*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

proc-add-kpageidle-file.patch
proc-export-idle-flag-via-kpageflags-fix.patch
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


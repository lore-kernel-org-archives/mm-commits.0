From: akpm@linux-foundation.org
Subject: [folded-merged] proc-add-kpageidle-file-fix-6-fix-2-fix.patch
 removed from -mm tree
Date: Wed, 09 Sep 2015 15:06:16 -0700
Message-ID: <55f0ad58.8LSbNkpw+4wgyMUh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55708 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216AbbIIWGQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 18:06:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mhocko@kernel.org, sfr@canb.auug.org.au, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc-add-kpageidle-file-fix-6-fix-2-fix
has been removed from the -mm tree.  Its filename was
     proc-add-kpageidle-file-fix-6-fix-2-fix.patch

This patch was dropped because it was folded into proc-add-kpageidle-file.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: proc-add-kpageidle-file-fix-6-fix-2-fix

kpageidle requires an MMU

Cc: Michal Hocko <mhocko@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/Kconfig~proc-add-kpageidle-file-fix-6-fix-2-fix mm/Kconfig
--- a/mm/Kconfig~proc-add-kpageidle-file-fix-6-fix-2-fix
+++ a/mm/Kconfig
@@ -651,7 +651,7 @@ config DEFERRED_STRUCT_PAGE_INIT
 
 config IDLE_PAGE_TRACKING
 	bool "Enable idle page tracking"
-	depends on SYSFS
+	depends on SYSFS && MMU
 	select PAGE_EXTENSION if !64BIT
 	help
 	  This feature allows to estimate the amount of user pages that have
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

proc-add-kpageidle-file.patch
proc-add-kpageidle-file-fix-99.patch
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


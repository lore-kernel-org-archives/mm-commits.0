From: akpm@linux-foundation.org
Subject: - compat_binfmt_elf-definition-tweak.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:18:53 -0700
Message-ID: <200810182318.m9INIrpS029361@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53005 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752181AbYJRXSz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:18:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     COMPAT_BINFMT_ELF definition tweak
has been removed from the -mm tree.  Its filename was
     compat_binfmt_elf-definition-tweak.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: COMPAT_BINFMT_ELF definition tweak
From: Alexey Dobriyan <adobriyan@gmail.com>

Don't repeat BINFMT_ELF definition, simply multiply COMPAT and BINFMT_ELF.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Kconfig.binfmt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/Kconfig.binfmt~compat_binfmt_elf-definition-tweak fs/Kconfig.binfmt
--- a/fs/Kconfig.binfmt~compat_binfmt_elf-definition-tweak
+++ a/fs/Kconfig.binfmt
@@ -25,7 +25,7 @@ config BINFMT_ELF
 
 config COMPAT_BINFMT_ELF
 	bool
-	depends on COMPAT && MMU
+	depends on COMPAT && BINFMT_ELF
 
 config BINFMT_ELF_FDPIC
 	bool "Kernel support for FDPIC ELF binaries"
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
seq_file-dont-call-bitmap_scnprintf_len.patch
seq_file-add-seq_cpumask_list-seq_nodemask_list.patch
cpuset-use-seq_mask_-to-print-masks.patch
bitmask-remove-bitmap_scnprintf_len.patch
fs-kconfig-move-ext2-ext3-ext4-jbd-jbd2-out.patch
fs-kconfig-move-cifs-out.patch


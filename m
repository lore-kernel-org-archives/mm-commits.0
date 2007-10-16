From: akpm@linux-foundation.org
Subject: - clean-up-duplicate-includes-in-include-linux-memory_hotplugh.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:30:47 -0700
Message-ID: <200710162030.l9GKUlo3014435@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37949 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966189AbXJPVnh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:43:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.juhl@gmail.com, y-goto@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Clean up duplicate includes in include/linux/memory_hotplug.h
has been removed from the -mm tree.  Its filename was
     clean-up-duplicate-includes-in-include-linux-memory_hotplugh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Clean up duplicate includes in include/linux/memory_hotplug.h
From: Jesper Juhl <jesper.juhl@gmail.com>

This patch cleans up duplicate includes in
	include/linux/memory_hotplug.h

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Acked-by: Yasunori Goto <y-goto@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memory_hotplug.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN include/linux/memory_hotplug.h~clean-up-duplicate-includes-in-include-linux-memory_hotplugh include/linux/memory_hotplug.h
--- a/include/linux/memory_hotplug.h~clean-up-duplicate-includes-in-include-linux-memory_hotplugh
+++ a/include/linux/memory_hotplug.h
@@ -3,7 +3,6 @@
 
 #include <linux/mmzone.h>
 #include <linux/spinlock.h>
-#include <linux/mmzone.h>
 #include <linux/notifier.h>
 
 struct page;
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

origin.patch
git-alsa.patch
git-cifs.patch
mga_dma-return-err-not-just-zero-from-mga_do_cleanup_dma.patch
git-xfs.patch
clean-up-duplicate-includes-in-drivers-char.patch
clean-up-duplicate-includes-in-drivers-w1.patch
clean-up-duplicate-includes-in-fs.patch
clean-up-duplicate-includes-in-fs-ecryptfs.patch
clean-up-duplicate-includes-in-kernel.patch
avoid-a-small-unlikely-memory-leak-in-proc_read_escd.patch
docs-ramdisk-initrd-initramfs-corrections.patch
floppy-do-a-very-minimal-style-cleanup-of-the-floppy-driver.patch
floppy-remove-dead-commented-out-code-from-floppy-driver.patch
floppy-remove-register-keyword-use-from-floppy-driver.patch
clean-up-duplicate-includes-in-documentation.patch
add-a-missing-00-index-file-for-documentation-vm.patch
add-a-missing-00-index-file-for-documentation-vm-fix.patch
add-a-00-index-file-to-documentation-mips.patch
add-a-00-index-file-to-documentation-sysctl.patch
add-a-00-index-file-to-documentation-telephony.patch
mxser-fix-compiler-warning-when-building-withoug-config_pci.patch
mxser-fix-compiler-warning-when-building-withoug-config_pci-fix.patch
cyclades-avoid-label-defined-but-not-used-warning.patch

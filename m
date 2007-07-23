From: akpm@linux-foundation.org
Subject: + clean-up-duplicate-includes-in-drivers-block.patch added to -mm tree
Date: Mon, 23 Jul 2007 16:15:39 -0700
Message-ID: <200707232315.l6NNFdwg017057@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47106 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756799AbXGWXQX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 19:16:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jesper.juhl@gmail.com, jens.axboe@oracle.com, sfr@canb.auug.org.au


The patch titled
     Clean up duplicate includes in drivers/block/
has been added to the -mm tree.  Its filename is
     clean-up-duplicate-includes-in-drivers-block.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Clean up duplicate includes in drivers/block/
From: Jesper Juhl <jesper.juhl@gmail.com>

This patch cleans up duplicate includes in
	drivers/block/

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Acked-by: Stephen Rothwell <sfr@canb.auug.org.au>
Acked-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/viodasd.c |    1 -
 1 files changed, 1 deletion(-)

diff -puN drivers/block/viodasd.c~clean-up-duplicate-includes-in-drivers-block drivers/block/viodasd.c
--- a/drivers/block/viodasd.c~clean-up-duplicate-includes-in-drivers-block
+++ a/drivers/block/viodasd.c
@@ -41,7 +41,6 @@
 #include <linux/dma-mapping.h>
 #include <linux/completion.h>
 #include <linux/device.h>
-#include <linux/kernel.h>
 
 #include <asm/uaccess.h>
 #include <asm/vio.h>
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

fix-use-after-free--double-free-bug-in-amd_create_gatt_pages--amd_free_gatt_pages.patch
fix-use-after-free--double-free-bug-in-ati_create_gatt_pages--ati_free_gatt_pages.patch
git-gfs2-nmw.patch
hid-fix-a-null-pointer-dereference-when-we-fail-to-allocate-memory.patch
git-kbuild.patch
git-mtd.patch
git-selinux.patch
git-xfs.patch
ipmi-fix-mem-leak-in-try_init_dmi.patch
fix-a-use-after-free-bug-in-kernel-userspace-relay-file-support.patch
floppy-do-a-very-minimal-style-cleanup-of-the-floppy-driver.patch
floppy-remove-dead-commented-out-code-from-floppy-driver.patch
floppy-remove-register-keyword-use-from-floppy-driver.patch
clean-up-duplicate-includes-in-documentation.patch
clean-up-duplicate-includes-in-arch-i386-xen.patch
clean-up-duplicate-includes-in-drivers-atm.patch
clean-up-duplicate-includes-in-drivers-block.patch
clean-up-duplicate-includes-in-drivers-char.patch
clean-up-duplicate-includes-in-drivers-hwmon.patch
clean-up-duplicate-includes-in-drivers-input.patch
clean-up-duplicate-includes-in-drivers-media.patch
clean-up-duplicate-includes-in-drivers-mtd.patch
clean-up-duplicate-includes-in-drivers-net.patch
clean-up-duplicate-includes-in-drivers-scsi.patch
clean-up-duplicate-includes-in-drivers-spi.patch
clean-up-duplicate-includes-in-drivers-usb.patch
clean-up-duplicate-includes-in-drivers-w1.patch
clean-up-duplicate-includes-in-fs.patch
clean-up-duplicate-includes-in-fs-ecryptfs.patch
clean-up-duplicate-includes-in-fs-gfs2.patch
clean-up-duplicate-includes-in-fs-ntfs.patch
clean-up-duplicate-includes-in-include-media.patch
clean-up-duplicate-includes-in-include-linux-memory_hotplugh.patch
clean-up-duplicate-includes-in-include-linux-nfs_fsh.patch
clean-up-duplicate-includes-in-kernel.patch
clean-up-duplicate-includes-in-mm.patch
clean-up-duplicate-includes-in-net-atm.patch
clean-up-duplicate-includes-in-net-bridge.patch
clean-up-duplicate-includes-in-net-ipv4.patch
clean-up-duplicate-includes-in-net-ipv6.patch
clean-up-duplicate-includes-in-net-netfilter.patch
clean-up-duplicate-includes-in-net-sched.patch
clean-up-duplicate-includes-in-net-sunrpc.patch
clean-up-duplicate-includes-in-net-tipc.patch
clean-up-duplicate-includes-in-net-xfrm.patch
clean-up-duplicate-includes-in-sound-core.patch
clean-up-duplicate-includes-in-sound-ppc.patch
clean-up-duplicate-includes-in-sound-soc.patch

From: akpm@linux-foundation.org
Subject: - clean-up-duplicate-includes-in-drivers-usb.patch removed from -mm tree
Date: Tue, 31 Jul 2007 13:30:18 -0700
Message-ID: <200707312030.l6VKUIF9020960@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54843 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764996AbXGaUbJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 16:31:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.juhl@gmail.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     Clean up duplicate includes in drivers/usb/
has been removed from the -mm tree.  Its filename was
     clean-up-duplicate-includes-in-drivers-usb.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Clean up duplicate includes in drivers/usb/
From: Jesper Juhl <jesper.juhl@gmail.com>

This patch cleans up duplicate includes in
	drivers/usb/

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/host/u132-hcd.c |    1 -
 1 files changed, 1 deletion(-)

diff -puN drivers/usb/host/u132-hcd.c~clean-up-duplicate-includes-in-drivers-usb drivers/usb/host/u132-hcd.c
--- a/drivers/usb/host/u132-hcd.c~clean-up-duplicate-includes-in-drivers-usb
+++ a/drivers/usb/host/u132-hcd.c
@@ -51,7 +51,6 @@
 #include <linux/usb.h>
 #include <linux/workqueue.h>
 #include <linux/platform_device.h>
-#include <linux/pci_ids.h>
 #include <linux/mutex.h>
 #include <asm/io.h>
 #include <asm/irq.h>
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

origin.patch
various-doc-kernel-parameters-fixes.patch
m68knommu-get-rid-of-duplicate-include.patch
ipmi-fix-mem-leak-in-try_init_dmi.patch
fix-a-use-after-free-bug-in-kernel-userspace-relay-file-support.patch
cciss-fix-memory-leak.patch
git-alsa.patch
fix-use-after-free--double-free-bug-in-amd_create_gatt_pages--amd_free_gatt_pages.patch
powerpc-clean-out-a-bunch-of-duplicate-includes.patch
git-dvb.patch
git-hwmon.patch
git-gfs2-nmw.patch
git-hid.patch
ia64-remove-a-few-duplicate-includes.patch
clean-up-duplicate-includes-in-drivers-input.patch
mips-remove-some-duplicate-includes.patch
git-mtd.patch
clean-up-duplicate-includes-in-drivers-net.patch
clean-up-duplicate-includes-in-drivers-atm.patch
clean-up-duplicate-includes-in-net-atm.patch
clean-up-duplicate-includes-in-net-ipv4.patch
clean-up-duplicate-includes-in-net-ipv6.patch
clean-up-duplicate-includes-in-net-sched.patch
clean-up-duplicate-includes-in-net-sunrpc.patch
clean-up-duplicate-includes-in-net-tipc.patch
clean-up-duplicate-includes-in-net-xfrm.patch
dccp-fix-memory-leak-and-clean-up-style-dccp_feat_empty_confirm.patch
clean-up-duplicate-includes-in-include-linux-nfs_fsh.patch
clean-up-duplicate-includes-in-fs-ntfs.patch
sh64-arch-sh64-kernel-signalh-duplicate-include-removal.patch
clean-up-duplicate-includes-in-drivers-scsi.patch
clean-up-duplicate-includes-in-drivers-block.patch
clean-up-duplicate-includes-in-arch-i386-xen.patch
clean-up-duplicate-includes-in-include-linux-memory_hotplugh.patch
clean-up-duplicate-includes-in-mm.patch
clean-up-duplicate-includes-in-drivers-char.patch
clean-up-duplicate-includes-in-drivers-w1.patch
clean-up-duplicate-includes-in-fs.patch
clean-up-duplicate-includes-in-fs-ecryptfs.patch
clean-up-duplicate-includes-in-kernel.patch
clean-up-duplicate-includes-in-drivers-spi.patch
floppy-do-a-very-minimal-style-cleanup-of-the-floppy-driver.patch
floppy-remove-dead-commented-out-code-from-floppy-driver.patch
floppy-remove-register-keyword-use-from-floppy-driver.patch
clean-up-duplicate-includes-in-documentation.patch

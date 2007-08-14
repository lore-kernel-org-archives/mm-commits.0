From: akpm@linux-foundation.org
Subject: - clean-up-duplicate-includes-in-net-sunrpc.patch removed from -mm tree
Date: Tue, 14 Aug 2007 12:12:37 -0700
Message-ID: <200708141912.l7EJCbdv016419@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54820 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933942AbXHNTVf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 15:21:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.juhl@gmail.com, neilb@suse.de, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     Clean up duplicate includes in net/sunrpc/
has been removed from the -mm tree.  Its filename was
     clean-up-duplicate-includes-in-net-sunrpc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Clean up duplicate includes in net/sunrpc/
From: Jesper Juhl <jesper.juhl@gmail.com>

This patch cleans up duplicate includes in
	net/sunrpc/

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sunrpc/auth_gss/svcauth_gss.c |    1 -
 1 files changed, 1 deletion(-)

diff -puN net/sunrpc/auth_gss/svcauth_gss.c~clean-up-duplicate-includes-in-net-sunrpc net/sunrpc/auth_gss/svcauth_gss.c
--- a/net/sunrpc/auth_gss/svcauth_gss.c~clean-up-duplicate-includes-in-net-sunrpc
+++ a/net/sunrpc/auth_gss/svcauth_gss.c
@@ -42,7 +42,6 @@
 #include <linux/pagemap.h>
 
 #include <linux/sunrpc/auth_gss.h>
-#include <linux/sunrpc/svcauth.h>
 #include <linux/sunrpc/gss_err.h>
 #include <linux/sunrpc/svcauth.h>
 #include <linux/sunrpc/svcauth_gss.h>
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

origin.patch
git-alsa.patch
git-agpgart.patch
fix-use-after-free--double-free-bug-in-amd_create_gatt_pages--amd_free_gatt_pages.patch
powerpc-clean-out-a-bunch-of-duplicate-includes.patch
mga_dma-return-err-not-just-zero-from-mga_do_cleanup_dma.patch
git-dvb.patch
git-gfs2-nmw.patch
clean-up-duplicate-includes-in-drivers-input.patch
scripts-ver_linux-correct-printing-of-binutils-version.patch
improve-scripts-gcc-versionsh-output-a-bit-when-called-without-args.patch
git-mtd.patch
git-ubi.patch
git-netdev-all.patch
git-backlight.patch
clean-up-duplicate-includes-in-include-linux-nfs_fsh.patch
clean-up-duplicate-includes-in-fs-ntfs.patch
sh64-arch-sh64-kernel-signalh-duplicate-include-removal.patch
clean-up-duplicate-includes-in-drivers-scsi.patch
mpt-fusion-fix-two-potential-mem-leaks.patch
fix-a-potential-null-pointer-deref-in-the-aic7xxx-ahc_print_register-function.patch
git-xfs.patch
fix-a-potential-null-pointer-deref-in-xfs-on-failed-mount.patch
clean-up-duplicate-includes-in-include-linux-memory_hotplugh.patch
clean-up-duplicate-includes-in-mm.patch
clean-up-duplicate-includes-in-drivers-char.patch
clean-up-duplicate-includes-in-drivers-w1.patch
clean-up-duplicate-includes-in-fs.patch
clean-up-duplicate-includes-in-fs-ecryptfs.patch
clean-up-duplicate-includes-in-kernel.patch
avoid-a-small-unlikely-memory-leak-in-proc_read_escd.patch
clean-up-duplicate-includes-in-drivers-spi.patch
fix-possible-null-deref-on-low-memory-condition-in-capidrvcsend_message.patch
isdn-guard-against-a-potential-null-pointer-dereference-in-old_capi_manufacturer.patch
floppy-do-a-very-minimal-style-cleanup-of-the-floppy-driver.patch
floppy-remove-dead-commented-out-code-from-floppy-driver.patch
floppy-remove-register-keyword-use-from-floppy-driver.patch
clean-up-duplicate-includes-in-documentation.patch

From: akpm@linux-foundation.org
Subject: + clean-up-duplicate-includes-in-fs-gfs2.patch added to -mm tree
Date: Mon, 23 Jul 2007 16:16:07 -0700
Message-ID: <200707232316.l6NNG7Or017106@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42296 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754037AbXGWX0P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 19:26:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jesper.juhl@gmail.com


The patch titled
     Clean up duplicate includes in fs/gfs2/
has been added to the -mm tree.  Its filename is
     clean-up-duplicate-includes-in-fs-gfs2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Clean up duplicate includes in fs/gfs2/
From: Jesper Juhl <jesper.juhl@gmail.com>

This patch cleans up duplicate includes in
	fs/gfs2/

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/gfs2/glock.c                |    2 --
 fs/gfs2/locking/dlm/lock_dlm.h |    1 -
 fs/gfs2/locking/nolock/main.c  |    1 -
 3 files changed, 4 deletions(-)

diff -puN fs/gfs2/glock.c~clean-up-duplicate-includes-in-fs-gfs2 fs/gfs2/glock.c
--- a/fs/gfs2/glock.c~clean-up-duplicate-includes-in-fs-gfs2
+++ a/fs/gfs2/glock.c
@@ -25,8 +25,6 @@
 #include <asm/uaccess.h>
 #include <linux/seq_file.h>
 #include <linux/debugfs.h>
-#include <linux/module.h>
-#include <linux/kallsyms.h>
 
 #include "gfs2.h"
 #include "incore.h"
diff -puN fs/gfs2/locking/dlm/lock_dlm.h~clean-up-duplicate-includes-in-fs-gfs2 fs/gfs2/locking/dlm/lock_dlm.h
--- a/fs/gfs2/locking/dlm/lock_dlm.h~clean-up-duplicate-includes-in-fs-gfs2
+++ a/fs/gfs2/locking/dlm/lock_dlm.h
@@ -13,7 +13,6 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
-#include <linux/module.h>
 #include <linux/types.h>
 #include <linux/string.h>
 #include <linux/list.h>
diff -puN fs/gfs2/locking/nolock/main.c~clean-up-duplicate-includes-in-fs-gfs2 fs/gfs2/locking/nolock/main.c
--- a/fs/gfs2/locking/nolock/main.c~clean-up-duplicate-includes-in-fs-gfs2
+++ a/fs/gfs2/locking/nolock/main.c
@@ -9,7 +9,6 @@
 
 #include <linux/module.h>
 #include <linux/slab.h>
-#include <linux/module.h>
 #include <linux/init.h>
 #include <linux/types.h>
 #include <linux/fs.h>
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

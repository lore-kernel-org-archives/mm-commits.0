From: akpm@linux-foundation.org
Subject: - clean-up-duplicate-includes-in-fs.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:53:42 -0700
Message-ID: <200710180653.l9I6rgiY030460@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60926 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932118AbXJRHhi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:37:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.juhl@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Clean up duplicate includes in fs/
has been removed from the -mm tree.  Its filename was
     clean-up-duplicate-includes-in-fs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Clean up duplicate includes in fs/
From: Jesper Juhl <jesper.juhl@gmail.com>

This patch cleans up duplicate includes in
	fs/

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/compat_ioctl.c |    1 -
 fs/namei.c        |    1 -
 2 files changed, 2 deletions(-)

diff -puN fs/compat_ioctl.c~clean-up-duplicate-includes-in-fs fs/compat_ioctl.c
--- a/fs/compat_ioctl.c~clean-up-duplicate-includes-in-fs
+++ a/fs/compat_ioctl.c
@@ -108,7 +108,6 @@
 #include <linux/dvb/dmx.h>
 #include <linux/dvb/frontend.h>
 #include <linux/dvb/video.h>
-#include <linux/lp.h>
 
 #ifdef CONFIG_SPARC
 #include <asm/fbio.h>
diff -puN fs/namei.c~clean-up-duplicate-includes-in-fs fs/namei.c
--- a/fs/namei.c~clean-up-duplicate-includes-in-fs
+++ a/fs/namei.c
@@ -30,7 +30,6 @@
 #include <linux/capability.h>
 #include <linux/file.h>
 #include <linux/fcntl.h>
-#include <linux/namei.h>
 #include <asm/namei.h>
 #include <asm/uaccess.h>
 
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

origin.patch
git-cifs.patch
mga_dma-return-err-not-just-zero-from-mga_do_cleanup_dma.patch
mxser-fix-compiler-warning-when-building-withoug-config_pci.patch
mxser-fix-compiler-warning-when-building-withoug-config_pci-fix.patch
cyclades-avoid-label-defined-but-not-used-warning.patch

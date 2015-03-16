From: akpm@linux-foundation.org
Subject: + fs-fat-remove-unnecessary-includes-fix-2.patch added to -mm
 tree
Date: Mon, 16 Mar 2015 14:14:26 -0700
Message-ID: <550747b2.Mun6ifDze8EsAdVY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35325 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932182AbbCPVO1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Mar 2015 17:14:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, hirofumi@mail.parknet.co.jp, kuleshovmail@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/fat: put one actually necessary include file back
has been added to the -mm tree.  Its filename is
     fs-fat-remove-unnecessary-includes-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-fat-remove-unnecessary-includes-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-fat-remove-unnecessary-includes-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: fs/fat: put one actually necessary include file back

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Alexander Kuleshov <kuleshovmail@gmail.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/inode.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/fat/inode.c~fs-fat-remove-unnecessary-includes-fix-2 fs/fat/inode.c
--- a/fs/fat/inode.c~fs-fat-remove-unnecessary-includes-fix-2
+++ a/fs/fat/inode.c
@@ -17,6 +17,7 @@
 #include <linux/vfs.h>
 #include <linux/seq_file.h>
 #include <linux/parser.h>
+#include <linux/uio.h>
 #include <linux/blkdev.h>
 #include <asm/unaligned.h>
 #include "fat.h"
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

mm-cma-release-trigger-fixpatch.patch
lib-add-huge-i-o-map-capability-interfaces-fix.patch
mm-change-ioremap-to-set-up-huge-i-o-mappings-fix.patch
zsmalloc-support-compaction-fix.patch
fs-fat-remove-unnecessary-includes-fix-2.patch
linux-next.patch
kernel-forkc-export-kernel_thread-to-modules.patch


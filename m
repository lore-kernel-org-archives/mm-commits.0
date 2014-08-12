From: akpm@linux-foundation.org
Subject: [merged] fs-cramfs-inodec-use-linux-uaccessh.patch removed from
 -mm tree
Date: Tue, 12 Aug 2014 12:41:08 -0700
Message-ID: <53ea6dd4.P5S00yMg2c+AT0KW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f74.google.com ([209.85.220.74]:38003 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755000AbaHLTlI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:41:08 -0400
Received: by mail-pa0-f74.google.com with SMTP id lj1so2671893pab.3
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:41:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, sasha.levin@oracle.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/cramfs/inode.c: use linux/uaccess.h
has been removed from the -mm tree.  Its filename was
     fs-cramfs-inodec-use-linux-uaccessh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/cramfs/inode.c: use linux/uaccess.h

Fixes checkpatch warning:

WARNING: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cramfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/cramfs/inode.c~fs-cramfs-inodec-use-linux-uaccessh fs/cramfs/inode.c
--- a/fs/cramfs/inode.c~fs-cramfs-inodec-use-linux-uaccessh
+++ a/fs/cramfs/inode.c
@@ -23,7 +23,7 @@
 #include <linux/vfs.h>
 #include <linux/mutex.h>
 #include <uapi/linux/cramfs_fs.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 #include "internal.h"
 
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-cifs-remove-obsolete-__constant.patch
fs-cifs-filec-replace-countsize-kzalloc-by-kcalloc.patch
fs-cifs-smb2filec-replace-countsize-kzalloc-by-kcalloc.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-isofs-logging-clean-up.patch
fs-isofs-logging-clean-up-fix.patch
linux-next.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch


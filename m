From: akpm@linux-foundation.org
Subject: [merged] zsmalloc-add-fsh-include.patch removed from -mm
 tree
Date: Fri, 12 Jan 2018 13:43:59 -0800
Message-ID: <20180112214359.Ekol7-alE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54768 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965189AbeALVoI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 12 Jan 2018 16:44:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, mm-commits@vger.kernel.org, sergey.senozhatsky.work@gmail.com, sergey.senozhatsky@gmail.com


The patch titled
     Subject: mm/zsmalloc.c: include fs.h
has been removed from the -mm tree.  Its filename was
     zsmalloc-add-fsh-include.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: mm/zsmalloc.c: include fs.h

`struct file_system_type' and alloc_anon_inode() function are defined in
fs.h, include it directly.

Link: http://lkml.kernel.org/r/20171219104219.3017-1-sergey.senozhatsky@gmail.com
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/zsmalloc.c~zsmalloc-add-fsh-include mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-add-fsh-include
+++ a/mm/zsmalloc.c
@@ -53,6 +53,7 @@
 #include <linux/mount.h>
 #include <linux/migrate.h>
 #include <linux/pagemap.h>
+#include <linux/fs.h>
 
 #define ZSPAGE_MAGIC	0x58
 
_

Patches currently in -mm which might be from sergey.senozhatsky.work@gmail.com are

mm-remove-unneeded-kallsyms-include.patch
hrtimer-remove-unneeded-kallsyms-include.patch
genirq-remove-unneeded-kallsyms-include.patch


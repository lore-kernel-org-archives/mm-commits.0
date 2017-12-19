From: akpm@linux-foundation.org
Subject: + zsmalloc-add-fsh-include.patch added to -mm tree
Date: Tue, 19 Dec 2017 15:39:13 -0800
Message-ID: <5a39a321.UIjGVTXFxdGTr6tD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35844 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753421AbdLSXjP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 19 Dec 2017 18:39:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky.work@gmail.com, minchan@kernel.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zsmalloc.c: include fs.h
has been added to the -mm tree.  Its filename is
     zsmalloc-add-fsh-include.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zsmalloc-add-fsh-include.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zsmalloc-add-fsh-include.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

zsmalloc-add-fsh-include.patch
mm-remove-unneeded-kallsyms-include.patch
pci-remove-unneeded-kallsyms-include.patch
hrtimer-remove-unneeded-kallsyms-include.patch
genirq-remove-unneeded-kallsyms-include.patch


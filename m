From: akpm@linux-foundation.org
Subject: [merged]
 printkc-comments-should-refer-to-proc-vmcore-instead-of-proc-vmcoreinfo.patch removed from -mm tree
Date: Wed, 13 Nov 2013 12:40:22 -0800
Message-ID: <5283e3b6.ku80ljymvRncO4ad%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42919 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720Ab3KMUkX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:40:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com, dirk@gouders.net

Subject: [merged] printkc-comments-should-refer-to-proc-vmcore-instead-of-proc-vmcoreinfo.patch removed from -mm tree
To: dirk@gouders.net,joe@perches.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:40:22 -0800


The patch titled
     Subject: printk.c: comments should refer to /proc/vmcore instead of /proc/vmcoreinfo
has been removed from the -mm tree.  Its filename was
     printkc-comments-should-refer-to-proc-vmcore-instead-of-proc-vmcoreinfo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dirk Gouders <dirk@gouders.net>
Subject: printk.c: comments should refer to /proc/vmcore instead of /proc/vmcoreinfo

In one of those comments a typo was fixed, too.

Signed-off-by: Dirk Gouders <dirk@gouders.net>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/printk/printk.c~printkc-comments-should-refer-to-proc-vmcore-instead-of-proc-vmcoreinfo kernel/printk/printk.c
--- a/kernel/printk/printk.c~printkc-comments-should-refer-to-proc-vmcore-instead-of-proc-vmcoreinfo
+++ a/kernel/printk/printk.c
@@ -705,9 +705,9 @@ const struct file_operations kmsg_fops =
 
 #ifdef CONFIG_KEXEC
 /*
- * This appends the listed symbols to /proc/vmcoreinfo
+ * This appends the listed symbols to /proc/vmcore
  *
- * /proc/vmcoreinfo is used by various utiilties, like crash and makedumpfile to
+ * /proc/vmcore is used by various utilities, like crash and makedumpfile to
  * obtain access to symbols that are otherwise very difficult to locate.  These
  * symbols are specifically used so that utilities can access and extract the
  * dmesg log from a vmcore file after a crash.
_

Patches currently in -mm which might be from dirk@gouders.net are

origin.patch


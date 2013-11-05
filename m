From: akpm@linux-foundation.org
Subject: +
 printkc-comments-should-refer-to-proc-vmcore-instead-of-proc-vmcoreinfo.patch added to -mm tree
Date: Tue, 05 Nov 2013 14:53:05 -0800
Message-ID: <527976d1.eoTe2Lg0/meA+frH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59101 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755762Ab3KEWxG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Nov 2013 17:53:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com, dirk@gouders.net

Subject: + printkc-comments-should-refer-to-proc-vmcore-instead-of-proc-vmcoreinfo.patch added to -mm tree
To: dirk@gouders.net,joe@perches.com
From: akpm@linux-foundation.org
Date: Tue, 05 Nov 2013 14:53:05 -0800


The patch titled
     Subject: printk.c: comments should refer to /proc/vmcore instead of /proc/vmcoreinfo
has been added to the -mm tree.  Its filename is
     printkc-comments-should-refer-to-proc-vmcore-instead-of-proc-vmcoreinfo.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/printkc-comments-should-refer-to-proc-vmcore-instead-of-proc-vmcoreinfo.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/printkc-comments-should-refer-to-proc-vmcore-instead-of-proc-vmcoreinfo.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

printkc-comments-should-refer-to-proc-vmcore-instead-of-proc-vmcoreinfo.patch


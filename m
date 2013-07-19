From: akpm@linux-foundation.org
Subject: +
 printk-move-to-separate-directory-for-easier-modification-fix.patch added
 to -mm tree
Date: Thu, 18 Jul 2013 18:58:34 -0700
Message-ID: <51e89d4a.EzMm4kY3e/JyyINM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37437 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759441Ab3GSB6q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 18 Jul 2013 21:58:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fengguang.wu@intel.com, joe@perches.com

Subject: + printk-move-to-separate-directory-for-easier-modification-fix.patch added to -mm tree
To: joe@perches.com,fengguang.wu@intel.com
From: akpm@linux-foundation.org
Date: Thu, 18 Jul 2013 18:58:33 -0700


The patch titled
     Subject: docproc: Move printk file location
has been added to the -mm tree.  Its filename is
     printk-move-to-separate-directory-for-easier-modification-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/printk-move-to-separate-directory-for-easier-modification-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/printk-move-to-separate-directory-for-easier-modification-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: docproc: Move printk file location

> docproc: kernel/printk.c: No such file or directory

So rename the file.

Signed-off-by: Joe Perches <joe@perches.com>
Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/device-drivers.tmpl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/DocBook/device-drivers.tmpl~printk-move-to-separate-directory-for-easier-modification-fix Documentation/DocBook/device-drivers.tmpl
--- a/Documentation/DocBook/device-drivers.tmpl~printk-move-to-separate-directory-for-easier-modification-fix
+++ a/Documentation/DocBook/device-drivers.tmpl
@@ -84,7 +84,7 @@ X!Iinclude/linux/kobject.h
 
      <sect1><title>Kernel utility functions</title>
 !Iinclude/linux/kernel.h
-!Ekernel/printk.c
+!Ekernel/printk/printk.c
 !Ekernel/panic.c
 !Ekernel/sys.c
 !Ekernel/rcupdate.c
_

Patches currently in -mm which might be from joe@perches.com are

maintainers-dynamic-debug-jasons-not-there.patch
printk-move-to-separate-directory-for-easier-modification.patch
printk-move-to-separate-directory-for-easier-modification-fix.patch
printk-add-console_cmdlineh.patch
printk-move-braille-console-support-into-separate-braille-files.patch
printk-use-pointer-for-console_cmdline-indexing.patch
printk-rename-struct-log-to-struct-printk_log.patch
firmware-dmi_scan-drop-obsolete-comment.patch
firmware-dmi_scan-fix-most-checkpatch-errors-and-warnings.patch
firmware-dmi_scan-constify-strings.patch
firmware-dmi_scan-drop-oom-messages.patch
linux-next.patch


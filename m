From: akpm@linux-foundation.org
Subject: + pc-fs-char_devc-remove-useless-loop-fix.patch added to -mm tree
Date: Thu, 06 Aug 2009 18:38:04 -0700
Message-ID: <200908070138.n771c4P0001758@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55484 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752166AbZHGBib (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Aug 2009 21:38:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hidave.darkstar@gmail.com, renzo@cs.unibo.it, viro@zeniv.linux.org.uk


The patch titled
     pc-fs-char_devc-remove-useless-loop-fix
has been added to the -mm tree.  Its filename is
     pc-fs-char_devc-remove-useless-loop-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pc-fs-char_devc-remove-useless-loop-fix
From: Dave Young <hidave.darkstar@gmail.com>

Fix build warning about the unused variable in char_dev.c:267

Remove the unused char *s.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Cc: Renzo Davoli <renzo@cs.unibo.it>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/char_dev.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/char_dev.c~pc-fs-char_devc-remove-useless-loop-fix fs/char_dev.c
--- a/fs/char_dev.c~pc-fs-char_devc-remove-useless-loop-fix
+++ a/fs/char_dev.c
@@ -264,7 +264,6 @@ int register_chrdev(unsigned int major, 
 {
 	struct char_device_struct *cd;
 	struct cdev *cdev;
-	char *s;
 	int err = -ENOMEM;
 
 	cd = __register_chrdev_region(major, 0, 256, name);
_

Patches currently in -mm which might be from hidave.darkstar@gmail.com are

origin.patch
fbcon-dont-use-vc_resize-on-initialization.patch
linux-next.patch
bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse.patch
printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec.patch
printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec-fix.patch
printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec-fix-2.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-fix.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-cleanup.patch
pc-fs-char_devc-remove-useless-loop-fix.patch


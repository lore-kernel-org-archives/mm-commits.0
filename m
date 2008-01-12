From: akpm@linux-foundation.org
Subject: + nuke-duplicate-include-from-printkc.patch added to -mm tree
Date: Fri, 11 Jan 2008 16:39:29 -0800
Message-ID: <200801120039.m0C0dTLU005949@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37849 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762573AbYALAje (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jan 2008 19:39:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jesper.juhl@gmail.com


The patch titled
     Nuke duplicate include from printk.c
has been added to the -mm tree.  Its filename is
     nuke-duplicate-include-from-printkc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Nuke duplicate include from printk.c
From: Jesper Juhl <jesper.juhl@gmail.com>

Remove the duplicate inclusion of linux/jiffies.h from kernel/printk.c

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN kernel/printk.c~nuke-duplicate-include-from-printkc kernel/printk.c
--- a/kernel/printk.c~nuke-duplicate-include-from-printkc
+++ a/kernel/printk.c
@@ -32,7 +32,6 @@
 #include <linux/security.h>
 #include <linux/bootmem.h>
 #include <linux/syscalls.h>
-#include <linux/jiffies.h>
 
 #include <asm/uaccess.h>
 
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

git-drm.patch
git-kbuild.patch
git-ubi.patch
git-x86.patch
nuke-duplicate-include-from-printkc.patch
nuke-a-duplicate-include-from-profilec.patch
nuke-duplicate-header-from-sysctlc.patch

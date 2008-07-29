From: akpm@linux-foundation.org
Subject: + linux-fsh-include-linux-pathh.patch added to -mm tree
Date: Mon, 28 Jul 2008 21:01:08 -0700
Message-ID: <200807290401.m6T418Bl013107@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36916 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750764AbYG2EBk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 00:01:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: niels.devos@wincor-nixdorf.com, viro@zeniv.linux.org.uk


The patch titled
     linux/fs.h: include linux/path.h
has been added to the -mm tree.  Its filename is
     linux-fsh-include-linux-pathh.patch

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
Subject: linux/fs.h: include linux/path.h
From: Niels de Vos <niels.devos@wincor-nixdorf.com>

In linux/fs.h 'struct path' is being used. Therefore linux/path.h should
be included.

Signed-off-by: Niels de Vos <niels.devos@wincor-nixdorf.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/fs.h~linux-fsh-include-linux-pathh include/linux/fs.h
--- a/include/linux/fs.h~linux-fsh-include-linux-pathh
+++ a/include/linux/fs.h
@@ -8,6 +8,7 @@
 
 #include <linux/limits.h>
 #include <linux/ioctl.h>
+#include <linux/path.h>
 
 /*
  * It's silly to have NR_OPEN bigger than NR_FILE, but you can change
_

Patches currently in -mm which might be from niels.devos@wincor-nixdorf.com are

origin.patch
linux-fsh-include-linux-pathh.patch


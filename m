From: akpm@linux-foundation.org
Subject: + mn10300-remove-duplicated-include.patch added to -mm tree
Date: Mon, 13 Jul 2009 14:21:41 -0700
Message-ID: <200907132121.n6DLLfE0029281@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56998 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755596AbZGMVW0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 13 Jul 2009 17:22:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: weiyi.huang@gmail.com, dhowells@redhat.com


The patch titled
     mn10300: remove duplicated #include
has been added to the -mm tree.  Its filename is
     mn10300-remove-duplicated-include.patch

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
Subject: mn10300: remove duplicated #include
From: Huang Weiyi <weiyi.huang@gmail.com>

Remove duplicated #include('s) in
  arch/mn10300/kernel/sys_mn10300.c

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mn10300/kernel/sys_mn10300.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/mn10300/kernel/sys_mn10300.c~mn10300-remove-duplicated-include arch/mn10300/kernel/sys_mn10300.c
--- a/arch/mn10300/kernel/sys_mn10300.c~mn10300-remove-duplicated-include
+++ a/arch/mn10300/kernel/sys_mn10300.c
@@ -20,7 +20,6 @@
 #include <linux/mman.h>
 #include <linux/file.h>
 #include <linux/utsname.h>
-#include <linux/syscalls.h>
 #include <linux/tty.h>
 
 #include <asm/uaccess.h>
_

Patches currently in -mm which might be from weiyi.huang@gmail.com are

origin.patch
linux-next.patch
mn10300-remove-duplicated-include.patch


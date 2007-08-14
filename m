From: akpm@linux-foundation.org
Subject: + h8300-missing-include.patch added to -mm tree
Date: Tue, 14 Aug 2007 12:42:50 -0700
Message-ID: <200708141942.l7EJgo5i017755@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48437 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934912AbXHNTnF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 15:43:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ysato@users.sourceforge.jp


The patch titled
     h8300: missing include
has been added to the -mm tree.  Its filename is
     h8300-missing-include.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: h8300: missing include
From: Yoshinori Sato <ysato@users.sourceforge.jp>

Build error fix.

Signed-off-by: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/h8300/kernel/process.c   |    1 +
 arch/h8300/kernel/sys_h8300.c |    1 +
 2 files changed, 2 insertions(+)

diff -puN arch/h8300/kernel/process.c~h8300-missing-include arch/h8300/kernel/process.c
--- a/arch/h8300/kernel/process.c~h8300-missing-include
+++ a/arch/h8300/kernel/process.c
@@ -37,6 +37,7 @@
 #include <linux/a.out.h>
 #include <linux/interrupt.h>
 #include <linux/reboot.h>
+#include <linux/fs.h>
 
 #include <asm/uaccess.h>
 #include <asm/system.h>
diff -puN arch/h8300/kernel/sys_h8300.c~h8300-missing-include arch/h8300/kernel/sys_h8300.c
--- a/arch/h8300/kernel/sys_h8300.c~h8300-missing-include
+++ a/arch/h8300/kernel/sys_h8300.c
@@ -18,6 +18,7 @@
 #include <linux/mman.h>
 #include <linux/file.h>
 #include <linux/utsname.h>
+#include <linux/fs.h>
 
 #include <asm/setup.h>
 #include <asm/uaccess.h>
_

Patches currently in -mm which might be from ysato@users.sourceforge.jp are

h8300-missing-include.patch

From: akpm@linux-foundation.org
Subject: - h8300-missing-include.patch removed from -mm tree
Date: Fri, 24 Aug 2007 13:55:45 -0700
Message-ID: <200708242055.l7OKtjTm013981@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60693 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756825AbXHXU42 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 16:56:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ysato@users.sourceforge.jp, mm-commits@vger.kernel.org


The patch titled
     h8300: missing include
has been removed from the -mm tree.  Its filename was
     h8300-missing-include.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

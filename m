From: akpm@linux-foundation.org
Subject: [merged] mn10300-remove-duplicated-include.patch removed from -mm tree
Date: Tue, 14 Jul 2009 13:33:37 -0700
Message-ID: <200907142033.n6EKXbC5013763@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58393 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756351AbZGNUdw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Jul 2009 16:33:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: weiyi.huang@gmail.com, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mn10300: remove duplicated #include
has been removed from the -mm tree.  Its filename was
     mn10300-remove-duplicated-include.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch


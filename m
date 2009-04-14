From: akpm@linux-foundation.org
Subject: [merged] sysrq-remove-duplicated-include.patch removed from -mm tree
Date: Tue, 14 Apr 2009 12:49:26 -0700
Message-ID: <200904141949.n3EJnQ3X019649@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53422 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753308AbZDNTun (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Apr 2009 15:50:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: weiyi.huang@gmail.com, mm-commits@vger.kernel.org


The patch titled
     sysrq: remove duplicated #include
has been removed from the -mm tree.  Its filename was
     sysrq-remove-duplicated-include.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysrq: remove duplicated #include
From: Huang Weiyi <weiyi.huang@gmail.com>

Remove duplicated #include in drivers/char/sysrq.c.

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/sysrq.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/char/sysrq.c~sysrq-remove-duplicated-include drivers/char/sysrq.c
--- a/drivers/char/sysrq.c~sysrq-remove-duplicated-include
+++ a/drivers/char/sysrq.c
@@ -35,7 +35,6 @@
 #include <linux/vt_kern.h>
 #include <linux/workqueue.h>
 #include <linux/kexec.h>
-#include <linux/interrupt.h>
 #include <linux/hrtimer.h>
 #include <linux/oom.h>
 
_

Patches currently in -mm which might be from weiyi.huang@gmail.com are

origin.patch
linux-next.patch


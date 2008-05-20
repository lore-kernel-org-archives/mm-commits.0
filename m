From: akpm@linux-foundation.org
Subject: - rcu-remove-duplicated-include-in-kernel-rcupreemptc.patch removed from -mm tree
Date: Tue, 20 May 2008 14:14:31 -0700
Message-ID: <200805202114.m4KLEVgo011472@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42607 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761595AbYETVPB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 17:15:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: weiyi.huang@gmail.com, mm-commits@vger.kernel.org


The patch titled
     rcu: remove duplicated include in kernel/rcupreempt.c
has been removed from the -mm tree.  Its filename was
     rcu-remove-duplicated-include-in-kernel-rcupreemptc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rcu: remove duplicated include in kernel/rcupreempt.c
From: Huang Weiyi <weiyi.huang@gmail.com>

Removed duplicated include file <linux/rcupdate.h> in kernel/rcupreempt.c.

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/rcupreempt.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN kernel/rcupreempt.c~rcu-remove-duplicated-include-in-kernel-rcupreemptc kernel/rcupreempt.c
--- a/kernel/rcupreempt.c~rcu-remove-duplicated-include-in-kernel-rcupreemptc
+++ a/kernel/rcupreempt.c
@@ -50,7 +50,6 @@
 #include <linux/moduleparam.h>
 #include <linux/percpu.h>
 #include <linux/notifier.h>
-#include <linux/rcupdate.h>
 #include <linux/cpu.h>
 #include <linux/random.h>
 #include <linux/delay.h>
_

Patches currently in -mm which might be from weiyi.huang@gmail.com are

linux-next.patch


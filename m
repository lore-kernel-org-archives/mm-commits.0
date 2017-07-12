From: akpm@linux-foundation.org
Subject: [folded-merged]
 fault-inject-support-systematic-fault-injection-fix.patch removed from -mm
 tree
Date: Wed, 12 Jul 2017 14:16:44 -0700
Message-ID: <596691bc.1t9GTui4vUKaZJwm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52150 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753343AbdGLVQp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jul 2017 17:16:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, akinobu.mita@gmail.com, dvyukov@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fault-inject-support-systematic-fault-injection-fix
has been removed from the -mm tree.  Its filename was
     fault-inject-support-systematic-fault-injection-fix.patch

This patch was dropped because it was folded into fault-inject-support-systematic-fault-injection.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fault-inject-support-systematic-fault-injection-fix

fix build

Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/base.c~fault-inject-support-systematic-fault-injection-fix fs/proc/base.c
--- a/fs/proc/base.c~fault-inject-support-systematic-fault-injection-fix
+++ a/fs/proc/base.c
@@ -1374,7 +1374,7 @@ static ssize_t proc_fail_nth_write(struc
 	if (n < 0 || n == INT_MAX)
 		return -EINVAL;
 	current->fail_nth = n + 1;
-	return len;
+	return count;
 }
 
 static ssize_t proc_fail_nth_read(struct file *file, char __user *buf,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

fault-inject-support-systematic-fault-injection.patch
powerpc-64s-implement-arch-specific-hardlockup-watchdog-checkpatch-fixes.patch
mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic-fix.patch


From: akpm@linux-foundation.org
Subject: [folded-merged]
 support-resetting-warn_once-for-all-architectures-v2-fix-fix.patch removed
 from -mm tree
Date: Fri, 17 Nov 2017 15:12:19 -0800
Message-ID: <5a0f6cd3.YklZlp7wJ3j4CMgk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53596 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966887AbdKQXMU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Nov 2017 18:12:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ak@linux.intel.com, mpe@ellerman.id.au, mm-commits@vger.kernel.org


The patch titled
     Subject: support-resetting-warn_once-for-all-architectures-v2-fix-fix
has been removed from the -mm tree.  Its filename was
     support-resetting-warn_once-for-all-architectures-v2-fix-fix.patch

This patch was dropped because it was folded into support-resetting-warn_once-for-all-architectures.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: support-resetting-warn_once-for-all-architectures-v2-fix-fix

Use 0200 for clear_warn_once file, per mpe

Cc: Andi Kleen <ak@linux.intel.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/panic.c~support-resetting-warn_once-for-all-architectures-v2-fix-fix kernel/panic.c
--- a/kernel/panic.c~support-resetting-warn_once-for-all-architectures-v2-fix-fix
+++ a/kernel/panic.c
@@ -608,7 +608,7 @@ DEFINE_SIMPLE_ATTRIBUTE(clear_warn_once_
 static __init int register_warn_debugfs(void)
 {
 	/* Don't care about failure */
-	debugfs_create_file("clear_warn_once", 0644, NULL,
+	debugfs_create_file("clear_warn_once", 0200, NULL,
 			    NULL, &clear_warn_once_fops);
 	return 0;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

support-resetting-warn_once-for-all-architectures.patch
support-resetting-warn_once-for-all-architectures-v2-fix-fix-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
watchdog-core-make-use-of-devm_register_reboot_notifier-fix.patch
sysvipc-unteach-ids-next_id-for-checkpoint_restore-checkpatch-fixes.patch
sysvipc-make-get_maxid-o1-again-checkpatch-fixes.patch


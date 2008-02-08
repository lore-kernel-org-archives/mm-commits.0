From: akpm@linux-foundation.org
Subject: - proc-remove-module_license.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:11:48 -0800
Message-ID: <200802082011.m18KBTm4010119@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53837 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752154AbYBHUoz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:44:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@sw.ru, mm-commits@vger.kernel.org


The patch titled
     proc: remove MODULE_LICENSE
has been removed from the -mm tree.  Its filename was
     proc-remove-module_license.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc: remove MODULE_LICENSE
From: Alexey Dobriyan <adobriyan@sw.ru>

proc is not modular, so MODULE_LICENSE just expands to empty space.  proc
without doubts remains GPLed.

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/inode.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/proc/inode.c~proc-remove-module_license fs/proc/inode.c
--- a/fs/proc/inode.c~proc-remove-module_license
+++ a/fs/proc/inode.c
@@ -467,4 +467,3 @@ out_no_root:
 	de_put(&proc_root);
 	return -ENOMEM;
 }
-MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from adobriyan@sw.ru are

origin.patch
single_open-seq_release-leak-diagnostics.patch

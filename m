From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Mon, 08 Aug 2016 13:14:53 -0700
Message-ID: <57a8e83d.DfvTYYj0UXINLTo8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37346 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318AbcHHUOz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Aug 2016 16:14:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/jump_label.c |   11 -----------
 1 file changed, 11 deletions(-)

diff -puN kernel/jump_label.c~linux-next-git-rejects kernel/jump_label.c
--- a/kernel/jump_label.c~linux-next-git-rejects
+++ a/kernel/jump_label.c
@@ -279,19 +279,8 @@ void __init jump_label_init(void)
 	struct static_key *key = NULL;
 	struct jump_entry *iter;
 
-<<<<<<< HEAD
-	/*
-	 * Since we are initializing the static_key.enabled field with
-	 * with the 'raw' int values (to avoid pulling in atomic.h) in
-	 * jump_label.h, let's make sure that is safe. There are only two
-	 * cases to check since we initialize to 0 or 1.
-	 */
-	BUILD_BUG_ON((int)ATOMIC_INIT(0) != 0);
-	BUILD_BUG_ON((int)ATOMIC_INIT(1) != 1);
-=======
 	if (static_key_initialized)
 		return;
->>>>>>> linux-next/akpm-base
 
 	jump_label_lock();
 	jump_label_sort_entries(iter_start, iter_stop);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch


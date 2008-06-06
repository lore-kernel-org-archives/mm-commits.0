From: akpm@linux-foundation.org
Subject: - proc-calculate-the-correct-proc-pid-link-count-cleanup.patch removed from -mm tree
Date: Thu, 05 Jun 2008 21:01:27 -0700
Message-ID: <200806060401.m5641RBp012256@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46693 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750758AbYFFEBd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jun 2008 00:01:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, adobriyan@gmail.com, davem@davemloft.net, ebiederm@xmission.com, vegard.nossum@gmail.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     proc-calculate-the-correct-proc-pid-link-count-cleanup
has been removed from the -mm tree.  Its filename was
     proc-calculate-the-correct-proc-pid-link-count-cleanup.patch

This patch was dropped because it was folded into proc-calculate-the-correct-proc-pid-link-count.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc-calculate-the-correct-proc-pid-link-count-cleanup
From: Andrew Morton <akpm@linux-foundation.org>

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Vegard Nossum <vegard.nossum@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN fs/proc/base.c~proc-calculate-the-correct-proc-pid-link-count-cleanup fs/proc/base.c
--- a/fs/proc/base.c~proc-calculate-the-correct-proc-pid-link-count-cleanup
+++ a/fs/proc/base.c
@@ -127,8 +127,10 @@ struct pid_entry {
 		NULL, &proc_single_file_operations,	\
 		{ .proc_show = &proc_##OTYPE } )
 
-/* Count the number of hardlinks for the pid_entry table, excluding the .
- * and .. links. */
+/*
+ * Count the number of hardlinks for the pid_entry table, excluding the .
+ * and .. links.
+ */
 static unsigned int pid_entry_count_dirs(const struct pid_entry *entries,
 	unsigned int n)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

pagemap-fix-bug-in-add_to_pagemap-require-aligned-length-reads-of-proc-pid-pagemap-v2-of-series-checkpatch-fixes.patch
rtc-class-driver-for-ppc_md-rtc-functions.patch
proc-calculate-the-correct-proc-pid-link-count.patch
proc-calculate-the-correct-proc-pid-link-count-cleanup.patch


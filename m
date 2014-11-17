From: akpm@linux-foundation.org
Subject: [merged] kernel-panic-update-comments-for-print_tainted.patch
 removed from -mm tree
Date: Mon, 17 Nov 2014 12:51:03 -0800
Message-ID: <546a5fb7.Yu1ZYryzG9N69kEK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51039 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755AbaKQUvE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Nov 2014 15:51:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiexiuqi@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/panic.c: update comments for print_tainted
has been removed from the -mm tree.  Its filename was
     kernel-panic-update-comments-for-print_tainted.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xie XiuQi <xiexiuqi@huawei.com>
Subject: kernel/panic.c: update comments for print_tainted

Commit 69361eef9056 ("panic: add TAINT_SOFTLOCKUP") added the 'L' flag,
but failed to update the comments for print_tainted().  So, update the
comments.

Signed-off-by: Xie XiuQi <xiexiuqi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/panic.c~kernel-panic-update-comments-for-print_tainted kernel/panic.c
--- a/kernel/panic.c~kernel-panic-update-comments-for-print_tainted
+++ a/kernel/panic.c
@@ -244,6 +244,7 @@ static const struct tnt tnts[] = {
  *  'I' - Working around severe firmware bug.
  *  'O' - Out-of-tree module has been loaded.
  *  'E' - Unsigned module has been loaded.
+ *  'L' - A soft lockup has previously occurred.
  *
  *	The string is overwritten by the next call to print_tainted().
  */
_

Patches currently in -mm which might be from xiexiuqi@huawei.com are

linux-next.patch


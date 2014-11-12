From: akpm@linux-foundation.org
Subject: + kernel-panic-update-comments-for-print_tainted.patch added to
 -mm tree
Date: Wed, 12 Nov 2014 15:07:42 -0800
Message-ID: <5463e83e.l6Wk3zhCJObLvQdz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49955 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147AbaKLXHn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Nov 2014 18:07:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiexiuqi@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/panic.c: update comments for print_tainted
has been added to the -mm tree.  Its filename is
     kernel-panic-update-comments-for-print_tainted.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-panic-update-comments-for-print_tainted.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/kernel-panic-update-comments-for-print_tainted.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xie XiuQi <xiexiuqi@huawei.com>
Subject: kernel/panic.c: update comments for print_tainted

Commits 69361eef9056 ("panic: add TAINT_SOFTLOCKUP") added the 'L' flag,
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
@@ -246,6 +246,7 @@ static const struct tnt tnts[] = {
  *  'I' - Working around severe firmware bug.
  *  'O' - Out-of-tree module has been loaded.
  *  'E' - Unsigned module has been loaded.
+ *  'L' - A soft lockup has previously occurred.
  *
  *	The string is overwritten by the next call to print_tainted().
  */
_

Patches currently in -mm which might be from xiexiuqi@huawei.com are

kernel-panic-update-comments-for-print_tainted.patch


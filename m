From: akpm@linux-foundation.org
Subject: +
 ocfs2-o2net-should-remove-debugfs-in-o2net_init-out-branch.patch added to
 -mm tree
Date: Fri, 22 May 2015 12:27:05 -0700
Message-ID: <555f8309.aqdpuKTXQsoo8GP6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46940 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756720AbbEVT1G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 May 2015 15:27:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.chen@huawei.com, jlbec@evilplan.org, joseph.qi@huawei.com, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: o2net: should remove debugfs in o2net_init() out branch
has been added to the -mm tree.  Its filename is
     ocfs2-o2net-should-remove-debugfs-in-o2net_init-out-branch.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-o2net-should-remove-debugfs-in-o2net_init-out-branch.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-o2net-should-remove-debugfs-in-o2net_init-out-branch.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: alex chen <alex.chen@huawei.com>
Subject: ocfs2: o2net: should remove debugfs in o2net_init() out branch

Signed-off-by: Alex Chen <alex.chen@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/tcp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ocfs2/cluster/tcp.c~ocfs2-o2net-should-remove-debugfs-in-o2net_init-out-branch fs/ocfs2/cluster/tcp.c
--- a/fs/ocfs2/cluster/tcp.c~ocfs2-o2net-should-remove-debugfs-in-o2net_init-out-branch
+++ a/fs/ocfs2/cluster/tcp.c
@@ -2204,7 +2204,7 @@ out:
 	kfree(o2net_hand);
 	kfree(o2net_keep_req);
 	kfree(o2net_keep_resp);

From: akpm@linux-foundation.org
Subject: [merged] kernel-fix-generic_exec_single-indication.patch removed
 from -mm tree
Date: Fri, 15 Nov 2013 12:09:21 -0800
Message-ID: <52867f71.dKfL1eoegKjB06h5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35813 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290Ab3KOUJV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Nov 2013 15:09:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jack@suse.cz, hch@lst.de, axboe@kernel.dk, hch@infradead.org

Subject: [merged] kernel-fix-generic_exec_single-indication.patch removed from -mm tree
To: hch@infradead.org,axboe@kernel.dk,hch@lst.de,jack@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 15 Nov 2013 12:09:21 -0800


The patch titled
     Subject: kernel: fix generic_exec_single indentation
has been removed from the -mm tree.  Its filename was
     kernel-fix-generic_exec_single-indication.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@infradead.org>
Subject: kernel: fix generic_exec_single indentation

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/smp.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN kernel/smp.c~kernel-fix-generic_exec_single-indication kernel/smp.c
--- a/kernel/smp.c~kernel-fix-generic_exec_single-indication
+++ a/kernel/smp.c
@@ -139,8 +139,7 @@ static void csd_unlock(struct call_singl
  * for execution on the given CPU. data must already have
  * ->func, ->info, and ->flags set.
  */
-static
-void generic_exec_single(int cpu, struct call_single_data *csd, int wait)
+static void generic_exec_single(int cpu, struct call_single_data *csd, int wait)
 {
 	struct call_single_queue *dst = &per_cpu(call_single_queue, cpu);
 	unsigned long flags;
_

Patches currently in -mm which might be from hch@infradead.org are

origin.patch
kernel-use-lockless-list-for-smp_call_function_single.patch
blk-mq-use-__smp_call_function_single-directly.patch
linux-next.patch


From: akpm@linux-foundation.org
Subject: + kernel-fix-generic_exec_single-indication.patch added to -mm
 tree
Date: Fri, 01 Nov 2013 14:58:18 -0700
Message-ID: <527423fa.4ZpfPUgPMBAVTChN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54828 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754136Ab3KAV6T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Nov 2013 17:58:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jack@suse.cz, hch@lst.de, axboe@kernel.dk, hch@infradead.org

Subject: + kernel-fix-generic_exec_single-indication.patch added to -mm tree
To: hch@infradead.org,axboe@kernel.dk,hch@lst.de,jack@suse.cz
From: akpm@linux-foundation.org
Date: Fri, 01 Nov 2013 14:58:18 -0700


The patch titled
     Subject: kernel: fix generic_exec_single indentation
has been added to the -mm tree.  Its filename is
     kernel-fix-generic_exec_single-indication.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-fix-generic_exec_single-indication.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-fix-generic_exec_single-indication.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

hfsplus-add-metadata-files-clump-size-calculation-functionality.patch
hfsplus-implement-attributes-files-header-node-initialization-code.patch
hfsplus-implement-attributes-files-header-node-initialization-code-v2.patch
hfsplus-implement-attributes-file-creation-functionality.patch
hfsplus-implement-attributes-file-creation-functionality-v2.patch
linux-next.patch
revert-softirq-add-support-for-triggering-softirq-work-on-softirqs.patch
kernel-remove-config_use_generic_smp_helpers.patch
kernel-provide-a-__smp_call_function_single-stub-for-config_smp.patch
kernel-fix-generic_exec_single-indication.patch
llists-move-llist_reverse_order-from-raid5-to-llistc.patch
kernel-use-lockless-list-for-smp_call_function_single.patch
blk-mq-use-__smp_call_function_single-directly.patch


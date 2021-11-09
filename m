Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FE3BC433F5
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:14:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B8BC6117A
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:14:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238813AbhKICQq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 21:16:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:44552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234245AbhKICQo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Nov 2021 21:16:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A18696117A;
        Tue,  9 Nov 2021 02:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636424039;
        bh=44iyBSTecncaeC1p9rESKrIKNjXopv1tNyz7VXupW7Q=;
        h=Date:From:To:Subject:From;
        b=ZGkz/pEhKT3f+45Ogs1UREEL2hPV/o2YmdeZwdf5ElSOl0e1iKzKDDi7qsRatYy2P
         hddvVO+s8VwA9k/eboI+4s/AW1kIgwHPxLbq5xdv/j9C9oByZOY4NJTShs2EdIVlq9
         fuVImmN5RF6pOAJ/ahWPkZVKuHWC4I6ZcZFGcQmg=
Date:   Mon, 08 Nov 2021 18:13:59 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        mm-commits@vger.kernel.org
Subject:  [folded-merged]
 generic-radix-tree-replace-kernelh-with-the-necessary-inclusions-fix.patch
 removed from -mm tree
Message-ID: <20211109021359._YqIt6SUX%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: generic-radix-tree-replace-kernelh-with-the-necessary-inclusions-fix
has been removed from the -mm tree.  Its filename was
     generic-radix-tree-replace-kernelh-with-the-necessary-inclusions-fix.patch

This patch was dropped because it was folded into generic-radix-tree-replace-kernelh-with-the-necessary-inclusions.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: generic-radix-tree-replace-kernelh-with-the-necessary-inclusions-fix

include math.h for round_up()

Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/generic-radix-tree.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/generic-radix-tree.h~generic-radix-tree-replace-kernelh-with-the-necessary-inclusions-fix
+++ a/include/linux/generic-radix-tree.h
@@ -39,6 +39,7 @@
 #include <asm/page.h>
 #include <linux/bug.h>
 #include <linux/log2.h>
+#include <linux/math.h>
 #include <linux/types.h>
 
 struct genradix_root;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

generic-radix-tree-replace-kernelh-with-the-necessary-inclusions.patch
ipc-check-checkpoint_restore_ns_capable-to-modify-c-r-proc-files-fix.patch
kasan-test-use-underlying-string-helpers-checkpatch-fixes.patch
mm-bdi-initialize-bdi_min_ratio-when-bdi-unregister-fix.patch
mm.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
revert-acct_reclaim_writeback-for-next.patch
mm-filemap-check-if-thp-has-hwpoisoned-subpage-for-pmd-page-fault-vs-folios.patch
mm-page_ownerc-modify-the-type-of-argument-order-in-some-functions-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch


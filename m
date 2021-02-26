Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 264F0C433DB
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 00:44:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2BC064F2D
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 00:44:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbhBZAoG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 19:44:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:60774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229954AbhBZAoE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 19:44:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A35EE64F22;
        Fri, 26 Feb 2021 00:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614300203;
        bh=epY0ARUwfqgwru6vSS6vAe38zgskd1MtanttovJVz7k=;
        h=Date:From:To:Subject:From;
        b=o6vWNUDzRk6P680vd12+G0XfXegZcyEtxJIeas3xRsPlnUv+TPtaejNNKDL7lK3bq
         Dswzti6mrLm+DF4OW6VoKqB++n06sBgu56CIgP7uYambjFLS3KXiYBPOzswCzVMqtX
         766iT+KdsgU+SCCsa8bMEnI8le+Yb8XCJtO+vuUk=
Date:   Thu, 25 Feb 2021 16:43:23 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, daniel.vetter@ffwll.ch,
        daniel.vetter@intel.com, lkp@intel.com, mm-commits@vger.kernel.org
Subject:  [folded-merged] bdi-use-might_alloc-fix.patch removed
 from -mm tree
Message-ID: <20210226004323.K-QZlZe0-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: bdi-use-might_alloc-fix
has been removed from the -mm tree.  Its filename was
     bdi-use-might_alloc-fix.patch

This patch was dropped because it was folded into bdi-use-might_alloc.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: bdi-use-might_alloc-fix

include linux/sched/mm.h

Reported-by: kernel test robot <lkp@intel.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Daniel Vetter <daniel.vetter@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/backing-dev.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/backing-dev.c~bdi-use-might_alloc-fix
+++ a/mm/backing-dev.c
@@ -8,6 +8,7 @@
 #include <linux/fs.h>
 #include <linux/pagemap.h>
 #include <linux/mm.h>
+#include <linux/sched/mm.h>
 #include <linux/sched.h>
 #include <linux/module.h>
 #include <linux/writeback.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

bdi-use-might_alloc.patch
kfence-kasan-make-kfence-compatible-with-kasan-fix.patch
lib-stackdepot-add-support-to-disable-stack-depot-fix.patch
seq_file-document-how-per-entry-resources-are-managed-fix.patch
initramfs-panic-with-memory-information-fix.patch
mm-page_allocc-refactor-initialization-of-struct-page-for-holes-in-memory-layout-fix.patch
mm.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch


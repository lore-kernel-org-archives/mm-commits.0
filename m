Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E43CFC11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:01:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB3EB61425
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:01:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238432AbhGABDy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:03:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:59162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238423AbhGABDx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:03:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA65361424;
        Thu,  1 Jul 2021 01:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625101283;
        bh=9yUIh7Zbg8aEFpci0d1ftG0gPvbEDxEaog7/VR82akc=;
        h=Date:From:To:Subject:From;
        b=uVtbyIahnTuT+ybwYjseZz6Wv7IUmM8BYQ2FjxDUtl8i4zMGZyqGFpwgPW1LoTTzI
         CSIjVaY0SmFr8rDZ0mW2d/JkjCKb6/CBswXFKvXqty9ylcb4paNezAxKlKg5zbvldH
         WPMzb7OxrkjYIXGIb16G0zw9vRXj4zJFpo1oLh60=
Date:   Wed, 30 Jun 2021 18:01:23 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        mm-commits@vger.kernel.org
Subject:  [folded-merged]
 kernelh-split-out-panic-and-oops-helpers-fix.patch removed from -mm tree
Message-ID: <20210701010123.LiCviCVfx%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernelh-split-out-panic-and-oops-helpers-fix
has been removed from the -mm tree.  Its filename was
     kernelh-split-out-panic-and-oops-helpers-fix.patch

This patch was dropped because it was folded into kernelh-split-out-panic-and-oops-helpers.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kernelh-split-out-panic-and-oops-helpers-fix

thread_info.h needs limits.h

Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/thread_info.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/thread_info.h~kernelh-split-out-panic-and-oops-helpers-fix
+++ a/include/linux/thread_info.h
@@ -9,6 +9,7 @@
 #define _LINUX_THREAD_INFO_H
 
 #include <linux/types.h>
+#include <linux/limits.h>
 #include <linux/bug.h>
 #include <linux/restart_block.h>
 #include <linux/errno.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kernelh-split-out-panic-and-oops-helpers.patch
lib-math-rational-add-kunit-test-cases-fix.patch
lib-decompressors-remove-set-but-not-used-variabled-level-fix.patch
ipc-utilc-use-binary-search-for-max_idx-fix.patch
mm.patch
lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable-fix.patch
linux-next-pre.patch
linux-next-post.patch
linux-next-rejects.patch
kernel-cgroup-cgroupc-dont-export-cgroup_get_e_css-twice.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch


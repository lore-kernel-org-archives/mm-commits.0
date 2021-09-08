Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6BA9C433FE
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:17:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B134B6103D
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:17:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346389AbhIHCSk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 22:18:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:58114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346910AbhIHCSk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 22:18:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 078426103D;
        Wed,  8 Sep 2021 02:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631067453;
        bh=V6k915Lmeshn0SE/Pt1jLZUi/QG2sllHxltYAR7NMVY=;
        h=Date:From:To:Subject:From;
        b=dcau89ZUyTeRFwXRtnFH/nBqrpYRwJCctuAqUnx6Fd6sms3kV8NT9Pd0O3leHz7pQ
         VSE82PbdzM+zidlcG1edCcazraRck6lbht4IuWgZZm03NvI84bnrqVr6sK5FuK2Epb
         2d+tDeYMUCuL2cw3eHiHjF5H1eKN5Bui9cd3N3v4=
Date:   Tue, 07 Sep 2021 19:17:32 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        sjpark@amazon.de
Subject:  [folded-merged]
 mm-idle_page_tracking-make-pg_idle-reusable-fix-fix.patch removed from -mm
 tree
Message-ID: <20210908021732.rBZgHIwu7%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-idle_page_tracking-make-pg_idle-reusable-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-idle_page_tracking-make-pg_idle-reusable-fix-fix.patch

This patch was dropped because it was folded into mm-idle_page_tracking-make-pg_idle-reusable.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-idle_page_tracking-make-pg_idle-reusable-fix-fix

tweak Kconfig text

Cc: SeongJae Park <sjpark@amazon.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/Kconfig~mm-idle_page_tracking-make-pg_idle-reusable-fix-fix
+++ a/mm/Kconfig
@@ -743,9 +743,9 @@ config PAGE_IDLE_FLAG
 	bool "Add PG_idle and PG_young flags"
 	select PAGE_EXTENSION if !64BIT
 	help
-	  This feature adds PG_idle and PG_young flags in 'struct page'.  PTE
-	  Accessed bit writers can set the state of the bit in the flags to let
-	  other PTE Accessed bit readers don't disturbed.
+	  This adds PG_idle and PG_young flags to 'struct page'.  PTE Accessed
+	  bit writers can set the state of the bit in the flags so that PTE
+	  Accessed bit readers may avoid disturbance.
 
 config IDLE_PAGE_TRACKING
 	bool "Enable idle page tracking"
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-idle_page_tracking-make-pg_idle-reusable.patch
mm-damon-implement-primitives-for-the-virtual-memory-address-spaces-fix.patch
mm-damon-implement-a-debugfs-based-user-space-interface-fix.patch
mm-damon-implement-a-debugfs-based-user-space-interface-fix-fix.patch
checkpatch-improve-git_commit_id-test-fix.patch
fs-epoll-use-a-per-cpu-counter-for-users-watches-count-fix-fix.patch
log-if-a-core-dump-is-aborted-due-to-changed-file-permissions-fix.patch
mm.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch


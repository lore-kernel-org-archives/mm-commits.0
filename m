Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 212E2C32771
	for <mm-commits@archiver.kernel.org>; Fri, 19 Aug 2022 21:51:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231424AbiHSVv1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 Aug 2022 17:51:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231168AbiHSVv0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 19 Aug 2022 17:51:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 073B8B5E5B
        for <mm-commits@vger.kernel.org>; Fri, 19 Aug 2022 14:51:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8CEEE617AB
        for <mm-commits@vger.kernel.org>; Fri, 19 Aug 2022 21:51:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E27FDC433D6;
        Fri, 19 Aug 2022 21:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660945885;
        bh=OXMkd80hs2E3pYU05ffeDtzcyrIKmKwRfCBQY7ize5M=;
        h=Date:To:From:Subject:From;
        b=UE311Y4dywSrVti+w//xfUZC4oPV/W2tnvNmJQ9XbRioMYVwYh0sBORer2uGIErQw
         ATIrGjQ5OTUeLEOKaLWMXyIdvcGq6vuCN4/NBLqfWHBewzArKc1JMzzSK6K/hH/ec5
         /K/flLv36MAop56tHRZwRhD8egkbw0+8irShDlRw=
Date:   Fri, 19 Aug 2022 14:51:24 -0700
To:     mm-commits@vger.kernel.org, treding@nvidia.com,
        quanyang.wang@windriver.com, arnd@arndb.de, ardb@kernel.org,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + asm-generic-sections-refactor-memory_intersects-fix.patch added to mm-unstable branch
Message-Id: <20220819215124.E27FDC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: asm-generic-sections-refactor-memory_intersects-fix
has been added to the -mm mm-unstable branch.  Its filename is
     asm-generic-sections-refactor-memory_intersects-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/asm-generic-sections-refactor-memory_intersects-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: asm-generic-sections-refactor-memory_intersects-fix
Date: Fri Aug 19 02:49:53 PM PDT 2022

fix nearby comment typo

Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Quanyang Wang <quanyang.wang@windriver.com>
Cc: Thierry Reding <treding@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/sections.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/asm-generic/sections.h~asm-generic-sections-refactor-memory_intersects-fix
+++ a/include/asm-generic/sections.h
@@ -97,7 +97,7 @@ static inline bool memory_contains(void
 /**
  * memory_intersects - checks if the region occupied by an object intersects
  *                     with another memory region
- * @begin: virtual address of the beginning of the memory regien
+ * @begin: virtual address of the beginning of the memory region
  * @end: virtual address of the end of the memory region
  * @virt: virtual address of the memory object
  * @size: size of the memory object
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

procfs-add-path-to-proc-pid-fdinfo-fix.patch
zsmalloc-zs_object_copy-add-clarifying-comment-fix.patch
mm-oom_kill-add-trace-logs-in-process_mrelease-system-call-fix.patch
zsmalloc-zs_object_copy-replace-email-link-to-doc-checkpatch-fixes.patch
mm-demotion-add-support-for-explicit-memory-tiers-fix.patch
asm-generic-sections-refactor-memory_intersects-fix.patch


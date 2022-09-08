Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D29AAC54EE9
	for <mm-commits@archiver.kernel.org>; Thu,  8 Sep 2022 22:32:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbiIHWcL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 8 Sep 2022 18:32:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbiIHWcK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 8 Sep 2022 18:32:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33026F6B99
        for <mm-commits@vger.kernel.org>; Thu,  8 Sep 2022 15:32:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C2350B8229C
        for <mm-commits@vger.kernel.org>; Thu,  8 Sep 2022 22:32:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56CB0C433C1;
        Thu,  8 Sep 2022 22:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662676326;
        bh=rx2pXYN1cJXwJEQpWG9HIJrKjqRl5HVUKB+Rxc8SKXA=;
        h=Date:To:From:Subject:From;
        b=Yc+atY+aKzz0MsP65OcsCWUPnWtRFPu5Y24X9UMyawwyXVV2Ic3/ab1y/SxF2apO7
         FaFRCmZlWXvu/hqxk0nYOBD6SFjtUiTqOtDNbjJEHIpTUBVxyL/+kWn+mB3dtyV1gd
         O5oQtLDL/49EiUyuuXYzwQBSfrN+uMxMHvyBPCXc=
Date:   Thu, 08 Sep 2022 15:32:05 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, kaixuxia@tencent.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-vaddr-add-a-comment-for-default-case-in-damon_va_apply_scheme-fix.patch added to mm-unstable branch
Message-Id: <20220908223206.56CB0C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-damon-vaddr-add-a-comment-for-default-case-in-damon_va_apply_scheme-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-vaddr-add-a-comment-for-default-case-in-damon_va_apply_scheme-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-vaddr-add-a-comment-for-default-case-in-damon_va_apply_scheme-fix.patch

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
Subject: mm-damon-vaddr-add-a-comment-for-default-case-in-damon_va_apply_scheme-fix
Date: Thu Sep  8 03:31:21 PM PDT 2022

fx comment grammar

Cc: Kaixu Xia <kaixuxia@tencent.com>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/vaddr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/vaddr.c~mm-damon-vaddr-add-a-comment-for-default-case-in-damon_va_apply_scheme-fix
+++ a/mm/damon/vaddr.c
@@ -659,7 +659,7 @@ static unsigned long damon_va_apply_sche
 		return 0;
 	default:
 		/*
-		 * DAMOS actions that not yet supported by 'vaddr'.
+		 * DAMOS actions that are not yet supported by 'vaddr'.
 		 */
 		return 0;
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-fix-race-condition-between-build_all_zonelists-and-page-allocation-fix.patch
procfs-add-path-to-proc-pid-fdinfo-fix.patch
zsmalloc-zs_object_copy-add-clarifying-comment-fix.patch
mm-gupc-simplify-and-fix-check_and_migrate_movable_pages-return-codes-fix-fix.patch
mm-oom_kill-add-trace-logs-in-process_mrelease-system-call-fix.patch
zsmalloc-zs_object_copy-replace-email-link-to-doc-checkpatch-fixes.patch
zsmalloc-zs_object_copy-replace-email-link-to-doc-fix.patch
mm-demotion-add-support-for-explicit-memory-tiers-fix.patch
mm-demotion-update-node_is_toptier-to-work-with-memory-tiers-fix-2.patch
mm-drop-oom-code-from-exit_mmap-fix-fix.patch
mm-delete-unused-mmf_oom_victim-flag-vs-mglru.patch
mm-add-merging-after-mremap-resize-checkpatch-fixes.patch
mm-gupc-refactor-check_and_migrate_movable_pages-fix.patch
mm-reduce-noise-in-show_mem-for-lowmem-allocations-vs-mapletree.patch
mm-reduce-noise-in-show_mem-for-lowmem-allocations-vs-mapletree-fix.patch
page_ext-introduce-boot-parameter-early_page_ext-fix.patch
mm-fix-null-ptr-deref-in-kswapd_is_running-fix.patch
mm-vmscan-fix-a-lot-of-comments-vs-mglru.patch
swap-add-swap_cache_get_folio-fix.patch
mm-damon-vaddr-add-a-comment-for-default-case-in-damon_va_apply_scheme-fix.patch
ia64-fix-clock_getresclock_monotonic-to-report-itc-frequency-checkpatch-fixes.patch


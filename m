Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69364C07E9D
	for <mm-commits@archiver.kernel.org>; Thu, 29 Sep 2022 04:03:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234289AbiI2EDv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 29 Sep 2022 00:03:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbiI2EDs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 29 Sep 2022 00:03:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4065125DBF
        for <mm-commits@vger.kernel.org>; Wed, 28 Sep 2022 21:03:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 712A4B82208
        for <mm-commits@vger.kernel.org>; Thu, 29 Sep 2022 04:03:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3A12C433D6;
        Thu, 29 Sep 2022 04:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664424225;
        bh=oJik9euFyEFmwkd1c5sQ1w9pkkShWFBnx2MveTQvUAw=;
        h=Date:To:From:Subject:From;
        b=xglARkTOm1VX2SFxo8Pn/V+H/iZNwOJjTjn4/MRHKNHZe82mrepyuS7V5/d8zegPM
         ebdUivQ0c6UvYF2n+PvvoAow9LmFkCDTI2e6/Q+U6BnhH+M3LTgOKk61iCPcrSwh/5
         AkvfGCUvfKctGmOCdkrRlM68wKCmJZeseUP8gMxQ=
Date:   Wed, 28 Sep 2022 21:03:43 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, kaixuxia@tencent.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-damon-vaddr-add-a-comment-for-default-case-in-damon_va_apply_scheme-fix.patch removed from -mm tree
Message-Id: <20220929040344.F3A12C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-damon-vaddr-add-a-comment-for-default-case-in-damon_va_apply_scheme-fix
has been removed from the -mm tree.  Its filename was
     mm-damon-vaddr-add-a-comment-for-default-case-in-damon_va_apply_scheme-fix.patch

This patch was dropped because it was folded into mm-damon-vaddr-add-a-comment-for-default-case-in-damon_va_apply_scheme.patch

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

mm-damon-vaddr-add-a-comment-for-default-case-in-damon_va_apply_scheme.patch
mm-page_allocc-rename-check_free_page-to-free_page_is_bad.patch
mm-page_allocc-rename-check_free_page-to-free_page_is_bad-fix.patch
mm-page_allocc-document-bulkfree_pcp_prepare-return-value.patch
fs-uninline-inode_maybe_inc_iversion.patch
ipc-msg-mitigate-the-lock-contention-with-percpu-counter-checkpatch-fixes.patch
ipc-msg-mitigate-the-lock-contention-with-percpu-counter-fix-fix.patch


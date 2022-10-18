Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71D6DC433FE
	for <mm-commits@archiver.kernel.org>; Tue, 18 Oct 2022 22:18:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbiJRWSW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Oct 2022 18:18:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbiJRWSV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Oct 2022 18:18:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1167B3B442
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 15:18:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E08D6170E
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 22:18:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F241DC433D6;
        Tue, 18 Oct 2022 22:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666131500;
        bh=HqhOesedmJFMF4vzKc/2+syk4zS0f+K0u38KVK17PCs=;
        h=Date:To:From:Subject:From;
        b=IC8Gw3MwBPMC/Ou7oYobsLtb3ei2LwS5D9zGObFjvzX2OBShsZf0HrlNEQF9xgDnU
         iwkla7UrkvzXrjE5Ow7wr/+/0p4XI/k4uK2CMbeE0TAyVm6q8dDfRNJUomyzQYEHxU
         C8tB7EvWQKfOkFvus2LJs7B/zoX7yNDbzvLLBrhQ=
Date:   Tue, 18 Oct 2022 15:18:19 -0700
To:     mm-commits@vger.kernel.org, urezki@gmail.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + vmalloc-add-reviewers-for-vmalloc-code-checkpatch-fixes.patch added to mm-unstable branch
Message-Id: <20221018221819.F241DC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: vmalloc-add-reviewers-for-vmalloc-code-checkpatch-fixes
has been added to the -mm mm-unstable branch.  Its filename is
     vmalloc-add-reviewers-for-vmalloc-code-checkpatch-fixes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/vmalloc-add-reviewers-for-vmalloc-code-checkpatch-fixes.patch

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
Subject: vmalloc-add-reviewers-for-vmalloc-code-checkpatch-fixes
Date: Tue Oct 18 03:17:35 PM PDT 2022


WARNING: Misordered MAINTAINERS entry - list file patterns in alphabetic order
#39: FILE: MAINTAINERS:13300:
+F:	mm/vmalloc.c
+F:	include/linux/vmalloc.h

total: 0 errors, 1 warnings, 21 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/vmalloc-add-reviewers-for-vmalloc-code.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/MAINTAINERS~vmalloc-add-reviewers-for-vmalloc-code-checkpatch-fixes
+++ a/MAINTAINERS
@@ -13296,8 +13296,8 @@ L:	linux-mm@kvack.org
 S:	Maintained
 W:	http://www.linux-mm.org
 T:	git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
-F:	mm/vmalloc.c
 F:	include/linux/vmalloc.h
+F:	mm/vmalloc.c
 
 MEMORY HOT(UN)PLUG
 M:	David Hildenbrand <david@redhat.com>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-mmapc-__vma_adjust-suppress-unintialized-var-warning.patch
mm-hugetlb-convert-free_huge_page-to-folios-fix.patch
vmalloc-add-reviewers-for-vmalloc-code-checkpatch-fixes.patch
powerpc-ptrace-user_regset_copyin_ignore-always-returns-0-fix.patch
minmax-sanity-check-constant-bounds-when-clamping-checkpatch-fixes.patch
minmax-sanity-check-constant-bounds-when-clamping-checkpatch-fixes-fix.patch


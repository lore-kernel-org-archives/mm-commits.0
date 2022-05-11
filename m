Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A2ABC433F5
	for <mm-commits@archiver.kernel.org>; Wed, 11 May 2022 18:57:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232115AbiEKS5K (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 11 May 2022 14:57:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345196AbiEKS5J (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 May 2022 14:57:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4761A46B1D
        for <mm-commits@vger.kernel.org>; Wed, 11 May 2022 11:57:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9E428B82608
        for <mm-commits@vger.kernel.org>; Wed, 11 May 2022 18:57:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CF56C34115;
        Wed, 11 May 2022 18:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652295419;
        bh=DCV9DnEhYEFQNhsZuUAycnTPaNiE0ewJrch0HLRqGbE=;
        h=Date:To:From:Subject:From;
        b=NLdRnmzhgp8jBEpUk7WgN/O8Y40WXGYmoniPorbMbftBxnjDu3t/1+DyjVnoaTpFm
         /yiFkJeJBtHOdkC4V2L+V08qQUCJZ8apzJPuF4t+KhZglRWdOv4rDXh3Xex0+5N8rA
         IA9KSfJGp8zuoEjSvqmx0RR23ssgZHgT3hxXA8Nk=
Date:   Wed, 11 May 2022 11:56:58 -0700
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        hannes@cmpxchg.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + documentation-filesystems-proc-update-meminfo-section-fix.patch added to mm-unstable branch
Message-Id: <20220511185659.4CF56C34115@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: documentation-filesystems-proc-update-meminfo-section-fix
has been added to the -mm mm-unstable branch.  Its filename is
     documentation-filesystems-proc-update-meminfo-section-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/documentation-filesystems-proc-update-meminfo-section-fix.patch

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
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: documentation-filesystems-proc-update-meminfo-section-fix

fix htmldocs warnings

Link: https://lkml.kernel.org/r/Ynve8dg4zJyhH2gW@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.rst |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

--- a/Documentation/filesystems/proc.rst~documentation-filesystems-proc-update-meminfo-section-fix
+++ a/Documentation/filesystems/proc.rst
@@ -1146,16 +1146,9 @@ CmaTotal
               Memory reserved for the Contiguous Memory Allocator (CMA)
 CmaFree
               Free remaining memory in the CMA reserves
-HugePages_Total
-HugePages_Free
-HugePages_Rsvd
-HugePages_Surp
-Hugepagesize
-Hugetlb
+HugePages_Total, HugePages_Free, HugePages_Rsvd, HugePages_Surp, Hugepagesize, Hugetlb
               See Documentation/admin-guide/mm/hugetlbpage.rst.
-DirectMap4k
-DirectMap2M
-DirectMap1G
+DirectMap4k, DirectMap2M, DirectMap1G
               Breakdown of page table sizes used in the kernel's
               identity mapping of RAM
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

documentation-filesystems-proc-update-meminfo-section.patch
documentation-filesystems-proc-update-meminfo-section-fix.patch
mm-kconfig-move-swap-and-slab-config-options-to-the-mm-section.patch
mm-zswap-add-basic-meminfo-and-vmstat-coverage.patch
zswap-memcg-accounting.patch


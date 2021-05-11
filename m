Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83EBAC43460
	for <mm-commits@archiver.kernel.org>; Tue, 11 May 2021 00:05:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D2B261621
	for <mm-commits@archiver.kernel.org>; Tue, 11 May 2021 00:05:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbhEKAGx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 10 May 2021 20:06:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:57618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229533AbhEKAGw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 10 May 2021 20:06:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1DFFA61613;
        Tue, 11 May 2021 00:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620691547;
        bh=pXEhM2KNC93cTMnypfJmnAx1Vt4wqIwgeb+6Tb+Ls+M=;
        h=Date:From:To:Subject:From;
        b=pbWjpC2EwyZR6p4o7bHofqgSFO5x1+RJ2/ZOOh0DifpMsnjctzr959qzvwMKBPRkr
         S7ofvaVQITcR95xSiqvFa444NS0BL02iupA9UicewFF4Jxun7CigwbO1GIEG1awpPx
         1dDj5FRf+VEQqr4EtyF6iPsd6rUma0Mjh0SO/Jj0=
Date:   Mon, 10 May 2021 17:05:46 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Message-ID: <20210511000546.wj5HG4r-N%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/kernel/alternative.c |    4 ----
 arch/powerpc/Kconfig            |    4 ----
 2 files changed, 8 deletions(-)

--- a/arch/arm64/kernel/alternative.c~linux-next-git-rejects
+++ a/arch/arm64/kernel/alternative.c
@@ -134,11 +134,7 @@ static void clean_dcache_range_nopatch(u
 }
 
 static void __nocfi __apply_alternatives(struct alt_region *region, bool is_module,
-<<<<<<< HEAD
-				 unsigned long *feature_mask)
-=======
 					 unsigned long *feature_mask)
->>>>>>> linux-next/akpm-base
 {
 	struct alt_instr *alt;
 	__le32 *origptr, *updptr;
--- a/arch/powerpc/Kconfig~linux-next-git-rejects
+++ a/arch/powerpc/Kconfig
@@ -166,10 +166,6 @@ config PPC
 	select CLONE_BACKWARDS
 	select DCACHE_WORD_ACCESS		if PPC64 && CPU_LITTLE_ENDIAN
 	select DMA_OPS_BYPASS			if PPC64
-<<<<<<< HEAD
-	select DMA_OPS				if PPC64
-=======
->>>>>>> linux-next/akpm-base
 	select DYNAMIC_FTRACE			if FUNCTION_TRACER
 	select EDAC_ATOMIC_SCRUB
 	select EDAC_SUPPORT
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-gup-pack-has_pinned-in-mmf_has_pinned-checkpatch-fixes.patch
mm-memcg-optimize-user-context-object-stock-access-checkpatch-fixes.patch
mm-improve-mprotectrw-efficiency-on-pages-referenced-once-fix.patch
nommu-remove-__gfp_highmem-in-vmalloc-vzalloc-checkpatch-fixes.patch
mm-madvise-introduce-madv_populate_readwrite-to-prefault-page-tables-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch


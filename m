Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3096EC433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:38:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B18961402
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:38:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbhEHWjI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:39:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:41668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229522AbhEHWjI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:39:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 39DC6613E8;
        Sat,  8 May 2021 22:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513485;
        bh=gciEQ2bfGxv6U+3SXbFxvwcgWhuCltBK5WGf53TOSH4=;
        h=Date:From:To:Subject:From;
        b=a3qTLxmc286QVbV+cfX4QXVq3jvjAeHSA3Ey3eDlBhGMZ8f4liDKALaMyAC5epEg0
         VxrbfnJ1Bfyads5horOjz+3MgXRYStaYTo/QP++VD0JbTWrFCWPy9Esbo1X4tSu8Tu
         3wqZXNs2QR2cj2LtC7HT0fLkwzN+6P04eCU0ximU=
Date:   Sat, 08 May 2021 15:38:04 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  + linux-next-git-rejects.patch added to -mm tree
Message-ID: <20210508223804.oGnJ8-uMZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
cifsd-is-broken.patch
kernel-forkc-export-kernel_thread-to-modules.patch
linux-next-git-rejects.patch


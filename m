Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38369C4361B
	for <mm-commits@archiver.kernel.org>; Tue,  8 Dec 2020 01:31:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2586221FD
	for <mm-commits@archiver.kernel.org>; Tue,  8 Dec 2020 01:31:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726184AbgLHBbA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Dec 2020 20:31:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:45944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725924AbgLHBbA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 7 Dec 2020 20:31:00 -0500
Date:   Mon, 07 Dec 2020 17:30:18 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607391019;
        bh=i9XDgHncMp43c3dcIxlbGY08gMYgWEUauTcWXI1bETU=;
        h=From:To:Subject:From;
        b=tHu0QCsKGriWbg1vfojWFUmViuAokcAoIKVi5puS/iRKmvZMu8ByXWnXFzj+6F7LQ
         2EHEAT96o2k9dEg83uuY1okuSFhw6GyRGWeYotfU86zl4aUGeUVDsJqLWGLTfz7AXk
         IRdJEn47NWMgp2MxMtMdT2Oba2WBgjTuEqCk3bAg=
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org,
        colin.king@canonical.com
Subject:  + arch-fix-spelling-mistakes-in-kconfig.patch added to -mm
 tree
Message-ID: <20201208013018.ToMYJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arch/Kconfig: fix spelling mistakes
has been added to the -mm tree.  Its filename is
     arch-fix-spelling-mistakes-in-kconfig.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/arch-fix-spelling-mistakes-in-kconfig.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/arch-fix-spelling-mistakes-in-kconfig.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Colin Ian King <colin.king@canonical.com>
Subject: arch/Kconfig: fix spelling mistakes

There are a few spelling mistakes in the Kconfig comments and help text. 
Fix these.

Link: https://lkml.kernel.org/r/20201207155004.171962-1-colin.king@canonical.com
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/Kconfig~arch-fix-spelling-mistakes-in-kconfig
+++ a/arch/Kconfig
@@ -261,7 +261,7 @@ config ARCH_HAS_SET_DIRECT_MAP
 
 #
 # Select if the architecture provides the arch_dma_set_uncached symbol to
-# either provide an uncached segement alias for a DMA allocation, or
+# either provide an uncached segment alias for a DMA allocation, or
 # to remap the page tables in place.
 #
 config ARCH_HAS_DMA_SET_UNCACHED
@@ -314,14 +314,14 @@ config ARCH_32BIT_OFF_T
 config HAVE_ASM_MODVERSIONS
 	bool
 	help
-	  This symbol should be selected by an architecure if it provides
+	  This symbol should be selected by an architecture if it provides
 	  <asm/asm-prototypes.h> to support the module versioning for symbols
 	  exported from assembly code.
 
 config HAVE_REGS_AND_STACK_ACCESS_API
 	bool
 	help
-	  This symbol should be selected by an architecure if it supports
+	  This symbol should be selected by an architecture if it supports
 	  the API needed to access registers and stack entries from pt_regs,
 	  declared in asm/ptrace.h
 	  For example the kprobes-based event tracer needs this API.
@@ -336,7 +336,7 @@ config HAVE_RSEQ
 config HAVE_FUNCTION_ARG_ACCESS_API
 	bool
 	help
-	  This symbol should be selected by an architecure if it supports
+	  This symbol should be selected by an architecture if it supports
 	  the API needed to access function arguments from pt_regs,
 	  declared in asm/ptrace.h
 
_

Patches currently in -mm which might be from colin.king@canonical.com are

arch-fix-spelling-mistakes-in-kconfig.patch
mm-process_vm_access-remove-redundant-initialization-of-iov_r.patch


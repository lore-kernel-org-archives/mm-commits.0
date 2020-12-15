Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 728D9C2BB9A
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:35:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B205224BE
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:35:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbgLODez (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:34:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:60682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727201AbgLODEm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:04:42 -0500
Date:   Mon, 14 Dec 2020 19:03:44 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001424;
        bh=fcREoDAT0+oYpDObQ0dz5RNNqnUhikJiQBkp5yxMRk4=;
        h=From:To:Subject:In-Reply-To:From;
        b=K4BW1ymGfgi0QIDjHmNLl07h82iSvkc/xFfFeajyyjz7A1Yv/WqPqVO5U9nEn6dlJ
         zD4+AvxVMNz5J1LCEzBZMAD7VHWXu3dKIv3D6err82iRyG+BHAVPEF0gYh7j9wNg0G
         Q8GFBmtj83YfyGgRBPShDcv04gSAgQIc0Fsm/Vxs=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, colin.king@canonical.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, torvalds@linux-foundation.org
Subject:  [patch 010/200] arch/Kconfig: fix spelling mistakes
Message-ID: <20201215030344.R92btvML4%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A93CC11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:01:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 047E361476
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:01:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238361AbhGABD6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:03:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:59184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238296AbhGABD4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:03:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A855161469;
        Thu,  1 Jul 2021 01:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625101285;
        bh=ne3C8jg0FUQG9lvDVsUrL1QKcDRB5JfhI+sA6LKVups=;
        h=Date:From:To:Subject:From;
        b=gacrXf2fRCNp7rrrbmsnFg/ZDf4oz0pBPCgvnaIOZr8IicUpTFmVULQjzRI+Io7pC
         WBWe0ieYpPmoZfi8MLSaHtH2xu9zunRGt+MHUrS6QLb+UGunDagCrOkaqmqXBcg0Dt
         m542YECYwM2knby45EQRI24byVkpHUDClYmVmTLU=
Date:   Wed, 30 Jun 2021 18:01:25 -0700
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, glaubitz@physik.fu-berlin.de,
        lkp@intel.com, mm-commits@vger.kernel.org
Subject:  [folded-merged]
 kernelh-split-out-panic-and-oops-helpers-fix-2.patch removed from -mm tree
Message-ID: <20210701010125.adhmREjfD%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel.h: split out panic and oops helpers (ia64 fix)
has been removed from the -mm tree.  Its filename was
     kernelh-split-out-panic-and-oops-helpers-fix-2.patch

This patch was dropped because it was folded into kernelh-split-out-panic-and-oops-helpers.patch

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: kernel.h: split out panic and oops helpers (ia64 fix)

Follow up fix for the "kernel.h: split out panic and oops helpers" patch.

Link: https://lkml.kernel.org/r/20210520130557.55277-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reported-by: kernel test robot <lkp@intel.com>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/include/asm/pal.h |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/ia64/include/asm/pal.h~kernelh-split-out-panic-and-oops-helpers-fix-2
+++ a/arch/ia64/include/asm/pal.h
@@ -99,6 +99,7 @@
 
 #include <linux/types.h>
 #include <asm/fpu.h>
+#include <asm/intrinsics.h>
 
 /*
  * Data types needed to pass information into PAL procedures and
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

drm-include-only-needed-headers-in-ascii85h.patch
kernelh-split-out-panic-and-oops-helpers.patch
lib-string_helpers-switch-to-use-bit-macro.patch
lib-string_helpers-move-escape_np-check-inside-else-branch-in-a-loop.patch
lib-string_helpers-drop-indentation-level-in-string_escape_mem.patch
lib-string_helpers-introduce-escape_na-for-escaping-non-ascii.patch
lib-string_helpers-introduce-escape_nap-to-escape-non-ascii-and-non-printable.patch
lib-string_helpers-allow-to-append-additional-characters-to-be-escaped.patch
lib-test-string_helpers-print-flags-in-hexadecimal-format.patch
lib-test-string_helpers-get-rid-of-trailing-comma-in-terminators.patch
lib-test-string_helpers-add-test-cases-for-new-features.patch
maintainers-add-myself-as-designated-reviewer-for-generic-string-library.patch
seq_file-introduce-seq_escape_mem.patch
seq_file-add-seq_escape_str-as-replica-of-string_escape_str.patch
seq_file-convert-seq_escape-to-use-seq_escape_str.patch
nfsd-avoid-non-flexible-api-in-seq_quote_mem.patch
seq_file-drop-unused-_escape_mem_ascii.patch
kernelh-split-out-kstrtox-and-simple_strtox-to-a-separate-header.patch


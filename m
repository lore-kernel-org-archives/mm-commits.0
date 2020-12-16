Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C122C4361B
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:12:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1956F23118
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:12:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725550AbgLPELz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:11:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:41786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725274AbgLPELz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 23:11:55 -0500
Date:   Tue, 15 Dec 2020 20:11:13 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608091874;
        bh=LFuc2RYOwFn0DUlkeRAjXWHO9viflBBTRNLeEkt/ixI=;
        h=From:To:Subject:From;
        b=TKQv2Ri/19ksD0BGNrNCCewz4am7wnKSyeOCixo+4oizcdE9usG1VwNY/3XiuoYjE
         HWHyfQcDOR+3PotzKMFbMxWfYzTQwNXiGz14uFBw7yd1JuGz6jN9KLAkLqS13xF7Nr
         wgiSAhKJ6ZzGhIP4ScJnA30RncJbyfFuOtkTsnIA=
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  [folded-merged]
 ilog2-improve-ilog2-for-constant-arguments-checkpatch-fixes.patch removed
 from -mm tree
Message-ID: <20201216041113.rbP7NfuxP%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ilog2-improve-ilog2-for-constant-arguments-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     ilog2-improve-ilog2-for-constant-arguments-checkpatch-fixes.patch

This patch was dropped because it was folded into ilog2-improve-ilog2-for-constant-arguments.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ilog2-improve-ilog2-for-constant-arguments-checkpatch-fixes

WARNING: space prohibited between function name and open parenthesis '('
#39: FILE: include/linux/log2.h:160:
+	 63 - __builtin_clzll (n)) :	\

total: 0 errors, 1 warnings, 9 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/ilog2-improve-ilog2-for-constant-arguments.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/log2.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/log2.h~ilog2-improve-ilog2-for-constant-arguments-checkpatch-fixes
+++ a/include/linux/log2.h
@@ -157,7 +157,7 @@ unsigned long __rounddown_pow_of_two(uns
 ( \
 	__builtin_constant_p(n) ?	\
 	((n) < 2 ? 0 :			\
-	 63 - __builtin_clzll (n)) :	\
+	 63 - __builtin_clzll(n)) :	\
 	(sizeof(n) <= 4) ?		\
 	__ilog2_u32(n) :		\
 	__ilog2_u64(n)			\
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

ilog2-improve-ilog2-for-constant-arguments.patch
lib-test_bitmapc-add-for_each_set_clump-test-cases-checkpatch-fixes.patch
checkpatch-fix-typo_spelling-check-for-words-with-apostrophe-fix.patch
resource-fix-kernel-doc-markups-checkpatch-fixes.patch
lib-ubsanc-mark-type_check_kinds-with-static-keyword-fix.patch
mm.patch
mm-fix-initialization-of-struct-page-for-holes-in-memory-layout-checkpatch-fixes.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
linux-next-rejects.patch
kmap-stupid-hacks-to-make-it-compile.patch
epoll-wire-up-syscall-epoll_pwait2-fix.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages-fix.patch
arch-mm-wire-up-memfd_secret-system-call-were-relevant-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch


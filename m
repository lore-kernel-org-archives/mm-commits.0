Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA0CBC2BBCA
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:16:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A37CA23118
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:16:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725562AbgLPEQS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:16:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:42536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725550AbgLPEQR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 23:16:17 -0500
Date:   Tue, 15 Dec 2020 20:15:36 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608092137;
        bh=0+JSs2+r5Apjp6xQSGkXUqHSbwoxpgkZ/X/F2xf9m6E=;
        h=From:To:Subject:From;
        b=YMspTjE5K4CdXOkcKdw/qexpaAlrodZxEXEBglpSS1BBhs7XHkPcJZkrmeA/IDQ3m
         6bO5JUBpLNvztMbF+/7weEzKjvoujqZZulBuMQcjPgRuMot601a1//+RlwPm/Sgous
         qomPgd8BV+2ykBVKZBGLfwpvULjmJxUUUB3gUFiY=
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        zou_wei@huawei.com
Subject:  [folded-merged]
 lib-ubsanc-mark-type_check_kinds-with-static-keyword-fix.patch removed from
 -mm tree
Message-ID: <20201216041536.4FkilAKAs%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib-ubsanc-mark-type_check_kinds-with-static-keyword-fix
has been removed from the -mm tree.  Its filename was
     lib-ubsanc-mark-type_check_kinds-with-static-keyword-fix.patch

This patch was dropped because it was folded into lib-ubsanc-mark-type_check_kinds-with-static-keyword.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib-ubsanc-mark-type_check_kinds-with-static-keyword-fix

make it `staitc const char * const' while we're in there

Cc: Zou Wei <zou_wei@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/ubsan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/ubsan.c~lib-ubsanc-mark-type_check_kinds-with-static-keyword-fix
+++ a/lib/ubsan.c
@@ -17,7 +17,7 @@
 
 #include "ubsan.h"
 
-static const char *type_check_kinds[] = {
+static const char * const type_check_kinds[] = {
 	"load of",
 	"store to",
 	"reference binding to",
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

lib-ubsanc-mark-type_check_kinds-with-static-keyword.patch
mm.patch
mm-fix-initialization-of-struct-page-for-holes-in-memory-layout-checkpatch-fixes.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
linux-next-rejects.patch
kmap-stupid-hacks-to-make-it-compile.patch
epoll-wire-up-syscall-epoll_pwait2-fix.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages-fix.patch
arch-mm-wire-up-memfd_secret-system-call-were-relevant-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch


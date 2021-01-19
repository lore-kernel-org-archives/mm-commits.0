Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0B53C433E6
	for <mm-commits@archiver.kernel.org>; Tue, 19 Jan 2021 20:25:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 624FA23138
	for <mm-commits@archiver.kernel.org>; Tue, 19 Jan 2021 20:25:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729497AbhASUZA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Jan 2021 15:25:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:56594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390547AbhASUYx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 19 Jan 2021 15:24:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 076DB23138;
        Tue, 19 Jan 2021 20:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611087852;
        bh=i/e+CmdPH97V/0sbS2LTBavU7gpjNG+2jpMCtmj0Mjc=;
        h=Date:From:To:Subject:From;
        b=EGD+KBQeqfu6K2SRt5VmqoJyKn7SQjFkYgPIttY3mapUPxLin6vwIu2qIT13T9cFu
         Iqk83M8g+xaBOQGt8Zz4HznL7zl9VWhyCFfq4IsCPXFyvAX/IRFDm5pPkI0we7wd17
         WrKNZ1o2dAeKcB1CfRMcUyL3jYOkete3sTuC+48s=
Date:   Tue, 19 Jan 2021 12:24:11 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, dvyukov@google.com, elver@google.com,
        glider@google.com, mm-commits@vger.kernel.org
Subject:  + arm64-kfence-enable-kfence-for-arm64-fix.patch added to
 -mm tree
Message-ID: <20210119202411.uxFZHjJlu%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kfence, arm64: add missing copyright and description header
has been added to the -mm tree.  Its filename is
     arm64-kfence-enable-kfence-for-arm64-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/arm64-kfence-enable-kfence-for-arm64-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/arm64-kfence-enable-kfence-for-arm64-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Marco Elver <elver@google.com>
Subject: kfence, arm64: add missing copyright and description header

Add missing copyright and description header to KFENCE source file.

Link: https://lkml.kernel.org/r/20210118092159.145934-3-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/kfence.h |    5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/arm64/include/asm/kfence.h~arm64-kfence-enable-kfence-for-arm64-fix
+++ a/arch/arm64/include/asm/kfence.h
@@ -1,4 +1,9 @@
 /* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * arm64 KFENCE support.
+ *
+ * Copyright (C) 2020, Google LLC.
+ */
 
 #ifndef __ASM_KFENCE_H
 #define __ASM_KFENCE_H
_

Patches currently in -mm which might be from elver@google.com are

mm-add-kernel-electric-fence-infrastructure-fix.patch
mm-add-kernel-electric-fence-infrastructure-fix-2.patch
mm-add-kernel-electric-fence-infrastructure-fix-3.patch
mm-add-kernel-electric-fence-infrastructure-fix-4.patch
mm-add-kernel-electric-fence-infrastructure-fix-5.patch
x86-kfence-enable-kfence-for-x86-fix.patch
arm64-kfence-enable-kfence-for-arm64.patch
arm64-kfence-enable-kfence-for-arm64-fix.patch
kfence-use-pt_regs-to-generate-stack-trace-on-faults.patch
kfence-documentation-add-kfence-documentation.patch
kfence-documentation-add-kfence-documentation-fix.patch
kfence-add-test-suite.patch
kfence-add-test-suite-fix.patch
kfence-add-test-suite-fix-2.patch
maintainers-add-entry-for-kfence.patch


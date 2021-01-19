Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27506C433E6
	for <mm-commits@archiver.kernel.org>; Tue, 19 Jan 2021 20:25:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4AF323138
	for <mm-commits@archiver.kernel.org>; Tue, 19 Jan 2021 20:25:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390364AbhASUY4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Jan 2021 15:24:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:56572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729497AbhASUYt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 19 Jan 2021 15:24:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB0C723133;
        Tue, 19 Jan 2021 20:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611087849;
        bh=+//4piwAFhkGK74x3OwnQwZRezopTvFGQr5GscgJSfg=;
        h=Date:From:To:Subject:From;
        b=SdAEfKeFwpZk9E0Ou44jFOlzw5J6OiJZFfy3HRjfgHNh/Af/Xwa71Aj2aW3c4KgSS
         pPBw7S0QX3ptyhlUQ6Nr00SC+PlDBX47ac5ww7nx4Rpu/S+RE0JKdMZdhM4IpP/sDs
         w1A9px/KA9Na6R/AB5IaC3YKWOq6qpL/IP2LYZpM=
Date:   Tue, 19 Jan 2021 12:24:08 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, dvyukov@google.com, elver@google.com,
        glider@google.com, mm-commits@vger.kernel.org
Subject:  + x86-kfence-enable-kfence-for-x86-fix.patch added to -mm
 tree
Message-ID: <20210119202408.jvh5UMYU1%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kfence, x86: add missing copyright and description header
has been added to the -mm tree.  Its filename is
     x86-kfence-enable-kfence-for-x86-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/x86-kfence-enable-kfence-for-x86-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/x86-kfence-enable-kfence-for-x86-fix.patch

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
Subject: kfence, x86: add missing copyright and description header

Add missing copyright and description header to KFENCE source file.

Link: https://lkml.kernel.org/r/20210118092159.145934-2-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/kfence.h |    5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/x86/include/asm/kfence.h~x86-kfence-enable-kfence-for-x86-fix
+++ a/arch/x86/include/asm/kfence.h
@@ -1,4 +1,9 @@
 /* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * x86 KFENCE support.
+ *
+ * Copyright (C) 2020, Google LLC.
+ */
 
 #ifndef _ASM_X86_KFENCE_H
 #define _ASM_X86_KFENCE_H
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


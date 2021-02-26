Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CADECC433DB
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 00:46:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 898DD601FD
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 00:46:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231629AbhBZAq0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 19:46:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:33716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231414AbhBZAq0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 19:46:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 806A0601FD;
        Fri, 26 Feb 2021 00:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614300345;
        bh=lvYLctr8qH6A4pv/fPNAE54vkNkNyQoh7CTNfhDJf2Y=;
        h=Date:From:To:Subject:From;
        b=uAhu339KmHXF68Qnc7TCKZwZBeO46vRxiu5uJ2vZzFyPpTbrtyG7ThqskRi462nr/
         rEpWdIndovOGJ0zFE3nYzi/eDUo4Tbk/XSKLwEpduo6KenJNAFywy4JzDnTPPo6NfO
         kMSb3lk1ZMHtHasKvTkYJdCeoJInGQZmJAv7hcqs=
Date:   Thu, 25 Feb 2021 16:45:44 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, dvyukov@google.com, elver@google.com,
        glider@google.com, mm-commits@vger.kernel.org
Subject:  [folded-merged]
 x86-kfence-enable-kfence-for-x86-fix.patch removed from -mm tree
Message-ID: <20210226004544.5XfTxLHRj%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kfence, x86: add missing copyright and description header
has been removed from the -mm tree.  Its filename was
     x86-kfence-enable-kfence-for-x86-fix.patch

This patch was dropped because it was folded into x86-kfence-enable-kfence-for-x86.patch

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

x86-kfence-enable-kfence-for-x86.patch
arm64-kfence-enable-kfence-for-arm64.patch
arm64-kfence-enable-kfence-for-arm64-fix.patch
kfence-use-pt_regs-to-generate-stack-trace-on-faults.patch
kfence-documentation-add-kfence-documentation.patch
kfence-documentation-add-kfence-documentation-fix.patch
kfence-add-test-suite.patch
kfence-add-test-suite-fix.patch
kfence-add-test-suite-fix-2.patch
maintainers-add-entry-for-kfence.patch
kfence-report-sensitive-information-based-on-no_hash_pointers.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADCF1C433E0
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 00:48:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70A4E64F22
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 00:48:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbhBZAsm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 19:48:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:34706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230330AbhBZAsl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 19:48:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0EF4664DA3;
        Fri, 26 Feb 2021 00:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614300481;
        bh=DikJ8o9zt5wRyQD/v+0yXNDw4F2LM8vFuKb2dRA7YI8=;
        h=Date:From:To:Subject:From;
        b=I076dTQH0kwO6LaLYfULMvPGYOrqSSr0biqehzNEY1LRoMEy8QMtgdLNWSSyn0MpA
         gFtQdildbx3pOb7yLPHY91QL1DXHHdyR/B722KUxR2xmy86TKWTwXYyeFd8cLJPFdx
         ucq1hQ33xrLdQ5NhDOwDLlQEEKdw+FXcPSv0BB2M=
Date:   Thu, 25 Feb 2021 16:48:00 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, dvyukov@google.com, elver@google.com,
        glider@google.com, mm-commits@vger.kernel.org
Subject:  [folded-merged]
 kfence-documentation-add-kfence-documentation-fix.patch removed from -mm
 tree
Message-ID: <20210226004800.Ib_0QM9Hu%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kfence: add missing copyright header to documentation
has been removed from the -mm tree.  Its filename was
     kfence-documentation-add-kfence-documentation-fix.patch

This patch was dropped because it was folded into kfence-documentation-add-kfence-documentation.patch

------------------------------------------------------
From: Marco Elver <elver@google.com>
Subject: kfence: add missing copyright header to documentation

Add missing copyright header to KFENCE documentation.

Link: https://lkml.kernel.org/r/20210118092159.145934-4-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kfence.rst |    1 +
 1 file changed, 1 insertion(+)

--- a/Documentation/dev-tools/kfence.rst~kfence-documentation-add-kfence-documentation-fix
+++ a/Documentation/dev-tools/kfence.rst
@@ -1,4 +1,5 @@
 .. SPDX-License-Identifier: GPL-2.0
+.. Copyright (C) 2020, Google LLC.
 
 Kernel Electric-Fence (KFENCE)
 ==============================
_

Patches currently in -mm which might be from elver@google.com are

arm64-kfence-enable-kfence-for-arm64.patch
kfence-use-pt_regs-to-generate-stack-trace-on-faults.patch
kfence-documentation-add-kfence-documentation.patch
kfence-add-test-suite.patch
kfence-add-test-suite-fix.patch
kfence-add-test-suite-fix-2.patch
maintainers-add-entry-for-kfence.patch
kfence-report-sensitive-information-based-on-no_hash_pointers.patch


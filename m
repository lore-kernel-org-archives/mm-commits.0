Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7390C433DB
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 00:46:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6547264F22
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 00:46:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231530AbhBZAq4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 19:46:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:33964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231375AbhBZAq4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 19:46:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C1DA64DA3;
        Fri, 26 Feb 2021 00:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614300375;
        bh=m4JJpua/Q92JUM+AJ7ygxWvJDohLCU2K6uCjYVkXggU=;
        h=Date:From:To:Subject:From;
        b=V6SmN14yhvCnKhaW/0vih2iIg5ZqvrAIqTUJZXVmLnLW3FSJfgmE/WNh9Dom2PBsB
         EKHkg5kQO7EybttrfXEAor4XzRhS6xelr/XmPnaeWI2tlJuNkXbUve2JVSoBkTBoso
         QMXzvASnNaEXAuPT6IY5GLcTHQ/3Z2rJxtvHOYyY=
Date:   Thu, 25 Feb 2021 16:46:14 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, dvyukov@google.com, elver@google.com,
        glider@google.com, mm-commits@vger.kernel.org
Subject:  [folded-merged]
 arm64-kfence-enable-kfence-for-arm64-fix.patch removed from -mm tree
Message-ID: <20210226004614.Z-G-L3GuJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kfence, arm64: add missing copyright and description header
has been removed from the -mm tree.  Its filename was
     arm64-kfence-enable-kfence-for-arm64-fix.patch

This patch was dropped because it was folded into arm64-kfence-enable-kfence-for-arm64.patch

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

arm64-kfence-enable-kfence-for-arm64.patch
kfence-use-pt_regs-to-generate-stack-trace-on-faults.patch
kfence-documentation-add-kfence-documentation.patch
kfence-documentation-add-kfence-documentation-fix.patch
kfence-add-test-suite.patch
kfence-add-test-suite-fix.patch
kfence-add-test-suite-fix-2.patch
maintainers-add-entry-for-kfence.patch
kfence-report-sensitive-information-based-on-no_hash_pointers.patch


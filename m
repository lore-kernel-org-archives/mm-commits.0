Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 568E8C433E0
	for <mm-commits@archiver.kernel.org>; Tue, 19 Jan 2021 20:25:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E65A323138
	for <mm-commits@archiver.kernel.org>; Tue, 19 Jan 2021 20:25:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390864AbhASUZG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Jan 2021 15:25:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:56624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390661AbhASUY6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 19 Jan 2021 15:24:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6EC6F23139;
        Tue, 19 Jan 2021 20:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611087858;
        bh=wHs3tZekpIV2u+GdTZAz20u8cw/yAbzf1dI5dxEpos4=;
        h=Date:From:To:Subject:From;
        b=IBh1fdTYYyAe6ZUXKsJkUmM26qG8714SvkJ1BQkYHRXepiucbq6KGRYJk3EbDFna8
         Lj/YgPqq4Uywo8VGtZHVo0K1MuIqJIDV4mfW6MfVKPvxyy13pX67Z5u6Rv+/6OExsI
         AwRR0fGv1GnPxCHkGPsxhCMyLGibPmcW+Kq30sAk=
Date:   Tue, 19 Jan 2021 12:24:16 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, dvyukov@google.com, elver@google.com,
        glider@google.com, mm-commits@vger.kernel.org
Subject:  + kfence-documentation-add-kfence-documentation-fix.patch
 added to -mm tree
Message-ID: <20210119202416.Rbe1qR_Lt%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kfence: add missing copyright header to documentation
has been added to the -mm tree.  Its filename is
     kfence-documentation-add-kfence-documentation-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kfence-documentation-add-kfence-documentation-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kfence-documentation-add-kfence-documentation-fix.patch

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


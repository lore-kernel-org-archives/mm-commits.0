Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED71CC433DB
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 00:44:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9887864F24
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 00:44:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231614AbhBZAob (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 19:44:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:60964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231326AbhBZAob (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 19:44:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6CC5564F24;
        Fri, 26 Feb 2021 00:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614300230;
        bh=Ie/7wKt9aIgvzvMDK0RZkT2NFzMvdAqizsQgobCz/4w=;
        h=Date:From:To:Subject:From;
        b=aUeU+FlmbZ+Nh4yyr2FMsQlstFqnvvT0Mk6Do3dC5SU9AuD7iDPOCGPfZR4tFaTZ+
         gASAzW/xNnSL8U/jvm+pCUlkjIqJypALV5lNg71NWeqRxu9pbTstylAxY6buDYtTSg
         7uLeQtbm1XE/y6MT15v55c7di1w7an4vVueLKPwg=
Date:   Thu, 25 Feb 2021 16:43:48 -0800
From:   akpm@linux-foundation.org
To:     elver@google.com, glider@google.com, mm-commits@vger.kernel.org,
        sfr@canb.auug.org.au
Subject:  [folded-merged]
 mm-add-kernel-electric-fence-infrastructure-fix.patch removed from -mm tree
Message-ID: <20210226004348.TE1iWy5hD%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kfence: Fix parameter description for kfence_object_start()
has been removed from the -mm tree.  Its filename was
     mm-add-kernel-electric-fence-infrastructure-fix.patch

This patch was dropped because it was folded into mm-add-kernel-electric-fence-infrastructure.patch

------------------------------------------------------
From: Marco Elver <elver@google.com>
Subject: kfence: Fix parameter description for kfence_object_start()

Describe parameter @addr correctly by delimiting with ':'.

Link: https://lkml.kernel.org/r/20201106092149.GA2851373@elver.google.com
Signed-off-by: Marco Elver <elver@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kfence.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/kfence.h~mm-add-kernel-electric-fence-infrastructure-fix
+++ a/include/linux/kfence.h
@@ -125,7 +125,7 @@ size_t kfence_ksize(const void *addr);
 
 /**
  * kfence_object_start() - find the beginning of a KFENCE object
- * @addr - address within a KFENCE-allocated object
+ * @addr: address within a KFENCE-allocated object
  *
  * Return: address of the beginning of the object.
  *
_

Patches currently in -mm which might be from elver@google.com are

mm-add-kernel-electric-fence-infrastructure.patch
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
kfence-report-sensitive-information-based-on-no_hash_pointers.patch


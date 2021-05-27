Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09DEBC47089
	for <mm-commits@archiver.kernel.org>; Thu, 27 May 2021 00:33:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCB746139A
	for <mm-commits@archiver.kernel.org>; Thu, 27 May 2021 00:33:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232816AbhE0AfX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 26 May 2021 20:35:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:45252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232632AbhE0AfW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 26 May 2021 20:35:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 763576139A;
        Thu, 27 May 2021 00:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622075629;
        bh=u5p0AoqX4B2EEgf+hoOO0OOJw7Tfi6Uj7OTqww/iDcA=;
        h=Date:From:To:Subject:From;
        b=p96MD73eRfey/oIBgBKZpUWla+vIhnbUGsb5BqzJGGeM60jY3So+ItAjTK7gCnaNt
         LslvoiSOKumHAB/jJSUyJ3XUQvQ7u7baGpxLh/pgZm2GUBggyOkOIBzlQGq8qpN0k+
         4VqrsVdRHVf4oeoc4v22byEE4Qh9iJ9oKik2B2RE=
Date:   Wed, 26 May 2021 17:33:48 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rppt@kernel.org
Subject:  [folded-merged]
 arm64-drop-pfn_valid_within-and-simplify-pfn_valid-fix.patch removed from
 -mm tree
Message-ID: <20210527003348.5A1xogJ2-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm64-drop-pfn_valid_within-and-simplify-pfn_valid-fix
has been removed from the -mm tree.  Its filename was
     arm64-drop-pfn_valid_within-and-simplify-pfn_valid-fix.patch

This patch was dropped because it was folded into arm64-drop-pfn_valid_within-and-simplify-pfn_valid.patch

------------------------------------------------------
From: Mike Rapoport <rppt@kernel.org>
Subject: arm64-drop-pfn_valid_within-and-simplify-pfn_valid-fix

fix merge fix

Link: https://lkml.kernel.org/r/YJtoQhidtIJOhYsV@kernel.org

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/Kconfig |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/arm64/Kconfig~arm64-drop-pfn_valid_within-and-simplify-pfn_valid-fix
+++ a/arch/arm64/Kconfig
@@ -201,7 +201,6 @@ config ARM64
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
 	select HAVE_GENERIC_VDSO
-	select HOLES_IN_ZONE
 	select IOMMU_DMA if IOMMU_SUPPORT
 	select IRQ_DOMAIN
 	select IRQ_FORCED_THREADING
_

Patches currently in -mm which might be from rppt@kernel.org are

arm64-drop-pfn_valid_within-and-simplify-pfn_valid.patch


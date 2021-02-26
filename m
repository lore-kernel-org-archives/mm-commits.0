Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8AC3C433DB
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:23:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60FEF64EE4
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:23:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbhBZBX1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:23:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:52948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230087AbhBZBWw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 20:22:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0581A64F2A;
        Fri, 26 Feb 2021 01:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302539;
        bh=fbK5xZNbVI2PN5CGMgETojSaNUCDfWsqpg6CAsRAOXo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=HdlTe+EOcmiiKYep4kf3knoe7q62ID7Jp3jMilV4b2Nv/Xtbq1w20z2Pp11D5QIfQ
         Niu6JpUO48FHpqGYBNWz4LS1UKnH8KNk8UcLCe4qf7yuMrx0BSj5F4J3w4WfYnIAp7
         2348IhTdyzfM6YscBfe4etYt9WPrLJmlnOV9FG2o=
Date:   Thu, 25 Feb 2021 17:22:18 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, nathan@kernel.org,
        rdunlap@infradead.org, torvalds@linux-foundation.org,
        unixbhaskar@gmail.com
Subject:  [patch 110/118] init/Kconfig: fix a typo in
 CC_VERSION_TEXT help text
Message-ID: <20210226012218.4f2-kBtMy%akpm@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: init/Kconfig: fix a typo in CC_VERSION_TEXT help text

s/compier/compiler/

Link: https://lkml.kernel.org/r/20210224223325.29099-1-unixbhaskar@gmail.com
Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/init/Kconfig~init-kconfig-fix-a-typo-in-cc_version_text-help-text
+++ a/init/Kconfig
@@ -19,7 +19,7 @@ config CC_VERSION_TEXT
 	    CC_VERSION_TEXT so it is recorded in include/config/auto.conf.cmd.
 	    When the compiler is updated, Kconfig will be invoked.
 
-	  - Ensure full rebuild when the compier is updated
+	  - Ensure full rebuild when the compiler is updated
 	    include/linux/kconfig.h contains this option in the comment line so
 	    fixdep adds include/config/cc/version/text.h into the auto-generated
 	    dependency. When the compiler is updated, syncconfig will touch it
_

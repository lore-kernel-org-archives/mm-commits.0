Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97473C43381
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:33:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68B3E64F14
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:33:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbhB0Cdl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Feb 2021 21:33:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:52838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230183AbhB0Cde (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Feb 2021 21:33:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7AD0F64F31;
        Sat, 27 Feb 2021 02:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614393159;
        bh=GM5zF1s5tnH93P3Hu8yjEv6fsoaFKeGbVr6hjssn9Wk=;
        h=Date:From:To:Subject:From;
        b=A+spYN2oOeeeODH0zqFeQRiGuDP0vfCObOyboHcv3B9F+HiP+NrfQZTsADaBwNlqo
         J1gtfmJ/OfbOC8JHS/OO4qQEBMKEOsRav5+z12CargtoIw7sGv10XWK/Q/ebm7gsCa
         3KOAP2qKUqFc/qMKLboumI2BGhoRiY4OGapOQs8g=
Date:   Fri, 26 Feb 2021 18:32:39 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, nathan@kernel.org,
        rdunlap@infradead.org, unixbhaskar@gmail.com
Subject:  [merged]
 init-kconfig-fix-a-typo-in-cc_version_text-help-text.patch removed from -mm
 tree
Message-ID: <20210227023239.JEhZ6Pxmu%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: init/Kconfig: fix a typo in CC_VERSION_TEXT help text
has been removed from the -mm tree.  Its filename was
     init-kconfig-fix-a-typo-in-cc_version_text-help-text.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from unixbhaskar@gmail.com are



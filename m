Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1E2BC4332F
	for <mm-commits@archiver.kernel.org>; Fri, 21 Oct 2022 04:35:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbiJUEfK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Oct 2022 00:35:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229871AbiJUEev (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Oct 2022 00:34:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 497D22FC26
        for <mm-commits@vger.kernel.org>; Thu, 20 Oct 2022 21:34:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A9F0961DAD
        for <mm-commits@vger.kernel.org>; Fri, 21 Oct 2022 04:34:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DEBAC433D6;
        Fri, 21 Oct 2022 04:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666326888;
        bh=2cSguU8q3jsQnTjASWolHkzziLwwbIQBlK/2aI5T6iM=;
        h=Date:To:From:Subject:From;
        b=fbNc306AFWROa4524BnQbTbqsdO1thHHBgBrh6YISeH1BjBzt2zc1q7m3PWX+OlSv
         mkAge54QcqnPKNrOYCVCNAu5Yydn2dtWQ+8bZyz4jIJXLGoz3IslOKyI1PqKKYCE8c
         +NQBuqVpUsaSkOasJ8Jf7ow6YiYyPxrRJKyO03+Y=
Date:   Thu, 20 Oct 2022 21:34:47 -0700
To:     mm-commits@vger.kernel.org, colin.i.king@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] init-kconfig-fix-spelling-mistake-satify-satisfy.patch removed from -mm tree
Message-Id: <20221021043448.0DEBAC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: init: Kconfig: fix spelling mistake "satify" -> "satisfy"
has been removed from the -mm tree.  Its filename was
     init-kconfig-fix-spelling-mistake-satify-satisfy.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Colin Ian King <colin.i.king@gmail.com>
Subject: init: Kconfig: fix spelling mistake "satify" -> "satisfy"
Date: Fri, 7 Oct 2022 21:43:39 +0100

There is a spelling mistake in a Kconfig description.  Fix it.

Link: https://lkml.kernel.org/r/20221007204339.2757753-1-colin.i.king@gmail.com
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/init/Kconfig~init-kconfig-fix-spelling-mistake-satify-satisfy
+++ a/init/Kconfig
@@ -66,7 +66,7 @@ config RUST_IS_AVAILABLE
 	  This shows whether a suitable Rust toolchain is available (found).
 
 	  Please see Documentation/rust/quick-start.rst for instructions on how
-	  to satify the build requirements of Rust support.
+	  to satisfy the build requirements of Rust support.
 
 	  In particular, the Makefile target 'rustavailable' is useful to check
 	  why the Rust toolchain is not being detected.
_

Patches currently in -mm which might be from colin.i.king@gmail.com are

lib-remove-redundant-assignment-to-variable-num.patch


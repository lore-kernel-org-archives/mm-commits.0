Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17333C4332F
	for <mm-commits@archiver.kernel.org>; Tue, 18 Oct 2022 00:34:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbiJRAeP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Oct 2022 20:34:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230025AbiJRAeM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Oct 2022 20:34:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67AF92496F
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 17:34:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE012611F3
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 00:21:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 211C2C433D6;
        Tue, 18 Oct 2022 00:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666052510;
        bh=eRygxjod0vspRTnWB7xPvIH9WTI5Rsmz6mURLXRVlgY=;
        h=Date:To:From:Subject:From;
        b=w86cwVSk9QygMOwz4LPBlrQpXhMuiZuO3GCHX62xF3BssgaPq9l0/G8JnCNuEEmfO
         mCaP5TaJhEihZC0KXtC3n08Lv66SivXslTl3IgqoLffOnQQ1yf8a7pdk9RZnsVdVJa
         TV3SQmrbh8OGzlUmVPvYiz36DyFIxu3Tem2eoARk=
Date:   Mon, 17 Oct 2022 17:21:49 -0700
To:     mm-commits@vger.kernel.org, colin.i.king@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + init-kconfig-fix-spelling-mistake-satify-satisfy.patch added to mm-hotfixes-unstable branch
Message-Id: <20221018002150.211C2C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: init: Kconfig: fix spelling mistake "satify" -> "satisfy"
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     init-kconfig-fix-spelling-mistake-satify-satisfy.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/init-kconfig-fix-spelling-mistake-satify-satisfy.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

init-kconfig-fix-spelling-mistake-satify-satisfy.patch
lib-remove-redundant-assignment-to-variable-num.patch


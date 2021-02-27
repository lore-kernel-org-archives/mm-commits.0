Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DB84C433DB
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:32:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1616A64F35
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:32:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbhB0Ccp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Feb 2021 21:32:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:51000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229745AbhB0CcW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Feb 2021 21:32:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 847CF64F3F;
        Sat, 27 Feb 2021 02:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614393098;
        bh=pwGnp44yeRwETuj6Mh8N6Frz8h9UbGNpNGTe9x8VukM=;
        h=Date:From:To:Subject:From;
        b=QF4qR/WZbrtBgHag5nJvmeRqUXVwk9/sxPN1Psy/4IHf4mMgukJ2gfeqZuv/2LGsY
         BP+6KUDDoBVdwZujqIrXVDmaG0ayGPsm0+QUynIH41oU4pxGCpwTDHcJl9IE5MFfgt
         JE0v+8DBwQbzNQ2CBF8tvyxHkDplqoVEGoQh79vw=
Date:   Fri, 26 Feb 2021 18:31:38 -0800
From:   akpm@linux-foundation.org
To:     gregkh@linuxfoundation.org, ink@jurassic.park.msu.ru,
        keescook@chromium.org, mattst88@gmail.com,
        mm-commits@vger.kernel.org, rdunlap@infradead.org, rth@twiddle.net
Subject:  [merged]
 alpha-remove-config_experimental-from-defconfigs.patch removed from -mm
 tree
Message-ID: <20210227023138.i9KQa_i2k%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: alpha: remove CONFIG_EXPERIMENTAL from defconfigs
has been removed from the -mm tree.  Its filename was
     alpha-remove-config_experimental-from-defconfigs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: alpha: remove CONFIG_EXPERIMENTAL from defconfigs

Since CONFIG_EXPERIMENTAL was removed in 2013, go ahead and drop it
from any defconfig files.

Link: https://lkml.kernel.org/r/20210115005956.29408-1-rdunlap@infradead.org
Fixes: 3d374d09f16f ("final removal of CONFIG_EXPERIMENTAL")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/configs/defconfig |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/alpha/configs/defconfig~alpha-remove-config_experimental-from-defconfigs
+++ a/arch/alpha/configs/defconfig
@@ -1,4 +1,3 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_LOG_BUF_SHIFT=14
_

Patches currently in -mm which might be from rdunlap@infradead.org are



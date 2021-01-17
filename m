Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09245C433DB
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jan 2021 21:41:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C87F720791
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jan 2021 21:41:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728669AbhAQVlh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jan 2021 16:41:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:55548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728042AbhAQVlg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 17 Jan 2021 16:41:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D629222B3;
        Sun, 17 Jan 2021 21:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610919655;
        bh=HahTQhnYRrkl5eGTTaf7mIOwJsv2OZyhL+aahLauUSY=;
        h=Date:From:To:Subject:From;
        b=J/u/kzkj5MZUVbRQRJmQ9kStIh0QglrU2YPqM0uGWXsdXd9gTk4vxskODnVqlXZDB
         ucqZBFW6hw9hLVGxBB4if480+elLye2x0rPPGtFbdd2jmTW+shyoOd/8JLGSUeLAbS
         tmuU6EmPg0qi1a+8F0aT9Kp2Q3CVrNtVgiEAggRE=
Date:   Sun, 17 Jan 2021 13:40:54 -0800
From:   akpm@linux-foundation.org
To:     gregkh@linuxfoundation.org, ink@jurassic.park.msu.ru,
        keescook@chromium.org, mattst88@gmail.com,
        mm-commits@vger.kernel.org, rdunlap@infradead.org, rth@twiddle.net
Subject:  + alpha-remove-config_experimental-from-defconfigs.patch
 added to -mm tree
Message-ID: <20210117214054.ndkSHTdTc%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: alpha: remove CONFIG_EXPERIMENTAL from defconfigs
has been added to the -mm tree.  Its filename is
     alpha-remove-config_experimental-from-defconfigs.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/alpha-remove-config_experimental-from-defconfigs.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/alpha-remove-config_experimental-from-defconfigs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

hexagon-remove-config_experimental-from-defconfigs.patch
fs-delete-repeated-words-in-comments.patch
mm-zswap-clean-up-confusing-comment.patch
alpha-remove-config_experimental-from-defconfigs.patch


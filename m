Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC6E2C432BE
	for <mm-commits@archiver.kernel.org>; Wed, 18 Aug 2021 19:42:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E11C610CD
	for <mm-commits@archiver.kernel.org>; Wed, 18 Aug 2021 19:42:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233143AbhHRTn0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Aug 2021 15:43:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:55088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233609AbhHRTnX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 18 Aug 2021 15:43:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9816C610CF;
        Wed, 18 Aug 2021 19:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629315767;
        bh=B3CQAhMCNYJgMhsKzmLCPidDmiDBat/SyAwqt+xIXX4=;
        h=Date:From:To:Subject:From;
        b=lLdx16Jaaad9J4MMbXbn9Ujpd4e1C4RPrZ/cZDEXCfFu1+YY3I5T5OerRclTfOhHV
         j3cMNNbz9YO0kwG2Lb4llghkzcv9Oz1kGpZNf6b2C9eSK9N16Dfy+3uE+rFcTokLQH
         1vATwl85eXvUsdGiSNGF0zyOh00DQAC7ikEDa+yk=
Date:   Wed, 18 Aug 2021 12:42:47 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, ndesaulniers@google.com,
        keescook@chromium.org, nathan@kernel.org
Subject:  + maintainers-update-clangbuiltlinux-irc-chat.patch added
 to -mm tree
Message-ID: <20210818194247.vDPTe%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: update ClangBuiltLinux IRC chat
has been added to the -mm tree.  Its filename is
     maintainers-update-clangbuiltlinux-irc-chat.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/maintainers-update-clangbuiltlinux-irc-chat.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/maintainers-update-clangbuiltlinux-irc-chat.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nathan Chancellor <nathan@kernel.org>
Subject: MAINTAINERS: update ClangBuiltLinux IRC chat

Everyone has moved from Freenode to Libera so updated the channel entry
for MAINTAINERS.

Link: https://github.com/ClangBuiltLinux/linux/issues/1402
Link: https://lkml.kernel.org/r/20210818022339.3863058-1-nathan@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/MAINTAINERS~maintainers-update-clangbuiltlinux-irc-chat
+++ a/MAINTAINERS
@@ -4498,7 +4498,7 @@ L:	clang-built-linux@googlegroups.com
 S:	Supported
 W:	https://clangbuiltlinux.github.io/
 B:	https://github.com/ClangBuiltLinux/linux/issues
-C:	irc://chat.freenode.net/clangbuiltlinux
+C:	irc://irc.libera.chat/clangbuiltlinux
 F:	Documentation/kbuild/llvm.rst
 F:	include/linux/compiler-clang.h
 F:	scripts/clang-tools/
_

Patches currently in -mm which might be from nathan@kernel.org are

maintainers-update-clangbuiltlinux-irc-chat.patch
mm-hugetlb-add-support-for-mempolicy-mpol_preferred_many-fix-fix.patch


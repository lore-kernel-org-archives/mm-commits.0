Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6C27C4332F
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:05:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1B0C611F0
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:05:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346551AbhIIVGJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:06:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:54488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347300AbhIIVFd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 17:05:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 67F6C611EF;
        Thu,  9 Sep 2021 21:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221450;
        bh=QBXudHUstBwneGLTWbZnolyjs7/Yfj6bcJVbe4WoTeU=;
        h=Date:From:To:Subject:From;
        b=peIxk8zJiXUpxJE6IwYZGqVoD4LoA3zggY555aYihlvTCpyGjlvEk3xmvZdDOSNDs
         vhSrpQmwpLF2LVdxrUS+FKCN7jRv5euAHNF3WXo5hyw+5pomrpiBhNwps0LAfuW0HT
         cIsoeTnMelI8yiJmyW56Irz7NoLgWIylanQBE7TE=
Date:   Thu, 09 Sep 2021 14:04:10 -0700
From:   akpm@linux-foundation.org
To:     keescook@chromium.org, masahiroy@kernel.org,
        mm-commits@vger.kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, samitolvanen@google.com
Subject:  [merged] documentation-llvm-update-irc-location.patch
 removed from -mm tree
Message-ID: <20210909210410.Pbk7Us2um%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation/llvm: update IRC location
has been removed from the -mm tree.  Its filename was
     documentation-llvm-update-irc-location.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Nathan Chancellor <nathan@kernel.org>
Subject: Documentation/llvm: update IRC location

This should have been done with commit 91ed3ed0f798 ("MAINTAINERS: update
ClangBuiltLinux IRC chat") but I did not realize it was in two separate
spots.

Link: https://lkml.kernel.org/r/20210825211823.6406-3-nathan@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kbuild/llvm.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/kbuild/llvm.rst~documentation-llvm-update-irc-location
+++ a/Documentation/kbuild/llvm.rst
@@ -114,7 +114,7 @@ Getting Help
 - `Mailing List <https://lore.kernel.org/llvm/>`_: <llvm@lists.linux.dev>
 - `Old Mailing List Archives <https://groups.google.com/g/clang-built-linux>`_
 - `Issue Tracker <https://github.com/ClangBuiltLinux/linux/issues>`_
-- IRC: #clangbuiltlinux on chat.freenode.net
+- IRC: #clangbuiltlinux on irc.libera.chat
 - `Telegram <https://t.me/ClangBuiltLinux>`_: @ClangBuiltLinux
 - `Wiki <https://github.com/ClangBuiltLinux/linux/wiki>`_
 - `Beginner Bugs <https://github.com/ClangBuiltLinux/linux/issues?q=is%3Aopen+is%3Aissue+label%3A%22good+first+issue%22>`_
_

Patches currently in -mm which might be from nathan@kernel.org are



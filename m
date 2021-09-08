Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA389C433EF
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:58:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C68BD61102
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:58:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347049AbhIHC7k (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 22:59:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:57410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347291AbhIHC7i (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 22:59:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE19061100;
        Wed,  8 Sep 2021 02:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631069911;
        bh=AtgRKhJJ0gfbKhF8mMqQlROvfh0ziuCgrd/OBoOaY+A=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=eUyoIhAbyn5w5C0WYd2UWqp+9Nulvj/GjUDZyBuXf5zf8Y1Qt8YDYDqwXTV+/kRyt
         CvnmyOiJObBZ4pb7+2RFmU2d6nn+QU0uZY19AUAXPSZEJK7L4p0Wqp5+tvE8WXFPwE
         4rpfF+iaIaFopOV6xpUwP7F5Rij9VDUwX+iaIaxU=
Date:   Tue, 07 Sep 2021 19:58:30 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, keescook@chromium.org,
        linux-mm@kvack.org, masahiroy@kernel.org,
        mm-commits@vger.kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, samitolvanen@google.com,
        torvalds@linux-foundation.org
Subject:  [patch 098/147] Documentation/llvm: update IRC location
Message-ID: <20210908025830.O1vKR9xwA%akpm@linux-foundation.org>
In-Reply-To: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

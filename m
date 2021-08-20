Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE33DC4338F
	for <mm-commits@archiver.kernel.org>; Fri, 20 Aug 2021 02:04:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8B57610FA
	for <mm-commits@archiver.kernel.org>; Fri, 20 Aug 2021 02:04:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235640AbhHTCE4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 Aug 2021 22:04:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:56604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234428AbhHTCEz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 19 Aug 2021 22:04:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 61E9B610FF;
        Fri, 20 Aug 2021 02:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629425058;
        bh=6G6yWlzFk/0qQIo/Ix5Mr6Lv3wj7cR7kb+VxiX2toEA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ZVjw4iza9Nn9Nx+FhgZbZs4Ubcb2cu+6FEX/WvDGIIIkrxukADUMRNifNUfruNwbf
         IlrAFLZRXGjXOUyrSGDzI2vO1ON8lxflT2Zjs1JfoOQvyEynp+rE1B2is1GEVSbfMk
         Lz7NXhAV55sXTHOvt28q8isR4renRRbrdFsmNVKQ=
Date:   Thu, 19 Aug 2021 19:04:18 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, keescook@chromium.org,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, torvalds@linux-foundation.org
Subject:  [patch 05/10] MAINTAINERS: update ClangBuiltLinux IRC
 chat
Message-ID: <20210820020418.Ucu7Z-_NH%akpm@linux-foundation.org>
In-Reply-To: <20210819190327.14fc4e97102e1af7929e30af@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

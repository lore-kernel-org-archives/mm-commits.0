Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD41DC432BE
	for <mm-commits@archiver.kernel.org>; Mon, 23 Aug 2021 18:24:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F95D613A6
	for <mm-commits@archiver.kernel.org>; Mon, 23 Aug 2021 18:24:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231959AbhHWSY6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 23 Aug 2021 14:24:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:59644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231955AbhHWSY6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 23 Aug 2021 14:24:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 847D961391;
        Mon, 23 Aug 2021 18:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629743055;
        bh=oLr4ta7Z3E96vuT1wXzkGJq/POpGEfjgmeheZaLF3QE=;
        h=Date:From:To:Subject:From;
        b=U07nTigHbLzBsYhx2I9J5is8Is0JQnzNRAD//4QLbl33/uaGHyW1lFUDtG4IoEqIM
         FZwdZ2Tix2mAye7xxSSZoBQ1pNm3jtRHp1AZ3gJiWMKhr+XTKUBGQSiDil7qvc14aB
         ADovG+euv4EZVs6CreV80cH6XD7aTkFshL7XfkZE=
Date:   Mon, 23 Aug 2021 11:24:15 -0700
From:   akpm@linux-foundation.org
To:     keescook@chromium.org, mm-commits@vger.kernel.org,
        nathan@kernel.org, ndesaulniers@google.com
Subject:  [merged]
 maintainers-update-clangbuiltlinux-irc-chat.patch removed from -mm tree
Message-ID: <20210823182415.cbx-sJauV%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: update ClangBuiltLinux IRC chat
has been removed from the -mm tree.  Its filename was
     maintainers-update-clangbuiltlinux-irc-chat.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

mm-hugetlb-add-support-for-mempolicy-mpol_preferred_many-fix-fix.patch


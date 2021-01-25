Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 671EBC433E9
	for <mm-commits@archiver.kernel.org>; Mon, 25 Jan 2021 22:28:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 34EDF2080D
	for <mm-commits@archiver.kernel.org>; Mon, 25 Jan 2021 22:28:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732418AbhAYW23 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Jan 2021 17:28:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:36014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732978AbhAYVhZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 25 Jan 2021 16:37:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7615A22A84;
        Mon, 25 Jan 2021 21:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611610535;
        bh=vXjEW2zC/uctIj25rQ5AYLrOdP8OGQ5NA6Mx+Myor80=;
        h=Date:From:To:Subject:From;
        b=uJ5xsiYW3vkgWypBqidBedo7POb6J+RnKQXq4LjIDxpCKNZudD4ZyPu3Vj0XnX6F0
         /qoN2z+ZH/a8X2rXKfN6x8vgirn1SlZA52O/bwFArI2kdwBdq2O5Yyn2gy1ZoFlwH4
         Pl5dyj5UeM8Gpd0/w8TJKkpYinbrXXQr1nQ6fcBc=
Date:   Mon, 25 Jan 2021 13:35:35 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, natechancellor@gmail.com,
        ndesaulniers@google.com
Subject:  [merged]
 maintainers-add-a-couple-more-files-to-the-clang-llvm-section.patch removed
 from -mm tree
Message-ID: <20210125213535.IkG-htZfF%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add a couple more files to the Clang/LLVM section
has been removed from the -mm tree.  Its filename was
     maintainers-add-a-couple-more-files-to-the-clang-llvm-section.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Nathan Chancellor <natechancellor@gmail.com>
Subject: MAINTAINERS: add a couple more files to the Clang/LLVM section

The K: entry should ensure that Nick and I always get CC'd on patches that
touch these files but it is better to be explicit rather than implicit.

Link: https://lkml.kernel.org/r/20210114004059.2129921-1-natechancellor@gmail.com
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

--- a/MAINTAINERS~maintainers-add-a-couple-more-files-to-the-clang-llvm-section
+++ a/MAINTAINERS
@@ -4311,7 +4311,9 @@ W:	https://clangbuiltlinux.github.io/
 B:	https://github.com/ClangBuiltLinux/linux/issues
 C:	irc://chat.freenode.net/clangbuiltlinux
 F:	Documentation/kbuild/llvm.rst
+F:	include/linux/compiler-clang.h
 F:	scripts/clang-tools/
+F:	scripts/clang-version.sh
 F:	scripts/lld-version.sh
 K:	\b(?i:clang|llvm)\b
 
_

Patches currently in -mm which might be from natechancellor@gmail.com are

mm-zswap-add-the-flag-can_sleep_mapped-fix.patch


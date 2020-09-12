Return-Path: <SRS0=X2ny=CV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CF48C43461
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 16:24:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B809221E5
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 16:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599927843;
	bh=Y8874xJbj6B7xujTRhSd8sFHzsFjmxLgqTnI2zfQaX4=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=MTBWUaMxzkjZqaPOYU7qJHk9mqn81Ah3KXKilN+/ZyYXm2yRK2nMS/P2PB+yDIRjF
	 dTXosqG6v02GoFYAQYTam2wrClr75g0RvYc5yZsFfRAy8/x1RVfL165Lsi+oj6uJ0A
	 5Lakq260tg0aXyoUUNan/nd7VStRT7KeCTc5lFds=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725863AbgILQXp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Sep 2020 12:23:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:59626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725873AbgILQXn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 12 Sep 2020 12:23:43 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79B6F2087C;
        Sat, 12 Sep 2020 16:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599927822;
        bh=Y8874xJbj6B7xujTRhSd8sFHzsFjmxLgqTnI2zfQaX4=;
        h=Date:From:To:Subject:From;
        b=ki+7Rxfm8YpW6d1bHUPOG9lYjluqkGmdlGv/PTJyMeKVJG9nJxtHS9h9EfKR4b7qT
         AXlPzuRqIYbQiNbLyvX76Z95nUD5iO09KpDNaAjCPrktKcGwOHnz1XNwudBEiHHAr+
         ex4mXiMbkqNgNZUxCrwWywavNv9nzo17DNuvdx3s=
Date:   Sat, 12 Sep 2020 09:23:42 -0700
From:   akpm@linux-foundation.org
To:     lukas.bulwahn@gmail.com, masahiroy@kernel.org,
        miguel.ojeda.sandonis@gmail.com, mm-commits@vger.kernel.org,
        natechancellor@gmail.com, ndesaulniers@google.com,
        sedat.dilek@gmail.com
Subject:  [merged] maintainers-add-llvm-maintainers.patch removed
 from -mm tree
Message-ID: <20200912162342.ZmlznXNBI%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add LLVM maintainers
has been removed from the -mm tree.  Its filename was
     maintainers-add-llvm-maintainers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Nick Desaulniers <ndesaulniers@google.com>
Subject: MAINTAINERS: add LLVM maintainers

Nominate Nathan and myself to be point of contact for clang/LLVM related
support, after a poll at the LLVM BoF at Linux Plumbers Conf 2020.

While corporate sponsorship is beneficial, its important to not entrust
the keys to the nukes with any one entity.  Should Nathan and I find
ourselves at the same employer, I would gladly step down.

Link: https://lkml.kernel.org/r/20200825143540.2948637-1-ndesaulniers@google.com
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Acked-by: Nathan Chancellor <natechancellor@gmail.com>
Reviewed-by: Sedat Dilek <sedat.dilek@gmail.com>
Acked-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Acked-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Masahiro Yamada <masahiroy@kernel.org
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

--- a/MAINTAINERS~maintainers-add-llvm-maintainers
+++ a/MAINTAINERS
@@ -4257,6 +4257,8 @@ S:	Maintained
 F:	.clang-format
 
 CLANG/LLVM BUILD SUPPORT
+M:	Nathan Chancellor <natechancellor@gmail.com>
+M:	Nick Desaulniers <ndesaulniers@google.com>
 L:	clang-built-linux@googlegroups.com
 S:	Supported
 W:	https://clangbuiltlinux.github.io/
_

Patches currently in -mm which might be from ndesaulniers@google.com are

compiler-clang-add-build-check-for-clang-1001.patch
revert-kbuild-disable-clangs-default-use-of-fmerge-all-constants.patch
revert-arm64-bti-require-clang-=-1001-for-in-kernel-bti-support.patch
revert-arm64-vdso-fix-compilation-with-clang-older-than-8.patch
partially-revert-arm-8905-1-emit-__gnu_mcount_nc-when-using-clang-1000-or-newer.patch
compiler-gcc-improve-version-error.patch


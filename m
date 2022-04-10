Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 041D4C433F5
	for <mm-commits@archiver.kernel.org>; Sun, 10 Apr 2022 04:39:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231927AbiDJEla (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 10 Apr 2022 00:41:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231952AbiDJElY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 10 Apr 2022 00:41:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C7A92F394
        for <mm-commits@vger.kernel.org>; Sat,  9 Apr 2022 21:39:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E5FE9B80B8A
        for <mm-commits@vger.kernel.org>; Sun, 10 Apr 2022 04:39:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88AC2C385A1;
        Sun, 10 Apr 2022 04:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649565550;
        bh=llcpmXOe39lwuC3LYSf2zjjmGGdi63W414IkNjaqAOA=;
        h=Date:To:From:Subject:From;
        b=nAyBknmp8HijIL5A+C1Gr7/cCAo0sx7A3EKcV+ekSwbF4POYyelv8ChX6KkVx8BzI
         sKTBUaM5v+InLNVzjIwDLtkPUsHdRWtJ14eZaN6LMDqQd2sTe3M1tI4w5y36n6CL59
         VKt25Xo07r0XdHBASzGwBHWApFoLWOA3W5t+Vc7k=
Date:   Sat, 09 Apr 2022 21:39:09 -0700
To:     mm-commits@vger.kernel.org, ndesaulniers@google.com,
        nathan@kernel.org, trix@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] maintainers-add-self-as-clang-reviewer.patch removed from -mm tree
Message-Id: <20220410043910.88AC2C385A1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add Tom as clang reviewer
has been removed from the -mm tree.  Its filename was
     maintainers-add-self-as-clang-reviewer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tom Rix <trix@redhat.com>
Subject: MAINTAINERS: add Tom as clang reviewer

I have been helping with build breaks and other clang things and would
like to help with the reviews.

Link: https://lkml.kernel.org/r/20220407175715.3378998-1-trix@redhat.com
Signed-off-by: Tom Rix <trix@redhat.com>
Acked-by: Nathan Chancellor <nathan@kernel.org>
Acked-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-self-as-clang-reviewer
+++ a/MAINTAINERS
@@ -4791,6 +4791,7 @@ F:	.clang-format
 CLANG/LLVM BUILD SUPPORT
 M:	Nathan Chancellor <nathan@kernel.org>
 M:	Nick Desaulniers <ndesaulniers@google.com>
+R:	Tom Rix <trix@redhat.com>
 L:	llvm@lists.linux.dev
 S:	Supported
 W:	https://clangbuiltlinux.github.io/
_

Patches currently in -mm which might be from trix@redhat.com are

lib-remove-back_str-initialization.patch


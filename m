Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C958FC433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:54:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE1676143B
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:54:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbhEHWz4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:55:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:44578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229660AbhEHWzy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:55:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 82FD46142D;
        Sat,  8 May 2021 22:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514492;
        bh=NnuK4LT7FAGrSEsknfG0Cox5/NbGXyXZTzVOjbgW9CI=;
        h=Date:From:To:Subject:From;
        b=SZosAZscennvh7TC1uKUkoL+1oWK7dIyNoLXuLorgc1sQKw//IFPCaWvUfzkOway9
         Yz7PEMbZyQBBRfMKhPT3LPQEvaE2VrZIqFGfil/G7mfoGjWAvHZTECwOaVsKFoUOJC
         lTtg6y2nXom6KFvgWD6Dxg+uyzb2kVF4StpXhg5o=
Date:   Sat, 08 May 2021 15:54:52 -0700
From:   akpm@linux-foundation.org
To:     drew@beagleboard.org, keescook@chromium.org,
        mm-commits@vger.kernel.org
Subject:  [merged] scripts-spellingtxt-add-overlfow.patch removed
 from -mm tree
Message-ID: <20210508225452.kz14zShQP%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/spelling.txt: add "overlfow"
has been removed from the -mm tree.  Its filename was
     scripts-spellingtxt-add-overlfow.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Drew Fustini <drew@beagleboard.org>
Subject: scripts/spelling.txt: add "overlfow"

Add typo "overlfow" for "overflow". This typo was found and fixed in
net/sctp/tsnmap.c.

Link: https://lore.kernel.org/netdev/20210304055548.56829-1-drew@beagleboard.org/
Link: https://lkml.kernel.org/r/20210304072657.64577-1-drew@beagleboard.org
Signed-off-by: Drew Fustini <drew@beagleboard.org>
Suggested-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/spelling.txt |    1 +
 1 file changed, 1 insertion(+)

--- a/scripts/spelling.txt~scripts-spellingtxt-add-overlfow
+++ a/scripts/spelling.txt
@@ -1027,6 +1027,7 @@ oustanding||outstanding
 overaall||overall
 overhread||overhead
 overlaping||overlapping
+overlfow||overflow
 overide||override
 overrided||overridden
 overriden||overridden
_

Patches currently in -mm which might be from drew@beagleboard.org are



Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E658FC433EF
	for <mm-commits@archiver.kernel.org>; Thu,  3 Feb 2022 22:22:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355773AbiBCWWd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Feb 2022 17:22:33 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:54244 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbiBCWWc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 3 Feb 2022 17:22:32 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EE6DEB835A3
        for <mm-commits@vger.kernel.org>; Thu,  3 Feb 2022 22:22:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD4FCC340E8;
        Thu,  3 Feb 2022 22:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643926950;
        bh=WMDhqnYPRQZmDhKYk3GjN4TxOsNjbjbVnIlg5f90heg=;
        h=Date:To:From:Subject:From;
        b=shggD2pOl57yrhcYs2gJyixOnOVrG/FVzY6aFGqg1U/bram0DHFO9KQbzdZ/qn6Zg
         L2dZlLCtYkFafkrik0O4hGWDEVazKnD0dQ11FnqK0HirKOdtGahq4/4N0EpBRh/5gm
         Reeje2gy4Puyi1HqTaCoPqZTBNfftPZrcz+nS/5k=
Received: by hp1 (sSMTP sendmail emulation); Thu, 03 Feb 2022 14:22:29 -0800
Date:   Thu, 03 Feb 2022 14:22:29 -0800
To:     mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-update-rppts-email.patch added to -mm tree
Message-Id: <20220203222229.AD4FCC340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: update rppt's email
has been added to the -mm tree.  Its filename is
     maintainers-update-rppts-email.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/maintainers-update-rppts-email.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/maintainers-update-rppts-email.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: MAINTAINERS: update rppt's email

Use my @kernel.org address

Link: https://lkml.kernel.org/r/20220203090324.3701774-1-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/MAINTAINERS~maintainers-update-rppts-email
+++ a/MAINTAINERS
@@ -12400,7 +12400,7 @@ F:	include/uapi/linux/membarrier.h
 F:	kernel/sched/membarrier.c
 
 MEMBLOCK
-M:	Mike Rapoport <rppt@linux.ibm.com>
+M:	Mike Rapoport <rppt@kernel.org>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	Documentation/core-api/boot-time-mm.rst
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

mm-pgtable-define-pte_index-so-that-preprocessor-could-recognize-it.patch
maintainers-update-rppts-email.patch
fs-binfmt_elf-fix-pt_load-p_align-values-for-loaders.patch


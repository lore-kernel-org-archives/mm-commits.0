Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46C38C27C76
	for <mm-commits@archiver.kernel.org>; Thu, 26 Jan 2023 01:29:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233619AbjAZB3r (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Jan 2023 20:29:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbjAZB3q (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jan 2023 20:29:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB1884698
        for <mm-commits@vger.kernel.org>; Wed, 25 Jan 2023 17:29:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7DCA0616E2
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 01:29:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAF3DC433EF;
        Thu, 26 Jan 2023 01:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674696584;
        bh=oGOw4xScrbw7ZQPVcjuJ4tZdrnMm4sTzECFF0cHRW3g=;
        h=Date:To:From:Subject:From;
        b=t15s9DPX4R2ATk9zyI1PTblNF6NY16zWgdNrXEBSDyHabPdQYhl3IdxJsqABmu25P
         N0tc1J5EdtKhYOzF9tiU0ds9Xg7HaYTwBj59cskQshwQPiTBj/DHGS9d3rdQl0QRGQ
         3q3BCz2j57vK3WUDbPAb8b62PMcJpr0O5bNMmAbA=
Date:   Wed, 25 Jan 2023 17:29:44 -0800
To:     mm-commits@vger.kernel.org, nico@fluxnic.net,
        rdunlap@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + cramfs-kconfig-fix-spelling-punctuation.patch added to mm-nonmm-unstable branch
Message-Id: <20230126012944.DAF3DC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: cramfs: Kconfig: fix spelling & punctuation
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     cramfs-kconfig-fix-spelling-punctuation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/cramfs-kconfig-fix-spelling-punctuation.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: cramfs: Kconfig: fix spelling & punctuation
Date: Tue, 24 Jan 2023 10:16:31 -0800

Fix spelling and hyphenation in cramfs Kconfig.

Link: https://lkml.kernel.org/r/20230124181631.15204-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Nicolas Pitre <nico@fluxnic.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/fs/cramfs/Kconfig~cramfs-kconfig-fix-spelling-punctuation
+++ a/fs/cramfs/Kconfig
@@ -38,7 +38,7 @@ config CRAMFS_MTD
 	default y if !CRAMFS_BLOCKDEV
 	help
 	  This option allows the CramFs driver to load data directly from
-	  a linear adressed memory range (usually non volatile memory
+	  a linear addressed memory range (usually non-volatile memory
 	  like flash) instead of going through the block device layer.
 	  This saves some memory since no intermediate buffering is
 	  necessary.
_

Patches currently in -mm which might be from rdunlap@infradead.org are

lib-kconfig-fix-spellos.patch
freevxfs-kconfig-fix-spelling.patch
freevxfs-fix-kernel-doc-warnings.patch
ntfs-fix-multiple-kernel-doc-warnings.patch
userns-fix-a-structs-kernel-doc-notation.patch
cramfs-kconfig-fix-spelling-punctuation.patch


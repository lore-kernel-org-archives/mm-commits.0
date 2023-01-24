Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DABDCC61D97
	for <mm-commits@archiver.kernel.org>; Tue, 24 Jan 2023 20:50:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234343AbjAXUuB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 24 Jan 2023 15:50:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234377AbjAXUtx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jan 2023 15:49:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9EE95085E
        for <mm-commits@vger.kernel.org>; Tue, 24 Jan 2023 12:49:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4688BB816D8
        for <mm-commits@vger.kernel.org>; Tue, 24 Jan 2023 20:49:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA67BC433EF;
        Tue, 24 Jan 2023 20:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674593388;
        bh=tuxaBxn8a1dUM3Fr1LFZiFtioFIu7W+RA9aPmS5Nj4w=;
        h=Date:To:From:Subject:From;
        b=stTNPuRB1mv9DopMKQqxqQ5FSSTQyMmJZ4b0r7XUSHp9e/ZnDC+q9+mHcUtfNDSlu
         kTFQ6ENLa43rLQ5wjlhUhLcssnFnZF4VmtQv8T344ZhREaShg8q/imib3WD+Gx1FBe
         qGFLjsHX7IUmePqqn7gOJAi5JqNfWow41wcNIrdQ=
Date:   Tue, 24 Jan 2023 12:49:48 -0800
To:     mm-commits@vger.kernel.org, hch@infradead.org,
        rdunlap@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + freevxfs-kconfig-fix-spelling.patch added to mm-hotfixes-unstable branch
Message-Id: <20230124204948.DA67BC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: freevxfs: Kconfig: fix spelling
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     freevxfs-kconfig-fix-spelling.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/freevxfs-kconfig-fix-spelling.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: freevxfs: Kconfig: fix spelling
Date: Tue, 24 Jan 2023 10:16:38 -0800

Fix a spello in freevxfs Kconfig.
(reported by codespell)

Link: https://lkml.kernel.org/r/20230124181638.15604-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/freevxfs/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/freevxfs/Kconfig~freevxfs-kconfig-fix-spelling
+++ a/fs/freevxfs/Kconfig
@@ -8,7 +8,7 @@ config VXFS_FS
 	  of SCO UnixWare (and possibly others) and optionally available
 	  for Sunsoft Solaris, HP-UX and many other operating systems. However
 	  these particular OS implementations of vxfs may differ in on-disk
-	  data endianess and/or superblock offset. The vxfs module has been
+	  data endianness and/or superblock offset. The vxfs module has been
 	  tested with SCO UnixWare and HP-UX B.10.20 (pa-risc 1.1 arch.)
 	  Currently only readonly access is supported and VxFX versions
 	  2, 3 and 4. Tests were performed with HP-UX VxFS version 3.
_

Patches currently in -mm which might be from rdunlap@infradead.org are

lib-kconfig-fix-spellos.patch
freevxfs-kconfig-fix-spelling.patch
freevxfs-fix-kernel-doc-warnings.patch
ntfs-fix-multiple-kernel-doc-warnings.patch
userns-fix-a-structs-kernel-doc-notation.patch


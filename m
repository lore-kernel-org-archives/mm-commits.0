Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7517C38142
	for <mm-commits@archiver.kernel.org>; Wed,  1 Feb 2023 00:45:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231858AbjBAApW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 31 Jan 2023 19:45:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231846AbjBAApM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jan 2023 19:45:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54413521C0
        for <mm-commits@vger.kernel.org>; Tue, 31 Jan 2023 16:45:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F306EB81FC6
        for <mm-commits@vger.kernel.org>; Wed,  1 Feb 2023 00:45:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DD61C4339B;
        Wed,  1 Feb 2023 00:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675212308;
        bh=zB21Ge7+RLdNgRtTRRL4bKrvrzxKRijc5UQJ25Wo1tk=;
        h=Date:To:From:Subject:From;
        b=r2PBmZP3FwR54iBIzeBgrIKBbTpT59tZdWtB4DLbJTrH6u1/7lvZjMd5beZAw19FA
         M/zpsXt1mkTF9elqiQd+p2kcq9+Q73T6Pp+wsn+OjDSm7JeTSJc+s3h4KctomawMhA
         /PX9uZvFXFPYRHncpvCatXU6dxLyXf/HK11jx7M0=
Date:   Tue, 31 Jan 2023 16:45:08 -0800
To:     mm-commits@vger.kernel.org, hch@infradead.org,
        rdunlap@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] freevxfs-kconfig-fix-spelling.patch removed from -mm tree
Message-Id: <20230201004508.8DD61C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: freevxfs: Kconfig: fix spelling
has been removed from the -mm tree.  Its filename was
     freevxfs-kconfig-fix-spelling.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

freevxfs-fix-kernel-doc-warnings.patch
ntfs-fix-multiple-kernel-doc-warnings.patch
userns-fix-a-structs-kernel-doc-notation.patch
cramfs-kconfig-fix-spelling-punctuation.patch


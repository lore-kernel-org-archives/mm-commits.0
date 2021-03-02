Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2812C433DB
	for <mm-commits@archiver.kernel.org>; Tue,  2 Mar 2021 23:36:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF78E64F2B
	for <mm-commits@archiver.kernel.org>; Tue,  2 Mar 2021 23:36:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbhCBXec (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 2 Mar 2021 18:34:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:37642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2361098AbhCBXUo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Mar 2021 18:20:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B40864F32;
        Tue,  2 Mar 2021 23:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614727203;
        bh=mJwd2tVKBVhXAfMd8hBYptgP7umC7+M7IoJm/Cse77c=;
        h=Date:From:To:Subject:From;
        b=gFYg+7n0FzJ26+3eycVIvjBWU2hZnXSmQ+5/+JQcYRW9GQqdNUkdWptUaHEpnRLgH
         gyUzc70rUK5pL5J0fowsnuokhxnUCpDOCFMgVRaSm2ZYrs0JHVA7/8++156AoIohsk
         CCeVdtZ/eNZ+pzWYXP3AjPd9AN2JygWmgApoxYSw=
Date:   Tue, 02 Mar 2021 15:20:02 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Message-ID: <20210302232002.GfJwbjZKP%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/btrfs/reflink.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/fs/btrfs/reflink.c~linux-next-git-rejects
+++ a/fs/btrfs/reflink.c
@@ -567,11 +567,7 @@ process_slot:
 			set_bit(BTRFS_INODE_NEEDS_FULL_SYNC,
 				&BTRFS_I(inode)->runtime_flags);
 
-<<<<<<< HEAD
-		ret = btrfs_replace_file_extents(inode, path, last_dest_end,
-=======
 		ret = btrfs_replace_file_extents(BTRFS_I(inode), path, last_dest_end,
->>>>>>> linux-next/akpm-base
 				destoff + len - 1, NULL, &trans);
 		if (ret)
 			goto out;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_allocc-refactor-initialization-of-struct-page-for-holes-in-memory-layout-fix.patch
mm.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
kernel-forkc-export-kernel_thread-to-modules.patch


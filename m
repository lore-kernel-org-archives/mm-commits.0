Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2086AC433EF
	for <mm-commits@archiver.kernel.org>; Wed, 13 Jul 2022 20:42:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbiGMUmZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Jul 2022 16:42:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237132AbiGMUmY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jul 2022 16:42:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D73153121C
        for <mm-commits@vger.kernel.org>; Wed, 13 Jul 2022 13:42:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 61C2E61D3E
        for <mm-commits@vger.kernel.org>; Wed, 13 Jul 2022 20:42:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFE18C3411E;
        Wed, 13 Jul 2022 20:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657744942;
        bh=Ocy2Rm+SbQLqEk+Jz8YqONO4iwJDnRbdhkFTeDBHgd0=;
        h=Date:To:From:Subject:From;
        b=aEriQDELSoC211Fd8QFLoQzkLbGGxoWRccGtbMhhGJwCdulDAXjaXHPLeVRfoQ0q+
         QJCDNti/y3XfCBCDrEMKuxBxb6p1IqGkG6frGLkg9+SEYa9Xap748MzmVMZXZe1F8H
         +fSWc9fNR0Qn9SLtXarNI4OemKVl5lGIza5g47f8=
Date:   Wed, 13 Jul 2022 13:42:21 -0700
To:     mm-commits@vger.kernel.org, tytso@mit.edu,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [failures] mm-shmem-add-support-for-fs_ioc_etflags-for-tmpfs-fix.patch removed from -mm tree
Message-Id: <20220713204222.AFE18C3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-shmem-add-support-for-fs_ioc_etflags-for-tmpfs-fix
has been removed from the -mm tree.  Its filename was
     mm-shmem-add-support-for-fs_ioc_etflags-for-tmpfs-fix.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-shmem-add-support-for-fs_ioc_etflags-for-tmpfs-fix
Date: Wed Jul 13 08:48:24 AM PDT 2022

remove extra newlines

Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/shmem.c~mm-shmem-add-support-for-fs_ioc_etflags-for-tmpfs-fix
+++ a/mm/shmem.c
@@ -2846,8 +2846,6 @@ int shmem_fileattr_get(struct dentry *de
 	return 0;
 }
 
-
-
 int shmem_fileattr_set(struct user_namespace *mnt_userns,
 		       struct dentry *dentry, struct fileattr *fa)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

ntfs-fix-use-after-free-in-ntfs_ucsncmp-v3-checkpatch-fixes.patch
android-binder-stop-saving-a-pointer-to-the-vma-fix.patch
mm-remove-the-vma-linked-list-fix-2-fix.patch
mm-drop-oom-code-from-exit_mmap-fix-fix.patch
mm-add-merging-after-mremap-resize-checkpatch-fixes.patch
mm-factor-helpers-for-memory_failure_dev_pagemap-fix.patch
xfs-support-cow-in-fsdax-mode-fix.patch
mm-thp-kill-transparent_hugepage_active-fix.patch
mm-thp-kill-transparent_hugepage_active-fix-fix.patch
mm-page_alloc-protect-pcp-lists-with-a-spinlock-fix.patch


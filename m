Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8821ECCA479
	for <mm-commits@archiver.kernel.org>; Wed, 13 Jul 2022 15:49:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231580AbiGMPtK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Jul 2022 11:49:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236979AbiGMPtH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jul 2022 11:49:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA0931A819
        for <mm-commits@vger.kernel.org>; Wed, 13 Jul 2022 08:49:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E69F6192C
        for <mm-commits@vger.kernel.org>; Wed, 13 Jul 2022 15:49:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81E06C341C0;
        Wed, 13 Jul 2022 15:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657727345;
        bh=W0hDdvSjTPY8tNknLNdnphPD9NHJQiDWDc7fkxcF7Ss=;
        h=Date:To:From:Subject:From;
        b=hWxpR2L4HIOQCkvYUL6PbZLyJidPTGMXpcgxFNmTW1uujzwS4HLOg7V7W4w4L1pGm
         RQTRFdv/ph0A04Pz0NEOKjJ8PR36CpLUmgIxXIDN8GyuJVhzdHv0YpeOTK311V5Dat
         OY+wRxqRzo+CDS5oMGm8U694EJcvM3MYB7JjpC98=
Date:   Wed, 13 Jul 2022 08:49:04 -0700
To:     mm-commits@vger.kernel.org, tytso@mit.edu,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-add-support-for-fs_ioc_etflags-for-tmpfs-fix.patch added to mm-unstable branch
Message-Id: <20220713154905.81E06C341C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-shmem-add-support-for-fs_ioc_etflags-for-tmpfs-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmem-add-support-for-fs_ioc_etflags-for-tmpfs-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-add-support-for-fs_ioc_etflags-for-tmpfs-fix.patch

This patch will later appear in the mm-unstable branch at
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
mm-shmem-add-support-for-fs_ioc_etflags-for-tmpfs-fix.patch


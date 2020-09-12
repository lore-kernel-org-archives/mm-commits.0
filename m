Return-Path: <SRS0=X2ny=CV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A642C433E2
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 19:17:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4DB7121D40
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 19:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599938260;
	bh=3lf84jwVfYCt2qudU7eWWXmscngj0eyB3mUebZpksmc=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=HJWi5Xa9nYi92WezYN1eEXGVTE7oILMEyMbBVuD8TyydxwHUSU/BaWCgBBKf/qfIp
	 aC4GhfcWpPSwwB2WNYwIbRJUFAlBU1DRmr6fRqn391eUUX+2QrUn4aCStq9ILR2mbi
	 kUslZ5ujUftFhogtFGrDv5I6u4B33jzZ7ddiQ1Mg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725872AbgILTRi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Sep 2020 15:17:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:34546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725838AbgILTRi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 12 Sep 2020 15:17:38 -0400
Received: from X1 (unknown [209.33.215.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4FF1207C3;
        Sat, 12 Sep 2020 19:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599938257;
        bh=3lf84jwVfYCt2qudU7eWWXmscngj0eyB3mUebZpksmc=;
        h=Date:From:To:Subject:From;
        b=e24RFuT715Nb4lnqIzhN55DDCKWQ4oVolPpH6FvTze9ZKlqQxZ+cGLgiH5nn6D7+b
         MkuS5JHKZ3yVMxKRZVZ9W6+dYO3tMfCA9ozfF9oWP1lNFkmaMJpo3i3giggVEhreOA
         8O3jsh1pLMTAuhsCSxKyM0R9TWj+46g81t4nK334=
Date:   Sat, 12 Sep 2020 12:17:37 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org
Subject:  + lib-mpi-fix-spello-of-functions.patch added to -mm tree
Message-ID: <20200912191737.IGcLa%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/mpi/mpi-bit.c: fix spello of "functions"
has been added to the -mm tree.  Its filename is
     lib-mpi-fix-spello-of-functions.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-mpi-fix-spello-of-functions.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-mpi-fix-spello-of-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: lib/mpi/mpi-bit.c: fix spello of "functions"

Fix typo/spello of "functions".

Link: https://lkml.kernel.org/r/8df15173-a6df-9426-7cad-a2d279bf1170@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/mpi/mpi-bit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/mpi/mpi-bit.c~lib-mpi-fix-spello-of-functions
+++ a/lib/mpi/mpi-bit.c
@@ -1,4 +1,4 @@
-/* mpi-bit.c  -  MPI bit level fucntions
+/* mpi-bit.c  -  MPI bit level functions
  * Copyright (C) 1998, 1999 Free Software Foundation, Inc.
  *
  * This file is part of GnuPG.
_

Patches currently in -mm which might be from rdunlap@infradead.org are

fs-ocfs2-delete-repeated-words-in-comments.patch
fs-xattrc-fix-kernel-doc-warnings-for-setxattr-removexattr.patch
x86-numa-add-nohmat-option-fix.patch
fs-configfs-delete-repeated-words-in-comments.patch
lib-bitmap-delete-duplicated-words.patch
lib-libcrc32c-delete-duplicated-words.patch
lib-decompress_bunzip2-delete-duplicated-words.patch
lib-devres-delete-duplicated-words.patch
lib-dynamic_queue_limits-delete-duplicated-words-fix-typo.patch
lib-earlycpio-delete-duplicated-words.patch
lib-radix-tree-delete-duplicated-words.patch
lib-syscall-delete-duplicated-words.patch
lib-test_sysctl-delete-duplicated-words.patch
lib-mpi-fix-spello-of-functions.patch


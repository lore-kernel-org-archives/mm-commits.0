Return-Path: <SRS0=Fe7N=DY=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 373B5C433E7
	for <mm-commits@archiver.kernel.org>; Sat, 17 Oct 2020 23:04:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06276208B6
	for <mm-commits@archiver.kernel.org>; Sat, 17 Oct 2020 23:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602975853;
	bh=2vwhZih4MYk5XM4KVGPd73gYFmyGPlJJc73ygLhs8pQ=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=xASx76ClXuDPPIZhL1aNXl0YyP80MKp1h8V2plTYzjKncJnhI2XLvcR2+dwwUbR7O
	 v2iPyfeNR2akyGGxBV5G3gpHVrJaLK+lr4CalMBB6p0cMVE1Q9cDqnG1n+Uf6pPCFt
	 yBf/qe4PIAjVls1xYrT5IqPFaxNbEgYk8iYu0HgE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439836AbgJQXEM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 17 Oct 2020 19:04:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:45570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438235AbgJQXEM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 17 Oct 2020 19:04:12 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8605A20878;
        Sat, 17 Oct 2020 23:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602975850;
        bh=2vwhZih4MYk5XM4KVGPd73gYFmyGPlJJc73ygLhs8pQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=m34SgwzGitpRFvh7LaY6of3zEp0+MqwakolD5NtvEidV+6Jnpdd0gFF0TBNoNeegY
         ATpH2IcvTxXz4EAwhaTzp4tSnE2UAmng5J4OKwbRBQEZHP/KzKb7c72wD+F1lkA7U1
         WWIKzWFf0oMzKJ+93bUsLpTL4Tc1tCcqvO3a4ET0=
Date:   Sat, 17 Oct 2020 16:04:10 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     minchan@kernel.org, mm-commits@vger.kernel.org,
        sfr@canb.auug.org.au
Subject:  [folded-merged]
 =?US-ASCII?Q?mm-madvise-introduce-process=5Fmadvise-syscall-an-external-?=
 =?US-ASCII?Q?memory-hinting-api-fix-fix-fix.patch?= removed from -mm tree
Message-ID: <20201017230410.UJfywgJQF%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject:  mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix.patch

This patch was dropped because it was folded into mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api.patch

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject:  mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix

Link: https://lkml.kernel.org/r/20200905142639.49fc3f1a@canb.auug.org.au
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/unistd32.h |    2 +-
 include/uapi/asm-generic/unistd.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/include/asm/unistd32.h~mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix
+++ a/arch/arm64/include/asm/unistd32.h
@@ -887,7 +887,7 @@ __SYSCALL(__NR_openat2, sys_openat2)
 __SYSCALL(__NR_pidfd_getfd, sys_pidfd_getfd)
 #define __NR_faccessat2 439
 __SYSCALL(__NR_faccessat2, sys_faccessat2)
-#define __NR_watch_mount 440
+#define __NR_process_madvise 440
 __SYSCALL(__NR_process_madvise, sys_process_madvise)
 
 /*
--- a/include/uapi/asm-generic/unistd.h~mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix
+++ a/include/uapi/asm-generic/unistd.h
@@ -857,7 +857,7 @@ __SYSCALL(__NR_openat2, sys_openat2)
 __SYSCALL(__NR_pidfd_getfd, sys_pidfd_getfd)
 #define __NR_faccessat2 439
 __SYSCALL(__NR_faccessat2, sys_faccessat2)
-#define __NR_watch_mount 441
+#define __NR_process_madvise 440
 __SYSCALL(__NR_process_madvise, sys_process_madvise)
 
 #undef __NR_syscalls
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix-fix-fix-fix-fix-fix.patch


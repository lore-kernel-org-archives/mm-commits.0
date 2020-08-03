Return-Path: <SRS0=IQ0i=BN=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E373C433DF
	for <mm-commits@archiver.kernel.org>; Mon,  3 Aug 2020 22:39:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6EE812068F
	for <mm-commits@archiver.kernel.org>; Mon,  3 Aug 2020 22:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596494357;
	bh=gbS6qpqSw98nElU/rLP0MVKZMMZubvq0b/eHdgtJCO4=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=TvWB1jNxcJuF7bqSf2jre1b7yit3cyEpPt3VH1GcLkqGTulRI433O96iQPLVd20Wl
	 lgzPK939bdnc4Zs4ZDZviZpyG7QY4vhJN5FQROoD8YQVl4K0+hh7+XNMtVrU876n6r
	 wfeD1u6e6UlJ9DVPjYm/1Gbo5gQPWi0K59nydj0c=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbgHCWjQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Aug 2020 18:39:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:35348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726276AbgHCWjQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 3 Aug 2020 18:39:16 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D0FC2068F;
        Mon,  3 Aug 2020 22:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596494356;
        bh=gbS6qpqSw98nElU/rLP0MVKZMMZubvq0b/eHdgtJCO4=;
        h=Date:From:To:Subject:From;
        b=qa6pNJDEceMRGHmQLiLWRX9WF8oTUpkkPnED4IM2NlTZO2WlSj3WuA9wT/v0qBRfI
         agUPP2OVjyBJQy+ZYZMXnc0SeQyeqy4y316iNxdxRhPd00OiUfSPZOKMi56Yg04xBw
         4fYaDsKzLwA8ZSG+W8iCAbddIoibnqeVRbtrPT1I=
Date:   Mon, 03 Aug 2020 15:39:15 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Message-ID: <20200803223915.AAfAir2dG%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
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

 arch/arm/include/asm/percpu.h |    4 ----
 1 file changed, 4 deletions(-)

--- a/arch/arm/include/asm/percpu.h~linux-next-git-rejects
+++ a/arch/arm/include/asm/percpu.h
@@ -5,11 +5,7 @@
 #ifndef _ASM_ARM_PERCPU_H_
 #define _ASM_ARM_PERCPU_H_
 
-<<<<<<< HEAD
 #include <asm/thread_info.h>
-=======
-register unsigned long current_stack_pointer asm ("sp");
->>>>>>> linux-next/akpm-base
 
 /*
  * Same as asm-generic/percpu.h, except that we store the per cpu offset
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-fix-kthread_use_mm-vs-tlb-invalidate-fix.patch
mm.patch
mm-handle-page-mapping-better-in-dump_page-fix.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix-fix.patch
mm-thp-replace-http-links-with-https-ones-fix.patch
mm-vmstat-add-events-for-thp-migration-without-split-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
linux-next-rejects.patch
mm-migrate-clear-__gfp_reclaim-to-make-the-migration-callback-consistent-with-regular-thp-allocations-fix.patch
mm-migrate-make-a-standard-migration-target-allocation-function-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch


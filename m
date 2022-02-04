Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A21F1C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  4 Feb 2022 05:44:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239538AbiBDFoL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Feb 2022 00:44:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230515AbiBDFoL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 4 Feb 2022 00:44:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7785DC061714
        for <mm-commits@vger.kernel.org>; Thu,  3 Feb 2022 21:44:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5EE1A61555
        for <mm-commits@vger.kernel.org>; Fri,  4 Feb 2022 05:44:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADBC0C004E1;
        Fri,  4 Feb 2022 05:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643953449;
        bh=KkfQiXaEsN2sMKwfxX91Ns/YWEDgcbPTi1ARPL2N61c=;
        h=Date:To:From:Subject:From;
        b=ILsK4DSeYQ4XCqfMAaW41d6yiWBz9g+t1oYVIJulcBn9u57UYbvlkd4HOyOlfcXnM
         06iVSv/4FEoX/m/ZQRaL0+J2a+urlbo5GMfDoSRSBAykgSeBusgMOVat2I03VkBJmz
         XQU7Js/WIJe0u6k7z39t2NFR8TQw079Eudn/FJbg=
Received: by hp1 (sSMTP sendmail emulation); Thu, 03 Feb 2022 21:44:08 -0800
Date:   Thu, 03 Feb 2022 21:44:08 -0800
To:     mm-commits@vger.kernel.org, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + linux-next-git-rejects.patch added to -mm tree
Message-Id: <20220204054408.ADBC0C004E1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/sysctl.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/kernel/printk/sysctl.c~linux-next-git-rejects
+++ a/kernel/printk/sysctl.c
@@ -11,7 +11,6 @@
 
 static const int ten_thousand = 10000;
 
-<<<<<<< HEAD
 static int proc_dointvec_minmax_sysadmin(struct ctl_table *table, int write,
 				void *buffer, size_t *lenp, loff_t *ppos)
 {
@@ -21,8 +20,6 @@ static int proc_dointvec_minmax_sysadmin
 	return proc_dointvec_minmax(table, write, buffer, lenp, ppos);
 }
 
-=======
->>>>>>> linux-next/akpm-base
 static struct ctl_table printk_sysctls[] = {
 	{
 		.procname	= "printk",
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

remove-bdi_congested-and-wb_congested-and-related-functions-fix.patch
mm.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
mm-move-page-writeback-sysctls-to-is-own-file-checkpatch-fixes.patch
mm-move-page-writeback-sysctls-to-is-own-file-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
numa-balancing-optimize-page-placement-for-memory-tiering-system-fix.patch
proc-alloc-path_max-bytes-for-proc-pid-fd-symlinks-fix.patch
linux-next-rejects.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
linux-next-git-rejects.patch


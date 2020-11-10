Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AE62C56201
	for <mm-commits@archiver.kernel.org>; Tue, 10 Nov 2020 18:13:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 536B8207D3
	for <mm-commits@archiver.kernel.org>; Tue, 10 Nov 2020 18:13:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="EizbfWHP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731282AbgKJSNP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Nov 2020 13:13:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:57996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731394AbgKJSNP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 10 Nov 2020 13:13:15 -0500
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 427C020674;
        Tue, 10 Nov 2020 18:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605031994;
        bh=fMwAp5V8haQLep4uOYNbrDw92GQyil6ldjie+MRPmtk=;
        h=Date:From:To:Subject:From;
        b=EizbfWHPTMWtM0ht/CuRR2vS+LPwz9M7njVpxj2nnYSnL2RFvqHV+a/u05ps4m4Ko
         6db4apZkiItwIhCukan+6Y3+LVqOq1zNzU8syv8lUaXD0K7ECDGyVIAzAPRG6xMWBz
         +/tGXhU+YN4IVpj3+hjBm6vIBMHbjbAvO8iWPmrA=
Date:   Tue, 10 Nov 2020 10:13:13 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  + linux-next-rejects.patch added to -mm tree
Message-ID: <20201110181313.W7RzLKsSK%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-rejects
has been added to the -mm tree.  Its filename is
     linux-next-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-rejects.patch

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
Subject: linux-next-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arc/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arc/Kconfig~linux-next-rejects
+++ a/arch/arc/Kconfig
@@ -507,6 +507,7 @@ config LINUX_RAM_BASE
 config HIGHMEM
 	bool "High Memory Support"
 	select HAVE_ARCH_PFN_VALID
+	select KMAP_LOCAL
 	help
 	  With ARC 2G:2G address split, only upper 2G is directly addressable by
 	  kernel. Enable this to potentially allow access to rest of 2G and PAE
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kthread_worker-document-cpu-hotplug-handling-fix.patch
mm.patch
mm-swap_state-skip-meaningless-swap-cache-readahead-when-ra_infowin-==-0-fix.patch
mm-vmallocc-__vmalloc_area_node-avoid-32-bit-overflow.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
lib-test_bitmapc-add-for_each_set_clump-test-cases-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch
linux-next-git-rejects.patch
linux-next-rejects.patch


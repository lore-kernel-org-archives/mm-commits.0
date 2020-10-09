Return-Path: <SRS0=4AP6=DQ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E833DC433DF
	for <mm-commits@archiver.kernel.org>; Fri,  9 Oct 2020 21:42:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B90272225D
	for <mm-commits@archiver.kernel.org>; Fri,  9 Oct 2020 21:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602279730;
	bh=Qxj/aB37qxxrT2rzD1wsgwFbPr+oaRyfODWpbuscDMA=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=q3uAsk3Ak/do20p/YBIXQJ4yrMxJnEsP6CC7f3BF8IaZkbclH0fgJZL1EhNKlx59R
	 XX2Iff7COG43pz8+k4QgqFYfAcuVdWGMKiX2g7353nf5jiru/PnbPHmgCEt1MP+wWy
	 MMgC/BublEe3ZMxJK0THMJLyCYtzz8n/LkWdvAMU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391903AbgJIVmK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Oct 2020 17:42:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:46360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391902AbgJIVmK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Oct 2020 17:42:10 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1778722247;
        Fri,  9 Oct 2020 21:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602279729;
        bh=Qxj/aB37qxxrT2rzD1wsgwFbPr+oaRyfODWpbuscDMA=;
        h=Date:From:To:Subject:From;
        b=zSQ7EbP07l+ZTrqVBnN2Of7OE8QgzOoRRlnEnctSdxQntdS7RhMH4BzAZxBhwS3HZ
         JirJVdGVS1WmCTZdo455Z99fokkR4wGeBK4fnie1eNmOgqBjx4tLn16bu2exJlE/uV
         J+O/tpSINun0kUiXoMD+lQ3N57hS0TydQRpd/T2g=
Date:   Fri, 09 Oct 2020 14:42:08 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  + linux-next-git-rejects.patch added to -mm tree
Message-ID: <20201009214208.vDIG2MJb5%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

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

 arch/riscv/kernel/vmlinux.lds.S |    3 ---
 drivers/net/usb/rtl8150.c       |    6 ------
 net/rxrpc/conn_event.c          |    4 ----
 3 files changed, 13 deletions(-)

--- a/arch/riscv/kernel/vmlinux.lds.S~linux-next-git-rejects
+++ a/arch/riscv/kernel/vmlinux.lds.S
@@ -70,14 +70,11 @@ SECTIONS
 		_etext = .;
 	}
 
-<<<<<<< HEAD
-=======
 #ifdef CONFIG_EFI
 	. = ALIGN(PECOFF_SECTION_ALIGNMENT);
 	__pecoff_text_end = .;
 #endif
 
->>>>>>> linux-next/akpm-base
 	INIT_DATA_SECTION(16)
 
 	/* Start of data section */
--- a/drivers/net/usb/rtl8150.c~linux-next-git-rejects
+++ a/drivers/net/usb/rtl8150.c
@@ -258,15 +258,9 @@ static void set_ethernet_addr(rtl8150_t
 {
 	u8 node_id[ETH_ALEN];
 	int ret;
-<<<<<<< HEAD
 
 	ret = get_registers(dev, IDR, sizeof(node_id), node_id);
 
-=======
-
-	ret = get_registers(dev, IDR, sizeof(node_id), node_id);
-
->>>>>>> linux-next/akpm-base
 	if (ret == sizeof(node_id)) {
 		ether_addr_copy(dev->netdev->dev_addr, node_id);
 	} else {
--- a/net/rxrpc/conn_event.c~linux-next-git-rejects
+++ a/net/rxrpc/conn_event.c
@@ -341,11 +341,7 @@ static int rxrpc_process_event(struct rx
 		if (ret < 0)
 			return ret;
 
-<<<<<<< HEAD
-		spin_lock(&conn->channel_lock);
-=======
 		spin_lock(&conn->bundle->channel_lock);
->>>>>>> linux-next/akpm-base
 		spin_lock_bh(&conn->state_lock);
 
 		if (conn->state == RXRPC_CONN_SERVICE_CHALLENGING) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-memory_hotplug-introduce-default-phys_to_target_node-implementation-fix.patch
powerpc-mm-move-setting-pte-specific-flags-to-pfn_pte-fix.patch
mm-gup-dont-permit-users-to-call-get_user_pages-with-foll_longterm-fix.patch
mm-page_allocc-clean-code-by-removing-unnecessary-initialization-fix.patch
mm-mempool-add-else-to-split-mutually-exclusive-case-fix.patch
memblock-make-memblock_debug-and-related-functionality-private-fix.patch
arch-drivers-replace-for_each_membock-with-for_each_mem_range-fix.patch
xarray-add-xa_get_order-fix.patch
xarray-add-xas_split-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
mm-memory_hotplug-simplify-page-offlining-fix.patch
checkpatch-warn-on-self-assignments-checkpatch-fixes.patch
checkpatch-emit-a-warning-on-embedded-filenames-fix.patch
fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address-fix.patch
linux-next-rejects.patch
fs-fuse-virtio_fsc-fix-for-mm-memremap_pages-convert-to-struct-range.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix-fix-fix-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
linux-next-git-rejects.patch


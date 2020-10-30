Return-Path: <SRS0=SeUK=EF=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 777F1C00A89
	for <mm-commits@archiver.kernel.org>; Fri, 30 Oct 2020 22:58:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1ABC222245
	for <mm-commits@archiver.kernel.org>; Fri, 30 Oct 2020 22:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604098683;
	bh=N4Qs5NJRgwp7pRoLyKiZD+w/kJN8RbuZFeyb86Hs35U=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=WrwerR5IEqbtPJ++PmJo0erYFqBS2hM8RRlMAp9Wojlwu3D4ZUqMmJjyKgHPLtM8k
	 FxpHMG79nw7J4OWuShlZWRvXRZev2fqcr+z/+ULwdOYcWoEMSy9vx+45ibvOXb+LzG
	 wuLA+QNts96c+4oWuba6OmP3moIq95DU+p21eKj4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725873AbgJ3W6C (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Oct 2020 18:58:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:50976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725780AbgJ3W6C (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Oct 2020 18:58:02 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20E5722228;
        Fri, 30 Oct 2020 22:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604098681;
        bh=N4Qs5NJRgwp7pRoLyKiZD+w/kJN8RbuZFeyb86Hs35U=;
        h=Date:From:To:Subject:From;
        b=YufjsoJXU/lPWQ/3Q/0rIHW+56N4PKBDFqHjOMVYA8z4MZgxNGL7NHSgExFvIPBy4
         Z4UlaKPElF1rImjNh23m2NGCJTgYJ1lEaYBRWxBwCdKs12vDsDABbb30oWKU3SHcfT
         gOd6+er5rODuln6/Vduw/eLzpYpbzAMXcFm5cjfM=
Date:   Fri, 30 Oct 2020 15:58:00 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  + linux-next-git-rejects.patch added to -mm tree
Message-ID: <20201030225800.ETF3OfERo%akpm@linux-foundation.org>
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

 MAINTAINERS                                                     |    4 --
 arch/arm64/boot/dts/marvell/armada-3720-espressobin-v7-emmc.dts |   17 ----------
 arch/arm64/boot/dts/marvell/armada-3720-espressobin-v7.dts      |   17 ----------
 arch/arm64/boot/dts/marvell/armada-3720-espressobin.dtsi        |    5 --
 drivers/gpu/drm/drm_gem.c                                       |    4 --
 fs/io_uring.c                                                   |   16 ---------
 6 files changed, 63 deletions(-)

--- a/arch/arm64/boot/dts/marvell/armada-3720-espressobin.dtsi~linux-next-git-rejects
+++ a/arch/arm64/boot/dts/marvell/armada-3720-espressobin.dtsi
@@ -17,11 +17,6 @@
 		ethernet1 = &switch0port1;
 		ethernet2 = &switch0port2;
 		ethernet3 = &switch0port3;
-<<<<<<< HEAD
-		serial0 = &uart0;
-		serial1 = &uart1;
-=======
->>>>>>> linux-next/akpm-base
 	};
 
 	chosen {
--- a/arch/arm64/boot/dts/marvell/armada-3720-espressobin-v7.dts~linux-next-git-rejects
+++ a/arch/arm64/boot/dts/marvell/armada-3720-espressobin-v7.dts
@@ -27,27 +27,10 @@
 	};
 };
 
-<<<<<<< HEAD
-&switch0 {
-	ports {
-		switch0port1: port@1 {
-			reg = <1>;
-			label = "lan1";
-			phy-handle = <&switch0phy0>;
-		};
-
-		switch0port3: port@3 {
-			reg = <3>;
-			label = "wan";
-			phy-handle = <&switch0phy2>;
-		};
-	};
-=======
 &switch0port1 {
 	label = "lan1";
 };
 
 &switch0port3 {
 	label = "wan";
->>>>>>> linux-next/akpm-base
 };
--- a/arch/arm64/boot/dts/marvell/armada-3720-espressobin-v7-emmc.dts~linux-next-git-rejects
+++ a/arch/arm64/boot/dts/marvell/armada-3720-espressobin-v7-emmc.dts
@@ -28,29 +28,12 @@
 	};
 };
 
-<<<<<<< HEAD
-&switch0 {
-	ports {
-		switch0port1: port@1 {
-			reg = <1>;
-			label = "lan1";
-			phy-handle = <&switch0phy0>;
-		};
-
-		switch0port3: port@3 {
-			reg = <3>;
-			label = "wan";
-			phy-handle = <&switch0phy2>;
-		};
-	};
-=======
 &switch0port1 {
 	label = "lan1";
 };
 
 &switch0port3 {
 	label = "wan";
->>>>>>> linux-next/akpm-base
 };
 
 &sdhci0 {
--- a/drivers/gpu/drm/drm_gem.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/drm_gem.c
@@ -1078,11 +1078,7 @@ int drm_gem_mmap_obj(struct drm_gem_obje
 
 	vma->vm_private_data = obj;
 
-<<<<<<< HEAD
-	if (obj->funcs && obj->funcs->mmap) {
-=======
 	if (obj->funcs->mmap) {
->>>>>>> linux-next/akpm-base
 		ret = obj->funcs->mmap(obj, vma);
 		if (ret) {
 			drm_gem_object_put(obj);
--- a/fs/io_uring.c~linux-next-git-rejects
+++ a/fs/io_uring.c
@@ -1940,10 +1940,6 @@ static void __io_free_req(struct io_kioc
 	percpu_ref_put(&ctx->refs);
 }
 
-<<<<<<< HEAD
-static void io_kill_linked_timeout(struct io_kiocb *req)
-{
-=======
 static inline void io_remove_next_linked(struct io_kiocb *req)
 {
 	struct io_kiocb *nxt = req->link;
@@ -1954,22 +1950,14 @@ static inline void io_remove_next_linked
 
 static void io_kill_linked_timeout(struct io_kiocb *req)
 {
->>>>>>> linux-next/akpm-base
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_kiocb *link;
 	bool cancelled = false;
 	unsigned long flags;
-<<<<<<< HEAD
-
-	spin_lock_irqsave(&ctx->completion_lock, flags);
-	link = list_first_entry_or_null(&req->link_list, struct io_kiocb,
-					link_list);
-=======
 
 	spin_lock_irqsave(&ctx->completion_lock, flags);
 	link = req->link;
 
->>>>>>> linux-next/akpm-base
 	/*
 	 * Can happen if a linked timeout fired and link had been like
 	 * req -> link t-out -> link t-out [-> ...]
@@ -1978,12 +1966,8 @@ static void io_kill_linked_timeout(struc
 		struct io_timeout_data *io = link->async_data;
 		int ret;
 
-<<<<<<< HEAD
-		list_del_init(&link->link_list);
-=======
 		io_remove_next_linked(req);
 		link->timeout.head = NULL;
->>>>>>> linux-next/akpm-base
 		ret = hrtimer_try_to_cancel(&io->timer);
 		if (ret != -1) {
 			io_cqring_fill_event(link, -ECANCELED);
--- a/MAINTAINERS~linux-next-git-rejects
+++ a/MAINTAINERS
@@ -2373,11 +2373,7 @@ F:	drivers/i2c/busses/i2c-rk3x.c
 F:	sound/soc/rockchip/
 N:	rockchip
 
-<<<<<<< HEAD
-ARM/SAMSUNG EXYNOS ARM ARCHITECTURES
-=======
 ARM/SAMSUNG S3C, S5P AND EXYNOS ARM ARCHITECTURES
->>>>>>> linux-next/akpm-base
 M:	Krzysztof Kozlowski <krzk@kernel.org>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 L:	linux-samsung-soc@vger.kernel.org
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memcontrol-correct-the-nr_anon_thps-counter-of-hierarchical-memcg-fix.patch
mm-memcontrol-correct-the-nr_anon_thps-counter-of-hierarchical-memcg-fix-fix.patch
mm-vmscan-fix-nr_isolated_file-corruption-on-64-bit-fix.patch
mm.patch
mm-swap_state-skip-meaningless-swap-cache-readahead-when-ra_infowin-==-0-fix.patch
mm-page_alloc-do-not-rely-on-the-order-of-page_poison-and-init_on_alloc-free-parameters-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
lib-test_bitmapc-add-for_each_set_clump-test-cases-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch
linux-next-git-rejects.patch


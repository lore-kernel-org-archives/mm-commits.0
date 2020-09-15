Return-Path: <SRS0=Dxzc=CY=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D15A1C433E2
	for <mm-commits@archiver.kernel.org>; Tue, 15 Sep 2020 23:47:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9756820809
	for <mm-commits@archiver.kernel.org>; Tue, 15 Sep 2020 23:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600213665;
	bh=lqstKWA8dL8pFkKNQgcrJAtpt38yQGEjuL+Pakgf9Ww=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Bv9dLOszdrGooEvyK4lpz2sgMK7RoP0tcqacDFsPKZJsXIqTFkPKmFrmHcWxym11Y
	 qJSNVAuO9vI8Esy5nEwiQIUSnJUJCX8YPN7VEFW5BNXiNl1rVLiyqDHVV98V4z812Z
	 Snzjsq0J+qcTLzDS/qK/IX7pHRHgV81T4/uQC+j4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727070AbgIOXrm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Sep 2020 19:47:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:45382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727346AbgIOXpi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Sep 2020 19:45:38 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6AA9820715;
        Tue, 15 Sep 2020 23:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600213522;
        bh=lqstKWA8dL8pFkKNQgcrJAtpt38yQGEjuL+Pakgf9Ww=;
        h=Date:From:To:Subject:From;
        b=Ak8+whWpPkyvyFpM0IZcs/SDT4Cl4haZvB1O6UNpyqky4jITm6zfQMgF83lfUlJOq
         7XjmhCV5JRx1RsVkV37Gv3f0VNwFgyg2wqioykZgnHBskQ8+4soO3lUg5rBrMuWC7i
         +Iz5Hs+9TH2p3UTsMQk+aAL8C/f1eK8cuxZ1FFb8=
Date:   Tue, 15 Sep 2020 16:45:22 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Message-ID: <20200915234522.2bDvoym-t%akpm@linux-foundation.org>
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

 drivers/infiniband/ulp/rtrs/rtrs-srv.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/infiniband/ulp/rtrs/rtrs-srv.c~linux-next-git-rejects
+++ a/drivers/infiniband/ulp/rtrs/rtrs-srv.c
@@ -1344,10 +1344,6 @@ static struct rtrs_srv *__alloc_srv(stru
 	srv->queue_depth = sess_queue_depth;
 	srv->ctx = ctx;
 	device_initialize(&srv->dev);
-<<<<<<< HEAD
-	srv->dev.release = rtrs_srv_dev_release;
-=======
->>>>>>> linux-next/akpm-base
 
 	srv->chunks = kcalloc(srv->queue_depth, sizeof(*srv->chunks),
 			      GFP_KERNEL);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-memory_hotplug-introduce-default-phys_to_target_node-implementation-fix.patch
device-dax-make-pgmap-optional-for-instance-creation-fix.patch
mm-memremap_pages-support-multiple-ranges-per-invocation-fix.patch
device-dax-make-align-a-per-device-property-fix.patch
powerpc-mm-move-setting-pte-specific-flags-to-pfn_pte-fix.patch
mm-gup-dont-permit-users-to-call-get_user_pages-with-foll_longterm-fix.patch
mm-page_allocc-clean-code-by-removing-unnecessary-initialization-fix.patch
memblock-make-memblock_debug-and-related-functionality-private-fix.patch
arch-drivers-replace-for_each_membock-with-for_each_mem_range-fix.patch
xarray-add-xa_get_order-fix.patch
xarray-add-xas_split-fix.patch
mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
mm-memory_hotplug-simplify-page-offlining-fix.patch
checkpatch-warn-on-self-assignments-checkpatch-fixes.patch
fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address-fix.patch
linux-next-rejects.patch
drivers-media-pci-ttpci-av7110_v4lc-fix-build.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch


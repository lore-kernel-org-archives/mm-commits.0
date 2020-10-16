Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCD0EC433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:52:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69E06218AC
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881522;
	bh=dwwFdmOkKg0m4XBqhXob0QR9IXZYRB7ZK3R1isGmqOE=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=IOvbWUUGWeUQ9Pn5Wjxpc7ZmPbPjGFe9eD7Fp26LboljUBaCB1oEFWUB9aWM6OsgH
	 b0M0dmPLMAcQTdQnUq9uWnS3hkuE4UBQ/jyxqFLtsO6TxicL+sIq4UufrnZcIsRtJv
	 efTOO15j0xfO3JQMoMo4o0X7tD2W0jO1bXOF/o5k=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408165AbgJPUwC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:52:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:40690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408118AbgJPUwA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:52:00 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF2B220878;
        Fri, 16 Oct 2020 20:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881518;
        bh=dwwFdmOkKg0m4XBqhXob0QR9IXZYRB7ZK3R1isGmqOE=;
        h=Date:From:To:Subject:From;
        b=I//Omh/5cJweOxmChpu/u24SlisZQqovzlMew5A7IL3LsPBnD+0kDy8fHi2JLfJwG
         VwyHQ0qJTpZsRkav6RQ/bVbmzBGjNVzu0dWun/QGWMq+layJSGekw+Jph/B+oHIj5j
         FkW5veKQH4fJ6I0tfJSEQ/V4MYCLt0QG+gK6MXAk=
Date:   Fri, 16 Oct 2020 13:51:58 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, penberg@kernel.org,
        yuehaibing@huawei.com
Subject:  [merged] mm-slab-remove-duplicate-include.patch removed
 from -mm tree
Message-ID: <20201016205158.S-nVf7zZM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab.h: remove duplicate include
has been removed from the -mm tree.  Its filename was
     mm-slab-remove-duplicate-include.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: YueHaibing <yuehaibing@huawei.com>
Subject: mm/slab.h: remove duplicate include

Remove duplicate header which is included twice.

Link: http://lkml.kernel.org/r/20200818114323.58156-1-yuehaibing@huawei.com
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.h |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/slab.h~mm-slab-remove-duplicate-include
+++ a/mm/slab.h
@@ -46,7 +46,6 @@ struct kmem_cache {
 #include <linux/kmemleak.h>
 #include <linux/random.h>
 #include <linux/sched/mm.h>
-#include <linux/kmemleak.h>
 
 /*
  * State of the slab allocator.
_

Patches currently in -mm which might be from yuehaibing@huawei.com are

mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix-fix-fix.patch


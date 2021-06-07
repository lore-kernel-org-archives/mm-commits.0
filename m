Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82A95C47094
	for <mm-commits@archiver.kernel.org>; Mon,  7 Jun 2021 20:41:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6DD24611AE
	for <mm-commits@archiver.kernel.org>; Mon,  7 Jun 2021 20:41:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231501AbhFGUnS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Jun 2021 16:43:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:58490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230299AbhFGUnS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 7 Jun 2021 16:43:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83326611AD;
        Mon,  7 Jun 2021 20:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623098486;
        bh=X4lcpIoDdifR2+ypxfyE+afh8y0Evd0AzA2Utdl294c=;
        h=Date:From:To:Subject:From;
        b=GaoCX+35CE11eZONxK1cOYfSkDbd4JeMcDV/H+W8Dl0jewAvE4byZ4Avxn2AxNOLv
         WhewOKZmuanaTaFvSdIDKlQdBLYvl7JBwmlUGe3tFVAej1P2yFyXbq6T6EfiexJ2Tx
         En/hPCWvKeOBtQNwPL4nJ+tpduMMzy5MJzto0Yxs=
Date:   Mon, 07 Jun 2021 13:41:26 -0700
From:   akpm@linux-foundation.org
To:     colyli@suse.de, mm-commits@vger.kernel.org, rdunlap@infradead.org,
        yuehaibing@huawei.com
Subject:  [merged] lib-crc64-fix-kernel-doc-warning.patch removed
 from -mm tree
Message-ID: <20210607204126.JWrdD48af%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib: crc64: fix kernel-doc warning
has been removed from the -mm tree.  Its filename was
     lib-crc64-fix-kernel-doc-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: YueHaibing <yuehaibing@huawei.com>
Subject: lib: crc64: fix kernel-doc warning

Fix W=1 kernel build warning:

lib/crc64.c:40: warning:
 bad line:         or the previous crc64 value if computing incrementally.

Link: https://lkml.kernel.org/r/20210601135851.15444-1-yuehaibing@huawei.com
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Reviewed-by: Coly Li <colyli@suse.de>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/crc64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/crc64.c~lib-crc64-fix-kernel-doc-warning
+++ a/lib/crc64.c
@@ -37,7 +37,7 @@ MODULE_LICENSE("GPL v2");
 /**
  * crc64_be - Calculate bitwise big-endian ECMA-182 CRC64
  * @crc: seed value for computation. 0 or (u64)~0 for a new CRC calculation,
-	or the previous crc64 value if computing incrementally.
+ *       or the previous crc64 value if computing incrementally.
  * @p: pointer to buffer over which CRC64 is run
  * @len: length of buffer @p
  */
_

Patches currently in -mm which might be from yuehaibing@huawei.com are

mm-dmapool-use-device_attr_ro-macro.patch
mm-hugetlb-fix-racy-resv_huge_pages-underflow-on-uffdio_copy-fix.patch
mm-compaction-use-device_attr_wo-macro.patch


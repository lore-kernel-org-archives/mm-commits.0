Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06AF0C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 28 Mar 2022 21:13:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbiC1VPH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Mar 2022 17:15:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiC1VPG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Mar 2022 17:15:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25A35DDA
        for <mm-commits@vger.kernel.org>; Mon, 28 Mar 2022 14:13:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ABC8761505
        for <mm-commits@vger.kernel.org>; Mon, 28 Mar 2022 21:13:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06CABC340F0;
        Mon, 28 Mar 2022 21:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648502001;
        bh=YJMzCBDrk1LdevqXxmQjSkvtHFL56b7KsYDS9zheHTo=;
        h=Date:To:From:Subject:From;
        b=Q4bIYHLs84ermvHbJrmZ5YzT3osXRqejvNJb3KsgjwaxLHJfZvDGQkTxw7vwWhzl9
         lSNtwvyqe+k7yVkSF6ugDxKMo3Dudl+HO5v7Dr+BtbAAtkBDMGBoGR660p1ojZgccB
         B6yzvFusLMNKNy9RgIHy+zPufmrgTNF4bhy9r/vI=
Date:   Mon, 28 Mar 2022 14:13:20 -0700
To:     mm-commits@vger.kernel.org, zhaochongxi2019@email.szu.edu.cn,
        yuhongf@szu.edu.cn, yejiajian2018@email.szu.edu.cn,
        weizhenliang@huawei.com, tangbin@cmss.chinamobile.com,
        sfr@canb.auug.org.au, seanga2@gmail.com, liuyongqiang13@huawei.com,
        georgi.djakov@linaro.org, corbet@lwn.net,
        caoyixuan2019@email.szu.edu.cn, zhangyinan2019@email.szu.edu.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + doc-vm-page_ownerrst-remove-content-related-to-c-option.patch added to -mm tree
Message-Id: <20220328211321.06CABC340F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: doc/vm/page_owner.rst: remove content related to -c option
has been added to the -mm tree.  Its filename is
     doc-vm-page_ownerrst-remove-content-related-to-c-option.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/doc-vm-page_ownerrst-remove-content-related-to-c-option.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/doc-vm-page_ownerrst-remove-content-related-to-c-option.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yinan Zhang <zhangyinan2019@email.szu.edu.cn>
Subject: doc/vm/page_owner.rst: remove content related to -c option

-c option has been removed from page_owner_sort.c.

Remove the usage of -c option from Documentation.

This work is coauthored by
        Shenghong Han
        Yixuan Cao
        Chongxi Zhao
        Jiajian Ye
        Yuhong Feng
        Yongqiang Liu

Link: https://lkml.kernel.org/r/20220326085920.1470081-2-zhangyinan2019@email.szu.edu.cn
Signed-off-by: Yinan Zhang <zhangyinan2019@email.szu.edu.cn>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Sean Anderson <seanga2@gmail.com>
Cc: Tang Bin <tangbin@cmss.chinamobile.com>
Cc: Zhenliang Wei <weizhenliang@huawei.com>
Cc: Georgi Djakov <georgi.djakov@linaro.org>
Cc: Chongxi Zhao <zhaochongxi2019@email.szu.edu.cn>
Cc: Jiajian Ye <yejiajian2018@email.szu.edu.cn>
Cc: Yixuan Cao <caoyixuan2019@email.szu.edu.cn>
Cc: Yuhong Feng <yuhongf@szu.edu.cn>
Cc: Yongqiang Liu <liuyongqiang13@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/page_owner.rst |    1 -
 1 file changed, 1 deletion(-)

--- a/Documentation/vm/page_owner.rst~doc-vm-page_ownerrst-remove-content-related-to-c-option
+++ a/Documentation/vm/page_owner.rst
@@ -125,7 +125,6 @@ Usage
    additional function:
 
 	Cull:
-		-c		Cull by comparing stacktrace instead of total block.
 		--cull <rules>
 				Specify culling rules.Culling syntax is key[,key[,...]].Choose a
 				multi-letter key from the **STANDARD FORMAT SPECIFIERS** section.
_

Patches currently in -mm which might be from zhangyinan2019@email.szu.edu.cn are

tools-vm-page_owner_sortc-remove-c-option.patch
doc-vm-page_ownerrst-remove-content-related-to-c-option.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7DD9C47088
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:05:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbiLAAFz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:05:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230261AbiLAADw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:03:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C3078EE68
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:01:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3D95BB81D12
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:01:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA901C433D7;
        Thu,  1 Dec 2022 00:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852909;
        bh=IvSdp4qJq8+9DxL8NfPUUXwL2BjhkTPQkczUJRzhnRM=;
        h=Date:To:From:Subject:From;
        b=WU/9kQ4YVKd3RTQbL/a0+8bgG7zc0Imv0WnDw6t04ydZooMOq4eVdW2RE6o9XoECN
         Gprm4m5DIu6kc/+tz1fK8PeBLIzjPNFZ9RylRQ+mtspTidxN0tKIFM9Z3pZRN5ntho
         ZKMQasjN7hNFFwa5XefDd5M6YdLW8NQt8ovnEx1s=
Date:   Wed, 30 Nov 2022 16:01:48 -0800
To:     mm-commits@vger.kernel.org, caoyixuan2019@email.szu.edu.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kmemleakc-fix-a-comment.patch removed from -mm tree
Message-Id: <20221201000148.EA901C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/kmemleak.c: fix a comment
has been removed from the -mm tree.  Its filename was
     mm-kmemleakc-fix-a-comment.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yixuan Cao <caoyixuan2019@email.szu.edu.cn>
Subject: mm/kmemleak.c: fix a comment
Date: Tue, 15 Nov 2022 01:14:26 +0800

I noticed a typo in a code comment and I fixed it.

Link: https://lkml.kernel.org/r/20221114171426.91745-1-caoyixuan2019@email.szu.edu.cn
Signed-off-by: Yixuan Cao <caoyixuan2019@email.szu.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kmemleak.c~mm-kmemleakc-fix-a-comment
+++ a/mm/kmemleak.c
@@ -1461,7 +1461,7 @@ static void scan_gray_list(void)
 }
 
 /*
- * Conditionally call resched() in a object iteration loop while making sure
+ * Conditionally call resched() in an object iteration loop while making sure
  * that the given object won't go away without RCU read lock by performing a
  * get_object() if !pinned.
  *
_

Patches currently in -mm which might be from caoyixuan2019@email.szu.edu.cn are



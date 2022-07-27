Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD73FC00144
	for <mm-commits@archiver.kernel.org>; Wed, 27 Jul 2022 01:25:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239832AbiG0BZr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 26 Jul 2022 21:25:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230014AbiG0BZl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2022 21:25:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D91118B11
        for <mm-commits@vger.kernel.org>; Tue, 26 Jul 2022 18:25:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B5C4FB81F12
        for <mm-commits@vger.kernel.org>; Wed, 27 Jul 2022 01:25:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 528C3C433D7;
        Wed, 27 Jul 2022 01:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658885137;
        bh=mKa4j3mZ0RLD10zt78YNcdzFYzwq7X+mRoRFylI7ijI=;
        h=Date:To:From:Subject:From;
        b=eo2EDssRXFK37pf64/iXRjjyw8il2fUacEGXxj6u0667LnJH+sdMYcGI1n8usEpNg
         Jy+AmIWmUXOyyS4/+LbIXOddkwKqunLMO55TANMz48xk+1vLzTfdviDTh0sn2zEsf3
         xhdVSa3jBkmIWRWRbZLJVmb5Fu6bXY2XKk4Jb0po=
Date:   Tue, 26 Jul 2022 18:25:35 -0700
To:     mm-commits@vger.kernel.org, xiang@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-update-gao-xiangs-email-addresses.patch removed from -mm tree
Message-Id: <20220727012537.528C3C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mailmap: update Gao Xiang's email addresses
has been removed from the -mm tree.  Its filename was
     mailmap-update-gao-xiangs-email-addresses.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Gao Xiang <xiang@kernel.org>
Subject: mailmap: update Gao Xiang's email addresses
Date: Tue, 19 Jul 2022 23:42:46 +0800

I've been in Alibaba Cloud for more than one year, mainly to address
cloud-native challenges (such as high-performance container images) for
open source communities.

Update my email addresses on behalf of my current employer (Alibaba Cloud)
to support all my (team) work in this area.  Also add an outdated
@redhat.com address of me.

Link: https://lkml.kernel.org/r/20220719154246.62970-1-xiang@kernel.org
Signed-off-by: Gao Xiang <xiang@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    2 ++
 1 file changed, 2 insertions(+)

--- a/.mailmap~mailmap-update-gao-xiangs-email-addresses
+++ a/.mailmap
@@ -132,6 +132,8 @@ Frank Rowand <frowand.list@gmail.com> <f
 Frank Zago <fzago@systemfabricworks.com>
 Gao Xiang <xiang@kernel.org> <gaoxiang25@huawei.com>
 Gao Xiang <xiang@kernel.org> <hsiangkao@aol.com>
+Gao Xiang <xiang@kernel.org> <hsiangkao@linux.alibaba.com>
+Gao Xiang <xiang@kernel.org> <hsiangkao@redhat.com>
 Gerald Schaefer <gerald.schaefer@linux.ibm.com> <geraldsc@de.ibm.com>
 Gerald Schaefer <gerald.schaefer@linux.ibm.com> <gerald.schaefer@de.ibm.com>
 Gerald Schaefer <gerald.schaefer@linux.ibm.com> <geraldsc@linux.vnet.ibm.com>
_

Patches currently in -mm which might be from xiang@kernel.org are



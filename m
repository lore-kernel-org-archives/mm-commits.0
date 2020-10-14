Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F6ADC433DF
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:55:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C49A022254
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602708956;
	bh=ZG3H8guTEZ/uR8MnPIBslNlHtpcf175TsNU9vZE40vw=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=sxpnOQNG2XA37JMZKnuzJr1ebeAB9CMAmspuOv8rNaXpre8xpe2VG1LR5LEVRXNhc
	 vUm+SGFhgp0MQIqRSn1Q5NRAi40/eiB9+0v6MtwWbVXOA1vDpsw9ehEkbpvtw8TM0v
	 6VXvH9Lz9ut/qT4NUIkJ9wwX7KGEwDmbSDYHDTSk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389366AbgJNUz4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 16:55:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:46334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389361AbgJNUz4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 16:55:56 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A89942224E;
        Wed, 14 Oct 2020 20:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602708956;
        bh=ZG3H8guTEZ/uR8MnPIBslNlHtpcf175TsNU9vZE40vw=;
        h=Date:From:To:Subject:From;
        b=iTd/9XuZ87y6mdYjeUti3d8kRH/KlSwOvn3uSrN+k0OSn1I3e/KEVdpE7tTVFLnn0
         YsNVfU+0zUsbS/Qgsq2D+Ga2ZlhIMF7jlkI+fLhLFZPRXxkv+h8yjYu7rsz6HHHOyw
         7JFx1w62PDeSr1pBvGtKliVcrYzmHjeIFItbHUWs=
Date:   Wed, 14 Oct 2020 13:55:55 -0700
From:   akpm@linux-foundation.org
To:     apw@canonical.com, colin.king@canonical.com, joe@perches.com,
        mm-commits@vger.kernel.org, naoki.hayama@lineo.co.jp
Subject:  [merged] scripts-spellingtxt-add-arbitrary-typo.patch
 removed from -mm tree
Message-ID: <20201014205555.INCnVQQ-7%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/spelling.txt: add "arbitrary" typo
has been removed from the -mm tree.  Its filename was
     scripts-spellingtxt-add-arbitrary-typo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoki Hayama <naoki.hayama@lineo.co.jp>
Subject: scripts/spelling.txt: add "arbitrary" typo

Add "abitrary||arbitrary".

Link: https://lkml.kernel.org/r/6bf6520d-787d-5749-09b5-ff92185f501f@lineo.co.jp
Signed-off-by: Naoki Hayama <naoki.hayama@lineo.co.jp>
Cc: Colin Ian King <colin.king@canonical.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/spelling.txt |    1 +
 1 file changed, 1 insertion(+)

--- a/scripts/spelling.txt~scripts-spellingtxt-add-arbitrary-typo
+++ a/scripts/spelling.txt
@@ -9,6 +9,7 @@
 #
 abandonning||abandoning
 abigious||ambiguous
+abitrary||arbitrary
 abitrate||arbitrate
 abnornally||abnormally
 abnrormal||abnormal
_

Patches currently in -mm which might be from naoki.hayama@lineo.co.jp are



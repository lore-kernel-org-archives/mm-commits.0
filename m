Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DFBCC433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:04:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6397320774
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266275;
	bh=iB8oNnS/WEwex2RZqqb9iUdpK+mUPv7gJK+OkTsz7eU=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Jh/ucjBcIcESCbtLfw1vSzEHLjjYXkD86hUGibJ1TpmwIWb5g7w47LEaskZLwQZ0S
	 7venhZw+azD+s3TjoSvAgc8ObbTjF+W7A42WAtnYZt1ib0Mah7kTHlCbrfYs8GuUpu
	 oCLuVi6TqojKqwyqqjgiLypJ+CnPIDy7Y+f/7TQM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726578AbgHLVEf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:04:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:57134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726531AbgHLVEd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:04:33 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 625CC2078B;
        Wed, 12 Aug 2020 21:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266273;
        bh=iB8oNnS/WEwex2RZqqb9iUdpK+mUPv7gJK+OkTsz7eU=;
        h=Date:From:To:Subject:From;
        b=0ZZwafpS802rIunnyI0l+i3yPmWfcbqdItZC6igaP0EazS2EXC1ufhnrK9vaPJVP6
         /19m0p24gPAdDhy2QV37BJOKB/LQkVi09QeieFINTiGqMUhpPzqMq+te+NLh4L7dAX
         KcGCJ0YWcM9fa/vt9rZQjYTPVF8dpF2Y0400D+Ig=
Date:   Wed, 12 Aug 2020 14:04:33 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, raven@themaw.net, rdunlap@infradead.org
Subject:  [merged] autofs-fix-doubled-word.patch removed from -mm
 tree
Message-ID: <20200812210433.osbp6ZFfJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: autofs: fix doubled word
has been removed from the -mm tree.  Its filename was
     autofs-fix-doubled-word.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: autofs: fix doubled word

Change doubled word "is" to "it is".

Link: http://lkml.kernel.org/r/5a82befd-40f8-8dc0-3498-cbc0436cad9b@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/auto_dev-ioctl.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/uapi/linux/auto_dev-ioctl.h~autofs-fix-doubled-word
+++ a/include/uapi/linux/auto_dev-ioctl.h
@@ -82,7 +82,7 @@ struct args_ismountpoint {
 /*
  * All the ioctls use this structure.
  * When sending a path size must account for the total length
- * of the chunk of memory otherwise is is the size of the
+ * of the chunk of memory otherwise it is the size of the
  * structure.
  */
 
_

Patches currently in -mm which might be from rdunlap@infradead.org are



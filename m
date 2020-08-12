Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BB68C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:03:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CDD5220774
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266194;
	bh=1xvUcH7i4yj+InbQWU3NhLUFqGxwLPa7xNh7uiW1ieA=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=gqSru+XbUcdDKAPIVJPF2jA90QTCpf1Fs4cNLcdNF7fh0Zpynxg+w+lErV0JxZ8yX
	 xWpidjFHYWOQLoQU8EHsgd6q6HfA9fE7RkMJcjBeo7hVZxw6etCm61SKUEK0PtUuBm
	 IscpYx8HYmw+7UXdQ5YsOIyBvQmD+jykO5MoyYIM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbgHLVDO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:03:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:52514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726557AbgHLVDN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:03:13 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CC062078B;
        Wed, 12 Aug 2020 21:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266193;
        bh=1xvUcH7i4yj+InbQWU3NhLUFqGxwLPa7xNh7uiW1ieA=;
        h=Date:From:To:Subject:From;
        b=nA+WI9ydizV0m/3KkM+Ljln+HLcurxDTmRPJEJ+iFS9CNV9F6TC8XteviJCA6Kynj
         Uxp3z0dDnHVOsGtdeDIOaqNplGPWYUrksWU/veEPQgT7frFDlptARrUAwbnflLpJr/
         CsaxhP0p0ubiLf0PcJXtm668AoHZzPtBvu2JOCbo=
Date:   Wed, 12 Aug 2020 14:03:13 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, ziy@nvidia.com
Subject:  [merged]
 mm-zpoolc-delete-duplicated-word-and-fix-grammar.patch removed from -mm
 tree
Message-ID: <20200812210313.MStAPPLEw%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zpool.c: delete duplicated word and fix grammar
has been removed from the -mm tree.  Its filename was
     mm-zpoolc-delete-duplicated-word-and-fix-grammar.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: mm/zpool.c: delete duplicated word and fix grammar

Drop the repeated word "if".
Fix subject/verb agreement.

Link: http://lkml.kernel.org/r/20200801173822.14973-15-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zpool.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/zpool.c~mm-zpoolc-delete-duplicated-word-and-fix-grammar
+++ a/mm/zpool.c
@@ -239,15 +239,15 @@ const char *zpool_get_type(struct zpool
 }
 
 /**
- * zpool_malloc_support_movable() - Check if the zpool support
- * allocate movable memory
+ * zpool_malloc_support_movable() - Check if the zpool supports
+ *	allocating movable memory
  * @zpool:	The zpool to check
  *
- * This returns if the zpool support allocate movable memory.
+ * This returns if the zpool supports allocating movable memory.
  *
  * Implementations must guarantee this to be thread-safe.
  *
- * Returns: true if if the zpool support allocate movable memory, false if not
+ * Returns: true if the zpool supports allocating movable memory, false if not
  */
 bool zpool_malloc_support_movable(struct zpool *zpool)
 {
_

Patches currently in -mm which might be from rdunlap@infradead.org are



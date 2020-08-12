Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 504D1C433E1
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:03:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F4592078B
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266186;
	bh=Vew+iGAhuSvSlAjiYsvXmyXnhgUHtXS8bp83+iwgMZA=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=fTfrre00g3mOFkABWLHuyeSVaP6O2TpQEJnRSBAEv6LGRQErP0zJ+uf+7pz8N/Yws
	 RrDicRU2gY825xrfTvvVW26eNCsQl7Qx2RRfbYTh7TWAf288qh909D54QFMrNPcgLt
	 FCLBmncirevTuD/FFhB/uQwRgF3zfCPmi0ZxzyXo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbgHLVDF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:03:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:52024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726557AbgHLVDF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:03:05 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E56620774;
        Wed, 12 Aug 2020 21:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266185;
        bh=Vew+iGAhuSvSlAjiYsvXmyXnhgUHtXS8bp83+iwgMZA=;
        h=Date:From:To:Subject:From;
        b=yZfSVw7jpASor2SyK0b2R0Z2seADxYHN/mNz4ZW4/DaFRrmHRFiALo2FcYQ08ACID
         Asbq9k9lMCRFJV7lY82k9CiKET1UeP25izpjTaKG5TyrIFu2O4HzKLIgXAUvCQEWbC
         yiin5WlwAGhaxUe9STJMCFyfBZMKOp4qm0KucILM=
Date:   Wed, 12 Aug 2020 14:03:05 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, ziy@nvidia.com
Subject:  [merged] mm-shmemc-delete-duplicated-word.patch removed
 from -mm tree
Message-ID: <20200812210305.bZp06LzR-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/shmem.c: delete duplicated word
has been removed from the -mm tree.  Its filename was
     mm-shmemc-delete-duplicated-word.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: mm/shmem.c: delete duplicated word

Drop the repeated word "the".

Link: http://lkml.kernel.org/r/20200801173822.14973-11-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/shmem.c~mm-shmemc-delete-duplicated-word
+++ a/mm/shmem.c
@@ -1686,7 +1686,7 @@ static int shmem_replace_page(struct pag
  * Swap in the page pointed to by *pagep.
  * Caller has to make sure that *pagep contains a valid swapped page.
  * Returns 0 and the page in pagep if success. On failure, returns the
- * the error code and NULL in *pagep.
+ * error code and NULL in *pagep.
  */
 static int shmem_swapin_page(struct inode *inode, pgoff_t index,
 			     struct page **pagep, enum sgp_type sgp,
_

Patches currently in -mm which might be from rdunlap@infradead.org are


